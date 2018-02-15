namespace GlHelper;

interface
type

  ShapeVec = public record
    vec : TVector3;
    normal : TVector3;
    texture : TVector2;
    class method I (v1,v2,v3,n1,n2,n3 : Single) : ShapeVec;
  end;

  ShapeVecArray = public array of ShapeVec;
  IntArray = public array of UInt16;

  Shape = public class
  private
    faces : array of ShapeVecArray;
    faceindexes : array of IntArray;
    fmin, fmax : TVector3;
    method fixcenter;
    method checkMaxsize(Values : array of TVector3);
  public
    constructor (facecount : Integer);
    constructor (const Box: Boolean);
    method addFaceVecs(const &index : Integer; const Values : array of TVector3);
    method addNormales(const &index : Integer; const Values : array of TVector3);
    method addTexture(const &index : Integer; const Values : array of TVector2);
    method addIndexes(const &index : Integer; const Values : array of Integer);

    method getVecArray(const Layout : VertexLayout) : array of VertexArray;
  end;


implementation

constructor Shape(facecount: Integer);
begin
  inherited ();
  faces := new ShapeVecArray[facecount];
  faceindexes := new IntArray[facecount];
end;

method Shape.addFaceVecs(const &index: Integer; const Values: array of TVector3);
require
  (&index >= 0) and (&index < length(faces));
begin
  var i : Integer;
  faces[&index] := new ShapeVec[Values.length];
  for i := 0 to Values.length - 1 do
    faces[&index][i].vec := Values[i];

  if &index = 0 then
  begin
    fmin := Values[0];
    fmax := fmin;
  end;
  checkMaxsize(Values);

end;

method Shape.addNormales(const &index: Integer; const Values: array of TVector3);
require
  Values.length = faces[&index].length;
begin
  var i : Integer;
  for i := 0 to Values.length - 1 do
    faces[&index][i].normal := Values[i];
end;

method Shape.addTexture(const &index: Integer; const Values: array of TVector2);
require
  length(Values) = length(faces[&index]);
begin
  var i : Integer;
  for i := 0 to length(Values) - 1 do
    faces[&index][i].texture := Values[i];
end;

method Shape.addIndexes(const &index: Integer; const Values: array of Integer);
require
  (&index >= 0) and (&index < length(faceindexes));
begin
  var i : Integer;
  faceindexes[&index] := new UInt16[length(Values)];
  for i := 0 to Values.length - 1 do
    faceindexes[&index][i] := Values[i];
end;

method Shape.getVecArray(const Layout: VertexLayout): array of VertexArray;
begin

//  fixcenter;

  var i : Integer;

  result := new VertexArray[faces.length];
  for i := 0 to faces.length-1 do

    begin
    result[i] := new VertexArray(
    Layout,faces[i].length * sizeOf(ShapeVec), faceindexes[i].length,
    @faces[i][0].vec.X, @faceindexes[i][0]);
  end;


end;

method Shape.checkMaxsize(Values: array of TVector3);
begin
  for t in Values do
    begin
    fmin.X := Math.Min(fmin.X, t.X);
    fmin.Y := Math.Min(fmin.Y, t.Y);
    fmin.Z := Math.Min(fmin.Z, t.Z);

    fmax.X := Math.Max(fmax.X, t.X);
    fmax.Y := Math.Max(fmax.Y, t.Y);
    fmax.Z := Math.Max(fmax.Z, t.Z);
  end;
end;

method Shape.fixcenter;
begin
  var i, j : Integer;
  var Midpoint : TVector3 := ((fmax - fmin) / 2) + fmin;


  for i := 0 to faces.length-1 do
    for j := 0 to faces[i].length-1  do
      begin
      var s : ShapeVec := faces[i,j];
      s.vec := s.vec-Midpoint;
      faces[i,j] := s; //faces[i,j].v-Midpoint;
    end;

end;

constructor Shape(const Box: Boolean);
const V: array  of array of Single = [
    // Positions      // Normals
[
-0.5, -0.5, -0.5,  0.0,  0.0, -1.0,
0.5, -0.5, -0.5,  0.0,  0.0, -1.0,
0.5,  0.5, -0.5,  0.0,  0.0, -1.0,
-0.5,  0.5, -0.5,  0.0,  0.0, -1.0
],[

-0.5, -0.5,  0.5,  0.0,  0.0,  1.0,
0.5, -0.5,  0.5,  0.0,  0.0,  1.0,
0.5,  0.5,  0.5,  0.0,  0.0,  1.0,
-0.5,  0.5,  0.5,  0.0,  0.0,  1.0],[

-0.5,  0.5,  0.5, -1.0,  0.0,  0.0,
-0.5,  0.5, -0.5, -1.0,  0.0,  0.0,
-0.5, -0.5, -0.5, -1.0,  0.0,  0.0,
-0.5, -0.5,  0.5, -1.0,  0.0,  0.0],[

0.5,  0.5,  0.5,  1.0,  0.0,  0.0,
0.5,  0.5, -0.5,  1.0,  0.0,  0.0,
0.5, -0.5, -0.5,  1.0,  0.0,  0.0,
0.5, -0.5,  0.5,  1.0,  0.0,  0.0],[

-0.5, -0.5, -0.5,  0.0, -1.0,  0.0,
0.5, -0.5, -0.5,  0.0, -1.0,  0.0,
0.5, -0.5,  0.5,  0.0, -1.0,  0.0,
-0.5, -0.5,  0.5,  0.0, -1.0,  0.0],[

-0.5,  0.5, -0.5,  0.0,  1.0,  0.0,
0.5,  0.5, -0.5,  0.0,  1.0,  0.0,
0.5,  0.5,  0.5,  0.0,  1.0,  0.0,
-0.5,  0.5,  0.5,  0.0,  1.0,  0.0]];

INDICES: array  of array of UInt16 = [
[0,  1,  2,   2,  3,  0],[
4,  5,  6,   6,  7,  4],[
8,  9, 10,  10, 11,  8],[
12, 13, 14,  14, 15, 12],[
16, 17, 18,  18, 19, 16],[
20, 21, 22,  22, 23, 20]];



begin
  constructor (6);
  var j : Integer ;
  for  j := 0 to 5 do
    begin
    faces[j]:= [
    ShapeVec.I(V[j][0],V[j][1],V[j][2],V[j][3],V[j][4], V[j][5]),
         ShapeVec.I(V[j][6],V[j][7],V[j][8],V[j][9],V[j][10], V[j][11]),
         ShapeVec.I(V[j][12],V[0][13],V[j][14],V[j][15],V[j][16], V[j][17]),
         ShapeVec.I(V[j][18],V[j][19],V[j][20],V[j][21],V[j][22], V[j][23])
         ];

    faceindexes[j] := INDICES[j];

  end;

  fmin.Init(-0.5);
  fmax.Init(0.5);

end;

class method  ShapeVec.I(v1: Single; v2: Single; v3: Single; n1: Single; n2: Single; n3: Single) : ShapeVec;
begin
  result.vec.X := v1;
  result.vec.Y := v2;
  result.vec.Z := v3;
  result.normal.X := n1;
  result.normal.Y := n2;
  result.normal.Z := n3;
  result.texture.S := 0;
  result.texture.T := 0;

end;

end.