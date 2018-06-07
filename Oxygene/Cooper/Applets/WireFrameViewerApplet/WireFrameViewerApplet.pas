namespace wireframeviewerapplet;

// Sample applet project by Brian Long (http://blong.com)
// Translated from Michael McGuffin's WireframeViewer applet
// from http://profs.etsmtl.ca/mmcguffin/learn/java/11-3d

interface

uses
  java.applet.*,
  java.awt.*,
  java.awt.event.*;

type
  Point3D = class
  public
    var x, y, z: Integer;
    constructor(xCoord, yCoord, zCoord: Integer);
  end;

  Edge = class
  public
    var a, b: Integer;
    constructor(vertexA, vertexB: Integer);
  end;

  WireFrameViewerApplet = public class(Applet, MouseListener, MouseMotionListener)
  private
    var width, height: Integer;
    var mx, my: Integer; // the most recently recorded mouse coordinates
    var backbuffer: Image;
    var backg: Graphics;
    var azimuth: Integer := 35;
    var elevation: Integer := 30;
    var vertices: array of Point3D;
    var edges: array of Edge;
  public
    method init(); override;
    method paint(g: Graphics); override;
    method update(g: Graphics); override;
    method mouseEntered(e: MouseEvent);
    method mouseExited(e: MouseEvent);
    method mouseClicked(e: MouseEvent);
    method mousePressed(e: MouseEvent);
    method mouseReleased(e: MouseEvent);
    method mouseMoved(e: MouseEvent);
    method mouseDragged(e: MouseEvent);
    method drawWireFrame(g: Graphics);
  end;

implementation

constructor Point3D(xCoord, yCoord, zCoord: Integer);
begin
  x := xCoord;
  y := yCoord;
  z := zCoord;
end;

constructor Edge(vertexA, vertexB: Integer);
begin
  a := vertexA;
  b := vertexB;
end;

method WireFrameViewerApplet.init();
begin
  width := Size.width;
  height := Size.height;
  vertices := new Point3D[8];
  vertices[0] := new Point3D(-1, -1, -1);
  vertices[1] := new Point3D(-1, -1, 1);
  vertices[2] := new Point3D(-1, 1, -1);
  vertices[3] := new Point3D(-1, 1, 1);
  vertices[4] := new Point3D(1, -1, -1);
  vertices[5] := new Point3D(1, -1, 1);
  vertices[6] := new Point3D(1, 1, -1);
  vertices[7] := new Point3D(1, 1, 1);
  edges := new Edge[12];
  edges[0] := new Edge(0, 1);
  edges[1] := new Edge(0, 2);
  edges[2] := new Edge(0, 4);
  edges[3] := new Edge(1, 3);
  edges[4] := new Edge(1, 5);
  edges[5] := new Edge(2, 3);
  edges[6] := new Edge(2, 6);
  edges[7] := new Edge(3, 7);
  edges[8] := new Edge(4, 5);
  edges[9] := new Edge(4, 6);
  edges[10] := new Edge(5, 7);
  edges[11] := new Edge(6, 7);
  backbuffer := createImage(width, height);
  backg := backbuffer.Graphics;
  drawWireFrame(backg);
  addMouseListener(self);
  addMouseMotionListener(self)
end;

method WireFrameViewerApplet.mouseEntered(e: MouseEvent);
begin
end;

method WireFrameViewerApplet.mouseExited(e: MouseEvent);
begin
end;

method WireFrameViewerApplet.mouseClicked(e: MouseEvent);
begin
end;

method WireFrameViewerApplet.mousePressed(e: MouseEvent);
begin
  mx := e.X;
  my := e.Y;
end;

method WireFrameViewerApplet.mouseReleased(e: MouseEvent);
begin
end;

method WireFrameViewerApplet.mouseMoved(e: MouseEvent);
begin
end;

method WireFrameViewerApplet.mouseDragged(e: MouseEvent);
begin
  // get the latest mouse position
  var new_mx := e.X;
  var new_my := e.Y;

  // adjust angles according to the distance travelled by the mouse
  // since the last event
  azimuth := azimuth - (new_mx - mx);
  elevation := elevation + (new_my - my);

  // update the backbuffer
  drawWireFrame( backg );

  // update our data
  mx := new_mx;
  my := new_my;

  repaint;
  e.consume;
end;

method WireFrameViewerApplet.paint(g: Graphics);
begin
  update(g)
end;

method WireFrameViewerApplet.update(g: Graphics);
begin
  g.drawImage( backbuffer, 0, 0, Self );
  showStatus("Elev: " + elevation + " deg, Azim: " + azimuth + " deg");
end;

method WireFrameViewerApplet.drawWireFrame(g: Graphics);
const near: Single = 3;  // distance from eye to near plane
const nearToObj: Single = 1.5;  // distance from near plane to center of object
begin
  // compute coefficients for the projection
  var theta: Double := Math.PI * azimuth / 180.0;
  var phi: Double := Math.PI * elevation / 180.0;
  var cosT := Single(Math.cos( theta ));
  var sinT := Single(Math.sin( theta ));
  var cosP := Single(Math.cos( phi ));
  var sinP := Single(Math.sin( phi ));
  var cosTcosP := cosT*cosP;
  var cosTsinP := cosT*sinP;
  var sinTcosP := sinT*cosP;
  var sinTsinP := sinT*sinP;

  // project vertices onto the 2D viewport
  var points := new Point[ vertices.length ];
  var scaleFactor := width/4;
  for j: Integer := 0 to vertices.length - 1 do
  begin
    var x0 := vertices[j].x;
    var y0 := vertices[j].y;
    var z0 := vertices[j].z;

    // compute an orthographic projection
    var x1 := cosT*x0 + sinT*z0;
    var y1 := -sinTsinP*x0 + cosP*y0 + cosTsinP*z0;

    // now adjust things to get a perspective projection
    var z1 := cosTcosP*z0 - sinTcosP*x0 - sinP*y0;
    x1 := x1*near / (z1+near+nearToObj);
    y1 := y1*near / (z1+near+nearToObj);

    // the 0.5 is to round off when converting to int
    points[j] := new Point(
      Integer(width / 2 + scaleFactor*x1 + 0.5),
      Integer(height / 2 - scaleFactor*y1 + 0.5)
    );
  end;

  // draw the wireframe
  g.Color := Color.BLACK;
  g.fillRect( 0, 0, width, height );
  g.Color := Color.WHITE;
  for j: Integer := 0 to edges.length - 1 do
    g.drawLine(
      points[ edges[j].a ].x, points[ edges[j].a ].y,
      points[ edges[j].b ].x, points[ edges[j].b ].y
    );
end;

end.