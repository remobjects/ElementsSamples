namespace MetalExample;

interface
uses
  Metal,
  MetalKit;


type
  MetalHelper = class
  public
    class method createBox(_device: MTLDevice) : VertexBuffer;
  end;

implementation

class method MetalHelper.createBox(_device: MTLDevice): VertexBuffer;

const

  BOX_VERTICES: array  of Single = [
      // Positions      // Normals
      // unten
  -0.5, -0.5, -0.5,  0.0,  0.0, -1.0, // 0
       0.5, -0.5, -0.5,  0.0,  0.0, -1.0, // 1
       0.5,  0.5, -0.5,  0.0,  0.0, -1.0, //2
      -0.5,  0.5, -0.5,  0.0,  0.0, -1.0, //3
 // Oben
      -0.5, -0.5,  0.5,  0.0,  0.0,  1.0, //4
       0.5, -0.5,  0.5,  0.0,  0.0,  1.0, //5
       0.5,  0.5,  0.5,  0.0,  0.0,  1.0, // 6
      -0.5,  0.5,  0.5,  0.0,  0.0,  1.0, //7
//Links
      -0.5,  0.5,  0.5, -1.0,  0.0,  0.0, //8
      -0.5,  0.5, -0.5, -1.0,  0.0,  0.0, //9
      -0.5, -0.5, -0.5, -1.0,  0.0,  0.0, //10
      -0.5, -0.5,  0.5, -1.0,  0.0,  0.0, //11
//Rechts
       0.5,  0.5,  0.5,  1.0,  0.0,  0.0, //12
       0.5,  0.5, -0.5,  1.0,  0.0,  0.0, //13
       0.5, -0.5, -0.5,  1.0,  0.0,  0.0, //14
       0.5, -0.5,  0.5,  1.0,  0.0,  0.0, //15
// hinten
      -0.5, -0.5, -0.5,  0.0, -1.0,  0.0, //16
       0.5, -0.5, -0.5,  0.0, -1.0,  0.0, //17
       0.5, -0.5,  0.5,  0.0, -1.0,  0.0, //18
      -0.5, -0.5,  0.5,  0.0, -1.0,  0.0, //19

      -0.5,  0.5, -0.5,  0.0,  1.0,  0.0,
       0.5,  0.5, -0.5,  0.0,  1.0,  0.0,
       0.5,  0.5,  0.5,  0.0,  1.0,  0.0,
      -0.5,  0.5,  0.5,  0.0,  1.0,  0.0];


  { The indices define 2 triangles per cube face, 6 faces total }
      INDICES: array  of UInt16 = [
      2,  1,  0,   0,  3,  2, // Unten
      4,  5,  6,   6,  7,  4, // Oben
      8,  9, 10,  10, 11,  8, //Links
      14, 13, 12,  12, 15, 14,// Rechts
      16, 17, 18,  18, 19, 16 , //Hinten
      22, 21, 20,  20, 23, 22]; // Vorne
begin
  var FBox := new VertexArray(BOX_VERTICES, 6, INDICES);
  result  := VertexBuffer.newBuffer(_device) SoureArray(FBox);
end;

end.