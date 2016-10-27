namespace org.me.openglsquare;

//Sample app by Brian Long (http://blong.com)

{
  This example demonstrates using OpenGL in an Android View to draw a spinning
  coloured square
}

interface

uses
  java.util,
  android.os,
  android.app,
  android.util,
  android.view,
  android.widget,
  android.opengl;
  
type
  MainActivity = public class(Activity)
  public
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  var view := new GLSurfaceView(Self);
  //view.DebugFlags := GLSurfaceView.DEBUG_CHECK_GL_ERROR or GLSurfaceView.DEBUG_LOG_GL_CALLS;
  view.setEGLConfigChooser(8, 8, 8, 8, 16, 0);
  view.Renderer := new GLSquareRenderer;
  ContentView := view;
end;

end.
