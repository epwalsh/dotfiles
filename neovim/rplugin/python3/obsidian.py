"""Plugin for working in an [Obsidian](https://obsidian.md/) vault in Neovim."""

from dataclasses import dataclass, asdict
from datetime import datetime, timedelta
import os
from pathlib import Path
import string
import time
import random
import re
import urllib
import typing as t

import pynvim
import requests
import oyaml as yaml


FILE_NAME_SAFE_CHARS = {"-", "_"}


NOTE_TEMPLATE = """
---
tags: []
aliases: []
id: {id}

---

# {title}

{body}
""".lstrip()


_CHAR_CHOICES = string.ascii_uppercase + string.digits


def new_zettel_id(ts: t.Optional[float] = None) -> str:
    ts = int(ts or time.time())
    suffix = "".join((random.choice(_CHAR_CHOICES) for _ in range(4)))
    return f"{ts}-{suffix}"


def new_note(title: str, zettel_id: t.Optional[str] = None, body: t.Optional[str] = None):
    zettel_id = zettel_id or new_zettel_id()
    contents = NOTE_TEMPLATE.format(id=zettel_id, title=title, body=body or "")
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
    return new_note(title, zettel_id=zettel_id)


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

    @pynvim.command("OpenCurrent", sync=False)
    def open_current(self):
        self.open_in_obsidian(os.path.basename(self.nvim.current.buffer.name))

    @pynvim.command("Open", sync=False)
    def open(self):
        maybe_link = self.get_current_link()
        if maybe_link is None:
            link = os.path.basename(self.nvim.current.buffer.name)
        else:
            link = maybe_link
        self.open_in_obsidian(link)

    @pynvim.command("GoTo", nargs="*", sync=True)
    def goto(self, args) -> None:
        link: str
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
            maybe_link = self.get_current_link()
            if maybe_link is None:
                return self.nvim.err_write("Cursor is not on a link!\n")
            link = maybe_link
            path = Path(f"{link}.md")
        self.nvim.command(f"e {str(path)}")

    @pynvim.command("Today", sync=True)
    def today(self) -> None:
        self.nvim.command("GoTo today")

    @pynvim.command("Tomorrow", sync=True)
    def tomorrow(self) -> None:
        self.nvim.command("GoTo tomorrow")

    @pynvim.command("Paper", nargs=1, sync=True)
    def paper(self, args) -> None:
        paper = self.s2_client.get_paper(args[0])
        paper.to_file()
        self.nvim.command(f"GoTo {paper.reference_name()}")

    @pynvim.command("Link", nargs=1, sync=True)
    def link(self, args) -> None:
        link = args[0]
        if link in {"today", "tod"}:
            link = datetime.now().strftime("%Y-%m-%d")
        elif link in {"tomorrow", "tom"}:
            link = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
        self.insert_text(f"[[{link}]]")

    @pynvim.command("LinkPaper", nargs=1, sync=True)
    def link_paper(self, args) -> None:
        paper = self.s2_client.get_paper(args[0])
        paper.to_file()
        self.nvim.command(f"Link {paper.reference_name()}")

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

    def get_current_link(self) -> t.Optional[str]:
        return self.get_link(self.current_line, self.nvim.current.window.cursor[1])

    def get_link(self, line: str, cursor_pos: int) -> t.Optional[str]:
        for match in self.internal_link_finder.finditer(line):
            if match.start() <= cursor_pos <= match.end():
                return match.group(1).split("|")[0]
        return None

    def insert_text(self, text: str) -> None:
        line = self.current_line
        row, col = self.nvim.current.window.cursor
        self.current_line = line[0 : col + 1] + text + line[col + 1 :]
        self.nvim.current.window.cursor = (row, col + len(text))

    def open_in_obsidian(self, note: str):
        encoded_note = urllib.parse.quote(note)
        command = (
            f"open -a /Applications/Obsidian.app --background 'obsidian://open?file={encoded_note}'"
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

    def to_file(self):
        path = self.path()
        if not path.is_file():
            with open(path, "w") as f:
                f.write("---\n")
                f.write(yaml.dump({"tags": ["paper"]}, Dumper=CustomYamlDumper))
                f.write("\n---\n\n")
                f.write(f"# [{self.title}]({self.url})\n\n")
                f.write(f"> {self.abstract}")

    def path(self) -> Path:
        return Path(f"{self.reference_name()}.md")

    def reference_name(self) -> str:
        standardized_name = "".join(
            [
                c
                for c in self.title.replace(" ", "-").replace(":", "-").lower()
                if c.isalnum() or c in FILE_NAME_SAFE_CHARS
            ]
        )
        return f"paper-{standardized_name}-{self.corpusId}s2"


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
