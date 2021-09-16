"""Plugin for working in an [Obsidian](https://obsidian.md/) vault in Neovim."""

from itertools import tee, islice
from collections import OrderedDict
from dataclasses import dataclass, asdict
from datetime import datetime, timedelta
import os
from pathlib import Path
import re
import urllib
import sys
import typing as t

import pynvim
import requests
import oyaml as yaml

sys.path.append(str(Path(__file__).absolute().parent))

from nvim_common.util import (  # noqa: E402
    new_zettel_id,
    parse_frontmatter,
    parse_title,
    remove_links,
    remove_refs,
)


FILE_NAME_SAFE_CHARS = {"-", "_"}


NOTE_TEMPLATE = """
---
{frontmatter}
---

# {title}

{body}
""".lstrip()


def new_note(
    title: str,
    zettel_id: t.Optional[str] = None,
    body: t.Optional[str] = None,
    tags: t.Optional[t.List[str]] = None,
):
    zettel_id = zettel_id or new_zettel_id()
    tags = tags or []
    # Is this a daily note?
    try:
        datetime.strptime(zettel_id, "%Y-%m-%d")
        if "daily-notes" not in tags:
            tags.insert(0, "daily-notes")
    except ValueError:
        pass
    frontmatter = yaml.dump(
        OrderedDict(
            [("tags", tags), ("aliases", [remove_refs(remove_links(title))]), ("id", zettel_id)]
        ),
        Dumper=CustomYamlDumper,
    )
    contents = NOTE_TEMPLATE.format(frontmatter=frontmatter, title=title, body=body or "")
    path = f"{zettel_id}.md"
    with open(path, "w") as f:
        f.write(contents)


def clean_ordinal(ordinal: str) -> str:
    while ordinal.startswith("0"):
        ordinal = ordinal.replace("0", "", 1)
    if ordinal.endswith("1"):
        suffix = "st"
    elif ordinal.endswith("2"):
        suffix = "nd"
    elif ordinal.endswith("3"):
        suffix = "rd"
    else:
        suffix = "th"
    return ordinal + suffix


def new_daily_note(date: datetime):
    zettel_id = date.strftime("%Y-%m-%d")
    title = date.strftime("%B {}, %Y").format(clean_ordinal(date.strftime("%d")))
    return new_note(title, zettel_id=zettel_id, tags=["daily-notes"])


@pynvim.plugin
class ObsidianPlugin:
    internal_link_finder = re.compile(r"\[\[([^\]]+)\]\]")

    def __init__(self, nvim):
        self.nvim = nvim
        self.s2_client = S2Client()

    @pynvim.command("New", nargs="*", sync=True)
    def new(self, args) -> None:
        title = " ".join(args)
        zettel_id = new_zettel_id()
        new_note(title, zettel_id=zettel_id)
        if title:
            self.insert_text(f"[[{zettel_id}|{title}]]")
        else:
            self.insert_text(f"[[{zettel_id}]]")

    @pynvim.command("Nav", sync=False)
    def nav(self):
        self.nvim.command("e nav.md")

    @pynvim.command("Hub", sync=False)
    def hub(self):
        self.nvim.command("e hub.md")

    @pynvim.command("Backlinks", sync=False)
    def backlinks(self):
        buf_name = os.path.basename(self.nvim.current.buffer.name)[:-3]
        grep_cmd = "grep -FHn ''[[%s'' *.md" % buf_name
        command = (
            "call setloclist(0, [], ' ', {'lines' : systemlist('%s'), 'title': 'Backlinks'})"
            % grep_cmd
        )
        self.nvim.command(command)
        self.nvim.command("lop")

    @pynvim.command("Ref", nargs=1, sync=True)
    def add_reference(self, args):
        ref_num = args[0]
        self.insert_text(f"[\[{ref_num}\]][{ref_num}]")  # noqa: W605

    @pynvim.command("Frontmatter", sync=True)
    def add_frontmatter(self):
        # Parse front matter and title from current note.
        lines = iter(self.nvim.current.buffer)
        lines_for_frontmatter, lines_for_title = tee(lines)
        try:
            frontmatter, frontmatter_len = parse_frontmatter(lines_for_frontmatter)
        except Exception as e:
            return self.nvim.err_write(f"Error parsing frontmatter\n{e}\n")
        lines_for_title = islice(lines_for_title, frontmatter_len, None)
        title = parse_title(lines_for_title)
        del lines, lines_for_frontmatter, lines_for_title

        zettel_id = os.path.basename(self.nvim.current.buffer.name)[:-3]
        try:
            datetime.strptime(zettel_id, "%Y-%m-%d")
            is_daily_note = True
        except ValueError:
            is_daily_note = False

        # Possibly update or initialize the frontmatter.
        changed = False
        if frontmatter is None:
            new_frontmatter = OrderedDict(
                [
                    ("tags", ["daily-notes"] if is_daily_note else []),
                    ("aliases", [title] if title else []),
                    ("id", zettel_id),
                ]
            )
            changed = True
        else:
            new_frontmatter = frontmatter  # type: ignore[assignment]
            if "aliases" not in new_frontmatter:
                new_frontmatter["aliases"] = [title] if title else []
                changed = True
            elif title and title not in new_frontmatter["aliases"]:
                new_frontmatter["aliases"].insert(0, title)
                changed = True

            if "tags" not in new_frontmatter:
                new_frontmatter["tags"] = ["daily-notes"] if is_daily_note else []
                changed = True
            elif is_daily_note and "daily-notes" not in new_frontmatter["tags"]:
                new_frontmatter["tags"].insert(0, "daily-notes")
                changed = True

            if "id" not in new_frontmatter:
                new_frontmatter["id"] = zettel_id
                changed = True

        # If we've made changes, update the fronmatter.
        if changed:
            frontmatter_lines = (
                ["---"]
                + yaml.dump(
                    new_frontmatter,
                    Dumper=CustomYamlDumper,
                ).split("\n")
                + ["---"]
            )
            if frontmatter_len > 0:
                # Remove old frontmatter.
                del self.nvim.current.buffer[0:frontmatter_len]
            for line in reversed(frontmatter_lines):
                self.nvim.current.buffer.append(line, index=0)

    @pynvim.command("OpenCurrent", sync=False)
    def open_current(self):
        self.open_in_obsidian(os.path.basename(self.nvim.current.buffer.name))

    @pynvim.command("Open", sync=False)
    def open(self):
        maybe_link = self.get_current_link()
        if maybe_link is None:
            link = os.path.basename(self.nvim.current.buffer.name)
        else:
            link, _ = maybe_link
        self.open_in_obsidian(link)

    def maybe_create_note(self, exist_ok=True, ignore_errors=False) -> t.Optional[Path]:
        maybe_link = self.get_current_link()
        if maybe_link is None:
            if not ignore_errors:
                self.nvim.err_write("Cursor is not on a link!\n")
            return None
        link, title = maybe_link
        path = Path(f"{link}.md")
        if not path.exists():
            if title is not None:
                new_note(title, zettel_id=link)
            else:
                try:
                    date = datetime.strptime(link, "%Y-%m-%d")
                    new_daily_note(date)
                except ValueError:
                    new_note(link, zettel_id=link)
            self.nvim.out_write(f"{link} created\n")
        elif not exist_ok and not ignore_errors:
            self.nvim.err_write(f"{link} already exists\n")
        return path

    @pynvim.command("Create", sync=False)
    def create(self) -> None:
        _ = self.maybe_create_note()

    @pynvim.command("CreateSilent", sync=False)
    def create_silent(self) -> None:
        _ = self.maybe_create_note(exist_ok=True, ignore_errors=True)

    @pynvim.command("GoTo", nargs="*", sync=True)
    def goto(self, args) -> None:
        link: str
        path: t.Optional[Path]
        if args:
            if len(args) > 1:
                return self.nvim.err_write("Expected at most 1 argument\n")
            link = args[0]
            if link in {"today", "tod"}:
                date = datetime.now()
                link = date.strftime("%Y-%m-%d")
            elif link in {"tomorrow", "tom"}:
                date = datetime.now() + timedelta(days=1)
                link = date.strftime("%Y-%m-%d")
            path = Path(f"{link}.md")
            if not path.exists():
                new_daily_note(date)
        else:
            path = self.maybe_create_note()
        if path is not None:
            self.nvim.command(f"e {str(path)}")

    @pynvim.command("Today", sync=True)
    def today(self) -> None:
        self.nvim.command("GoTo today")

    @pynvim.command("Tomorrow", sync=True)
    def tomorrow(self) -> None:
        self.nvim.command("GoTo tomorrow")

    @pynvim.command("Link", nargs="*", sync=True)
    def link(self, args) -> None:
        link = " ".join(args)
        if link in {"today", "tod"}:
            link = datetime.now().strftime("%Y-%m-%d")
        elif link in {"tomorrow", "tom"}:
            link = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
        self.insert_text(f"[[{link}]]")

    @pynvim.command("LinkPaper", nargs=1, sync=True)
    def link_paper(self, args) -> None:
        paper = self.s2_client.get_paper(args[0])
        zettel_id = new_zettel_id()
        paper.to_file(zettel_id)
        self.nvim.command(f"Link {zettel_id}|{paper.title}")

    @pynvim.command("Done", sync=True)
    def done(self) -> None:
        line = self.current_line
        stripped_line = line.lstrip()  # remove leading whitespace
        if stripped_line.startswith("- [x]"):
            new_line = line
        elif stripped_line.startswith("- [ ]"):
            new_line = line.replace("- [ ]", "- [x]", 1)
        elif stripped_line.startswith("-"):
            new_line = line.replace("-", "- [x]", 1)
        else:
            indent = len(line) - len(stripped_line)
            new_line = (" " * indent) + "- [x] " + stripped_line
        self.current_line = new_line

    @pynvim.command("ToDo", sync=True)
    def todo(self) -> None:
        line = self.current_line
        stripped_line = line.lstrip()  # remove leading whitespace
        if stripped_line.startswith("- [ ]"):
            new_line = line
        elif stripped_line.startswith("- [x]"):
            new_line = line.replace("- [x]", "- [ ]", 1)
        elif stripped_line.startswith("-"):
            new_line = line.replace("-", "- [ ]", 1)
        else:
            indent = len(line) - len(stripped_line)
            new_line = (" " * indent) + "- [ ] " + stripped_line
        self.current_line = new_line

    def get_current_link(self) -> t.Optional[t.Tuple[str, t.Optional[str]]]:
        full_link = self.get_link(self.current_line, self.nvim.current.window.cursor[1])
        if not full_link:
            return None
        if "|" in full_link:
            file_name, *display = full_link.split("|")
            display_name = "|".join(display)
            return file_name, display_name
        return full_link, None

    def get_link(self, line: str, cursor_pos: int) -> t.Optional[str]:
        # We have to be careful because `cursor_pos` will be the position in terms of unicode
        # code points. So if there are unicode characters in the line befpre `cursor_pos` that
        # consist of multiple code points, then `cursor_pos` will not correspond to the position
        # of the cusor within `line`.
        adjusted_cursor_pos = len(line.encode()[:cursor_pos].decode())
        for match in self.internal_link_finder.finditer(line):
            if match.start() <= adjusted_cursor_pos <= match.end():
                return match.group(1)
        return None

    def insert_text(self, text: str) -> None:
        line = self.current_line
        row, col = self.nvim.current.window.cursor
        self.current_line = line[0 : col + 1] + text + line[col + 1 :]
        self.nvim.current.window.cursor = (row, col + len(text))

    def open_in_obsidian(self, note: str):
        encoded_note = urllib.parse.quote(note)  # type: ignore[attr-defined]
        encoded_path = urllib.parse.quote(os.path.basename(Path(".").absolute()))  # type: ignore[attr-defined]
        command = (
            f"open -a /Applications/Obsidian.app --background "
            f"'obsidian://open?file={encoded_note}&vault={encoded_path}'"
        )
        os.system(command)

    @property
    def current_line(self) -> str:
        return self.nvim.current.line

    @current_line.setter
    def current_line(self, line: str) -> None:
        self.nvim.current.line = line


@dataclass
class S2Author:
    authorId: str
    name: str


@dataclass
class S2Paper:
    corpusId: str
    paperId: str
    url: str
    title: str
    abstract: str
    authors: t.List[S2Author]
    year: int

    @classmethod
    def from_dict(cls, corpus_id, data: t.Dict[str, t.Any]) -> "S2Paper":
        data["authors"] = [S2Author(**author) for author in data["authors"]]
        return cls(corpusId=str(corpus_id), **data)

    def to_dict(self) -> t.Dict[str, t.Any]:
        return asdict(self)

    def to_file(self, zettel_id: str):
        new_note(
            f"[{self.title}]({self.url})",
            zettel_id=zettel_id,
            body=f"> {self.abstract}",
            tags=["paper"],
        )


class S2Client:
    base_url = "https://api.semanticscholar.org/graph/v1"

    def get_paper(self, corpus_id: t.Union[str, int]) -> S2Paper:
        response = requests.get(
            f"{self.base_url}/paper/CorpusID:{corpus_id}?fields=url,title,abstract,authors,year"
        )
        return S2Paper.from_dict(corpus_id, response.json())


class CustomYamlDumper(yaml.Dumper):
    def increase_indent(self, flow=False, indentless=False):
        return super().increase_indent(flow, False)
