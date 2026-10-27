#!/usr/bin/env python3
"""Run the full Promethium sample release gate without filtering failed targets."""

import argparse
from pathlib import Path
import platform
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ebuild", required=True)
    parser.add_argument("--compiler-dll")
    parser.add_argument("--reference-root", help="libPromethium build output root, such as Source/Bin/Release")
    parser.add_argument("--java")
    parser.add_argument("--architecture", default=platform.machine())
    parser.add_argument("--dont-sign", action="store_true")
    args = parser.parse_args()
    runner = Path(__file__).with_name("verify_samples.py")
    references = {
        "Echoes": "Echoes/NET",
        "Cooper": "Cooper/Plain",
        "Island": "Island/macOS/" + args.architecture,
        "Toffee": "Toffee/macOS",
    }
    results = []
    for target, reference in references.items():
        for configuration in ("Debug", "Release"):
            command = [sys.executable, "-u", str(runner), "--ebuild", args.ebuild,
                       "--target", target, "--configuration", configuration,
                       "--architecture", args.architecture]
            if args.compiler_dll:
                command += ["--compiler-dll", args.compiler_dll]
            if args.reference_root:
                command += ["--reference-path", str(Path(args.reference_root) / reference)]
            if args.java:
                command += ["--java", args.java]
            if args.dont_sign:
                command.append("--dont-sign")
            print(f"\n=== {target} {configuration} ===", flush=True)
            result = subprocess.run(command)
            results.append((target, configuration, result.returncode))
    print("\nRelease gate summary:")
    for target, configuration, status in results:
        print(f"{target} {configuration}: {'PASS' if status == 0 else 'FAIL'}")
    return int(any(status != 0 for _, _, status in results))


if __name__ == "__main__":
    sys.exit(main())
