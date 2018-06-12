namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

type
  MetalExample1 = class(MetalBaseDelegate)
  private
    _pipelineState :MTLRenderPipelineState ;
    _viewportSize : array [0..1] of UInt32;//Integer;

   // Interface
    method drawInMTKView(view: not nullable MTKView); override;
    method mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize); override;

  private // Consts
    triangleVertices :   Array of AAPLVertex1;
    method createVerticies;
    method UpdateColors;

  public
    constructor initWithMetalKitView(const mtkView : not nullable MTKView);// : MTKViewDelegate;
  end;
implementation

method MetalExample1.drawInMTKView(view: not nullable MTKView);
begin

  var commandBuffer :=  _commandQueue.commandBuffer();
  commandBuffer.label := 'MyCommand';
  var renderPassDescriptor: MTLRenderPassDescriptor := view.currentRenderPassDescriptor;
  if renderPassDescriptor ≠ nil then
  begin
    UpdateColors;
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

    var sizeTriangle := triangleVertices.length * sizeOf(AAPLVertex1);
   // var sizeTriangle := sizeOf(triangleVertices);//.length * sizeOf(AAPLVertex);
    renderEncoder.setVertexBytes(@triangleVertices[0] ) length(sizeTriangle) atIndex(AAPLVertexInputIndexVertices);



        // You send a pointer to `_viewportSize` and also indicate its size
        // The `AAPLVertexInputIndexViewportSize` enum value corresponds to the
        // `viewportSizePointer` argument in the `vertexShader` function because its
        //  buffer attribute also uses the `AAPLVertexInputIndexViewportSize` enum value
        //  for its index
    renderEncoder.setVertexBytes(@_viewportSize[0]) length(sizeOf(Int32)*2) atIndex(AAPLVertexInputIndexViewportSize );
   // Draw the 3 vertices of our triangle
    renderEncoder.drawPrimitives(MTLPrimitiveType.MTLPrimitiveTypeTriangle) vertexStart(0) vertexCount(triangleVertices.length);


    renderEncoder.endEncoding();
    commandBuffer.presentDrawable(view.currentDrawable);
  end;
  commandBuffer.commit();
end;

method MetalExample1.mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize);
begin
  _viewportSize[0] := Convert.ToInt32(size.width);
  _viewportSize[1] := Convert.ToInt32(size.height);
end;

constructor MetalExample1 initWithMetalKitView(const mtkView: not nullable MTKView);
begin
  inherited;
  var lError : Error;
  // First we try to load the Shadersource
  var SourceShader := Asset.loadFile('AAPLShaders1.metal');

  // If we dont have a Source we go out
  if SourceShader = nil then
  begin
    NSLog("Failed to load  the Shadersouce");
    exit nil;
  end;
  createVerticies;

  // Try to Compile the Shader
  var  defaultLibrary  := newShader(SourceShader);


  // Load all the shader files with a .metal file extension in the project
  // Will not work at moment in element because there is no precompile for the shaders like in xcode
 // var  defaultLibrary  : MTLLibrary := _device.newDefaultLibrary;

  if defaultLibrary = nil then
  begin
    exit nil;
  end
  else
  begin
   // Load the vertex function from the library
    var  vertexFunction  :MTLFunction := defaultLibrary.newFunctionWithName("vertexShader");

   // Load the fragment function from the library
    var fragmentFunction : MTLFunction := defaultLibrary.newFunctionWithName("fragmentColorShader");
    if fragmentFunction = nil then
    begin
      NSLog("Failed to get the fragmentFunction , error %@", lError);
      exit nil;
    end;
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
  end;
end;

method MetalExample1.UpdateColors;
begin
  if triangleVertices.length > 2 then
    triangleVertices[2].color := makeFancyColor;
end;

method MetalExample1.createVerticies;
begin

  triangleVertices := new AAPLVertex1[3];
//Positions
  triangleVertices[0].position := [ 250, -250];
  triangleVertices[1].position := [-250, -250];
  triangleVertices[2].position := [   0,  250];


  // Colors
  triangleVertices[0].color :=  Color.createRed();
  triangleVertices[1].color :=  Color.createGreen();
  triangleVertices[1].color :=  Color.createBlue();

end;


end.