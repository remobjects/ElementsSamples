namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

type
// "Basic Buffers"
  MetalExample2 = class(MetalBaseDelegate)
  private
    const QUAD_SIZE = 20;

    cShaderName = 'AAPLShaders2.metallib';
    cVertexFuncName = 'vertexShader2';
    cFragmentFuncName = 'fragmentColorShader2';

    var
      _pipelineState :MTLRenderPipelineState ;
      _viewportSize : array [0..1] of UInt32;//Integer;
      _vertexBuffer : VertexBuffer;//s<AAPLVertex3>;
      _numVertices : NSUInteger ;
   // Interface
    method drawInMTKView(view: not nullable MTKView); override;
    method mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize); override;

  private

    method createVerticies: array of AAPLVertex2;
    method generateVertexData : array of AAPLVertex2;

  public
    constructor initWithMetalKitView(const mtkView : not nullable MTKView);// : MTKViewDelegate;
  end;
implementation

method MetalExample2.drawInMTKView(view: not nullable MTKView);
begin

  var commandBuffer :=  _commandQueue.commandBuffer();
  commandBuffer.label := 'MyCommand';
  var renderPassDescriptor: MTLRenderPassDescriptor := view.currentRenderPassDescriptor;
  if renderPassDescriptor ≠ nil then
  begin
    view.clearColor := MTLClearColorMake(0, 0, 0, 1);
    var renderEncoder: IMTLRenderCommandEncoder := commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor);
    renderEncoder.label := 'MyRenderEncoder';

    // Set the region of the drawable to which we'll draw.
    var vp : MTLViewport;
    vp.originX:=0.0;;
    vp.originY:=0.0;
    vp.width:=_viewportSize[0];
    vp.height:= _viewportSize[1];
    vp.znear:= -1.0;
    vp.zfar:= 1.0;
    renderEncoder.setViewport(vp);


    renderEncoder.setRenderPipelineState(_pipelineState);


    // We call -[MTLRenderCommandEncoder setVertexBuffer:offset:atIndex:] to send data in our
        //   preloaded MTLBuffer from our ObjC code here to our Metal 'vertexShader' function
        // This call has 3 arguments
        //   1) buffer - The buffer object containing the data we want passed down
        //   2) offset - They byte offset from the beginning of the buffer which indicates what
        //      'vertexPointer' point to.  In this case we pass 0 so data at the very beginning is
        //      passed down.
        //      We'll learn about potential uses of the offset in future samples
        //   3) index - An integer index which corresponds to the index of the buffer attribute
        //      qualifier of the argument in our 'vertexShader' function.  Note, this parameter is
        //      the same as the 'index' parameter in
        //    -[MTLRenderCommandEncoder setVertexBytes:length:atIndex:]




    renderEncoder.setVertexBuffer(_vertexBuffer.verticies ) offset(0) atIndex(AAPLVertexInputIndexVertices);



        // You send a pointer to `_viewportSize` and also indicate its size
        // The `AAPLVertexInputIndexViewportSize` enum value corresponds to the
        // `viewportSizePointer` argument in the `vertexShader` function because its
        //  buffer attribute also uses the `AAPLVertexInputIndexViewportSize` enum value
        //  for its index
    renderEncoder.setVertexBytes(@_viewportSize[0]) length(sizeOf(Int32)*2) atIndex(AAPLVertexInputIndexViewportSize );
   // Draw the 3 vertices of our triangle
    renderEncoder.drawPrimitives(MTLPrimitiveType.MTLPrimitiveTypeTriangle) vertexStart(0) vertexCount(_numVertices);

    renderEncoder.endEncoding();
    commandBuffer.presentDrawable(view.currentDrawable);
  end;
  commandBuffer.commit();


end;

method MetalExample2.mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize);
begin
  _viewportSize[0] := Convert.ToInt32(size.width);
  _viewportSize[1] := Convert.ToInt32(size.height);
end;

constructor MetalExample2 initWithMetalKitView(const mtkView: not nullable MTKView);
begin
  inherited;
  var ShaderLoader := new shaderLoader(_device) Shadername(cShaderName) Vertexname(cVertexFuncName) Fragmentname(cFragmentFuncName);
  if ShaderLoader = nil then exit nil

  else
  begin
    var lError : Error;

    // Configure a pipeline descriptor that is used to create a pipeline state
    var pipelineStateDescriptor : MTLRenderPipelineDescriptor  := new MTLRenderPipelineDescriptor();
    pipelineStateDescriptor.label := "Simple Pipeline";
    pipelineStateDescriptor.vertexFunction := ShaderLoader.VertexFunc;
    pipelineStateDescriptor.fragmentFunction := ShaderLoader.FragmentFunc;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat := mtkView.colorPixelFormat;

    _pipelineState := _device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor) error(var lError);

    if (_pipelineState = nil) then
    begin
            // Pipeline State creation could fail if we haven't properly set up our pipeline descriptor.
            //  If the Metal API validation is enabled, we can find out more information about what
            //  went wrong.  (Metal API validation is enabled by default when a debug build is run
            //  from Xcode)
      NSLog("Failed to created pipeline state, error %@", lError);
      exit nil;
    end;
    var Buffer  := generateVertexData;
    var Bufflen : Integer := Buffer.length*sizeOf(AAPLVertex2);
    //NSLog("Bufflen %d", Bufflen);
     // Create a vertex buffer by allocating storage that can be read by the GPU
  //  _vertexBuffer := VertexBuffer.newBuffer(  _device,  Buffer, Bufflen);
    _vertexBuffer := VertexBuffer.newBuffer(  _device) SourceData(Buffer) withLength(Bufflen);
    //  number of vertices
    _numVertices := Buffer.length;

  end;
end;



method MetalExample2.createVerticies : array of AAPLVertex2;
begin

  result := new AAPLVertex2[6];

//Positions
  result[0].position := [-QUAD_SIZE,  QUAD_SIZE];
  result[1].position := [ QUAD_SIZE,  QUAD_SIZE];
  result[2].position := [-QUAD_SIZE, -QUAD_SIZE];

  result[3].position := [ QUAD_SIZE, -QUAD_SIZE];
  result[4].position := [-QUAD_SIZE, -QUAD_SIZE];
  result[5].position := [ QUAD_SIZE,  QUAD_SIZE];

  // Colors
  //result[0].color := Color.createRed();
  result[0].color := Color.create(1,1,0,1);
  result[1].color := Color.createGreen();
  result[2].color := Color.createBlue();
  result[3].color := Color.createRed();
  result[4].color := Color.createBlue();
  result[5].color := Color.createGreen();

end;

method MetalExample2.generateVertexData: array of AAPLVertex2;
begin
  const  NUM_COLUMNS = 25;
  const  NUM_ROWS = 15;
  const  QUAD_SPACING =   QUAD_SIZE *2 + 10.0;

  var quadVertices := createVerticies;
  var  NUM_VERTICES_PER_QUAD := quadVertices.length;
  var dataSize : Integer  := quadVertices.length * NUM_COLUMNS * NUM_ROWS;
  result := new AAPLVertex2[dataSize];


  for  row : Integer := 0 to NUM_ROWS-1 do
    begin
    for  column : Integer := 0 to NUM_COLUMNS -1 do
      begin
      var upperLeftPosition : vector_float2;
      upperLeftPosition[0] := ((-(NUM_COLUMNS) / 2.0) + column) * QUAD_SPACING + QUAD_SPACING/2.0;
      upperLeftPosition[1] := ((-(NUM_ROWS) / 2.0) + row) * QUAD_SPACING + QUAD_SPACING/2.0;
      for j : Integer := 0 to NUM_VERTICES_PER_QUAD-1 do
        begin
        var temp:= quadVertices[j];

        temp.position[0]  := temp.position[0] + upperLeftPosition[0];
        temp.position[1]  := temp.position[1] + upperLeftPosition[1];
        var &index : Integer := (row * NUM_COLUMNS * NUM_VERTICES_PER_QUAD) // Row
        + (column * NUM_VERTICES_PER_QUAD) // Column
        + j; // vertex
       // NSLog("row: %d column: %d  Vertex: %d index: %d", row, column, j, &index);
        result[&index] := temp;
      end;
    end;
  end;

end;

end.