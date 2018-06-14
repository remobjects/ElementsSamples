namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

type
[IBObject]
Metal_View = public class(MTKView)
public
 method awakeFromNib; override;
end;

implementation

method Metal_View.awakeFromNib;
begin
  inherited;
  device := MTLCreateSystemDefaultDevice();
  if device = nil then
  NSLog("Could not create a default MetalDevice!!")
end;


end.