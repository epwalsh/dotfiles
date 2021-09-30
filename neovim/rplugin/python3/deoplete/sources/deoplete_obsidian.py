from itertools import tee, islice
from datetime import datetime, timedelta
from glob import iglob
import os
import re
import sys
from pathlib import Path
import typing as t

from deoplete.base.source import Base

sys.path.append(str(Path(__file__).absolute().parent.parent.parent))

from nvim_common.util import new_zettel_id, parse_frontmatter, parse_title  # noqa: E402


class Source(Base):
    MAX_CANDIDATES_PER_GROUP = 25
    REFERENCE_FINDER = re.compile(r"\[\[([^\]]+)\]\]")

    def __init__(self, vim):
        super().__init__(vim)
        self.name = "obsidian"
        self.mark = "[obsidian]"
        self.rank = 500
        self.filetypes = ["markdown"]
        self.input_pattern = r"\[\[[^\]]*"
        self.is_volatile = True
        self.matcher_key = "match"
        self.matchers = ["matcher_full_fuzzy"]
        self.sorters = ["sorter_rank", "sorter_word"]

    def get_complete_position(self, context):
        return context["input"].rfind("[[") + 2

    def gather_candidates(self, context):
        brackets_start = context["input"].rfind("[[")
        brackets_end = context["input"].rfind("]]")
        if brackets_start < 0 or (brackets_start <= brackets_end):
            return []

        out = []
        unique = set()
        text = context["input"].split("[[")[-1].replace("]]", "").strip()

        def take_unique(candidates, kind="[ref]"):
            i = 0
            for cand, match in candidates:
                if i > self.MAX_CANDIDATES_PER_GROUP:
                    break
                if cand not in unique:
                    out.append({"word": cand, "kind": kind, "match": match})
                    unique.add(cand)
                    i += 1

        # Suggest a new.
        if (
            len(text) >= 2
            and "|" not in text
            and not os.path.exists(f"{text}.md")
            and re.search(
                r"[a-zA-Z]", text
            )  # should contain at least one letter, otherwise it might be a date
        ):
            zettel_id = new_zettel_id()
            cand = f"{zettel_id}|{text}"
            out.append({"word": cand, "kind": "[new]", "match": text})

        # `text` may be shortcut, e.g. 'today'
        if text:
            take_unique(self.find_shortcut_refs(text))

        # `text` may match an actual note ID of an existing note.
        if text and text[0].isnumeric():
            take_unique(self.find_path_refs(text))

        # `text` may match the note ID of another reference within the current buffer that
        # doesn't exist yet.
        buf = self.vim.buffers[context["bufnr"]]
        take_unique(self.find_buf_refs(buf, text), kind="[ref(buf)]")

        # Finally, we try to match semantically.
        if text:
            take_unique(self.find_semantic_refs(text))

        return out

    def find_shortcut_refs(self, text):
        if text in {"to", "tod", "toda", "today"}:
            yield datetime.now().strftime("%Y-%m-%d") + "|today", "today"
        if text in {"to", "tom", "tomo", "tomor", "tomorr", "tomorro", "tomorrow"}:
            yield (datetime.now() + timedelta(days=1)).strftime(
                "%Y-%m-%d"
            ) + "|tomorrow", "tomorrow"

    def find_path_refs(self, text):
        for path in iglob(f"**/{text}*.md", recursive=True):
            basename = os.path.basename(path)
            if not basename.startswith(text):
                continue
            cand = basename[:-3]
            yield cand, cand

    def find_buf_refs(self, buf, text):
        for line in buf:
            for match in self.REFERENCE_FINDER.finditer(line):
                ref = match.group(1)
                if ref.strip() == text:
                    continue
                if not ref.startswith(text):
                    continue
                yield ref, ref

    def find_semantic_refs(self, text):
        text_tokens = set(self.tokenize(text))
        for path in iglob("**/*.md", recursive=True):
            with open(path) as lines:
                lines_for_frontmatter, lines_for_title = tee(lines)
                try:
                    frontmatter, frontmatter_len = parse_frontmatter(lines_for_frontmatter)
                except Exception as e:
                    self.vim.err_write(f"Error parsing frontmatter for {path}\n{e}\n")
                    continue
                lines_for_title = islice(lines_for_title, frontmatter_len, None)
                aliases = None if not frontmatter else frontmatter.get("aliases")
                title = parse_title(lines_for_title)

            if not aliases and not title:
                continue

            note_id = os.path.basename(path)[:-3]

            for alias in aliases or []:
                if alias == title:
                    continue
                alias_tokens = set(self.tokenize(alias))
                if self.tokens_partially_match(text_tokens, alias_tokens):
                    yield note_id + "|" + alias, alias

            if title:
                title_tokens = set(self.tokenize(title))
                if self.tokens_partially_match(text_tokens, title_tokens):
                    yield note_id + "|" + title, title

    def tokenize(self, text: str, do_lower=True):
        for tok in text.split(" "):
            tok = tok.strip()
            if do_lower:
                tok = tok.lower()
            if tok:
                yield tok

    def tokens_partially_match(self, tokens1: t.Set[str], tokens2: t.Set[str]) -> bool:
        for tok1 in tokens1:
            for tok2 in tokens2:
                if tok1 in tok2:
                    return True
        return False
