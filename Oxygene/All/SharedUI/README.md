# Shared UI

One controller owns the inputs, calculation and result. Each platform supplies its native window and an adapter. This is the source-sharing approach used by Fire, Water and Earth: share application behavior while retaining the native toolkit.

Open `SharedUI.sln` and select the target you want to run. The Oxygene, Hydrogene, Iodine, Silver and Mercury copies each contain a complete Cocoa/WPF/GTK/VCL implementation in that language.

## Targets and prerequisites

| Project | Native UI | Requirements |
| --- | --- | --- |
| SharedUI.Cocoa | AppKit window from `MainWindow.xib` | macOS, Xcode and an Elements Cocoa SDK |
| SharedUI.WPF | WPF window from `MainWindow.xaml` | Windows and .NET 10 Desktop Runtime; .NET 10 SDK to build |
| SharedUI.GTK | GTK 4 window from `MainWindow.ui` through GirCore | .NET 10 and the native GTK/GObject libraries required by GirCore 0.8.1; NuGet access for the pinned dependency |
| SharedUI.VCL | Delphi VCL form from `MainWindow.dfm` | Windows x64, Elements Island, imported Delphi 13 SDK and matching Delphi runtime packages |

Use a current Elements compiler. SDKs and platform libraries are installed separately; selecting a target in the solution does not install them. Build a selected project with EBuild, for example from this directory:

```sh
ebuild SharedUI.GTK/SharedUI.GTK.elements --configuration:Debug
```

Run the selected project from Fire, Water or Earth on a host with its native UI dependencies. Cocoa produces an app bundle; WPF and VCL run on Windows. The GTK output can also be launched with `dotnet SharedUI.GTK.dll` from its output directory after the native GTK libraries are installed. Build and run are separate checks, particularly for cross-compiled VCL binaries.

## Code layout

- `MainWindowController` contains the shared state, `Notify` properties and `calculateResult` action.
- `MainWindowController.Cocoa/WPF/GTK/VCL` contains only the native integration: constructing the view, connecting inputs/actions and displaying result notifications.
- `MainWindow.xib`, `MainWindow.xaml`, `MainWindow.ui` and `MainWindow.dfm` live beside the controller in `SharedUI.Shared`. The GTK build embeds `MainWindow.ui`; its partial loads the layout with `Gtk.Builder` and connects the named controls to the shared properties and action. The layout does not depend on the process working directory.
- `MainWindow.dfm.<language>` is the Delphi form class. It forwards native events to the shared controller. The form and controller are separate objects; VCL owns the form and the application retains the controller.
- Cocoa uses native bindings, WPF uses `DataContext`, and GTK/VCL adapt native events to the same shared properties. No calculation is duplicated in a view.

Calculator is a separate sample: it currently shares its evaluator across native hosts. It does not yet use SharedUI's shared-controller pattern.

## Expected behavior and checks

The initial result is `N/A`. Entering `21` and `21` produces `42`; `-1.5` and `2.5` produces `1`. Non-numeric inputs concatenate, so `Hello, ` and `world` produces `Hello, world`. An empty input produces `(value required)`. Numeric parsing is invariant so the same input has the same meaning on every target.

The Elements test project compiles the selected language's real shared controller with one Oxygene test harness. It checks these cases and verifies result-change notifications without requiring a GUI:

```sh
ebuild SharedUI.Tests/SharedUI.Tests.elements
```

The sibling `SharedUI.Hydrogene.Tests.elements`, `SharedUI.Iodine.Tests.elements`, `SharedUI.Silver.Tests.elements` and `SharedUI.Mercury.Tests.elements` projects select the other implementations. Run the resulting `SharedUI.Tests.dll` with `dotnet`. Use distinct output/intermediate directories when retaining several language builds. This verifies shared behavior; each native host still needs interaction checks for input, Calculate/Enter, result updates, resizing, close/reopen and platform lifetime.

Gold is intentionally excluded from this partial-class UI design. Python and Myth are not represented by incomplete runnable projects: Python needs native attributes to survive property lowering, and Myth needs partial classes and authored native attributes before it can express this implementation.
