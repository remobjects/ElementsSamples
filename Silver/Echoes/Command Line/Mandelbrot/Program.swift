let cols = 78
let lines = 30

var chars = [" ",".",",","`","'",":","=","|","+","i","h","I","H","E","O","Q","S","B","#","$"]

let maxIter = count(chars)

var minRe = -2.0
var maxRe = 1.0
var minIm = -1.0
var maxIm = 1.0
var im = minIm

while im <= maxIm
{
	var re = minRe
	while re <= maxRe
	{
		var zr = re
		var zi = im
		var n = -1
		while n < maxIter-1
		{
			n++
			var a = zr * zr
			var b = zi * zi
			if a + b > 4.0 { break }
			zi = 2 * zr * zi + im
			zr = a - b + re
		}
		print(chars[n], separator: "", terminator: "")
		re += (maxRe - minRe) / Double(cols)
	}
	print()
	im += (maxIm - minIm) / Double(lines)
}
