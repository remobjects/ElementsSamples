namespace MetalExample;
uses
  Metal,
  MetalKit;

interface

type
  MetalBaseDelegate = class(MTKViewDelegate)
  protected //MTKViewDelegate
    _device : MTLDevice;//  id<MTLDevice>;
    _commandQueue :  MTLCommandQueue; // id<MTLCommandQueue>;

  private
    growing: Boolean := true;
    primaryChannel: NSUInteger := 0;
    colorChannels: array of Single := [1, 0, 0, 1];
    const DynamicColorRate: Single = 0.015;
  protected
    method makeFancyColor : Color;

    method newShader(const shader : String) : MTLLibrary;


    method drawInMTKView(view: not nullable MTKView); virtual; empty;
    method mtkView(view: not nullable MTKView) drawableSizeWillChange(size: CGSize); virtual; empty;
  public

    constructor initWithMetalKitView(const mtkView : not nullable MTKView);// : MTKViewDelegate;
  end;

// Only BAckground color
  MetalRenderer = class(MetalBaseDelegate)
  protected
      // Interface
    method drawInMTKView(view: not nullable MTKView); override;

  public

  end;
implementation

method MetalBaseDelegate.makeFancyColor: Color;
begin
  if growing then begin
    var dynamicChannelIndex: NSUInteger := (primaryChannel + 1) mod 3;
    colorChannels[dynamicChannelIndex] := colorChannels[dynamicChannelIndex] + DynamicColorRate;
    if colorChannels[dynamicChannelIndex] ≥ 1 then begin
      growing := false;
      primaryChannel := dynamicChannelIndex;
    end;
  end
  else begin
    var dynamicChannelIndex: NSUInteger := (primaryChannel + 2) mod 3;
    colorChannels[dynamicChannelIndex] := colorChannels[dynamicChannelIndex] - DynamicColorRate;
    if colorChannels[dynamicChannelIndex] ≤ 0 then begin
      growing := true;
    end;
  end;
  var color: Color;
  color.red := colorChannels[0];
  color.green := colorChannels[1];
  color.blue := colorChannels[2];
  color.alpha := colorChannels[3];
  exit color;
end;



constructor MetalBaseDelegate initWithMetalKitView(const mtkView: not nullable MTKView);
begin
  _device :=  mtkView.device;
  _commandQueue := _device.newCommandQueue;
end;

method MetalRenderer.drawInMTKView(view: not nullable MTKView);
begin
  var color  := makeFancyColor;
  view.clearColor := MTLClearColorMake(color.red, color.green, color.blue, color.alpha);

  var commandBuffer :=  _commandQueue.commandBuffer();
  commandBuffer.label := 'MyCommand';
  var renderPassDescriptor: MTLRenderPassDescriptor := view.currentRenderPassDescriptor;
  if renderPassDescriptor ≠ nil then begin
    var renderEncoder: IMTLRenderCommandEncoder := commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor);
    renderEncoder.label := 'MyRenderEncoder';
    renderEncoder.endEncoding();
    commandBuffer.presentDrawable(view.currentDrawable);
  end;
  commandBuffer.commit();
end;

method MetalBaseDelegate.newShader(const shader: String): MTLLibrary;
begin
  var Lerror : Error;
  result := _device.newLibraryWithSource(shader) options(new MTLCompileOptions()) error(var Lerror);
  if result = nil then
  begin
    NSLog("Failed to compile the Shader, error %@", Lerror);
  end;

end;



end.