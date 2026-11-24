# Newton Observatory

Newton Observatory draws a picture of where Newton’s method takes you. Each cell starts at a different point in the complex plane. The solver takes up to 36 steps to find one of the three roots of `z³ − 1 = 0`. Points that reach the same root form a region called a *basin*. Try zooming in where three basins meet.

## Run the sample

Open `NewtonObservatory.sln`, choose a target, and run it. With no arguments, the program prints a 77 × 25 plate and counts how many cells reached each root. It then renders a small patch called `SOUTH-03` with the calibration palette.

Read the picture using the legend below the plate. The three character sets start with `@` for east, `O` for north, and `W` for south. Within each set, the character changes with the number of steps. A `?` marks a point where the solver stopped without finding a root. On the starting plate, that happens at the center, where the Newton step would divide by zero.

## Explore the picture

Pass `--explore` as a command-line argument and run in an interactive terminal. For example, run `./NewtonObservatory --explore` for a native macOS or Linux build. For .NET, use `dotnet NewtonObservatory.dll --explore`. For the JVM, use `java -jar newtonobservatory.jar --explore` from the output folder. The picture fills the terminal and redraws when you resize the window. The bottom line shows the view size, zoom, and, when space permits, the counts for the current view.

| Key | Action |
| --- | --- |
| Arrow keys | Move left, right, up, or down |
| `+` or `=` | Zoom in |
| `-` or `_` | Zoom out |
| `R` | Return to the starting view |
| `Q`, Ctrl+C, or Ctrl+D | Quit and return to the previous screen |

## Build targets

The project includes .NET 10 (Echoes), JVM (Cooper), Cocoa for macOS (Toffee), and native macOS, Linux, and Windows (Island). Choose a target with its SDK installed. EBuild fetches JLine for the JVM terminal. The default plate also works when you redirect the output to a file.

## In the source

Start with `Plate.myth` to follow one point from its starting position to the character printed for it. The `Explorer` file handles panning and zooming. The projects share the Oxygene terminal code that reads keys, detects resizes, and draws the frame.
