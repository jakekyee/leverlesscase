#!/usr/bin/env python3
"""Export the parts of every ArtCase variant.

Writes printed parts as STL in print orientation to out/stl/<variant>/, and
laser-cut parts (plate_2d, top_2d) as DXF and SVG to out/laser/<variant>/. Each
.scad file echoes its part list, with how many of each to make, and the
hardware to buy; this script reads both and prints them. Runs from any folder;
paths are relative to the repo.

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

# scad/<variant>.scad
VARIANTS = ["artcase", "artcase_art", "artcase_big_acrylic", "artcase_big_allprinted",
            "artcase_screws", "artcase_deep_acrylic", "artcase_big_acrylic_onepiece",
            "artcase_big_allprinted_onepiece"]
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


def echoes(exe: str, scad: Path, defines: list[str]) -> dict:
    """The `printable` and `hardware` lists the .scad file echoes; {} on failure."""
    with tempfile.TemporaryDirectory() as tmp:
        echo = Path(tmp) / "parts.echo"
        # no -q here: quiet mode also leaves the .echo file empty
        cmd = [exe, str(scad), "-o", str(echo), "--hardwarnings", *d_args(defines)]
        if subprocess.run(cmd).returncode != 0 or not echo.exists():
            return {}
        text = echo.read_text()
    found = re.findall(r"^ECHO: (printable|hardware) = (.*)$", text, re.M)
    return {name: json.loads(value) for name, value in found}


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
        info = echoes(exe, scad, args.defines)
        if not info.get("printable"):
            print(f"export failed: {variant} (no part list)", file=sys.stderr)
            return 1
        dirs = {"stl": repo / "out" / "stl" / variant, "laser": repo / "out" / "laser" / variant}
        for d in dirs.values():
            d.mkdir(parents=True, exist_ok=True)
            for old in d.iterdir():  # a failed or dropped part must not leave an old file behind
                if old.suffix in (".stl", ".dxf", ".svg"):
                    old.unlink()
        for part, copies in info["printable"]:
            laser = part.endswith("_2d")
            for fmt in (["dxf", "svg"] if laser else ["stl"]):
                out = dirs["laser" if laser else "stl"] / f"{part}.{fmt}"
                cmd = [exe, str(scad), "-o", str(out)]
                cmd += ["--export-format", "binstl"] if fmt == "stl" else []
                cmd += ["--hardwarnings", "-q", "-D", f'part="{part}"', *d_args(args.defines)]
                if subprocess.run(cmd).returncode != 0:
                    print(f"export failed: {variant} {part}", file=sys.stderr)
                    return 1
                print(f"{out.relative_to(repo).as_posix()}  x{copies}{'  (laser cut)' if laser else ''}")
        if info.get("hardware"):
            print("  buy: " + ", ".join(f"{n} x {name}" for name, n in info["hardware"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
