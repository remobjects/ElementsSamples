# Myth samples

The command-line projects share their source in `All/Command Line` across .NET,
JVM and native macOS.

| Sample | Demonstrates |
| --- | --- |
| Word Frequency | String splitting, dictionaries and deterministic output |
| Reading List | Constructors, readonly properties, a computed getter and filtering |
| Trip Budget | Multiple source files, typed arrays and method overloads |
| Sensor Summary | Lower median, integer square root and Euclidean GCD |
| Dependency Plan | Stable topological ordering, shared dependencies and cycle detection |
| Binary Record | Big-endian unsigned 16-bit encoding and decoding |

Open `Command Line/CommandLineSamples.sln` within a target folder, or an individual
sample's solution. The projects require a Myth-enabled Elements compiler:

- `Echoes`: .NET 10 SDK/runtime.
- `Cooper`: a supported JDK and Elements Java libraries.
- `Toffee`: macOS SDK, Xcode tools and an Apple Silicon Mac.
- `Island`: macOS SDK, Elements Island libraries and an Apple Silicon Mac.

The native projects target macOS arm64.

## Behavior

The sensor helpers accept nonnegative square-root/GCD inputs and reject empty
median input. Binary records contain exactly two bytes in big-endian order.
Budget amounts are whole units.

String comparisons use RTL value comparison; Myth reference equality tests
identity.

## Verification

Run from this folder with Python 3 and a Myth-enabled Elements installation:

```sh
python3 verify_samples.py --ebuild /path/to/EBuild.dll \
  --target Echoes Cooper Toffee Island
```

The runner rebuilds and runs each project in Debug and Release, comparing stdout
with its `expected-output.txt`. It also runs the behavior tests in `Tests`.

Use `--sample WordFrequency` to select one sample, `--java /path/to/java` to select
a JVM, or `--output /path/to/new-directory` to choose where build output and logs
are written. Without `--output`, the runner creates a temporary directory.
`--compiler /path/to/RemObjects.Elements.dll` selects an alternate compiler.

## Shared UI

[SharedUI](All/SharedUI/README.md) demonstrates a shared controller with native
Cocoa, WPF, GTK and VCL windows.
