# Promethium samples

Ten original examples demonstrate everyday Python patterns and libPromethium APIs. Each has Echoes (.NET Framework 4.8), Cooper (Java), Island (macOS), and Toffee (macOS) projects with Debug and Release configurations. The non-Echoes projects link the same source files, so target differences remain visible.

| Sample | Patterns and library APIs | CPython reference |
| --- | --- | --- |
| [Word Frequency](Echoes/Command%20Line/Word%20Frequency/) | typed dictionaries, indexing, `re.split`, iteration | Same source |
| [Reading List](Echoes/Command%20Line/Reading%20List/) | classes, default arguments, properties, filtered comprehensions | Same source |
| [Context Manager](Echoes/Command%20Line/Context%20Manager/) | nested `with`, exception propagation and suppression | Same source |
| [Generator Pipeline](Echoes/Command%20Line/Generator%20Pipeline/) | `yield`, `range`, lazy iteration | Same source |
| [Trip Budget](Echoes/Command%20Line/Trip%20Budget/) | typed functions and cross-file declarations in an explicit namespace | Elements-specific |
| [JSON Configuration](Echoes/Command%20Line/JSON%20Configuration/) | `json.loads`, typed JSON nodes, `OrderedDict` | Separate script |
| [CSV Report](Echoes/Command%20Line/CSV%20Report/) | quoted fields through `csv.parse_line` and `csv.write_row` | Separate script |
| [Dependency Plan](Echoes/Command%20Line/Dependency%20Plan/) | generic `graphlib.TopologicalSorter` | Separate script |
| [Sensor Summary](Echoes/Command%20Line/Sensor%20Summary/) | `statistics.median_low`, `math.comb`, `isqrt`, `gcd` | Same source |
| [Binary Record](Echoes/Command%20Line/Binary%20Record/) | `struct` network-order helpers, `binascii.hexlify`, `len(bytes)` | Separate script |

Open `EverydayPython.sln` in the desired target's `Command Line` directory, or an individual sample solution. Samples require the corresponding Elements SDK and libPromethium; no external services or package installs are needed.

## Verification

```sh
python3 verify_samples.py --ebuild /path/to/EBuild.exe --target Echoes --configuration Debug
python3 verify_samples.py --ebuild /path/to/EBuild.exe --target Cooper --configuration Release --java /path/to/java
python3 verify_samples.py --ebuild /path/to/EBuild.exe --target Island --configuration Release --architecture arm64
python3 verify_samples.py --ebuild /path/to/EBuild.exe --target Toffee --configuration Release --architecture arm64
```

Run every target in both configurations for the release gate, or invoke the complete gate in one command:

```sh
python3 verify_matrix.py --ebuild /path/to/EBuild.exe --java /path/to/java
```

For a development build, add `--compiler-dll /path/to/RemObjects.Elements.dll --reference-root /path/to/PromethiumBaseLibrary/Source/Bin/Release --dont-sign`. The reference root selects the library build configuration independently of the sample configuration. CI can call this same command and use its exit status; it does not queue a CI build.

 The runner rebuilds each project, executes it with a timeout, and compares exact output against `expected-output.txt`. Failures produce a nonzero exit status. CPython reference checks are reported separately. The separate `Reference.py` scripts express equivalent behavior using CPython APIs; they do not imply identical library API surfaces.

The runner uses Mono to launch Framework EBuild on macOS/Linux, Mono for Echoes executables, Java for Cooper, and native execution for Island/Toffee. Use a Java runtime compatible with the SDK used by EBuild. Native projects currently target macOS; they do not validate Windows, Linux, iOS, or Android.

Use `--compiler-dll /path/to/RemObjects.Elements.dll` to test a branch compiler, `--reference-path /path/to/fresh/references` to select freshly built target libraries, and `--dont-sign` for an unsigned local compiler build. Repeat `--sample BinaryRecord` (or other binary names) for focused runs. Default compiler/reference selection tests the installed toolchain; branch overrides are development validation only.

## Language and library boundaries

Trip Budget uses `@namespace("trip_budget")` in both files and accesses their declarations directly. Elements project files do not automatically introduce Python modules named after filenames. Other examples import actual libPromethium namespaces.

The JSON sample uses libPromethium's typed `JsonValueNode` tree rather than CPython's dynamically typed dictionaries. CSV and binary samples use the library's explicit helper APIs. Each separate CPython reference makes that distinction visible.

See [known-gaps.md](known-gaps.md) for remaining compatibility limits. A successful build alone is never a passing runtime check.
