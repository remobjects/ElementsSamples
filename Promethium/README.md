# Promethium samples

These original examples exercise common Python patterns as complete Elements projects. The five Echoes command-line projects target .NET Framework 4.8. Four source files also run under CPython as reference cases; Trip Budget uses Promethium’s `@namespace` directive to share declarations across project files.

| Sample | Patterns | CPython reference |
| --- | --- | --- |
| [Word Frequency](Echoes/Command%20Line/Word%20Frequency/) | imports, `collections.Counter`, regular expressions, iteration | Yes |
| [Reading List](Echoes/Command%20Line/Reading%20List/) | classes, default arguments, `@property`, lists, loops | Yes |
| [Context Manager](Echoes/Command%20Line/Context%20Manager/) | nested `with`, exception propagation and suppression | Yes |
| [Generator Pipeline](Echoes/Command%20Line/Generator%20Pipeline/) | `yield`, `range`, generator iteration | Yes |
| [Trip Budget](Echoes/Command%20Line/Trip%20Budget/) | typed functions, default arguments, cross-file declarations | No; uses `@namespace` |

Open [EverydayPython.sln](Echoes/Command%20Line/EverydayPython.sln) to build the suite, or open an individual sample’s solution. No external services or package installs are required.

To build and run all projects, compare executable output with `expected-output.txt`, and compare the four portable scripts with CPython:

```sh
python3 verify_samples.py --ebuild /path/to/EBuild.exe
```

On macOS and Linux the runner invokes EBuild and sample executables through Mono. Use `--compiler-dll /path/to/RemObjects.Elements.dll` to test a branch compiler and `--dont-sign` if that local compiler build is unsigned. A sample passes only when it builds, exits successfully, and prints exactly its checked-in expected output. The CPython checks are reported separately.

These are end-to-end examples, not a claim of full CPython compatibility. Known gaps exposed while preparing the suite are listed in [known-gaps.md](known-gaps.md).
