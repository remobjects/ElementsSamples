namespace MetalExample;

interface
uses
  Metal,
  MetalKit;


// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs match
//   Metal API buffer set calls
type


//  This structure defines the layout of each vertex in the array of vertices set as an input to our
//    Metal vertex shader.  Since this header is shared between our .metal shader and C code,
//    we can be sure that the layout of the vertex array in our C code matches the layout that
//    our .metal vertex shader expects
// At moment we need a dummy record inside because the shader is using vectortypes with a alignment of 16

  AAPLVertex2 =  record
    // Positions in pixel space
    // (e.g. a value of 100 indicates 100 pixels from the center)
    position : vector_float2;
    // Is needed for 16 byte alignement used in Metal
    dummy : vector_float2;
    // Floating-point RGBA colors
    color : Color;//vector_float4;
  end;



type
  MetalExample2 = class(MetalBaseDelegate)
  private
    _pipelineState :MTLRenderPipelineState ;
    _viewportSize : array [0..1] of UInt32;//Integer;
    _vertexBuffer : MTLBuffer;
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


    // We call -[MTLRenderCommandEncoder setVertexBytes:length:atIndex:] to send data from our
        //   Application ObjC code here to our Metal 'vertexShader' function
        // This call has 3 arguments
        //   1) A pointer to the memory we want to pass to our shader
        //   2) The memory size of the data we want passed down
        //   3) An integer index which corresponds to the index of the buffer attribute qualifier
        //      of the argument in our 'vertexShader' function

        // You send a pointer to the `triangleVertices` array also and indicate its size
        // The `AAPLVertexInputIndexVertices` enum value corresponds to the `vertexArray`
        // argument in the `vertexShader` function because its buffer attribute also uses
        // the `AAPLVertexInputIndexVertices` enum value for its index



    renderEncoder.setVertexBuffer(_vertexBuffer ) offset(0) atIndex(AAPLVertexInputIndexVertices);



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
  var lError : Error;
  // First we try to load the Shadersource
  var SourceShader := Asset.loadFile('AAPLShaders2.metal');

  // If we dont have a Source we go out
  if SourceShader = nil then
  begin
    NSLog("Failed to load  the Shadersouce");
    exit nil;
  end;
  //createVerticies;

  // Try to Compile the Shader
  var  defaultLibrary  : MTLLibrary := _device.newLibraryWithSource(SourceShader) options(new MTLCompileOptions()) error(var lError);

  // Load all the shader files with a .metal file extension in the project
  // Will not work at moment in element because there is no precompile for the shaders like in xcode
 // var  defaultLibrary  : MTLLibrary := _device.newDefaultLibrary;

  if defaultLibrary = nil then
  begin
    NSLog("Failed to compile the Shader, error %@", lError);
    exit nil;
  end
  else
  begin
   // Load the vertex function from the library
    var  vertexFunction  :MTLFunction := defaultLibrary.newFunctionWithName("vertexShader");

   // Load the fragment function from the library
    var fragmentFunction : MTLFunction := defaultLibrary.newFunctionWithName("fragmentShader");

    // Configure a pipeline descriptor that is used to create a pipeline state
    var pipelineStateDescriptor : MTLRenderPipelineDescriptor  := new MTLRenderPipelineDescriptor();
    pipelineStateDescriptor.label := "Simple Pipeline";
    pipelineStateDescriptor.vertexFunction := vertexFunction;
    pipelineStateDescriptor.fragmentFunction := fragmentFunction;
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
    var Buffer := generateVertexData;
    var Bufflen : Integer := Buffer.length*sizeOf(AAPLVertex2);
    //NSLog("Bufflen %d", Bufflen);
     // Create a vertex buffer by allocating storage that can be read by the GPU
    _vertexBuffer := _device.newBufferWithLength(Bufflen)  options(MTLResourceOptions.MTLResourceStorageModeShared);


    // Copy the vertex data into the vertex buffer by accessing a pointer via
    // the buffer's `contents` property
    memcpy(_vertexBuffer.contents, Buffer, Bufflen);

    //  number of vertices
    _numVertices := Buffer.length;

  end;
end;



method MetalExample2.createVerticies : array of AAPLVertex2;
begin

  result := new AAPLVertex2[6];

//Positions
  result[0].position[0]:=-20;
  result[0].position[1]:=20;
  result[1].position[0]:=20;
  result[1].position[1]:=20;
  result[2].position[0]:=-20;
  result[2].position[1]:=-20;

  result[3].position[0]:=20;
  result[3].position[1]:=-20;
  result[4].position[0]:=-20;
  result[4].position[1]:=-20;
  result[5].position[0]:=20;
  result[5].position[1]:=20;


  // Colors
  result[0].color.red :=1;
  result[0].color.blue:=0;
  result[0].color.green:=0;
  result[0].color.alpha:=1;


  result[1].color.red :=0;
  result[1].color.blue:=0;
  result[1].color.green:=1;
  result[1].color.alpha:=1;


  result[2].color.red :=0;
  result[2].color.blue:=1;
  result[2].color.green:=0;
  result[2].color.alpha:=1;

  result[3].color.red :=1;
  result[3].color.blue:=0;
  result[3].color.green:=0;
  result[3].color.alpha:=1;


  result[4].color.red :=0;
  result[4].color.blue:=1;
  result[4].color.green:=0;
  result[4].color.alpha:=1;


  result[5].color.red :=0;
  result[5].color.blue:=0;
  result[5].color.green:=1;
  result[5].color.alpha:=1;


end;

method MetalExample2.generateVertexData: array of AAPLVertex2;
begin
  const  NUM_COLUMNS = 25;
  const  NUM_ROWS = 15;
  const  QUAD_SPACING = 50.0;

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