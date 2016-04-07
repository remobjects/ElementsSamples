namespace org.me.openglapplication;

//The animated cube code was based on, and enhanced from, an example from
//"Hello, Android" by Ed Burnette, published by Pragmatic Bookshelf, 2010

{$define LOG_FPS}
{$define SEETHRU}
{$define TEXTURES} //also in GLCube
{$define ACTION}
{$define LIGHTING}
{$define MATERIALS}

interface

uses
  android.content,
  android.opengl,
  android.util,
  javax.microedition.khronos.opengles,
  javax.microedition.khronos.egl;

type
  GLCubeRenderer = public class(GLSurfaceView.Renderer)
  private
    const Tag = 'GLCubeRenderer';
    var ctx: Context;
    var cube: GLCube := new GLCube;
    var startTime, fpsStartTime, numFrames: Int64;
  public
    constructor (aContext: Context);
    method OnSurfaceCreated(gl: GL10; config: EGLConfig);
    method OnSurfaceChanged(gl: GL10; width, height: Integer);
    method OnDrawFrame(gl: GL10);
  end;

implementation

constructor GLCubeRenderer(aContext: Context);
begin
  ctx := aContext;
end;

method GLCubeRenderer.OnSurfaceCreated(gl: GL10; config: EGLConfig);
begin
  //Set up any OpenGL options we need
{$ifdef SEETHRU}
  var SEE_THRU := true;
{$endif}
  startTime := System.currentTimeMillis();
  fpsStartTime := startTime;
  numFrames := 0;
  // Set up any OpenGL options we need
  
  //Enable depth-testing
  gl.glEnable(GL10.GL_DEPTH_TEST);
  //Specifically only show items at less or same depth than others
  gl.glDepthFunc(GL10.GL_LEQUAL);
  //Set background colour to black
  gl.glClearColor(0, 0, 0, 0.5);

  // Optional: disable dither to boost performance
  // gl.glDisable(GL10.GL_DITHER);

{$ifdef LIGHTING}
  //Enable lighting in general and light 0 specifically
  gl.glEnable(GL10.GL_LIGHTING);
  gl.glEnable(GL10.GL_LIGHT0);
  //Specify ambient RGBA light intensity. Default is (0,0,0,1)
  gl.glLightfv(GL10.GL_LIGHT0, GL10.GL_AMBIENT, [0.2, 0.2, 0.2, 1], 0);
  //Specify diffuse RGBA light intensity to be (1,1,1,1), which is the default
  gl.glLightfv(GL10.GL_LIGHT0, GL10.GL_DIFFUSE, [1, 1, 1, 1], 0);
  //Specify where light is. Default is (0,0,1,0)
  gl.glLightfv(GL10.GL_LIGHT0, GL10.GL_POSITION, [1, 1, 1, 1], 0);
{$endif}
{$ifdef MATERIALS}
  // What is the cube made of?
  //Specify ambient RGBA reflectance. Default is (0.2,0.2,0.2,1)
  gl.glMaterialfv(GL10.GL_FRONT_AND_BACK, GL10.GL_AMBIENT, [1, 1, 1, 1], 0);
  //Specify diffuse RGBA reflectance. Default is (0.8,0.8,0.8,1)
  gl.glMaterialfv(GL10.GL_FRONT_AND_BACK, GL10.GL_DIFFUSE, [1, 1, 1, 1], 0);
{$endif}
  
{$ifdef SEETHRU}
  if SEE_THRU then
  begin
    //Disable depth testing
    gl.glDisable(GL10.GL_DEPTH_TEST);
    //Enable colour blending
    gl.glEnable(GL10.GL_BLEND);
    gl.glBlendFunc(GL10.GL_SRC_ALPHA, GL10.GL_ONE)
  end;
{$endif}
{$ifdef TEXTURES}
  // Enable textures
  gl.glEnableClientState(GL10.GL_TEXTURE_COORD_ARRAY);
  gl.glEnable(GL10.GL_TEXTURE_2D);

  // Load the cube's texture from a bitmap
  GLCube.loadTexture(gl, ctx, R.drawable.eye)
{$endif}
end;

//Called e.g. if device rotated
method GLCubeRenderer.OnSurfaceChanged(gl: GL10; width, height: Integer);
begin
  //Set current view port to new size
  gl.glViewport(0, 0, width, height);
  //Select projection matrix
  gl.glMatrixMode(GL10.GL_PROJECTION);
  //Reset projection matrix
  gl.glLoadIdentity();
  var ratio := Single(width) / height;
  //Calculate window aspect ratio
  //gl.glFrustumf(-ratio, ratio, -1, 1, 1, 10); //OpenGL version
  GLU.gluPerspective(gl, 45, ratio, 1, 100);  //GLU version
end;

method GLCubeRenderer.OnDrawFrame(gl: GL10);
begin
  // Clear the screen and depth buffer
  gl.glClear(GL10.GL_COLOR_BUFFER_BIT or GL10.GL_DEPTH_BUFFER_BIT);

  // Position model so we can see it

  //Select model view matrix
  gl.glMatrixMode(GL10.GL_MODELVIEW);
  //Reset model view matrix
  gl.glLoadIdentity();
  //Move viewpoint 4 units out of the screen
  gl.glTranslatef(0, 0, -4);

  // Other drawing commands go here...

  // Set rotation angle based on the time
  var elapsed := System.currentTimeMillis() - startTime;
{$ifdef ACTION}
  //Rotate around X & Y axes 30 degrees/sec and 15 degrees/sec respectively
  gl.glRotatef(elapsed * (30.0 / 1000), 0, 1, 0);
  gl.glRotatef(elapsed * (15.0 / 1000), 1, 0, 0);
{$endif}

  // Draw the model
  cube.Draw(gl);

{$ifdef LOG_FPS}
  // Keep track of number of frames drawn
  inc(numFrames);
  var fpsElapsed := System.currentTimeMillis() - fpsStartTime;
  if fpsElapsed > 5 * 1000 then
  begin
    // every 5 seconds
    var fps := (numFrames * 1000) / fpsElapsed;
    Log.i(Tag, 'Frames per second: ' + fps + ' (' + numFrames + ' frames in ' + fpsElapsed + ' ms)');
    fpsStartTime := System.currentTimeMillis();
    numFrames := 0
  end
{$endif}
end;

end.