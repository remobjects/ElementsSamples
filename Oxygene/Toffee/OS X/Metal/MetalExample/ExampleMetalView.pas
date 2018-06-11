namespace MetalExample;

interface
uses
  AppKit,
  Metal,
  MetalKit,
  Foundation,
  RemObjects.Elements.RTL;


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

end;


end.