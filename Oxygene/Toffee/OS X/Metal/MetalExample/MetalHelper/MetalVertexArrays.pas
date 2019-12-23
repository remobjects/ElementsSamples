namespace MetalExample;
{$GLOBALS ON}
interface
uses
  Foundation;

type
  VertexArray = class
  private
    data : List<Vertex3d>;
    indicies: array of UInt16;
  public
    constructor (const adata : array of Single; const valueCount : Integer; const aIndicies : array of UInt16);
    method getArray : array of Vertex3d;
    property Count : Integer read indicies.length;
  end;


implementation

constructor VertexArray(const adata: array of Single; const valueCount: integer; const aIndicies : array of Uint16);
begin
  inherited constructor ();
  data := new List<Vertex3d>;
  var temp := new Single[valueCount];
  var i : Integer := 0;
  while i <= (adata.length-valueCount) do
  begin
    for j : Integer := 0 to valueCount-1 do
      temp[j] := adata[i+j];
    var v : Vertex3d := Vertex3d.fromBuffer(temp);
    v.color := Color.createGreen;
    data.Add(v);
    inc(i, valueCount);
  end;
  indicies := aIndicies;
  NSLog("Count of Verticies3d,  %d", data.Count);
end;

method VertexArray.getArray: array of Vertex3d;
begin
  result := new Vertex3d[indicies.length];
  for i : Integer := 0 to indicies.length - 1 do
    result[i] := data[indicies[i]];

end;

end.