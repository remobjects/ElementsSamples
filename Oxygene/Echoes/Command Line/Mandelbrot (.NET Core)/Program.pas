namespace mandelbrot;

// Sample app by Brian Long (http://blong.com)

{
  This example demonstrates using varying density characters to render the
  Mandelbrot set out to stdout
}

interface

type
  ConsoleApp = class
  public
    class method Main(args: array of String);
  end;

implementation

class method ConsoleApp.Main(args: array of String);
const 
  cols = 78;
  lines = 30;
  chars = " .,`':;=|+ihIHEOQSB#$";
  maxIter = length(chars);
begin
  var minRe := -2.0;
  var maxRe := 1.0;
  var minIm := -1.0;
  var maxIm := 1.0;
  var im := minIm;
  while im <= maxIm do begin
    var re := minRe;
    while re <= maxRe do begin
      var zr := re;
      var zi := im;
      var n: Integer := -1;
      while n < maxIter-1 do begin
        inc(n);
        var a := zr * zr; 
        var b := zi * zi;
        if a + b > 4.0 then
          Break;
        zi := 2 * zr * zi + im;
        zr := a - b + re;
      end;
      write(chars[n]);
      re := re + ((maxRe - minRe) / cols);
    end;
    writeLn();
    im := im + ((maxIm - minIm) / lines)
  end;
  //Press ENTER to continue
  writeLn("Press ENTER to exit");
  Console.Read();
end;

end.
