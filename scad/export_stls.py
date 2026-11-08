#!/usr/bin/env python3
"""Export printable STLs for every ArtCase variant.

Writes out/stl/<variant>/<part>.stl for each part a variant prints, in print
orientation: the case (or its pieces case1, case2 ... when it is split), plate,
top panel, peg and, for a split case, the bowtie key. Each .scad file echoes
its part list with the number of copies to print; this script reads that list
and prints each file with its copy count. Runs from any folder; paths are
relative to the repo.

    python scad/export_stls.py                                   # as designed
    python scad/export_stls.py -D plate_fit=0.2 -D peg_fit=0.2   # with FDM clearance

OpenSCAD is found the way scadloop.py finds it: $OPENSCAD, then the default
install folders, then PATH. A failed assert or any OpenSCAD warning stops
the export.
"""
import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

VARIANTS = ["artcase", "artcase_big"]  # scad/<variant>.scad
OPENSCAD_CANDIDATES = [
    os.environ.get("OPENSCAD", ""),
    r"C:\Program Files\OpenSCAD (Nightly)\openscad.com",
    r"C:\Program Files\OpenSCAD\openscad.com",
    "openscad-nightly",
    "openscad",
]


def find_openscad() -> str:
    for candidate in filter(None, OPENSCAD_CANDIDATES):
        if Path(candidate).is_file():
            return candidate
        found = shutil.which(candidate)
        if found:
            return found
    sys.exit("OpenSCAD not found. Set the OPENSCAD environment variable to its path.")


def d_args(defines: list[str]) -> list[str]:
    return [arg for define in defines for arg in ("-D", define)]


def part_list(exe: str, scad: Path, defines: list[str]) -> list:
    """The [[part, copies], ...] list the .scad file echoes as `printable`; [] on failure."""
    with tempfile.TemporaryDirectory() as tmp:
        echo = Path(tmp) / "parts.echo"
        # no -q here: quiet mode also leaves the .echo file empty
        cmd = [exe, str(scad), "-o", str(echo), "--hardwarnings", *d_args(defines)]
        if subprocess.run(cmd).returncode != 0 or not echo.exists():
            return []
        found = re.search(r"^ECHO: printable = (.*)$", echo.read_text(), re.M)
    return json.loads(found.group(1)) if found else []


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("-D", dest="defines", action="append", default=[], metavar="VAR=VAL",
                    help="override a variable in every export, e.g. -D plate_fit=0.2")
    args = ap.parse_args()

    repo = Path(__file__).resolve().parent.parent
    exe = find_openscad()
    for variant in VARIANTS:
        scad = repo / "scad" / f"{variant}.scad"
        parts = part_list(exe, scad, args.defines)
        if not parts:
            print(f"export failed: {variant} (no part list)", file=sys.stderr)
            return 1
        outdir = repo / "out" / "stl" / variant
        outdir.mkdir(parents=True, exist_ok=True)
        for old in outdir.glob("*.stl"):  # a failed or dropped part must not leave an old file behind
            old.unlink()
        for part, copies in parts:
            stl = outdir / f"{part}.stl"
            cmd = [exe, str(scad), "-o", str(stl), "--export-format", "binstl", "--hardwarnings", "-q",
                   "-D", f'part="{part}"', *d_args(args.defines)]
            if subprocess.run(cmd).returncode != 0:
                print(f"export failed: {variant} {part}", file=sys.stderr)
                return 1
            print(f"{stl.relative_to(repo).as_posix()}  x{copies}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
