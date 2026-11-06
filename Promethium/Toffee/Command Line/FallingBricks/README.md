# Falling Bricks

A colorful terminal game written in RemObjects Python (Promethium), with a
seven-piece bag, rotation with wall kicks, a landing preview, line scoring,
levels, pause and restart.

Open `FallingBricks.sln` in Fire, or build with Elements:

```sh
ebuild FallingBricks.sln --configuration:Release
```

Run the resulting `FallingBricks` executable in an interactive macOS terminal
with ANSI escape-sequence support and at least 52 columns by 26 rows. The
program prints a short explanation and exits when input or output is redirected.
It uses an alternate screen and restores the terminal settings on normal exit
or when an exception unwinds the game loop.

| Key | Action |
| --- | --- |
| Left / A | Move left |
| Right / D | Move right |
| Up / W / X | Rotate |
| Down / S / Space | Drop and lock the piece |
| P | Pause or resume |
| R | Restart |
| Q / Ctrl+C | Quit |

Letter controls use lowercase, except P, R and Q, which also accept uppercase.
Clearing one, two, three or four lines awards 1, 4, 9 or 16 points. The fall
speed increases after every ten cleared lines.

`Program.py` contains the game, renderer and terminal input loop. This version
targets Cocoa on macOS: it uses Foundation strings, timing and buffers, and
Darwin's 64-bit terminal ABI through `ioctl`. It is an example of native API
interop from Promethium and requires no CPython installation or external
packages.
