namespace GlHelper;
{$GLOBALS ON}
interface
uses
    rtl,
     RemObjects.Elements.RTL,
     OpenGL;

  const
    MAX_ATTRIBUTES = 8;


type

   TAttribute =  public record
        Location: Byte;
        Size: Byte;
        Normalized: Byte;
        Offset: Byte;
    end;

    VertexLayout=  public class
 {$REGION 'Internal Declarations'}
    private

            FProgram: GLuint;
            FAttributeCount: Byte;
            FStride: Byte;
            FAttributes: array [0 .. MAX_ATTRIBUTES - 1] of TAttribute;

        method getAttribute(const index : Integer): TAttribute;


    {$ENDREGION 'Internal Declarations'}

    public
    { Starts the definition of the vertex layout. You need to call this method
      before calling Add.

      Parameters:
      AProgram: the shader that uses this vertex layout. Should not  be 0.}



        constructor (const aProgram: GLuint);

    { Adds a vertex attribute to the layout.

      Parameters:
      AName: the name of the attribute as it appears in the shader.
      ACount: number of floating-point values for the attribute. For example,
      a 3D position contains 3 values and a 2D texture coordinate contains
      2 values.
      ANormalized: (optional) if set to True, values will be normalized from a
      0-255 range to 0.0 - 0.1 in the shader. Defaults to False.
      AOptional: (optional) if set to True, the attribute is ignored if it
      doesn't exist in the shader. Otherwise, an exception is raised if the
      attribute is not found.

      Returns:
      This instance, for use in a fluent API. }
        method &Add(const AName: String; const ACount: Integer;
        const ANormalized: Boolean := False; const AOptional: Boolean := False): VertexLayout;

// Properties
        property AttribCount : Byte read FAttributeCount;
        property Stride : Byte read FStride;
        property Attributes[index : Integer] : TAttribute read getAttribute;
    end;



  VertexArray = public class
    {$REGION 'Internal Declarations'}


  private

    class var
      FSupportsVAO: Boolean;
    class var
      FInitialized: Boolean;


  private
    FVertexBuffer: GLuint;
    FIndexBuffer: GLuint;
    FVertexArray: GLuint;
    FAttributes: array of TAttribute;
    FStride: Integer;
    FIndexCount: Integer;
    FRenderStarted: Boolean;

  private
     method Initialize;


  private

    method BeginRender;
    method EndRender;
  public

    method Render;

  public
    class constructor;
    {$ENDREGION 'Internal Declarations'}

  public
    { Creates a vertex array.

      Parameters:
      ALayout: the layout of the vertices in the array.
      AVertices: data containing the vertices in the given layout.
      ASizeOfVertices: size of the AVertices vertex data.
      AIndices: array of indices to the vertices defining the triangles.
      Must contain a multiple of 3 elements. }
    constructor (const ALayout: VertexLayout; const AVertices : Array of Single;  const AIndices : Array of UInt16);
    constructor (const ALayout: VertexLayout; const Vcount, Icount : Integer; const AVertices : ^Single;  const AIndices : ^UInt16);

    finalizer;
  end;




implementation

{$REGION 'Internal Declarations'}

method VertexLayout.getAttribute(const &index: Integer): TAttribute;
require
    &index >= 0;
    &index < FAttributeCount;
begin
    exit FAttributes[&index];
end;
{$ENDREGION}



constructor VertexLayout(const aProgram: GLuint);
require
    aProgram > 0;
begin
    inherited ();
    FProgram := aProgram;
end;

method VertexLayout.&Add(const AName: String; const ACount: Integer; const ANormalized: Boolean := false; const AOptional: Boolean := false): VertexLayout;
var
    Location, lStride: Integer;
begin
    if (FAttributeCount = MAX_ATTRIBUTES) then
        raise new Exception('Too many attributes in vertex layout');

    lStride := FStride + (ACount * sizeOf(Single));
    if (lStride >= 256) then
        raise new Exception('Vertex layout too big');

    Location := glGetAttribLocation(FProgram,  glStringHelper.toPansichar(AName));
    if (Location < 0) and (not AOptional) then
        raise new Exception(String.format('Attribute "{0}" not found in shader', [AName]));

    if (Location >= 0) then
    begin
      //  assert(Location <= 255);
        FAttributes[FAttributeCount].Location := Location;
        FAttributes[FAttributeCount].Size := ACount;
        FAttributes[FAttributeCount].Normalized := ord(ANormalized);
        FAttributes[FAttributeCount].Offset := FStride;
        inc(FAttributeCount);
    end;

    FStride := lStride;
    Result := Self;
end;

class constructor VertexArray;
begin
 {$IF TOFFEE}
  // FSupportsVAO := true;
  FInitialized := false;

  {$ENDIF}

end;

 method VertexArray.Initialize;
begin
  {$IF TOFFEE}
   FSupportsVAO := true;
  {$ELSE}
  FSupportsVAO := assigned(glGenVertexArrays);
  FSupportsVAO := FSupportsVAO and  assigned(glBindVertexArray) and assigned(glDeleteVertexArrays);
  {$ENDIF}
  FInitialized := True;
  // Disable for Testing......
 // FSupportsVAO := false;


end;

method VertexArray.Render;
begin
  if (not FRenderStarted) then
  begin
    BeginRender;
    glDrawElements(GL_TRIANGLES, FIndexCount, GL_UNSIGNED_SHORT, nil);
    glErrorCheck;
    EndRender;
  end
  else
    glDrawElements(GL_TRIANGLES, FIndexCount, GL_UNSIGNED_SHORT, nil);
end;

method VertexArray.BeginRender;
var
  I: Integer;
begin
  if (FRenderStarted) then
    Exit;

  if (FSupportsVAO) then
    { When VAO's are supported, we simple need to bind it... }
    glBindVertexArray(FVertexArray)
  else
  begin
      { Otherwise, we need to manually bind the VBO and EBO and configure and
        enable the attributes. }
    glBindBuffer(GL_ARRAY_BUFFER, FVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, FIndexBuffer);

    for I := 0 to length(FAttributes) - 1 do
      begin
      glVertexAttribPointer(FAttributes[I].Location, FAttributes[I].Size, GL_FLOAT, GLboolean(FAttributes[I].Normalized), FStride, Pointer(FAttributes[I].Offset));
      glEnableVertexAttribArray(FAttributes[I].Location);
    end;
  end;

  FRenderStarted := True;
end;

method VertexArray.EndRender;
var
  I: Integer;
begin
  if (not FRenderStarted) then
    Exit;

  FRenderStarted := False;

  if (FSupportsVAO) then
    { When VAO's are supported, we simple unbind it... }
    glBindVertexArray(0)
  else
  begin
      { Otherwise, we need to manually unbind the VBO and EBO and disable the
        attributes. }
    for I := 0 to length(FAttributes) - 1 do
      glDisableVertexAttribArray(FAttributes[I].Location);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
  end;
  glErrorCheck;
end;

finalizer VertexArray;
begin
  if (FSupportsVAO) then
    glDeleteVertexArrays(1, @FVertexArray);
  glDeleteBuffers(1, @FIndexBuffer);
  glDeleteBuffers(1, @FVertexBuffer);

end;

constructor VertexArray(const ALayout: VertexLayout; const AVertices: array of Single; const AIndices: array of UInt16 );
begin
  constructor (ALayout, AVertices.length, AIndices.length, @AVertices[0], @AIndices[0]);
end;



constructor VertexArray(const ALayout: VertexLayout; const Vcount, Icount: Integer; const AVertices: ^Single; const AIndices: ^UInt16);
var i : Integer;
begin
  inherited ();
  if (not FInitialized) then
    Initialize;

  FIndexCount := Icount;

   { Create vertex buffer and index buffer. }
  glGenBuffers(1, @FVertexBuffer);
  glGenBuffers(1, @FIndexBuffer);

  if (FSupportsVAO) then
  begin
    glGenVertexArrays(1, @FVertexArray);
    if FVertexArray > 0 then
      begin
    glBindVertexArray(FVertexArray);
    glErrorCheck;
    end
    else FSupportsVAO := false;
  end;

  glBindBuffer(GL_ARRAY_BUFFER, FVertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, Vcount * sizeOf(Single), Pointer(AVertices), GL_STATIC_DRAW);

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, FIndexBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, FIndexCount * sizeOf(UInt16), Pointer(AIndices), GL_STATIC_DRAW);

  if (FSupportsVAO) then
  begin
       { We can configure the attributes as part of the VAO }
    for i := 0 to ALayout.AttribCount - 1 do
      begin
      glVertexAttribPointer(ALayout.Attributes[i].Location, ALayout.Attributes[i].Size,
      GL_FLOAT, GLboolean(ALayout.Attributes[i].Normalized), ALayout.Stride,
      Pointer(ALayout.Attributes[i].Offset));
      glEnableVertexAttribArray(ALayout.Attributes[i].Location);
    end;
    glErrorCheck;

       { We can unbind the vertex buffer now since it is registered with the VAO.
         We cannot unbind the index buffer though. }
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
  end
  else
  begin
       { VAO's are not supported. We need to keep track of the attributes
         manually }
    FAttributes := new TAttribute[ALayout.AttribCount];
  //  SetLength(FAttributes, ALayout.FAttributeCount);
    for i := 0 to ALayout.AttribCount-1 do
      FAttributes[i]  := ALayout.Attributes[i];

    FStride := ALayout.Stride;
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
  end;
  glErrorCheck;
end;


end.