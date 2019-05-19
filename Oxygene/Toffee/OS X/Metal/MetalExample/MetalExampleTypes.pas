namespace MetalExample;

interface

// Buffer index values shared between shader and Oxygene code to ensure Metal shader buffer inputs match
//   Metal API buffer set calls
const AAPLVertexInputIndexVertices     = 0;
const AAPLVertexInputIndexViewportSize = 1;


type
  vector_float2 = Array[0..1] of Single;
  vector_float4 = Array[0..3] of Single;

  //vector_float2 = TVector2;
  //vector_float4 = TVector4;

type

//  This structure defines the layout of each vertex in the array of vertices set as an input to our
//    Metal vertex shader.  Since this header is shared between our .metal shader and C code,
//    we can be sure that the layout of the vertex array in our C code matches the layout that
//    our .metal vertex shader expects

// Used in Example1
  AAPLVertex1 =  record
    // Positions in pixel space
    // (e.g. a value of 100 indicates 100 pixels from the center)
    {$HIDE H7}
    position : vector_float2;


    // Floating-point RGBA colors
    color : Color;//vector_float4;
  end;

// Used in Example2
  AAPLVertex2 =  AAPLVertex1;

//Used in Example 3 and 4
  AAPLVertex3 = record
    // Positions in pixel space (i.e. a value of 100 indicates 100 pixels from the origin/center)
    position : vector_float2;
     // 2D texture coordinate
    textureCoordinate : vector_float2;
  end;

type Color = record
  red, green, blue, alpha : Single;
  class method create(const r,g,b,a : Single) : Color;
  class method createRed() : Color;
  class method createGreen() : Color;
  class method createBlue() : Color;

end;

Vertex3d = record
 position : array[0..2] of Single;
 normal : array[0..2] of Single;
 color : Color;
 tex : array[0..1] of Single;
 method toBuffer : array of Single;
 class method fromBuffer(const buffer : Array of Single) : Vertex3d;
end;



implementation
class method Color.create(const r: single; const g: single; const b: single; const a: single): Color;
begin
  result.red := r;
  result.green := g;
  result.blue := b;
  result.alpha := a;
end;

class method Color.createRed: Color;
begin
  result.red := 1;
  result.green := 0;
  result.blue := 0;
  result.alpha := 1;
end;

class method Color.createGreen: Color;
begin
  result.red := 0;
  result.green := 1;
  result.blue := 0;
  result.alpha := 1;
end;

class method Color.createBlue: Color;
begin
  result.red := 0;
  result.green := 0;
  result.blue := 1;
  result.alpha := 1;
end;

method Vertex3d.toBuffer: array of Single;
begin
  result := [position[0], position[1], position[2], normal[0], normal[1], normal[2], tex[0], tex[1]];
end;

class method Vertex3d.fromBuffer(const buffer: array of Single) : Vertex3d;
begin
  result := new Vertex3d();
  result.position[0] := buffer[0];
  result.position[1] := buffer[1];
  result.position[2] := buffer[2];
  result.normal[0] := buffer[3];
  result.normal[1] := buffer[4];
  result.normal[2] := buffer[5];
  result.color := Color.create(1,0,0,1);
end;

end.