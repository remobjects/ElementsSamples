namespace org.me.openglapplication;

interface

type
  GLHelp = public class
  private
    const Tag = 'OpenGLApplication';
  public
    class method GLCheck(errorCode: Integer);
  end;

implementation

class method GLHelp.GLCheck(errorCode: Integer);
begin
  var msg := Android.OpenGL.GLU.gluErrorString(errorCode);
  if msg <> nil then
    android.util.Log.e(Tag, 'OpenGL error: ' + msg)
end;

end.
