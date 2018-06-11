namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

type

  AAPLVertex3 = record
     // Positions in pixel space (i.e. a value of 100 indicates 100 pixels from the origin/center)
    position : vector_float2;

      // 2D texture coordinate
    textureCoordinate : vector_float2;
  end;


type
  MetalExample3 = class(MetalBaseDelegate)

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

constructor MetalExample3 initWithMetalKitView(const mtkView: not nullable MTKView);
begin
  inherited;
  var lError : Error;
  // First we try to load the Shadersource
  var SourceShader := Asset.loadFile('AAPLShaders3.metal');

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
    var fragmentFunction : MTLFunction := defaultLibrary.newFunctionWithName("samplingShader"); //samplingShader

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
    loadTextureWithLoader;
    _Vertextes :=  fillVertexes;
  end;
end;



method MetalExample3.mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize);
begin
  _viewportSize[0] := Convert.ToInt32(size.width);
  _viewportSize[1] := Convert.ToInt32(size.height);
end;

method MetalExample3.loadTextureWithLoader;
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

method MetalExample3.fillVertexes  : array of AAPLVertex3;
begin
  result := new AAPLVertex3[6];
  const hsize = 600.0;
  const vsize = 400.0;

//Positions

  result[0].position[0]:=hsize;
  result[0].position[1]:= -vsize;

  result[1].position[0]:= -hsize;
  result[1].position[1]:=-vsize;

  result[2].position[0]:=-hsize;
  result[2].position[1]:=vsize;

  result[3].position[0]:=hsize;
  result[3].position[1]:=-vsize;

  result[4].position[0]:=-hsize;
  result[4].position[1]:=vsize;

  result[5].position[0]:=hsize;
  result[5].position[1]:=vsize;
  // Texture

  result[0].textureCoordinate[0]:=1.0;
  result[0].textureCoordinate[1]:= 1.0;

  result[1].textureCoordinate[0]:=0.0;
  result[1].textureCoordinate[1]:= 1.0;

  result[2].textureCoordinate[0]:=0.0;
  result[2].textureCoordinate[1]:= 0.0;

  result[3].textureCoordinate[0]:=1.0;
  result[3].textureCoordinate[1]:= 1.0;

  result[4].textureCoordinate[0]:=0.0;
  result[4].textureCoordinate[1]:= 0.0;

  result[5].textureCoordinate[0]:=1.0;
  result[5].textureCoordinate[1]:= 0.0;
  //NSLog("SizeStruct %d", sizeOf(AAPLVertex3));

end;



method MetalExample3.drawInMTKView(view: not nullable MTKView);
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

    renderEncoder.setFragmentTexture(_texture[akttex])  atIndex(0);


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