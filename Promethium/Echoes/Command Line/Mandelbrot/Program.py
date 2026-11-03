# Render the Mandelbrot set with density characters, as in the Oxygene sample.
# Integer grid coordinates keep the output dimensions independent of rounding.
def escape_index(real: float, imaginary: float, limit: int) -> int:
    zr: float = real
    zi: float = imaginary
    iteration: int = 0
    while iteration < limit - 1:
        real_squared: float = zr * zr
        imaginary_squared: float = zi * zi
        if real_squared + imaginary_squared > 4.0:
            return iteration
        zi = 2.0 * zr * zi + imaginary
        zr = real_squared - imaginary_squared + real
        iteration += 1
    return iteration


width: int = 78
height: int = 30
palette: str = " .,`':;=|+ihIHEOQSB#$"
for row in range(height):
    imaginary: float = -1.0 + 2.0 * row / (height - 1)
    line: str = ""
    for column in range(width):
        real: float = -2.0 + 3.0 * column / (width - 1)
        line += palette[escape_index(real, imaginary, len(palette))]
    print(line)
