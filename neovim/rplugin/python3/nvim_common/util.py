import string
import time
import random
import typing as t


_CHAR_CHOICES = string.ascii_uppercase + string.digits


def new_zettel_id(ts: t.Optional[float] = None) -> str:
    ts = int(ts or time.time())
    suffix = "".join((random.choice(_CHAR_CHOICES) for _ in range(4)))
    return f"{ts}-{suffix}"
