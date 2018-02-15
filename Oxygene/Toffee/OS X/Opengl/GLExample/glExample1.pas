namespace GLExample;

interface
uses
  rtl,
  GlHelper,
  OpenGL;

type
  GL_Example_1 = class(IAppInterface)
  private
    shader : Shader;
    fVertexArray : VertexArray;


  public
    method initialize : Boolean;
    method Update(width, Height : Integer; const ATotalTimeSec : Double := 0.3);
    method ChangeFillmode;
  end;

implementation


method GL_Example_1.initialize: Boolean;

const
  { Each vertex consists of a 3-element position and 3-element color. }
  VERTICES: array  of Single = [
    // Positions      // Colors
  0.5, -0.5, 0.0,   1.0, 0.0, 0.0,  // Bottom Right
   -0.5, -0.5, 0.0,   0.0, 1.0, 0.0,  // Bottom Left
    0.0,  0.5, 0.0,   0.30, 0.3, 1.0];

    const
  { The indices define a single triangle }
      INDICES: array of UInt16 = [0, 2, 1];

      Var VertexLayout : VertexLayout;

begin
  try
    shader := new Shader('basic.vs', 'basic.fs');
    if shader._GetHandle > 0 then
    begin
 { Define layout of the attributes in the shader program. The shader program
    contains 2 attributes called "position" and "color". Both attributes are of
    type "vec3" and thus contain 3 floating-point values. }
      VertexLayout := new VertexLayout(shader._GetHandle)
      .Add('position', 3)
      .Add('color', 3);


  { Create the vertex array }
      fVertexArray := new VertexArray(VertexLayout, VERTICES, INDICES);
      result := true;
    end;
  except
    on E : Exception do writeLn(E.Message);
  end;
end;

method GL_Example_1.Update(width, Height : Integer; const ATotalTimeSec : Double := 0.3);
begin


  { Define the viewport dimensions }

//  glViewport(0, 0, width, Height);

  { Clear the color buffer }
  glClearColor(0.2, 0.3, 0.3, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

  { Draw the triangle }
  if shader._GetHandle <> 0 then
  begin
    shader.Use;
    fVertexArray.Render;
  end;

end;

method GL_Example_1.ChangeFillmode;
begin
end;


end.