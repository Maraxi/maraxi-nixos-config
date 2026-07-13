#!/usr/bin/env python

import re
import sys
from pathlib import Path

if len(sys.argv) != 2:
    print("Invalid argument count")
    sys.exit()

match = re.search(r"(.*)(\.html)", sys.argv[1])

replacements = {
    "&lt;": "<",
    "&gt;": ">",
    "<<": "<",
    ">>": ">",
    "&amp;": "&",
    "&nbsp;": " ",
    "&quot;": '"',
    "&#39;": "'",
    "&#96;": "`",
    "</tw-passagedata><tw-passagedata": "</tw-passagedata>\n\n\n<tw-passagedata",
}

with (
    Path.open(sys.argv[1], encoding="utf8") as orig,
    Path.open(f"{match.group(1)}.xml", "w", encoding="utf8") as output,
):
    s = orig.read()
    for before, after in replacements.items():
        s = s.replace(before, after)
    output.write(s)
