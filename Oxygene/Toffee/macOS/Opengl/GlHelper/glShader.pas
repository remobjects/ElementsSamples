namespace GlHelper;
{$GLOBALS ON}
interface
uses
  rtl,
  {$IF ISLAND AND Windows}
  //RemObjects.Elements.System,
  {$ELSEIF TOFFEE}
  Foundation,

  {$ENDIF}
  RemObjects.Elements.RTL,
  OpenGL;

type
 {$IF TOFFEE}
   PGLChar =  ^GLchar;
  {$ENDIF}

  Shader= public class
    {$REGION 'Internal Declarations'}
  private
    FProgram: GLuint;

  private
    class method CreateShader(const AShaderPath: String; const AShaderType: GLenum): GLuint;

  public
    { IShader }
    method _GetHandle: GLuint;
    method Use;

    method GetUniformLocation(const AName: String): Integer;
    {$ENDREGION 'Internal Declarations'}

  public
    { Creates a shader.

      Parameters:
      AVertexShaderPath: path into the assets.zip file containing the vertex
      shader (eg. 'shaders/MyShader.vs').
      AFragmentShaderPath: path into the assets.zip file containing the
      fragment shader (eg. 'shaders/MyShader.fs'). }
    constructor (const AVertexShaderPath, AFragmentShaderPath: String);
    finalizer ;
  end;
  {$IF DEBUG AND ISLAND}
  method glErrorCheck;
 {$ELSE}


    method glErrorCheck; inline; empty;
 {$ENDIF}

implementation
  {$IF DEBUG AND ISLAND}
method glErrorCheck;
var
  Error: GLenum;
begin

if assigned(glGetError) then
begin

  Error := glGetError();
  if (Error <> GL_NO_ERROR) then
    begin
      repeat until glGetError() = GL_NO_ERROR;

      raise new Exception(String.format('OpenGL Error: {0}', [Error]));
    end

  end;
end;
{$ENDIF}

{$REGION 'Internal Declarations'}

class method Shader.CreateShader(const AShaderPath: String; const AShaderType: GLenum): GLuint;

var
  Source: String;
//  SourcePtr: ^AnsiChar;
  Status,
  LogLength
//  ,ShaderLength
  : GLint;
 // Log: Array of AnsiChar;
  Msg: String;

begin

    Source := Asset.loadFile(AShaderPath);
    if String.IsNullOrEmpty(Source) then exit;


    Result := glCreateShader(AShaderType);

  //  assert(Result <> 0);
    glErrorCheck;


  {$IFNDEF MOBILE}
  { Desktop OpenGL doesn't recognize precision specifiers }
  if (AShaderType = GL_FRAGMENT_SHADER) then
    Source := '#define lowp'#10 + '#define mediump'#10 + '#define highp'#10 + Source;
  {$ENDIF}
  var ShaderSource : ^AnsiChar := glStringHelper.toPansichar(Source);
    glShaderSource(Result, 1, @ShaderSource, nil);
    glErrorCheck;

    glCompileShader(Result);
    glErrorCheck;

    Status := Integer(GL_FALSE);
    glGetShaderiv(Result, GL_COMPILE_STATUS, @Status);

    if (Status <> Integer(GL_TRUE)) then
    begin
      glGetShaderiv(Result, GL_INFO_LOG_LENGTH, @LogLength);
      if (LogLength > 0) then
      begin
        var Log := new  Byte[LogLength];
         glGetShaderInfoLog(Result, LogLength, @LogLength, PGLChar(@Log[0]));
         Msg := new String(Log, Encoding.UTF8);
        raise new Exception('CreateShader Exception '+Msg);
      end;
    end;

end;

method Shader._GetHandle: GLuint;
begin
  Result := FProgram;
end;

method Shader.Use;
begin
  glUseProgram(FProgram);
end;

method Shader.GetUniformLocation(const AName: String): Integer;
begin
  Result := glGetUniformLocation(FProgram, glStringHelper.toPansichar(AName));
end;


{$ENDREGION}

constructor Shader(const AVertexShaderPath: String; const AFragmentShaderPath: String);
var
  Status, LogLength: GLint;
  VertexShader, FragmentShader: GLuint;
 // Log: array of Byte;
 // Msg: String;
begin

  FragmentShader := 0;
  VertexShader := CreateShader(AVertexShaderPath, GL_VERTEX_SHADER);
  try
    FragmentShader := CreateShader(AFragmentShaderPath, GL_FRAGMENT_SHADER);
    FProgram := glCreateProgram();

    glAttachShader(FProgram, VertexShader);
    glErrorCheck;

    glAttachShader(FProgram, FragmentShader);
    glErrorCheck;

    glLinkProgram(FProgram);
    glGetProgramiv(FProgram, GL_LINK_STATUS, @Status);

    if (Status <> Integer(GL_TRUE)) then
    begin
      glGetProgramiv(FProgram, GL_INFO_LOG_LENGTH, @LogLength);
      if (LogLength > 0) then
      begin
       var Log := new  Byte[LogLength];

        glGetProgramInfoLog(FProgram, LogLength, @LogLength,  PGLChar(@Log[0]));
        var Msg :=  new String(Log, Encoding.UTF8);
        raise new Exception('CreateProgram Exception '+Msg);
      end;
    end;
    glErrorCheck;
  finally
    if (FragmentShader <> 0) then
      glDeleteShader(FragmentShader);

    if (VertexShader <> 0) then
      glDeleteShader(VertexShader);
  end;
end;

finalizer Shader;
begin
  glUseProgram(0);
  if (FProgram <> 0) then
    glDeleteProgram(FProgram);
end;

end.