namespace keyboardapplet;

interface

// Sample applet project by Brian Long (http://blong.com)
// Translated from Michael McGuffin's Keyboard2 applet
// from http://profs.etsmtl.ca/mmcguffin/learn/java/05-keyboardInput

uses
  java.applet,
  java.awt,
  java.awt.event,
  java.util;

type
  KeyboardApplet = public class(Applet, KeyListener, MouseListener, MouseMotionListener)
  private
    const N = 25; // the number of colors created
    var spectrum: array of Color; // arrays of elements, each of type Color
    var listOfPositions: Vector;
    var s: String := '';
    var skip: Integer := 0;
  public
    method init(); override;
    method paint(g: Graphics); override;
    method keyPressed(e: KeyEvent);
    method keyReleased(e: KeyEvent);
    method keyTyped(e: KeyEvent);
    method mouseEntered(e: MouseEvent);
    method mouseExited(e: MouseEvent);
    method mouseClicked(e: MouseEvent);
    method mousePressed(e: MouseEvent);
    method mouseReleased(e: MouseEvent);
    method mouseMoved(e: MouseEvent);
    method mouseDragged(e: MouseEvent);
  end;
  
implementation

method KeyboardApplet.init();
begin
  Background := Color.black;
  spectrum := new Color[N];
  for i: Integer := 0 to N - 1 do
    spectrum[i] := new Color(Color.HSBtoRGB(i / Double(N), 1, 1));
  listOfPositions := new Vector;
  addKeyListener(self);
  addMouseListener(self);
  addMouseMotionListener(self);
end;

method KeyboardApplet.paint(g: Graphics);
begin
  if s <> '' then
  begin
    for j: Integer := 0 to listOfPositions.size - 1 do
    begin
      g.Color := spectrum[j];
      var p := Point(listOfPositions.elementAt(j));
      g.drawString(s, p.x, p.y)
    end;
  end
end;

method KeyboardApplet.mouseEntered(e: MouseEvent);
begin
end;

method KeyboardApplet.mouseExited(e: MouseEvent);
begin
end;

method KeyboardApplet.mouseClicked(e: MouseEvent);
begin
  s := '';
  repaint;
  e.consume
end;

method KeyboardApplet.mousePressed(e: MouseEvent);
begin
end;

method KeyboardApplet.mouseReleased(e: MouseEvent);
begin
end;

method KeyboardApplet.mouseMoved(e: MouseEvent);
begin
  // only process every 5th mouse event
  if &skip > 0 then
  begin
    dec(&skip);
    exit
  end
  else
    &skip := 5;

  if listOfPositions.size >= N then
    // delete the first element in the list
    listOfPositions.removeElementAt(0);

  // add the new position to the end of the list
  listOfPositions.addElement(new Point(e.X, e.Y));

  repaint();
  e.consume()
end;

method KeyboardApplet.mouseDragged(e: MouseEvent);
begin
end;

method KeyboardApplet.keyPressed(e: KeyEvent);
begin
end;

method KeyboardApplet.keyReleased(e: KeyEvent);
begin
end;

method KeyboardApplet.keyTyped(e: KeyEvent);
begin
  var c := e.KeyChar;
  if c <> KeyEvent.CHAR_UNDEFINED then
  begin
    s := s + c;
    repaint;
    e.consume
  end
end;

end.