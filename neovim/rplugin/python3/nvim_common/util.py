import random
import re
import string
import time
import typing as t

_CHAR_CHOICES = string.ascii_uppercase + string.digits


def new_zettel_id(ts: t.Optional[float] = None) -> str:
    ts = int(ts or time.time())
    suffix = "".join((random.choice(_CHAR_CHOICES) for _ in range(4)))
    return f"{ts}-{suffix}"


def parse_frontmatter(lines: t.Iterable[str]) -> t.Tuple[t.Optional[t.Dict[str, t.Any]], int]:
    num_dashes = 3
    frontmatter = []
    for line_num, line in enumerate(lines):
        line = line.strip()
        if line_num == 0:
            num_dashes = line.count("-")
            if num_dashes == 0 or num_dashes < len(line):
                return None, 0
        else:
            if line == "-" * num_dashes:
                break
            else:
                frontmatter.append(line)

    import oyaml as yaml

    out = yaml.load("\n".join(frontmatter), Loader=yaml.FullLoader)
    assert isinstance(out, dict)
    return out, len(frontmatter) + 2


LINK_FINDER = re.compile(r"\[([^\]]+)\]\(([^\)]+)\)")


def remove_links(content: str) -> str:
    return LINK_FINDER.sub(r"\g<1>", content)


REF_FINDER = re.compile(r"\[\[[^\|\]]+\|([^\]]+)\]\]")


def remove_refs(content: str) -> str:
    return REF_FINDER.sub(r"\g<1>", content)


def parse_title(lines: t.Iterable[str]) -> t.Optional[str]:
    in_code_block = False
    for line in lines:
        if line.startswith("```"):
            if in_code_block:
                in_code_block = False
            else:
                in_code_block = True
        elif line.startswith("# ") and not in_code_block:
            title = remove_refs(remove_links(line[2:].strip())).strip()
            return title if title else None
    return None
