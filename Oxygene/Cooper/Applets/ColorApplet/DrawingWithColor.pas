namespace colorapplet;

// Sample applet project by Brian Long (http://blong.com)
// Translated from Michael McGuffin's DrawingWithColor2 applet
// from http://profs.etsmtl.ca/mmcguffin/learn/java/03-color/

interface

uses
  java.util,
  java.applet.*,
  java.awt;

type
  ColorApplet = public class(Applet)
  private
    var width, height: Integer;
    const N = 25; // the number of colors created
    var spectrum: array of Color; // arrays of elements, each of type Color
  public
    method init(); override;
    method paint(g: Graphics); override;
  end;

implementation

method ColorApplet.init();
begin
  width := Size.width;
  height := Size.height;
  Background := Color.BLACK;
  spectrum := new Color[N];
  // Generate the colors and store them in the array.
  for i: Integer := 0 to N - 1 do
    // Here we specify colors by Hue, Saturation, and Brightness,
    // each of which is a number in the range [0,1], and use
    // a utility routine to convert it to an RGB value before
    // passing it to the Color() constructor.
    spectrum[i] := new Color(Color.HSBtoRGB(i / Double(N), 1, 1))
end;

method ColorApplet.paint(g: Graphics);
const Msg = 'Cooper';
begin
  var radius: Integer := width / 3;
  var msgLen := g.FontMetrics.stringWidth(Msg);
  for i: Integer := 0 to N - 1 do
  begin
    // Compute (x,y) positions along a circle,
    // using the sine and cosine of an appropriately computed angle.
    var angle: Double := 2 * Math.PI * i / N;
    var x := Integer(radius * Math.cos(angle));
    var y := Integer(radius * Math.sin(angle));
    g.Color := spectrum[i];
    g.drawString(Msg, (width - msgLen) / 2 + x, height / 2 + y)
  end;
end;

end.