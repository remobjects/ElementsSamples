namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

type
 // "3d Box"

  Uniforms = record
  {$HIDE H7}
    modelMatrix : TMatrix4;
    projectionMatrix : TMatrix4;
   {$SHOW H7}
    normalMatrix : TMatrix3;
  end;


  MetalExample5 = class(MetalBaseDelegate)
  private
    method DrawCursor(renderEncoder: IMTLRenderCommandEncoder);
    method CreateCursorPipeline(const mtkView: not nullable MTKView);
    method gBufferRenderPassDescriptor(const mtkView: not nullable MTKView): MTLRenderPassDescriptor;
    method zBufferTexture(const x,y : Integer): MTLTexture;
  // Box
    const
      cShaderName = 'AAPLShaders5.metallib';
      cVertexFuncName = 'basic_vertex';
      cFragmentFuncName = 'basic_fragment';
    var
      _pipelineState :MTLRenderPipelineState ;
      _depthStencilState : MTLDepthStencilState;
      _viewportSize : array [0..1] of UInt32;//Integer;
      _vertexBuffer : VertexBuffer;//s<AAPLVertex3>;
     // _numVertices : NSUInteger ;
      _uniform : Uniforms;
      FmodelRotation : Single := 0;

  // Cursor

    var
      _CursorPipelineState :MTLRenderPipelineState ;
     mx, my : Single;
   // Interface
    method drawInMTKView(view: not nullable MTKView); override;
    method mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize); override;

  private
    //FRemObjectsVAO: array of VertexArray;
    method UpdateViewAndProjection(const width: Single; const Height: Single);

    method createBox(_device: MTLDevice);
    method MouseMove(const amx, amy : Single); override;
    method DontShowCursor : Boolean; override;
    begin
      exit true;
    end;
  public
    constructor initWithMetalKitView(const mtkView : not nullable MTKView);// : MTKViewDelegate;
  end;
implementation

method MetalExample5.drawInMTKView(view: not nullable MTKView);
begin
 // exit;
  var commandBuffer :=  _commandQueue.commandBuffer();
  commandBuffer.label := 'MyCommand';
 // var renderPassDescriptor: MTLRenderPassDescriptor := view.currentRenderPassDescriptor;

  var renderPassDescriptor: MTLRenderPassDescriptor := gBufferRenderPassDescriptor(view);//view.currentRenderPassDescriptor;

  if renderPassDescriptor ≠ nil then
  begin
    UpdateViewAndProjection(view.drawableSize.width, view.drawableSize.height);


    var renderEncoder: IMTLRenderCommandEncoder := commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor);
    //var renderEncoder: IMTLRenderCommandEncoder := commandBuffer.renderCommandEncoderWithDescriptor(view.currentRenderPassDescriptor);
    renderEncoder.label := 'MyRenderEncoder';

    renderEncoder.setRenderPipelineState(_pipelineState);

    renderEncoder.setDepthStencilState(_depthStencilState);
    renderEncoder.setTriangleFillMode(MTLTriangleFillMode.Fill);


   // renderEncoder.setDepthStoreAction(MTLStoreAction.MTLStoreActionStore);

    renderEncoder.setFrontFacingWinding(MTLWinding.CounterClockwise);
    renderEncoder.setCullMode(MTLCullMode.None);


    renderEncoder.setVertexBuffer(_vertexBuffer.verticies ) offset(0) atIndex(AAPLVertexInputIndexVertices);

    renderEncoder.setVertexBytes(@_uniform) length(sizeOf(_uniform)) atIndex(AAPLVertexInputIndexViewportSize );
   // renderEncoder.setFragmentBytes(@_uniform) length(sizeOf(_uniform)) atIndex(0 );
   // Draw the vertices of our Box
    renderEncoder.drawPrimitives(MTLPrimitiveType.MTLPrimitiveTypeTriangle) vertexStart(0) vertexCount(_vertexBuffer.Count);

    // Try to show the Cursor
    if showCrosshair then
    DrawCursor(renderEncoder);
    renderEncoder.endEncoding();



    commandBuffer.presentDrawable(view.currentDrawable);
  end;
  commandBuffer.commit();

  {Change the Rotation in every step}
  if FmodelRotation >= 360 then
    FmodelRotation := 1.0 else
    FmodelRotation := FmodelRotation + 1.0;

end;

method MetalExample5.DrawCursor(renderEncoder: IMTLRenderCommandEncoder);
var a : Array of AAPLVertex1;
begin

  var G : Color := Color.createGreen;
  var R : Color := Color.createRed;
  a := new AAPLVertex1[4];
  a[0].color := G;
  a[1].color := R;

  a[2].color := G;
  a[3].color := R;
  var xpos : Single := _viewportSize[0] / 2;
  var ypos : Single := _viewportSize[1] / 2;


  a[0].position := [-xpos, my];
  a[1].position := [xpos, my];
  a[2].position := [mx, -ypos];
  a[3].position := [mx, ypos];
  renderEncoder.setRenderPipelineState(_CursorPipelineState);
  renderEncoder.setVertexBytes(@a[0]) length(sizeOf(AAPLVertex1) * a.length) atIndex(0 );
  renderEncoder.setVertexBytes(@_viewportSize[0]) length(sizeOf(Int32)*2) atIndex(AAPLVertexInputIndexViewportSize );
  renderEncoder.drawPrimitives(MTLPrimitiveType.Line) vertexStart(0) vertexCount(4);


end;


method MetalExample5.mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize);
begin
  _viewportSize[0] := Convert.ToInt32(size.width);
  _viewportSize[1] := Convert.ToInt32(size.height);
  UpdateViewAndProjection(size.width, size.height);
end;

constructor MetalExample5 initWithMetalKitView(const mtkView: not nullable MTKView);
begin
  inherited;
  var ShaderLoader := new shaderLoader(_device) Shadername(cShaderName) Vertexname(cVertexFuncName) Fragmentname(cFragmentFuncName);
  if ShaderLoader = nil then exit nil

  else
  begin
    var lError : Error;
    UpdateViewAndProjection(mtkView.drawableSize.width, mtkView.drawableSize.height);
    // Configure a pipeline descriptor that is used to create a pipeline state
    var pipelineStateDescriptor : MTLRenderPipelineDescriptor  := new MTLRenderPipelineDescriptor();
    pipelineStateDescriptor.label := "Simple Pipeline";
    pipelineStateDescriptor.vertexFunction := ShaderLoader.VertexFunc;
    pipelineStateDescriptor.fragmentFunction := ShaderLoader.FragmentFunc;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat := mtkView.colorPixelFormat;
    pipelineStateDescriptor.depthAttachmentPixelFormat := MTLPixelFormat.Depth32Float;
   // pipelineStateDescriptor.d

    var depthStencilDescriptor  : MTLDepthStencilDescriptor := new MTLDepthStencilDescriptor;


    depthStencilDescriptor.depthCompareFunction := MTLCompareFunction.LessEqual;
    depthStencilDescriptor.depthWriteEnabled := true;
    _depthStencilState  := _device.newDepthStencilStateWithDescriptor(depthStencilDescriptor);
    if (_depthStencilState = nil) then
    begin

      NSLog("Failed to created _depthStencilState ");
      exit nil;
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
    CreateCursorPipeline(mtkView);

    createBox(_device);

  end;
end;

method MetalExample5.CreateCursorPipeline(const mtkView: not nullable MTKView);

const
  cShaderNameCur = 'AAPLShaders1.metallib';
  cVertexFuncNameCur = 'vertexShader';
  cFragmentFuncNameCur = 'fragmentColorShader';
begin
  var ShaderLoader := new shaderLoader(_device) Shadername(cShaderNameCur) Vertexname(cVertexFuncNameCur) Fragmentname(cFragmentFuncNameCur);
  if ShaderLoader = nil then exit

  else
  begin
    var lError : Error;
    var pipelineStateDescriptor : MTLRenderPipelineDescriptor  := new MTLRenderPipelineDescriptor();
    pipelineStateDescriptor.label := "Cursor Pipeline";
    pipelineStateDescriptor.vertexFunction := ShaderLoader.VertexFunc;
    pipelineStateDescriptor.fragmentFunction := ShaderLoader.FragmentFunc;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat := mtkView.colorPixelFormat;

    _CursorPipelineState := _device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor) error(var lError);

    if (_CursorPipelineState = nil) then
      NSLog("Failed to created pipeline state, error %@", lError);


  end;
end;


method MetalExample5.createBox(_device: MTLDevice);
begin
  _vertexBuffer :=  MetalHelper.createBox(_device);
 // _numVertices := _vertexBuffer.Count;//INDICES.length;
end;

method MetalExample5.UpdateViewAndProjection(const width, Height : Single);
var Projection, View : TMatrix4;
begin
  var rot : Single := 310;
  const V : Single = 1.5;


  var lAspect : Single :=  (Height / width);
{ORTHOGNAL VIEW}

  Projection.InitOrthoOffCenterLH(-V, V*lAspect, V, -V*lAspect, V, -V);
  rot := FmodelRotation;
  //View.InitRotationYawPitchRoll(MetalMath.Radians(-rot), MetalMath.Radians(rot), MetalMath.Radians(-rot));
  View.InitRotationYawPitchRoll(MetalMath.Radians(-rot), MetalMath.Radians(-rot), MetalMath.Radians(-rot));
  _uniform.modelMatrix := View;
  _uniform.projectionMatrix := Projection;
  _uniform.normalMatrix.Init;
  //_uniform.normalMatrix := _uniform.normalMatrix.Inverse.Transpose;

 { Pass matrices to shader }
end;

//MARK:- Textures
method  MetalExample5.zBufferTexture(const x,y : integer): MTLTexture;
begin
  var zbufferTextureDescriptor := MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(MTLPixelFormat.Depth32Float) width(x) height(y) mipmapped(false);
//(pixelFormat: MTLPixelFormat.depth32Float, width: x, height: y, mipmapped: false)
  zbufferTextureDescriptor.usage := [MTLTextureUsage.RenderTarget, MTLTextureUsage.ShaderRead];
// [.renderTarget, .shaderRead]
  zbufferTextureDescriptor.storageMode := MTLStorageMode.Private;
  exit _device.newTextureWithDescriptor(zbufferTextureDescriptor);
//return HgRenderer.device.makeTexture(descriptor: zbufferTextureDescriptor)!
//}()
end;


method MetalExample5.gBufferRenderPassDescriptor(const mtkView: not nullable MTKView): MTLRenderPassDescriptor;
begin
  var  desc := mtkView.currentRenderPassDescriptor;
  //  new MTLRenderPassDescriptor();
  var color := desc.colorAttachments[0];
  color:clearColor := MTLClearColorMake(0.0,0.0,0.0,1);

  color:loadAction := MTLLoadAction.Clear;
  color:storeAction := MTLStoreAction.Store;
  var depth := desc.depthAttachment;
  if depth <> nil then
  begin
    depth.loadAction := MTLLoadAction.Clear;
    depth.storeAction := MTLStoreAction.Store;
  //  depth.texture := zBufferTexture(_viewportSize[0], _viewportSize[1]);
    depth.clearDepth := 1.0;
  end;

  exit desc;
end;

method MetalExample5.MouseMove(const amx: Single; const amy: Single);
begin
  self.mx := -(_viewportSize[0]*0.5) + amx;
  self.my := -(_viewportSize[1]*0.5) +amy;
end;


end.