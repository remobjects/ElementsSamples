namespace org.me.openglapplication;

//The animated cube code was based on, and enhanced from, an example from
//"Hello, Android" by Ed Burnette, published by Pragmatic Bookshelf, 2010

{$define TEXTURES} //also in GLRenderer

interface

uses
  java.nio,
  javax.microedition.khronos.opengles,
  android.content,
  android.graphics,
  android.opengl,
  android.util;

type
  GLCube = public class
  private
    var mVertexBuffer: IntBuffer;
  {$ifdef TEXTURES}
    var mTextureBuffer: IntBuffer;
  {$endif}
    const Tag = 'GLRenderer';
  public
    constructor;
    method Draw(gl: GL10);
    class method loadTexture(gl: GL10; ctx: Context; resource: Integer);
  end;

implementation

constructor GLCube;
begin
  var one := 65536;
  var half := one / 2;
  var vertices: array of Integer := [
    // FRONT
    -half, -half, half, half, -half, half,
    -half, half, half, half, half, half,
    // BACK
    -half, -half, -half, -half, half, -half,
    half, -half, -half, half, half, -half,
    // LEFT
    -half, -half, half, -half, half, half,
    -half, -half, -half, -half, half, -half,
    // RIGHT
    half, -half, -half, half, half, -half,
    half, -half, half, half, half, half,
    // TOP
    -half, half, half, half, half, half,
    -half, half, -half, half, half, -half,
    // BOTTOM
    -half, -half, half, -half, -half, -half,
    half, -half, half, half, -half, -half];
{$ifdef TEXTURES}
  var texCoords: array of Integer := [
    // FRONT
    0, one, one, one, 0, 0, one, 0,
    // BACK
    one, one, one, 0, 0, one, 0, 0,
    // LEFT
    one, one, one, 0, 0, one, 0, 0,
    // RIGHT
    one, one, one, 0, 0, one, 0, 0,
    // TOP
    one, 0, 0, 0, one, one, 0, one,
    // BOTTOM
    0, 0, 0, one, one, 0, one, one];
 {$endif}
  // Buffers to be passed to gl*Pointer() functions must be
  // direct, i.e., they must be placed on the native heap
  // where the garbage collector cannot move them.
  //
  // Buffers with multi-SByte data types (e.g., short, int,
  // float) must have their SByte order set to native order
  var vbb := ByteBuffer.allocateDirect(vertices.length * 4);
  vbb.order(ByteOrder.nativeOrder());
  mVertexBuffer := vbb.asIntBuffer();
  mVertexBuffer.put(vertices);
  mVertexBuffer.position(0);
{$ifdef TEXTURES}
  var tbb := ByteBuffer.allocateDirect(texCoords.length * 4);
  tbb.order(ByteOrder.nativeOrder());
  mTextureBuffer := tbb.asIntBuffer();
  mTextureBuffer.put(texCoords);
  mTextureBuffer.position(0)
{$endif}
end;

method GLCube.Draw(gl: GL10);
begin
  //Enable vertex buffer for writing to and to be used during render
  gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);
  //Identify vertex buffer and its format
  gl.glVertexPointer(3, GL10.GL_FIXED, 0, mVertexBuffer);
{$ifdef TEXTURES}
  //Enable 2D texture buffer for writing to and to be used during render
  gl.glEnable(GL10.GL_TEXTURE_2D);
  //Identify texture buffer and its format
  gl.glTexCoordPointer(2, GL10.GL_FIXED, 0, mTextureBuffer);
{$endif}
  //Set current colour to white
  gl.glColor4f(1, 1, 1, 1);
  gl.glNormal3f(0, 0, 1);
  gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, 0, 4);
  gl.glNormal3f(0, 0, -1);
  gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, 4, 4);

  //Set current colour to white
  gl.glColor4f(1, 1, 1, 1);
  gl.glNormal3f(-1, 0, 0);
  gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, 8, 4);
  gl.glNormal3f(1, 0, 0);
  gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, 12, 4);

  //Set current colour to white
  gl.glColor4f(1, 1, 1, 1);
  gl.glNormal3f(0, 1, 0);
  gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, 16, 4);
  gl.glNormal3f(0, -1, 0);
  gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, 20, 4);

  //Disable vertex buffer
  gl.glDisableClientState(GL10.GL_VERTEX_ARRAY);
  //Disable texture buffer
  gl.glDisable(GL10.GL_TEXTURE_2D);
end;

class method GLCube.loadTexture(gl: GL10; ctx: Context; resource: Integer);
begin
  //Ensure the image is not auto-scaled for device density on extraction
  var options := new BitmapFactory.Options;
  options.inScaled := False;
  //Load image from resources
  var bmp := BitmapFactory.decodeResource(ctx.Resources, resource, options);
  GLUtils.texImage2D(GL10.GL_TEXTURE_2D, 0, bmp, 0);
  GLHelp.GLCheck(gl.glGetError);
  //Scale linearly if texture is bigger than image
  gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MIN_FILTER, GL10.GL_LINEAR);
  //Scale linearly if texture is smaller than image
  gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MAG_FILTER, GL10.GL_LINEAR);
  bmp.recycle()
end;

end.