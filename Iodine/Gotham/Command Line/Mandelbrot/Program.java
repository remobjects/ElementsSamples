package mandelbrot;

/*
This example demonstrates using varying density characters to render the
Mandelbrot set out to stdout
*/

public class ConsoleApp
{
	public static void Main(String []args)
	{
		
		int cols = 78;
		int lines = 30;
		
		char []chars = new char[] {' ','.',',','`','\'',':','=','|','+','i','h','I','H','E','O','Q','S','B','#','$'};;
		
		int maxIter = length(chars);
		
		double minRe = -2.0;
		double maxRe = 1.0;
		double minIm = -1.0;
		double maxIm = 1.0;
		double im = minIm;
		
		while (im <= maxIm)
		{
			double re = minRe;
			while (re <= maxRe)
			{
				double zr = re;
				double zi = im;
				int n = -1;
				while (n < maxIter-1)
				{
					n++;
					double a = zr * zr;
					double b = zi * zi;
					if (a + b > 4.0) break;
					zi = 2 * zr * zi + im;
					zr = a - b + re;
				}
				write(chars[n]);
				re += (maxRe - minRe) / (Double)cols;
			}
			writeLn();
			im += (maxIm - minIm) / (Double)lines;
		}
	}
}
