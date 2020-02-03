package Mandelbrot

func main() {
	cols := 78
	lines := 30
	chars := " .,`':=|+ihIHEOQSB#$"
	maxIter := length(chars)

	var minRe = -2.0
	var maxRe = 1.0
	var minIm = -1.0
	var maxIm = 1.0
	var im = minIm
	for im <= maxIm {
		var re = minRe
		for re <= maxRe {
			var zr = re
			var zi = im
			var n = -1
			for n < maxIter-1 {
				n++
				var a = zr * zr
				var b = zi * zi
				if a + b > 4.0 {
					break
				}
				zi = 2 * zr * zi + im
				zr = a - b + re
			}
			write(chars[n])
			re += (maxRe - minRe) / cols
		}
		writeLn()
		im += (maxIm - minIm) / lines
	}
}