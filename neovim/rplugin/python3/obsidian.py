"""
Plugin for working in an [Obsidian](https://obsidian.md/) vault in Neovim.
"""

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

    @pynvim.command("GoTo", sync=True)
    def goto(self) -> None:
        link = self.get_current_link()
        if link is None:
            self.nvim.err_write("Cursor is not on a link!\n")
            return None

        # Create file if it doesn't already exist.
        path = Path(f"{link}.md")
        if not path.is_file():
            path.touch()

        self.nvim.command(f"e {str(path)}")

    def get_current_link(self) -> t.Optional[str]:
        return self.get_link(self.nvim.current.line, self.nvim.current.window.cursor[1])

    def get_link(self, line: str, cursor_pos: str) -> t.Optional[str]:
        for match in self.internal_link_finder.finditer(line):
            if match.start() <= cursor_pos <= match.end():
                return match.group(1)
        return None
