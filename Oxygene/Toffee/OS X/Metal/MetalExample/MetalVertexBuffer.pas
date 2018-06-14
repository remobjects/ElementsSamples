namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

type
  VertexBuffer = class
  private
    _buffer : MTLBuffer;

  public
    class method newBuffer(_device : MTLDevice; const _src : ^Void; const _bufflen : Integer) : VertexBuffer;
    class method newBuffer(_device : MTLDevice) SourceData(_src :^Void) withLength(_bufflen : Integer) : VertexBuffer;
    property  verticies : MTLBuffer read _buffer;
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




end.