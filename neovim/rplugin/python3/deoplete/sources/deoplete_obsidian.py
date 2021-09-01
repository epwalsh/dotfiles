from datetime import datetime, timedelta
from glob import iglob
import os
import re

from deoplete.base.source import Base


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

    def gather_candidates(self, context):
        out = []
        unique = set()
        text = context["input"].split("[[")[-1].replace("]]", "")

        if text:
            i = 0
            candidates = self.clean_and_filter_paths(
                iglob(f"**/{text}*.md", recursive=True), text
            )
            for cand, match in candidates:
                if i > self.MAX_CANDIDATES_PER_GROUP:
                    break
                if cand not in unique:
                    out.append({"word": cand, "kind": "[ref]", "match": match})
                    unique.add(cand)
                    i += 1

        buf = self.vim.buffers[context["bufnr"]]
        i = 0
        for cand, match in self.find_buf_refs(buf, text):
            if i > self.MAX_CANDIDATES_PER_GROUP:
                break
            if cand not in unique:
                out.append({"word": cand, "kind": "[ref(buf)]", "match": match})
                unique.add(cand)
                i += 1

        return out

    def find_buf_refs(self, buf, text):
        for line in buf:
            for match in self.REFERENCE_FINDER.finditer(line):
                ref = match.group(1)
                if ref == text:
                    continue
                if not ref.startswith(text):
                    continue
                yield ref, ref

    def clean_and_filter_paths(self, paths, text):
        if text in {"to", "tod", "toda", "today"}:
            yield datetime.now().strftime("%Y-%m-%d") + "|today", "today"
        if text in {"to", "tom", "tomo", "tomor", "tomorr", "tomorro", "tomorrow"}:
            yield (datetime.now() + timedelta(days=1)).strftime(
                "%Y-%m-%d"
            ) + "|tomorrow", "tomorrow"
        for path in paths:
            basename = os.path.basename(path)
            if not basename.startswith(text):
                continue
            cand = basename[:-3]
            yield cand, cand
