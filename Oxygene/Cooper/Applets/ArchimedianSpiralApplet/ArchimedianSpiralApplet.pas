namespace archimedianspiralapplet;

// Sample applet project by Brian Long (http://blong.com)
// Translated from Michael McGuffin's ArchimedianSpiral applet
// from http://profs.etsmtl.ca/mmcguffin/learn/java/12-miscellaneous

interface

uses
  java.util,
  java.applet.*,
  java.awt;

type
  ArchimedianSpiralApplet = public class(Applet)
  private
    var width, height: Integer;
    const N = 30; // number of points per full rotation
    const W = 5;  // winding number, or number of full rotations
  public
    method init(); override;
    method paint(g: Graphics); override;
  end;

implementation

method ArchimedianSpiralApplet.init();
begin
  width := Size.width;
  height := Size.height;
  Background := Color.BLACK;
  Foreground := Color.GREEN;
end;

method ArchimedianSpiralApplet.paint(g: Graphics);
begin
  var x1: Integer := 0;
  var y1: Integer := 0;
  var x2, y2: Integer;
  for i: Integer := 1 to W * N - 1 do
  begin
    var angle: Double := 2 * Math.PI * i / Double(N);
    var radius: Double := i / Double(N) * width / 2 / (W + 1);
    x2 := Integer(radius * Math.cos(angle));
    y2 := -Integer(radius * Math.sin(angle));
    g.drawLine(width / 2 + x1, height / 2 + y1, width / 2 + x2, height / 2 + y2);
    x1 := x2;
    y1 := y2
  end;
end;

end.