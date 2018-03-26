namespace clockapplet;

// Sample applet project by Brian Long (http://blong.com)
// Translated from Michael McGuffin's Clock1 applet
// from http://profs.etsmtl.ca/mmcguffin/learn/java/09-clocks

interface

uses
  java.util.*,
  java.applet.*,
  java.awt.*,
  java.text.*;

type
  ClockApplet = public class(Applet, Runnable)
  private
    var width, height: Integer;
    var t: Thread := nil;
    var threadSuspended: Boolean;
    var hours: Integer := 0;
    var minutes: Integer := 0;
    var seconds: Integer := 0;
    var timeString: String := '';
    method drawHand(angle: Double; radius: Integer; g: Graphics);
    method drawWedge(angle: Double; radius: Integer; g: Graphics);
  public
    method init(); override;
    method paint(g: Graphics); override;
    method start; override;
    method stop; override;
    method run;
  end;

implementation

method ClockApplet.init();
begin
  width := Size.width;
  height := Size.height;
  Background := Color.BLACK;
end;

method ClockApplet.stop;
begin
  threadSuspended := true;
end;

method ClockApplet.start;
begin
  if t = nil then
  begin
    t := new Thread(self);
    t.setPriority(Thread.MIN_PRIORITY);
    threadSuspended := false;
    t.start()
  end
  else
  begin
    if threadSuspended then
    begin
      threadSuspended := false;
      locking Self do
        notify
    end
  end
end;

method ClockApplet.run;
begin
  try
    while true do
    begin
      // Here's where the thread does some work
      var cal := Calendar.Instance;
      hours := cal.get(Calendar.HOUR_OF_DAY);
      if hours > 12 then
        hours := hours - 12;
      minutes := cal.get(Calendar.MINUTE);
      seconds := cal.get(Calendar.SECOND);

      var date := cal.Time;
      // Note that some (maybe older) browsers interpret the 'default' timezone as
      // something different to the local timezone, so this string might show the
      // wrong time if using the commented code - the hands, however, will be right
      //var formatter := new SimpleDateFormat('hh:mm:ss', Locale.getDefault());
      //timeString := formatter.format(date);
      timeString := date.toString();

      // Now the thread checks to see if it should suspend itself
      if threadSuspended then
        locking Self do
          while threadSuspended do
            wait;
      repaint();
      t.sleep(1000) // interval given in milliseconds
    end
  except
    on InterruptedException do
      //Nothing
  end;
end;

method ClockApplet.drawHand(angle: Double; radius: Integer; g: Graphics);
begin
  angle := angle - 0.5 * Math.PI;
  var x := Integer(radius * Math.cos(angle));
  var y := Integer(radius * Math.sin(angle));
  g.drawLine(width / 2, height / 2, width / 2 + x, height / 2 + y)
end;

method ClockApplet.drawWedge(angle: Double; radius: Integer; g: Graphics);
begin
  angle := angle - 0.5 * Math.PI;
  var x := Integer(radius * Math.cos(angle));
  var y := Integer(radius * Math.sin(angle));
  angle := angle + 2 * Math.PI / 3;
  var x2 := Integer(5 * Math.cos(angle));
  var y2 := Integer(5 * Math.sin(angle));
  angle := angle + 2 * Math.PI / 3;
  var x3 := Integer(5 * Math.cos(angle));
  var y3 := Integer(5 * Math.sin(angle));
  g.drawLine(width / 2 + x2, height / 2 + y2, width / 2 + x, height / 2 + y);
  g.drawLine(width / 2 + x3, height / 2 + y3, width / 2 + x, height / 2 + y);
  g.drawLine(width / 2 + x2, height / 2 + y2, width / 2 + x3, height / 2 + y3)
end;

method ClockApplet.paint(g: Graphics);
begin
  g.setColor(Color.GRAY);
  drawWedge(2 * Math.PI * hours / 12, width / 5, g);
  drawWedge(2 * Math.PI * minutes / 60, width / 3, g);
  drawHand(2 * Math.PI * seconds / 60, width / 2, g);
  g.setColor(Color.WHITE);
  g.drawString(timeString, 10, height - 10)
end;

end.