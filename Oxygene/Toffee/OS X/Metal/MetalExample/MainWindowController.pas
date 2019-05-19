namespace MetalExample;

interface

uses
  AppKit,
  MetalKit,
  Foundation;
// The MainWindowController is a partial class
// because i want to test it :-)
// and to split the OS (Xcode) part away from the Metal part
type
  [IBObject]
  MainWindowController = public partial class(NSWindowController)

  public
  // Used from XCODE
    [IBOutlet]
    var ViewGL: Metal_View;
    [IBOutlet]
    var TimeLabel : NSToolbarItem;

    [IBAction]
    method pressAppButton(sender: id);

    // Overrides from NSWindowController
    method init: instancetype; override;
    method windowDidLoad; override;

  end;

implementation

method MainWindowController.init: instancetype;
begin
  self := inherited initWithWindowNibName('MainWindowController');
  result := self;
end;

method MainWindowController.windowDidLoad;
begin
  inherited;// windowDidLoad();
  if ViewGL <> nil then
  begin
    switchApp(-1);
    ViewGL.preferredFramesPerSecond := 60;
    ViewGL.depthStencilPixelFormat := MTLPixelFormat.Depth32Float;
    //ViewGL.depthStencilTexture
  end;
end;

method MainWindowController.pressAppButton(sender: id);
begin
  var tag := NSToolbarItem(sender).tag;
  switchApp(tag);
end;

end.