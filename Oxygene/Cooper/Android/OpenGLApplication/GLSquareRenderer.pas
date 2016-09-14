namespace org.me.openglapplication;

{$define LOG_FPS}

interface

uses
  android.app,
  android.content,
  android.opengl,
  android.util,
  java.nio,
  javax.microedition.khronos.opengles,
  javax.microedition.khronos.egl;

type
  GLSquareRenderer = public class(GLSurfaceView.Renderer)
  private
    const Tag = 'GLSquareRenderer';
    var ctx: Context;
    var mVertexBuffer: FloatBuffer;
    var mColorBuffer: ByteBuffer;
    var startTime: Int64;
  {$ifdef LOG_FPS}
    var fpsStartTime, numFrames: Int64;
  {$endif}
  public
    constructor(aContext: Context);
    method OnSurfaceCreated(gl: GL10; config: EGLConfig);
    method OnSurfaceChanged(gl: GL10; width, height: Integer);
    method OnDrawFrame(gl: GL10);
  end;

implementation

constructor GLSquareRenderer(aContext: Context);
begin
  ctx := aContext;
  // Buffers to be passed to gl*Pointer() functions must be
  // direct, i.e., they must be placed on the native heap
  // where the garbage collector cannot move them.
  //
  // Buffers with multi-SByte data types (e.g., short, int,
  // float) must have their SByte order set to native order
  var vertices: array of Single := [
     -1, -1,
      1, -1,
     -1,  1, 
      1,  1];
  var vbb := ByteBuffer.allocateDirect(vertices.length * 4);
  vbb.order(ByteOrder.nativeOrder());
  mVertexBuffer := vbb.asFloatBuffer();
  mVertexBuffer.put(vertices);
  mVertexBuffer.position(0);
  var colors: array of SByte := [
      255 as Integer, 255 as Integer, 0,              255 as Integer,  //yellow
      0,              255 as Integer, 255 as Integer, 255 as Integer,  //cyan
      0,              0,              0,              255 as Integer,  //black
      255 as Integer, 0,              255 as Integer, 255 as Integer]; //purple
  mColorBuffer := ByteBuffer.allocateDirect(colors.length);
  mColorBuffer.order(ByteOrder.nativeOrder());
  mColorBuffer.put(colors);
  mColorBuffer.position(0);
end;

method GLSquareRenderer.OnSurfaceCreated(gl: GL10; config: EGLConfig);
begin
  startTime := System.currentTimeMillis();
{$ifdef LOG_FPS}
  fpsStartTime := startTime;
  numFrames := 0;
{$endif}

  // Set up any OpenGL options we need

  //Enable depth-testing
  gl.glEnable(GL10.GL_DEPTH_TEST);
  //Specifically <= type depth-testing
  gl.glDepthFunc(GL10.GL_LEQUAL);
  //Set clearing colour to grey if we're not in traslucent mode
  if not (ctx as Activity).Intent.getBooleanExtra(OpenGLActivity.IsTranslucent, false) then
    gl.glClearColor(0.5, 0.5, 0.5, 1);

  // Optional: disable dither to boost performance
  // gl.glDisable(GL10.GL_DITHER);
end;

//Called e.g. if device rotated
method GLSquareRenderer.OnSurfaceChanged(gl: GL10; width, height: Integer);
begin
  //Set current view port to new size
  gl.glViewport(0, 0, width, height);
  //Select projection matrix
  gl.glMatrixMode(GL10.GL_PROJECTION);
  //Reset projection matrix
  gl.glLoadIdentity();
  var ratio := Single(width) / height;
  //Calculate window aspect ratio
  gl.glFrustumf(-ratio, ratio, -1, 1, 1, 10);
end;

method GLSquareRenderer.OnDrawFrame(gl: GL10);
begin
  var elapsed := System.currentTimeMillis() - startTime;

  // Clear the screen
  gl.glClear(GL10.GL_COLOR_BUFFER_BIT or GL10.GL_DEPTH_BUFFER_BIT);

  // Position model so we can see it, and spin it

  //Select model view matrix
  gl.glMatrixMode(GL10.GL_MODELVIEW);
  //Reset model view matrix
  gl.glLoadIdentity();
  //Move viewpoint 3 steps out of the screen
  gl.glTranslatef(0, 0, -3);
  //Rotate view 40 degrees per second
  gl.glRotatef(elapsed * (40.0/1000), 0, 0, 1);

  // Draw the shape

  //Enable vertex buffer for writing to and to be used during render
  gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);
  //Identify vertex buffer and its format
  gl.glVertexPointer(2, GL10.GL_FLOAT, 0, mVertexBuffer);
  //Enable colour array buffer for use in rendering
  gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
  //Identify the colour array buffer
  gl.glColorPointer(4, GL10.GL_UNSIGNED_BYTE, 0, mColorBuffer);
  //Draw triangle strips from the 4 coordinates - 2 triangles
  gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, 0, 4);

{$ifdef LOG_FPS}
  // Keep track of number of frames drawn
  inc(numFrames);
  var fpsElapsed := System.currentTimeMillis() - fpsStartTime;
  if fpsElapsed > 5 * 1000 then
  begin
    // every 5 seconds
    var fps := (numFrames * 1000) / fpsElapsed;
    Log.d(Tag, 'Frames per second: ' + fps + ' (' + numFrames + ' frames in ' + fpsElapsed + ' ms)');
    fpsStartTime := System.currentTimeMillis();
    numFrames := 0
  end
{$endif}
end;


end.