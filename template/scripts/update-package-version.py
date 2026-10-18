#!/usr/bin/env python3
"""Update the shine-notes package version in one or more projects."""

import argparse
import re
from pathlib import Path

PACKAGE_IMPORT = re.compile(r'(@preview/shine-notes:)\d+\.\d+\.\d+')
VERSION = re.compile(r"\d+\.\d+\.\d+")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("version", help="package version, for example 0.2.0")
    parser.add_argument(
        "projects",
        nargs="*",
        type=Path,
        help="project directories (defaults to the current directory)",
    )
    args = parser.parse_args()
    if not VERSION.fullmatch(args.version):
        parser.error("version must use major.minor.patch format, such as 0.2.0")

    projects = args.projects or [Path.cwd()]
    replacements = 0
    for project in projects:
        if not project.is_dir():
            parser.error(f"project directory does not exist: {project}")
        for source in project.rglob("*.typ"):
            relative = source.relative_to(project)
            if any(part in {".git", "build"} for part in relative.parts):
                continue
            original = source.read_text(encoding="utf-8")
            updated, count = PACKAGE_IMPORT.subn(rf"\g<1>{args.version}", original)
            if count:
                source.write_text(updated, encoding="utf-8")
                replacements += count
                print(f"Updated {source}: {count} import(s)")

    print(f"Updated {replacements} package import(s) across {len(projects)} project(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
