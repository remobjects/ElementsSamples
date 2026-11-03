# Shared UI

One controller owns the inputs, calculation and result. Each platform supplies its native window and an adapter. This is the source-sharing approach used by Fire, Water and Earth: share application behavior while retaining the native toolkit.

Open `SharedUI.sln` and select the target you want to run.

## Targets and prerequisites

| Project | Native UI | Requirements |
| --- | --- | --- |
| SharedUI.Cocoa | AppKit window from `MainWindow.xib` | macOS, Xcode and an Elements Cocoa SDK |
| SharedUI.WPF | WPF window from `MainWindow.xaml` | Windows and .NET 10 Desktop Runtime; .NET 10 SDK to build |
| SharedUI.GTK | GTK 4 window from `MainWindow.ui` through GirCore | .NET 10 and the native GTK/GObject libraries required by GirCore 0.8.1; NuGet access for the pinned dependency |
| SharedUI.VCL | Delphi VCL form from `MainWindow.dfm` | Windows x64, Elements Island, imported Delphi 13 SDK and matching Delphi runtime packages |

Build a selected project with EBuild, for example from this directory:

```sh
ebuild SharedUI.GTK/SharedUI.GTK.elements --configuration:Debug
```

Cocoa produces an app bundle; WPF and VCL run on Windows. Launch GTK with `dotnet SharedUI.GTK.dll` from its output directory on a host with the required native GTK libraries.

## Code layout

- `MainWindowController` contains the shared state, `Notify` properties and `calculateResult` action.
- `MainWindowController.Cocoa/WPF/GTK/VCL` contains only the native integration: constructing the view, connecting inputs/actions and displaying result notifications.
- `MainWindow.xib`, `MainWindow.xaml`, `MainWindow.ui` and `MainWindow.dfm` live beside the controller in `SharedUI.Shared`. The GTK build embeds `MainWindow.ui`; its partial loads the layout with `Gtk.Builder` and connects the named controls to the shared properties and action. The layout does not depend on the process working directory.
- `MainWindow.dfm.pas` is the Delphi form class. It forwards native events to the shared controller. The form and controller are separate objects; VCL owns the form and the application retains the controller.
- Cocoa uses native bindings, WPF uses `DataContext`, and GTK/VCL adapt native events to the same shared properties. No calculation is duplicated in a view.

## Expected behavior and checks

The initial result is `N/A`. Entering `21` and `21` produces `42`; `-1.5` and `2.5` produces `1`. Non-numeric inputs concatenate, so `Hello, ` and `world` produces `Hello, world`. An empty input produces `(value required)`. Numeric parsing is invariant so the same input has the same meaning on every target.

The test project checks calculation, input validation and property-change
notifications without opening a window:

```sh
ebuild SharedUI.Tests/SharedUI.Tests.elements
```

Run the resulting `SharedUI.Tests.dll` with `dotnet`.
