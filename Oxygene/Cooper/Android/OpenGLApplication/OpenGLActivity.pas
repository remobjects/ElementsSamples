namespace org.me.openglapplication;

//Multi-purpose activity that initiates OpenGL surface views
//Expects 2 values to be passed in Intent's extras:
//  isTranslucent: Boolean
//  openGLRendererClass: string

interface

uses
  java.util,
  android.os,
  android.app,
  android.content,
  android.util,
  android.view,
  android.widget,
  android.opengl,
  android.graphics,
  android.util;

type
  OpenGLActivity = public class(Activity)
  public
    const IsTranslucent = 'isTranslucent';
    const OpenGLRendererClass = 'openGLRendererClass';
    method onCreate(savedInstanceState: Bundle); override;
  end;

implementation

method OpenGLActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;
  if Intent.getBooleanExtra(IsTranslucent, False) then
    //Title bar can't be re-added in code, but can be removed
    //So the manifest sets a translucent theme with a title bar, and here we disable the title bar if necessary
    requestWindowFeature(Window.FEATURE_NO_TITLE)
  else
    //Translucency can't be enabled in code, but it can be disabled
    //So the manifest sets a translucent theme, and here we disable the theme if necessary
    Theme := Android.R.style.Theme;

  var view := new GLSurfaceView(Self);
  //view.DebugFlags := GLSurfaceView.DEBUG_CHECK_GL_ERROR or GLSurfaceView.DEBUG_LOG_GL_CALLS;
  
  if Intent.getBooleanExtra(IsTranslucent, False) then
  begin
    // We want an 8888 pixel format because that's required for a translucent window.
    // And we want a depth buffer.
    view.setEGLConfigChooser(8, 8, 8, 8, 16, 0);
    // Use a surface format with an Alpha channel:
    view.Holder.Format := PixelFormat.TRANSLUCENT;
  end;

  //Find which OpenGL renderer class was requested and instantiate it
  var targetRendererClass := Intent.StringExtra[OpenGLRendererClass];
  if length(targetRendererClass) > 0 then
  begin
    try
      var cls := &Class.forName(targetRendererClass);
      var con := cls.getDeclaredConstructor([typeOf(Context)]);
      view.setEGLConfigChooser(8, 8, 8, 8, 16, 0);
      view.Renderer := con.newInstance(Self) as GLSurfaceView.Renderer ;
    except
      on E: Throwable do
        Log.e(MainActivity.Tag, 'Exception creating OpenGL renderer', E)
    end;
    ContentView := view
  end
  else
    finish
end;

end.
