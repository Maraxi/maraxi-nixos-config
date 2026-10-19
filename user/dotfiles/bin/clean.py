#!/usr/bin/env python

import re
import sys
from pathlib import Path

ARG_COUNT = 2

if len(sys.argv) != ARG_COUNT:
    print("Invalid argument count")
    sys.exit()

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


def main() -> None:
    match = re.search(r"(.*)(\.html)", sys.argv[1])
    if match is None:
        print("Invalid path name. Could not extract base name")
        return

    s = Path(sys.argv[1]).read_text(encoding="utf8")
    for before, after in replacements.items():
        s = s.replace(before, after)
    Path(f"{match.group(1)}.xml").write_text(s, encoding="utf8")


if __name__ == "__main__":
    main()
