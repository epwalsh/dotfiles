import sys
from pathlib import Path

from deoplete.base.source import Base

sys.path.append(str(Path(__file__).absolute().parent.parent.parent))


class Source(Base):
    MAX_CANDIDATES_PER_GROUP = 5

    def __init__(self, vim):
        super().__init__(vim)
        self.name = "emoji"
        self.mark = "[emoji]"
        self.rank = 500
        self.filetypes = ["markdown", "python"]
        self.input_pattern = r":[a-z_]+:?"
        self.is_volatile = True
        self.matcher_key = "match"
        self.matchers = ["matcher_full_fuzzy"]
        self.sorters = ["sorter_rank"]

    def get_complete_position(self, context):
        if context["input"].endswith(":"):
            return context["input"].rfind(":", 0, -1)
        else:
            return context["input"].rfind(":")

    def gather_candidates(self, context):
        if context["input"].endswith(":"):
            m = context["input"].split(":")[-2].strip()
            if not m:
                return []

            from emoji.unicode_codes.en import EMOJI_ALIAS_UNICODE_ENGLISH

            text = ":" + m + ":"
            if text in EMOJI_ALIAS_UNICODE_ENGLISH:
                return [
                    {"word": EMOJI_ALIAS_UNICODE_ENGLISH[text], "kind": "emoji", "match": text},
                    {"word": text, "kind": "alias", "match": text},
                ]
            else:
                return []
        else:
            m = context["input"].split(":")[-1].strip()
            if not m:
                return []

            from emoji.unicode_codes.en import EMOJI_ALIAS_UNICODE_ENGLISH

            out = []
            text = ":" + m
            for k, v in EMOJI_ALIAS_UNICODE_ENGLISH.items():
                if k.startswith(text):
                    out.append({"word": v, "kind": "emoji", "match": k})
                    out.append({"word": k, "kind": "alias", "match": k})
            return out
