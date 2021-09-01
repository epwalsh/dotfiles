from itertools import islice
from datetime import datetime, timedelta
from glob import iglob
import os

from deoplete.base.source import Base


class Source(Base):
    MAX_CANDIDATES = 50

    def __init__(self, vim):
        super().__init__(vim)
        self.name = "obsidian"
        self.mark = "[obsidian]"
        self.rank = 500
        self.filetypes = ["markdown"]
        self.input_pattern = r"\[\[[^\]]*"

    def gather_candidates(self, context):
        text = context["input"].split("[[")[-1].replace("]]", "")
        candidates = islice(
            self.clean_and_filter_paths(iglob(f"**/{text}*.md", recursive=True), text),
            self.MAX_CANDIDATES,
        )
        return [{"word": cand, "kind": "[ref]"} for cand in candidates]

    def clean_and_filter_paths(self, paths, text):
        if text in {"to", "tod", "toda", "today"}:
            yield datetime.now().strftime("%Y-%m-%d") + "|today"
        if text in {"to", "tom", "tomo", "tomor", "tomorr", "tomorro", "tomorrow"}:
            yield (datetime.now() + timedelta(days=1)).strftime(
                "%Y-%m-%d"
            ) + "|tomorrow"
        for path in paths:
            basename = os.path.basename(path)
            if not basename.startswith(text):
                continue
            yield basename[len(text) : -3]
