#!/usr/bin/env python3
"""Export printable STLs for every ArtCase variant.

Writes out/stl/<variant>/<part>.stl for the case, plate, top panel and peg of
each variant, in print orientation. Print four pegs per case. Runs from any
folder; paths are relative to the repo.

    python scad/export_stls.py                                   # as designed
    python scad/export_stls.py -D plate_fit=0.2 -D peg_fit=0.2   # with FDM clearance

OpenSCAD is found the way scadloop.py finds it: $OPENSCAD, then the default
install folders, then PATH. A failed assert or any OpenSCAD warning stops
the export.
"""
import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

VARIANTS = ["artcase", "artcase_big"]  # scad/<variant>.scad
PARTS = ["case", "plate", "top", "peg"]
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


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("-D", dest="defines", action="append", default=[], metavar="VAR=VAL",
                    help="override a variable in every export, e.g. -D plate_fit=0.2")
    args = ap.parse_args()

    repo = Path(__file__).resolve().parent.parent
    exe = find_openscad()
    for variant in VARIANTS:
        outdir = repo / "out" / "stl" / variant
        outdir.mkdir(parents=True, exist_ok=True)
        for part in PARTS:
            stl = outdir / f"{part}.stl"
            stl.unlink(missing_ok=True)  # a failed export must not leave an old file behind
            cmd = [exe, str(repo / "scad" / f"{variant}.scad"), "-o", str(stl),
                   "--export-format", "binstl", "--hardwarnings", "-q", "-D", f'part="{part}"']
            for define in args.defines:
                cmd += ["-D", define]
            if subprocess.run(cmd).returncode != 0:
                print(f"export failed: {variant} {part}", file=sys.stderr)
                return 1
            print(stl.relative_to(repo).as_posix())
    return 0


if __name__ == "__main__":
    sys.exit(main())
