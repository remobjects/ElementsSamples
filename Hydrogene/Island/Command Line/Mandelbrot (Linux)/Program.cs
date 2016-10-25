namespace Mandelbrot
{

	/*
  This example demonstrates using varying density characters to render the
  Mandelbrot set out to stdout
  */

	public class ConsoleApp
	{
		public static void Main(String[] args)
		{
			const int cols = 78;
			const int lines = 30;
			const String chars = " .,`':;=|+ihIHEOQSB#$";
			const int maxIter = length(chars);

			var minRe = -2.0;
			var maxRe = 1.0;
			var minIm = -1.0;
			var maxIm = 1.0;
			var im = minIm;
			while (im <= maxIm)
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
						if (a + b > 4.0)
							break;
						zi = 2 * zr * zi + im;
						zr = a - b + re;
					}
					write(chars[n]);
					re += (maxRe - minRe) / cols;
				}
				writeLn();
				im += (maxIm - minIm) / lines;
			}
		}
	}
}
