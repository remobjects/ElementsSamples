namespace GLExample;

interface
uses
  rtl,

  GlHelper,
  OpenGL;

type
  GL_Example_2 = class(IAppInterface)
  private
   // fTexture : Texture;
    shader : Shader;
    fVertexArray : VertexArray;

    FTexture1: Texture;
    FTexture2: Texture;
    FUniformOurTexture1: GLint;
    FUniformOurTexture2: GLint;

  public
    method initialize : Boolean;
    method Update(width, height : Integer; const ATotalTimeSec : Double := 0.3);
    method ChangeFillmode;
  end;

implementation


method GL_Example_2.initialize: Boolean;

const
  { Each vertex consists of a 3-element position and 3-element color. }
  VERTICES: array  of Single = [

    // Positions       // Texture Coords
     0.5,  0.4, 0.0,   1.0, 1.0,  // Top Right
     0.5, -0.4, 0.0,   1.0, 0.0,  // Bottom Right
    -0.5, -0.5, 0.0,   0.0, 0.0,  // Bottom Left
    -0.5,  0.5, 0.0,   0.0, 1.0]; // Top Left

    const
  { The indices define a single triangle }
      INDICES: array of UInt16 = [0, 1, 3, 1,2,3];

      Var VertexLayout : VertexLayout;

begin
    shader := new Shader('texture.vs', 'texture.fs');
    FUniformOurTexture1 := shader.GetUniformLocation('ourTexture1');
    FUniformOurTexture2 := shader.GetUniformLocation('ourTexture2');



 { Define layout of the attributes in the shader program. The shader program
    contains 2 attributes called "position" and "color". Both attributes are of
    type "vec3" and thus contain 3 floating-point values. }
    VertexLayout := new VertexLayout(shader._GetHandle)
   .Add('position', 3)
    .Add('texCoord', 2);

  { Create the vertex array }
    fVertexArray := new VertexArray(VertexLayout, VERTICES, INDICES);

  FTexture1 := new Texture('Tex1.JPG');
  FTexture2 := new Texture('coral.jpg');
  //FTexture2 := new Texture('gears.png');


  result := true;
end;

method GL_Example_2.Update(width, height : Integer; const ATotalTimeSec : Double := 0.3);
begin
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
  shader.Use;

  { Bind Textures using texture units }
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, FTexture1.Id);
  glUniform1i(FUniformOurTexture1, 0);
  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_2D, FTexture2.Id);
  glUniform1i(FUniformOurTexture2, 1);

  { Draw the rectangle }
  fVertexArray.Render;


end;

method GL_Example_2.ChangeFillmode;
begin
end;


end.