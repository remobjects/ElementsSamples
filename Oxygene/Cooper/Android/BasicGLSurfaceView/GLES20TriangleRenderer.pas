namespace com.example.android.basicglsurfaceview;

{*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *}

interface

uses
  java.io,
  java.nio,
  javax.microedition.khronos.egl,
  javax.microedition.khronos.opengles,
  android.content,
  android.graphics,
  android.opengl,
  android.os,
  android.util;

type
  GLES20TriangleRenderer = public class(GLSurfaceView.Renderer)
  private
    const TAG = 'GLES20TriangleRenderer';
    const FLOAT_SIZE_BYTES = 4;
    const TRIANGLE_VERTICES_DATA_STRIDE_BYTES = 5 * FLOAT_SIZE_BYTES;
    const TRIANGLE_VERTICES_DATA_POS_OFFSET = 0;
    const TRIANGLE_VERTICES_DATA_UV_OFFSET = 3;
    const mVertexShader = 
      'uniform mat4 uMVPMatrix;'#10 +
      'attribute vec4 aPosition;'#10 +
      'attribute vec2 aTextureCoord;'#10 +
      'varying vec2 vTextureCoord;'#10 +
      'void main() {'#10 +
      '  gl_Position = uMVPMatrix * aPosition;'#10 +
      '  vTextureCoord = aTextureCoord;'#10 +
      '}'#10;
    const mFragmentShader =
      'precision mediump float;'#10 +
      'varying vec2 vTextureCoord;'#10 +
      'uniform sampler2D sTexture;'#10 +
      'void main() {'#10 +
      '  gl_FragColor = texture2D(sTexture, vTextureCoord);'#10 +
      '}'#10;
    var mTriangleVerticesData: array of Single := [
       //  X, Y, Z, U, V
      -1.0, -0.5, 0, -0.5, 0.0,
       1.0, -0.5, 0, 1.5, -0.0,
       0.0,  1.11803399, 0, 0.5,  1.61803399 ]; readonly;
    var mTriangleVertices: FloatBuffer;
    var mMVPMatrix: array of Single := new Single[16];
    var mProjMatrix: array of Single := new Single[16];
    var mMMatrix: array of Single := new Single[16];
    var mVMatrix: array of Single := new Single[16];
    var mProgram: Integer;
    var mTextureID: Integer;
    var muMVPMatrixHandle: Integer;
    var maPositionHandle: Integer;
    var maTextureHandle: Integer;
    var mContext: Context;
    method loadShader(shaderType: Integer; source: String): Integer;
    method createProgram(vertexSource, fragmentSource: String): Integer;
    method checkGlError(op: String);
  public
    constructor(ctx: Context);
    method onDrawFrame(glUnused: GL10);
    method onSurfaceChanged(glUnused: GL10; width, height: Integer);
    method onSurfaceCreated(glUnused: GL10; config: javax.microedition.khronos.egl.EGLConfig);
  end;

implementation

constructor GLES20TriangleRenderer(ctx: Context);
begin
  mContext := ctx;
  mTriangleVertices := ByteBuffer.allocateDirect(mTriangleVerticesData.length * FLOAT_SIZE_BYTES).order(ByteOrder.nativeOrder).asFloatBuffer;
  mTriangleVertices.put(mTriangleVerticesData).position(0)
end;

method GLES20TriangleRenderer.onDrawFrame(glUnused: GL10);
begin
  //  Ignore the passed-in GL10 interface, and use the GLES20
  //  class's static methods instead.
  GLES20.glClearColor(0.0, 0.0, 1.0, 1.0);
  GLES20.glClear(GLES20.GL_DEPTH_BUFFER_BIT or GLES20.GL_COLOR_BUFFER_BIT);
  GLES20.glUseProgram(mProgram);
  checkGlError('glUseProgram');
  GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
  GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, mTextureID);
  mTriangleVertices.position(TRIANGLE_VERTICES_DATA_POS_OFFSET);
  GLES20.glVertexAttribPointer(maPositionHandle, 3, GLES20.GL_FLOAT, false, TRIANGLE_VERTICES_DATA_STRIDE_BYTES, mTriangleVertices);
  checkGlError('glVertexAttribPointer maPosition');
  mTriangleVertices.position(TRIANGLE_VERTICES_DATA_UV_OFFSET);
  GLES20.glEnableVertexAttribArray(maPositionHandle);
  checkGlError('glEnableVertexAttribArray maPositionHandle');
  GLES20.glVertexAttribPointer(maTextureHandle, 2, GLES20.GL_FLOAT, false, TRIANGLE_VERTICES_DATA_STRIDE_BYTES, mTriangleVertices);
  checkGlError('glVertexAttribPointer maTextureHandle');
  GLES20.glEnableVertexAttribArray(maTextureHandle);
  checkGlError('glEnableVertexAttribArray maTextureHandle');
  var time: Int64 := SystemClock.uptimeMillis mod 4000;
  var angle: Single := 0.090 * time;
  Matrix.setRotateM(mMMatrix, 0, angle, 0, 0, 1.0);
  Matrix.multiplyMM(mMVPMatrix, 0, mVMatrix, 0, mMMatrix, 0);
  Matrix.multiplyMM(mMVPMatrix, 0, mProjMatrix, 0, mMVPMatrix, 0);
  GLES20.glUniformMatrix4fv(muMVPMatrixHandle, 1, false, mMVPMatrix, 0);
  GLES20.glDrawArrays(GLES20.GL_TRIANGLES, 0, 3);
  checkGlError('glDrawArrays')
end;

method GLES20TriangleRenderer.onSurfaceChanged(glUnused: GL10; width, height: Integer);
begin
  //  Ignore the passed-in GL10 interface, and use the GLES20
  //  class's static methods instead.
  GLES20.glViewport(0, 0, width, height);
  var ratio: Single := Single(width) / height;
  Matrix.frustumM(mProjMatrix, 0, -ratio, ratio, -1, 1, 3, 7)
end;

method GLES20TriangleRenderer.onSurfaceCreated(glUnused: GL10; config: javax.microedition.khronos.egl.EGLConfig);
begin
  //  Ignore the passed-in GL10 interface, and use the GLES20
  //  class's static methods instead.
  mProgram := createProgram(mVertexShader, mFragmentShader);
  if mProgram = 0 then
    exit;
  maPositionHandle := GLES20.glGetAttribLocation(mProgram, 'aPosition');
  checkGlError('glGetAttribLocation aPosition');
  if maPositionHandle = -1 then
    raise new RuntimeException('Could not get attrib location for aPosition');
  maTextureHandle := GLES20.glGetAttribLocation(mProgram, 'aTextureCoord');
  checkGlError('glGetAttribLocation aTextureCoord');
  if maTextureHandle = -1 then
    raise new RuntimeException('Could not get attrib location for aTextureCoord');
  muMVPMatrixHandle := GLES20.glGetUniformLocation(mProgram, 'uMVPMatrix');
  checkGlError('glGetUniformLocation uMVPMatrix');
  if muMVPMatrixHandle = -1 then
    raise new RuntimeException('Could not get attrib location for uMVPMatrix');
  // Create our texture. This has to be done each time the
  // surface is created.
  var textures: array of Integer := new Integer[1];
  GLES20.glGenTextures(1, textures, 0);
  mTextureID := textures[0];
  GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, mTextureID);
  GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_NEAREST);
  GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_LINEAR);
  GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_S, GLES20.GL_REPEAT);
  GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_T, GLES20.GL_REPEAT);
  var &is: InputStream := mContext.Resources.openRawResource(R.raw.robot);
  var bmp: Bitmap;
  try
    bmp := BitmapFactory.decodeStream(&is);
  finally
    try
      &is.close;
    except
      on e: IOException do 
        ;//  Ignore.
    end;
  end;
  GLUtils.texImage2D(GLES20.GL_TEXTURE_2D, 0, bmp, 0);
  bmp.recycle;
  Matrix.setLookAtM(mVMatrix, 0, 0, 0, -5, 0, 0, 0, 0, 1.0, 0.0);
end;

method GLES20TriangleRenderer.loadShader(shaderType: Integer; source: String): Integer;
begin
  var shader: Integer := GLES20.glCreateShader(shaderType);
  if shader <> 0 then
  begin
    GLES20.glShaderSource(shader, source);
    GLES20.glCompileShader(shader);
    var compiled: array of Integer := new Integer[1];
    GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, compiled, 0);
    if compiled[0] = 0 then
    begin
      Log.e(TAG, 'Could not compile shader ' + shaderType + ':');
      Log.e(TAG, GLES20.glGetShaderInfoLog(shader));
      GLES20.glDeleteShader(shader);
      shader := 0
    end
  end;
  exit shader
end;

method GLES20TriangleRenderer.createProgram(vertexSource, fragmentSource: String): Integer;
begin
  var vertexShader: Integer := loadShader(GLES20.GL_VERTEX_SHADER, vertexSource);
  if vertexShader = 0 then
    exit 0;
  var pixelShader: Integer := loadShader(GLES20.GL_FRAGMENT_SHADER, fragmentSource);
  if pixelShader = 0 then
    exit 0;
  var program: Integer := GLES20.glCreateProgram;
  if program <> 0 then
  begin
    GLES20.glAttachShader(program, vertexShader);
    checkGlError('glAttachShader');
    GLES20.glAttachShader(program, pixelShader);
    checkGlError('glAttachShader');
    GLES20.glLinkProgram(program);
    var linkStatus: array of Integer := new Integer[1];
    GLES20.glGetProgramiv(program, GLES20.GL_LINK_STATUS, linkStatus, 0);
    if linkStatus[0] <> GLES20.GL_TRUE then
    begin
      Log.e(TAG, 'Could not link program: ');
      Log.e(TAG, GLES20.glGetProgramInfoLog(program));
      GLES20.glDeleteProgram(program);
      program := 0
    end
  end;
  exit program
end;

method GLES20TriangleRenderer.checkGlError(op: String);
begin
  var error: Integer;
  repeat
    error := GLES20.glGetError;
    if error <> GLES20.GL_NO_ERROR then
    begin
      Log.e(TAG, op + ': glError ' + error);
      raise new RuntimeException(op + ': glError ' + error)
    end
  until error = GLES20.GL_NO_ERROR
end;

end.