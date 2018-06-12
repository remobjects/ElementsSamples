namespace MetalExample;

interface
uses
  Metal,
  MetalKit;


type
  MetalExample4 = class(MetalBaseDelegate)

  private

    _pipelineState :MTLRenderPipelineState ;
    _viewportSize : array [0..1] of UInt32;//Integer;
    _texture : array of MTLTexture;
    _Vertextes : array of AAPLVertex3;
    akttex : Integer := 0;
    aktloop : Integer;
    method mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize); override;
    method drawInMTKView(view: not nullable MTKView); override;

    method loadTextureWithLoader;
    method fillVertexes : array of AAPLVertex3;
  public
    constructor initWithMetalKitView(const mtkView: not nullable MTKView);


  end;
implementation

constructor MetalExample4 initWithMetalKitView(const mtkView: not nullable MTKView);
begin
  inherited;
  var lError : Error;
  // First we try to load the Shadersource
  var SourceShader := Asset.loadFile('AAPLShaders4.metal');

  // If we dont have a Source we go out
  if SourceShader = nil then
  begin
    NSLog("Failed to load  the Shadersouce");
    exit nil;
  end;


  // Try to Compile the Shader
  var  defaultLibrary  : MTLLibrary := _device.newLibraryWithSource(SourceShader) options(new MTLCompileOptions()) error(var lError);

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
    var fragmentFunction : MTLFunction := defaultLibrary.newFunctionWithName("samplingShader2"); //samplingShader

    if fragmentFunction = nil then
    begin
      NSLog("Failed to get the Sampling Shader, error %@", lError);
      exit nil;
    end;


    // Configure a pipeline descriptor that is used to create a pipeline state
    var pipelineStateDescriptor : MTLRenderPipelineDescriptor  := new MTLRenderPipelineDescriptor();
    pipelineStateDescriptor.label := "Simple Pipeline";
    pipelineStateDescriptor.vertexFunction := vertexFunction;
    pipelineStateDescriptor.fragmentFunction := fragmentFunction;


    var renderbufferAttachment := pipelineStateDescriptor.colorAttachments[0];
    renderbufferAttachment.pixelFormat := mtkView.colorPixelFormat;
    const blending = true;
    if blending then
    begin
      renderbufferAttachment.blendingEnabled := true;
      renderbufferAttachment.rgbBlendOperation :=  MTLBlendOperation.MTLBlendOperationAdd;
      renderbufferAttachment.alphaBlendOperation := MTLBlendOperation.MTLBlendOperationAdd;

      renderbufferAttachment.sourceRGBBlendFactor :=  MTLBlendFactor.MTLBlendFactorSourceAlpha;
      renderbufferAttachment.sourceAlphaBlendFactor := MTLBlendFactor.MTLBlendFactorSourceAlpha;

      renderbufferAttachment.destinationRGBBlendFactor := MTLBlendFactor.MTLBlendFactorOneMinusSourceAlpha;
      renderbufferAttachment.destinationAlphaBlendFactor := MTLBlendFactor.MTLBlendFactorOneMinusSourceAlpha;
    end;

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
    loadTextureWithLoader;
    _Vertextes :=  fillVertexes;
  end;
end;



method MetalExample4.mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize);
begin
  _viewportSize[0] := Convert.ToInt32(size.width);
  _viewportSize[1] := Convert.ToInt32(size.height);
end;

method MetalExample4.loadTextureWithLoader;
begin
  var Loader : MTKTextureLoader := new MTKTextureLoader withDevice(_device);
  var Lerror : Error;
  var texturl0 :=  Asset.getUrlfor("Tex1.JPG");
  var texturl1 :=  Asset.getUrlfor("coral.JPG");


  var lDict := NSDictionary<MTKTextureLoaderOption, NSNumber>.dictionaryWithObjects(
  [
  NSNumber.numberWithBool(false)
  ]
  )
    forKeys(
    [
    MTKTextureLoaderOptionSRGB
    ]
    ) ;


// Load the textures
  _texture := new MTLTexture[2];
  _texture[0] := Loader.newTextureWithContentsOfURL(texturl0)
              options(lDict)
              error(var Lerror);
  if Lerror <>  nil then
  begin
    NSLog("Failed to Load Texture, error %@", Lerror);
    exit;
  end;

  _texture[1] := Loader.newTextureWithContentsOfURL(texturl1)
              options(lDict)
              error(var Lerror);
  if Lerror <>  nil then
  begin
    NSLog("Failed to Load Texture, error %@", Lerror);
    exit;
  end;

end;

method MetalExample4.fillVertexes  : array of AAPLVertex3;
begin
  result := new AAPLVertex3[6];
  const hsize = 600.0;
  const vsize = 400.0;

//Positions
  result[0].position := [hsize, -vsize];
  result[1].position := [-hsize, -vsize];
  result[2].position := [-hsize, vsize];
  result[3].position := [hsize, -vsize];
  result[4].position := [-hsize, vsize];
  result[5].position := [hsize, vsize];

  // Texture
  result[0].textureCoordinate := [1.0, 1.0];
  result[1].textureCoordinate := [0.0, 1.0];
  result[2].textureCoordinate := [0, 0];
  result[3].textureCoordinate := [1,1];
  result[4].textureCoordinate := [0,0];
  result[5].textureCoordinate := [1,0];
  //NSLog("SizeStruct %d", sizeOf(AAPLVertex3));

end;



method MetalExample4.drawInMTKView(view: not nullable MTKView);
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


    var sizeTriangle := _Vertextes.length * sizeOf(AAPLVertex3);
   // var sizeTriangle := sizeOf(triangleVertices);//.length * sizeOf(AAPLVertex);
    renderEncoder.setVertexBytes(@_Vertextes[0] ) length(sizeTriangle) atIndex(AAPLVertexInputIndexVertices);

        // You send a pointer to `_viewportSize` and also indicate its size
        // The `AAPLVertexInputIndexViewportSize` enum value corresponds to the
        // `viewportSizePointer` argument in the `vertexShader` function because its
        //  buffer attribute also uses the `AAPLVertexInputIndexViewportSize` enum value
        //  for its index
    renderEncoder.setVertexBytes(@_viewportSize[0]) length(sizeOf(Int32)*2) atIndex(AAPLVertexInputIndexViewportSize );

    renderEncoder.setFragmentTexture(_texture[0])  atIndex(0);


   // Draw the 3 vertices of our triangle
    renderEncoder.drawPrimitives(MTLPrimitiveType.MTLPrimitiveTypeTriangle) vertexStart(0) vertexCount(6);

    renderEncoder.setFragmentTexture(_texture[1])  atIndex(0);


       // Draw the 3 vertices of our triangle
    renderEncoder.drawPrimitives(MTLPrimitiveType.MTLPrimitiveTypeTriangle) vertexStart(0) vertexCount(6);


    renderEncoder.endEncoding();
    commandBuffer.presentDrawable(view.currentDrawable);
  end;
  commandBuffer.commit();

  inc(aktloop);
  if aktloop > 100 then
  begin
    akttex := if akttex = 0 then 1 else 0;
    aktloop := 0;
  end;
end;

end.