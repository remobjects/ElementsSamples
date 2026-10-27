#!/usr/bin/env python3
"""Build and run the Promethium Elements samples, with CPython reference checks."""

import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent / "Echoes" / "Command Line"
SAMPLES = (
    ("Word Frequency", "WordFrequency", True),
    ("Reading List", "ReadingList", True),
    ("Context Manager", "ContextManager", True),
    ("Generator Pipeline", "GeneratorPipeline", True),
    ("Trip Budget", "TripBudget", False),
)


def run(command, cwd, env=None):
    return subprocess.run(command, cwd=cwd, env=env, text=True,
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT)


def fail(label, result):
    print(f"FAIL {label} (exit {result.returncode})")
    print(result.stdout.rstrip())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ebuild", default=shutil.which("EBuild") or shutil.which("ebuild"),
                        help="path to EBuild.exe (defaults to EBuild on PATH)")
    parser.add_argument("--compiler-dll", help="branch RemObjects.Elements.dll")
    parser.add_argument("--dont-sign", action="store_true", help="build with AssemblyDontSign=true")
    args = parser.parse_args()
    if not args.ebuild:
        parser.error("supply --ebuild or place EBuild on PATH")
    ebuild = Path(args.ebuild).resolve()
    if not ebuild.is_file():
        parser.error(f"EBuild not found: {ebuild}")
    if args.compiler_dll and not Path(args.compiler_dll).is_file():
        parser.error(f"compiler DLL not found: {args.compiler_dll}")
    mono = shutil.which("mono") if os.name != "nt" else None
    if os.name != "nt" and not mono:
        parser.error("Mono is required to run Echoes samples on this platform")
    build_prefix = [mono, str(ebuild)] if mono else [str(ebuild)]
    passed = 0
    failed = 0
    python_passed = 0
    for folder, name, portable in SAMPLES:
        directory = ROOT / folder
        expected = (directory / "expected-output.txt").read_text()
        command = build_prefix + [f"{name}.elements", "--rebuild"]
        if args.compiler_dll:
            command.append("--setting:EBuild:ElementsCompilerDll=" + str(Path(args.compiler_dll).resolve()))
        if args.dont_sign:
            command.append("--setting:AssemblyDontSign=true")
        build = run(command, directory)
        if build.returncode:
            fail(f"{name} build", build)
            failed += 1
            continue
        executable = directory / "bin" / "Release" / f"{name}.exe"
        execution = run(([mono] if mono else []) + [str(executable)], directory)
        if execution.returncode or execution.stdout != expected:
            fail(f"{name} output", execution)
            print(f"Expected: {expected!r}")
            failed += 1
        else:
            print(f"PASS {name}: build and output")
            passed += 1
        if portable:
            env = dict(os.environ, PYTHONDONTWRITEBYTECODE="1")
            reference = run([sys.executable, "Program.py"], directory, env)
            if reference.returncode or reference.stdout != expected:
                fail(f"{name} CPython", reference)
                print(f"Expected: {expected!r}")
                failed += 1
            else:
                print(f"PASS {name}: CPython reference")
                python_passed += 1
    print(f"Promethium: {passed}/{len(SAMPLES)} passed; CPython: {python_passed}/4 passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
