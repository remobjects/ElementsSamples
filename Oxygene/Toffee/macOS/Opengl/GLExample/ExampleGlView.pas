namespace GLExample;

interface
uses
  AppKit,
  OpenGL,
  GlHelper,
  Foundation,
  RemObjects.Elements.RTL;

  [IBObject]
type Gl_View = public class(NSOpenGLView)
private
  fApp: IAppInterface;
  fwx  : GLint;
  fwy  : GLint;
  fww :   GLsizei;
  fwh : GLsizei;


  ftime : Double := 0.1;

  class method  getTicks(): UInt64;

public

// Overrides from NSVIEW
  method drawRect(dirtyRect: NSRect); override;

//  method keyUp(&event: not nullable NSEvent); override;

 // Overrides from NSOpenGLView
  method reshape; override;

  method update; override;
  method prepareOpenGL; override;
  method clearGLContext; override;


// Own Methods and Properties
  method Repaint;


  property app : IAppInterface read fApp write fApp;
  property speed : Integer read write;
end;

implementation


method Gl_View.drawRect(dirtyRect: NSRect);
begin

  Repaint;

end;

method Gl_View.reshape;
begin
  inherited;
  fwx :=  GLint(NSMinX(bounds));
  fwy  :=  GLint(NSMinY(bounds));
  fww :=  GLsizei(NSWidth(bounds));
  fwh := GLsizei(NSHeight(bounds));
  glViewport(fwx, fwy, fww, fwh); // Map OpenGL projection plane to NSWindow

end;

method Gl_View.update;
begin
  inherited;
end;

method Gl_View.prepareOpenGL;
begin
  inherited;
end;

method Gl_View.clearGLContext;
begin
  inherited;
end;

method Gl_View.Repaint;
begin

{ Clear the color and depth buffer }
  glClearColor(0.3, 0.3, 0.3, 1.0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 { Enable depth testing }
  glEnable(GL_DEPTH_TEST);
  if fApp <> nil then fApp.update(fww, fwh, ftime);
  ftime := ftime + 0.01;
  if ftime > 15 then ftime := 0.1;

  glFlush();
  openGLContext.flushBuffer;


end;

class method  Gl_View.getTicks(): UInt64;
begin
  var t : __struct_timeval;
  gettimeofday(var t, nil);
  exit UInt64(t.tv_sec * 1000) + UInt64(t.tv_usec / 1000)

end;


end.