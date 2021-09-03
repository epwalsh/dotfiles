import string
import time
import random
import typing as t

import oyaml as yaml


_CHAR_CHOICES = string.ascii_uppercase + string.digits


def new_zettel_id(ts: t.Optional[float] = None) -> str:
    ts = int(ts or time.time())
    suffix = "".join((random.choice(_CHAR_CHOICES) for _ in range(4)))
    return f"{ts}-{suffix}"


def parse_frontmatter(lines: t.Iterable[str]) -> t.Optional[t.Dict[str, t.Any]]:
    num_dashes = 3
    frontmatter = []
    for line_num, line in enumerate(lines):
        line = line.strip()
        if line_num == 0:
            num_dashes = line.count("-")
            if num_dashes == 0 or num_dashes < len(line):
                return None
        else:
            if line == "-" * num_dashes:
                break
            else:
                frontmatter.append(line)
    out = yaml.load("\n".join(frontmatter))
    assert isinstance(out, dict)
    return out
