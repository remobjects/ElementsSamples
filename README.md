# Elements Samples

This git repository contains the official sample suite for the [RemObjects Elements](http://www.elementscompiler.com) compiler and tool chain, including all three languages (Oxygene, C# and Swift) and all three currently supported platforms (.NET, Cocoa and Java/Android).

Most of these samples ship with and are installed by the Elements installer for Windows; this repository represents a complete super-set of those samples, and might contain newer versions. Fire 8.4 and later provides the option to install these samples directly from the git repository.

Please refer to branch and tag names to know which version of the compiler samples are targeted at; the base level of samples works with Elements 8.3 and later. The state of samples shipped with each release of Elements will me marked with a tag named `release-` plus the release month (e.g. `release-mar16` for the Elements 8.3 release shipped in March 2016).

The official repository URL is [github.com/remobjects/ElementsSamples](https://github.com/remobjects/ElementsSamples); the latest versions of samples can always be found there, and pull requests and contributions are welcome!

## Structure

Samples are grouped by language first, then by platform. Underneath each language/platform combo, samples may or may not be grouped by logical categories, depending own the scope and amount of samples in the section.

The folder names use the language and platform code names:

Languages:

* **Oxygene** &ndash; the Oxygene (Object Pascal) Language
* **Hydrogene** &ndash; RemObjects C#
* **Silver** &ndash; RemObjects Swift
* **Iodine** &ndash; RemObjects Java

Platforms:

* **All** &ndash; cross-platform samples, spanning two or more platforms
* **Echoes** &ndash; .NET, including Mono, WinRT, Windows Phone, Silverlight, Universal apps, and Xamarin
* **Cooper** &ndash; Java and Android
* **Toffee** &ndash; Cocoa, including macOS, iOS, tvOS and watchOS
* **Gotham** &ndash; Elements’ “Meta” platform for cross-platform libraries
* **Island** &ndash; Elements’ “Native” platform for Windows, Linux and Darwin

Each sample ships with a .SLN file that can be opened in both Fire, Water and Visual Studio (where applicable), and also built from the command line using EBuild or MSBuild/xbuild.

Enjoy!
