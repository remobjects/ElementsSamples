#!/usr/bin/env python3
"""Build and run the Promethium Elements samples, with CPython reference checks."""

import argparse
import os
import platform
import zipfile
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
SAMPLES = (
    ("Word Frequency", "WordFrequency", "Program.py"),
    ("Reading List", "ReadingList", "Program.py"),
    ("Context Manager", "ContextManager", "Program.py"),
    ("Generator Pipeline", "GeneratorPipeline", "Program.py"),
    ("Trip Budget", "TripBudget", None),
    ('JSON Configuration', 'JsonConfiguration', 'Reference.py'),
    ('CSV Report', 'CsvReport', 'Reference.py'),
    ('Dependency Plan', 'DependencyPlan', 'Reference.py'),
    ('Sensor Summary', 'SensorSummary', 'Program.py'),
    ('Binary Record', 'BinaryRecord', 'Reference.py'),
)


def run(command, cwd, env=None, timeout=180):
    try:
        return subprocess.run(command, cwd=cwd, env=env, text=True, timeout=timeout,
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    except subprocess.TimeoutExpired as error:
        output = error.stdout or ""
        if isinstance(output, bytes):
            output = output.decode("utf-8", errors="replace")
        return subprocess.CompletedProcess(command, 124, output + f"\nTimed out after {timeout}s\n")
    except OSError as error:
        return subprocess.CompletedProcess(command, 127, str(error))


def fail(label, result):
    print(f"FAIL {label} (exit {result.returncode})")
    print(result.stdout.rstrip())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ebuild", default=shutil.which("EBuild") or shutil.which("ebuild"),
                        help="path to EBuild.exe (defaults to EBuild on PATH)")
    parser.add_argument("--target", choices=("Echoes", "Cooper", "Island", "Toffee"), default="Echoes")
    parser.add_argument("--configuration", choices=("Debug", "Release"), default="Release")
    parser.add_argument("--java", default=shutil.which("java"), help="Java executable for Cooper samples")
    parser.add_argument("--architecture", default=platform.machine(), help="architecture for macOS native samples")
    parser.add_argument("--sample", action="append", help="limit to a sample binary name; may be repeated")
    parser.add_argument("--compiler-dll", help="branch RemObjects.Elements.dll")
    parser.add_argument("--reference-path", help="directory containing freshly built runtime references")
    parser.add_argument("--dont-sign", action="store_true", help="build with AssemblyDontSign=true")
    args = parser.parse_args()
    if not args.ebuild:
        parser.error("supply --ebuild or place EBuild on PATH")
    ebuild = Path(args.ebuild).resolve()
    if not ebuild.is_file():
        parser.error(f"EBuild not found: {ebuild}")
    if args.compiler_dll and not Path(args.compiler_dll).is_file():
        parser.error(f"compiler DLL not found: {args.compiler_dll}")
    if args.reference_path:
        library = {"Echoes": "Promethium.dll", "Cooper": "promethium.jar",
                   "Island": "Promethium.fx", "Toffee": "libPromethium.fx"}[args.target]
        if not (Path(args.reference_path) / library).is_file():
            parser.error(f"target library missing from reference path: {library}")
    unknown_samples = set(args.sample or ()) - {sample[1] for sample in SAMPLES}
    if unknown_samples:
        parser.error("unknown samples: " + ", ".join(sorted(unknown_samples)))
    mono = shutil.which("mono") if os.name != "nt" else None
    if os.name != "nt" and not mono:
        parser.error("Mono is required to run Echoes samples on this platform")
    build_prefix = [mono, str(ebuild)] if mono else [str(ebuild)]
    samples = [s for s in SAMPLES if not args.sample or s[1] in args.sample]
    if not samples:
        parser.error("no matching samples")
    if args.target == "Cooper" and not args.java:
        parser.error("supply --java or place Java on PATH")
    passed = 0
    failed = 0
    python_passed = 0
    for folder, name, reference_script in samples:
        directory = ROOT / args.target / "Command Line" / folder
        source_directory = ROOT / "Echoes" / "Command Line" / folder
        expected = (source_directory / "expected-output.txt").read_text()
        command = build_prefix + [f"{name}.elements", "--rebuild", "--configuration:" + args.configuration]
        if args.compiler_dll:
            command.append("--setting:EBuild:ElementsCompilerDll=" + str(Path(args.compiler_dll).resolve()))
        if args.reference_path:
            command.append("--setting:AdditionalReferencePaths=" + str(Path(args.reference_path).resolve()))
            if args.target == "Toffee":
                # EBuild sorts discovered -L paths; explicitly prefer the matching archive.
                library_path = str(Path(args.reference_path).resolve()).replace('"', '\\"')
                command.append('--setting:LinkerOptions=-L"' + library_path + '"')
        if args.dont_sign:
            command.append("--setting:AssemblyDontSign=true")
        if args.target in ("Island", "Toffee"):
            command.append("--setting:Architecture=" + args.architecture)
        build = run(command, directory)
        if build.returncode:
            fail(f"{name} build", build)
            failed += 1
            continue
        output_directory = directory / "bin" / args.configuration
        if args.target == "Echoes":
            executable = output_directory / f"{name}.exe"
            execution_command = ([mono] if mono else []) + [str(executable)]
        elif args.target == "Cooper":
            executable = output_directory / f"{name}.jar"
            try:
                with zipfile.ZipFile(executable) as jar:
                    manifest = jar.read("META-INF/MANIFEST.MF").decode("utf-8")
                main_class = next(line.split(":", 1)[1].strip() for line in manifest.splitlines()
                                  if line.startswith("Main-Class:"))
            except (OSError, zipfile.BadZipFile, KeyError, StopIteration, UnicodeError) as error:
                print(f"FAIL {name}: cannot read Java entry point: {error}")
                failed += 1
                continue
            # A symlinked library manifest can resolve its own stale cooper.jar first.
            # Put the runtime selected for this build ahead of transitive manifests.
            class_path = os.pathsep.join((str(output_directory / "cooper.jar"), str(output_directory / "*")))
            execution_command = [args.java, "-cp", class_path, main_class]
        else:
            executables = [p for p in output_directory.rglob(name) if p.is_file() and os.access(p, os.X_OK)]
            if len(executables) != 1:
                print(f"FAIL {name}: expected one native executable, found {executables}")
                failed += 1
                continue
            execution_command = [str(executables[0])]
        execution = run(execution_command, directory, timeout=30)
        if execution.returncode or execution.stdout != expected:
            fail(f"{name} output", execution)
            print(f"Expected: {expected!r}")
            failed += 1
        else:
            print(f"PASS {name}: build and output")
            passed += 1
        if reference_script:
            env = dict(os.environ, PYTHONDONTWRITEBYTECODE="1")
            reference = run([sys.executable, reference_script], source_directory, env, timeout=30)
            if reference.returncode or reference.stdout != expected:
                fail(f"{name} CPython", reference)
                print(f"Expected: {expected!r}")
                failed += 1
            else:
                print(f"PASS {name}: CPython reference")
                python_passed += 1
    print(f"{args.target} {args.configuration}: {passed}/{len(samples)} passed; CPython: {python_passed}/{sum(bool(s[2]) for s in samples)} passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
