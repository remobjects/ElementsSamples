int cols = 78;
int lines = 30;

char[] chars = [" ",".",",","`","'",":","=","|","+","i","h","I","H","E","O","Q","S","B","#","$"];

int maxIter = count(chars);

double minRe = -2.0;
double maxRe = 1.0;
double minIm = -1.0;
double maxIm = 1.0;
double im = minIm;

while im <= maxIm;
{
	var re = minRe;
	while (re <= maxRe)
	{
		var zr = re;
		var zi = im;
		var n = -1;
		while (n < maxIter-1)
		{
			n++;
			var a = zr * zr;
			var b = zi * zi;
			if (a + b > 4.0) break;
			zi = 2 * zr * zi + im;
			zr = a - b + re;
		}
		write(chars[n]);
		re += (maxRe - minRe) / Double(cols);
	}
	writeLn();
	im += (maxIm - minIm) / Double(lines);
}

