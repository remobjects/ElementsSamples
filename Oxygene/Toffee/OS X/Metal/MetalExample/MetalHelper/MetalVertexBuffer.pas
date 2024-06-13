namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

type
  VertexBuffer = class
  private
    method getCount: Integer;
    _buffer : MTLBuffer;
    _count  : Integer;

  public
    class method newBuffer(_device : MTLDevice; const _src : ^Void; const _bufflen : Integer) : VertexBuffer;
    class method newBuffer(_device : MTLDevice) SourceData(_src :^Void) withLength(_bufflen : Integer) : VertexBuffer;
    class method newBuffer(_device : MTLDevice) SoureArray(_src : VertexArray) : VertexBuffer;
    property  verticies : MTLBuffer read _buffer;
    property Count : Integer read getCount;
  end;



implementation

class method VertexBuffer.newBuffer(_device: MTLDevice; const _src: ^Void; const _bufflen: Integer): VertexBuffer;
begin
  result := new VertexBuffer();
  result._buffer := _device.newBufferWithLength(_bufflen)  options(MTLResourceOptions.StorageModeShared);

    // Copy the vertex data into the vertex buffer by accessing a pointer via
    // the buffer's `contents` property
  memcpy(result._buffer.contents, _src, _bufflen);

end;

class method VertexBuffer.newBuffer(_device: MTLDevice) SourceData(_src: ^Void) withLength(_bufflen: Integer): VertexBuffer;
begin
  result := new VertexBuffer();
  result._buffer := _device.newBufferWithLength(_bufflen)  options(MTLResourceOptions.StorageModeShared);

    // Copy the vertex data into the vertex buffer by accessing a pointer via
    // the buffer's `contents` property
  memcpy(result._buffer.contents, _src, _bufflen);
end;

class method VertexBuffer.newBuffer(_device: MTLDevice) SoureArray(_src: VertexArray): VertexBuffer;
//var buff : Array of Vertex3d;
begin
  result := new VertexBuffer();
  var vsize := sizeOf(Vertex3d);
  var buff :=  _src.getArray;
  var _bufflen := vsize * buff.length;
  result._count := buff.length;
  result._buffer := _device.newBufferWithLength(_bufflen)  options(MTLResourceOptions.StorageModeShared);
  memcpy(result._buffer.contents, @buff[0], _bufflen);
end;

method VertexBuffer.getCount: Integer;
begin
  exit _count;
end;

end.