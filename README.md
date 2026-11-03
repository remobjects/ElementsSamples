# Elements Samples

Official samples for the [RemObjects Elements](https://www.elementscompiler.com) languages and platforms. Open a sample's `.sln` in Fire, Water, Earth or Visual Studio where supported, or build its `.elements` project with EBuild. Use a current Elements release and the SDKs required by the selected target. Samples on the current branch may need newer features than older installed releases; release tags retain historical versions.

## Where to start

- [Shared UI](Oxygene/All/SharedUI/README.md): shared controller behavior with native Cocoa, WPF, GTK and Delphi VCL views.
- [Calculator](Oxygene/All/Calculator): a shared evaluator with separate native application hosts.
- [UIKit](Oxygene/Toffee/UIKit): scene lifecycle, navigation, collections, native controls and custom drawing. Modernized applications require iOS 13 or later.
- [Android](Oxygene/Cooper/Android): native activities, Bluetooth, lifecycle-owned work and widgets. Check each manifest and project for SDK requirements.
- [Myth](Myth/README.md): six shared command-line examples for .NET, JVM and native macOS, with output and behavioral verification.
- [Python](Promethium/README.md): practical language/library examples, expected output and target verification commands.
- [Legacy](Legacy/README.md): deprecated examples retained at their original relative language/platform paths for historical and compatibility use.

## Organization

Paths start with a language, then a platform and optional topic. Language folders use the compiler code names:

| Folder | Language |
| --- | --- |
| Oxygene | Object Pascal |
| Hydrogene | C# |
| Silver | Swift |
| Iodine | Java |
| Gold | Go |
| Mercury | Visual Basic |
| Promethium | Python, preview |
| Myth | Myth, preview |

| Folder | Platform |
| --- | --- |
| All / Cross-Platform | Multiple targets or shared source |
| Echoes | .NET |
| Cooper | JVM and Android |
| Toffee | Native Apple platforms |
| Island | Native targets, including Windows, Linux, Darwin and WebAssembly where demonstrated |
| Gotham | Shared cross-platform libraries |

Native UI samples require the platform toolkit; third-party integration samples list their required libraries in their READMEs.

The authoritative repository is [remobjects/ElementsSamples](https://github.com/remobjects/ElementsSamples). Contributions should include required resources, clear prerequisites and a way to verify the demonstrated behavior. Use Elements projects for sample tests.
