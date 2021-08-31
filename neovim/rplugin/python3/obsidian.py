"""
Plugin for working in an [Obsidian](https://obsidian.md/) vault in Neovim.
"""

from datetime import datetime, timedelta
import os
from pathlib import Path
import re
import typing as t

import pynvim


@pynvim.plugin
class ObsidianPlugin:
    internal_link_finder = re.compile(r"\[\[([^\]]+)\]\]")

    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.command("GoTo", nargs="*", sync=True)
    def goto(self, args) -> None:
        link: str
        if args:
            if len(args) > 1:
                return self.nvim.err_write("Expected at most 1 argument\n")
            link = args[0]
            if link == "today":
                link = datetime.now().strftime("%Y-%m-%d")
            elif link == "tomorrow":
                link = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
        else:
            link = self.get_current_link()
            if link is None:
                return self.nvim.err_write("Cursor is not on a link!\n")

        # Create file if it doesn't already exist.
        path = Path(f"{link}.md")
        if not path.is_file():
            path.touch()

        self.nvim.command(f"e {str(path)}")

    @pynvim.command("Today", sync=True)
    def today(self) -> None:
        self.nvim.command("GoTo today")

    @pynvim.command("Tomorrow", sync=True)
    def tomorrow(self) -> None:
        self.nvim.command("GoTo tomorrow")

    @pynvim.command("Link", nargs=1, sync=True)
    def link(self, args) -> None:
        link = args[0]
        if link in {"today", "tod"}:
            link = datetime.now().strftime("%Y-%m-%d")
        elif link in {"tomorrow", "tom"}:
            link = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
        self.insert_text(f"[[{link}]]")

    def get_current_link(self) -> t.Optional[str]:
        return self.get_link(self.nvim.current.line, self.nvim.current.window.cursor[1])

    def get_link(self, line: str, cursor_pos: str) -> t.Optional[str]:
        for match in self.internal_link_finder.finditer(line):
            if match.start() <= cursor_pos <= match.end():
                return match.group(1)
        return None

    def insert_text(self, text: str) -> None:
        line = self.nvim.current.line
        _, pos = self.nvim.current.window.cursor
        self.nvim.current.line = line[0:pos] + text + line[pos:]
