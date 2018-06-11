namespace MetalExample;

interface

uses
  AppKit,
  MetalKit,
  Foundation;

type
  [IBObject]
  MainWindowController = public class(NSWindowController)
  private
    const BaseExample = 'Only Background Example running';
    var renderer : MTKViewDelegate;
  protected
  public
    [IBOutlet]
    var ViewGL: Metal_View;
    [IBOutlet]
    var TimeLabel : NSToolbarItem;

    method init: instancetype; override;
    method windowDidLoad; override;


    [IBAction]
    method pressAppButton(sender: id);

  end;

implementation

method MainWindowController.init: instancetype;
begin
  self := inherited initWithWindowNibName('MainWindowController');
  if self <> nil then
  begin


  end;

  result := self;
end;

method MainWindowController.windowDidLoad;

begin
  inherited;// windowDidLoad();
  if ViewGL <> nil then
  begin

    TimeLabel.label := BaseExample;
  //  ViewGL.device := MTLCreateSystemDefaultDevice();
    renderer  := new MetalRenderer InitWithMetalKitView(ViewGL);

    if(renderer = nil) then
    begin
      NSLog("Renderer failed initialization");
      exit;
    end;

    ViewGL.delegate := renderer;
    ViewGL.preferredFramesPerSecond := 60;
  end;
end;



method MainWindowController.pressAppButton(sender: id);
begin
  var tag := NSToolbarItem(sender).tag;
  var App : MTKViewDelegate := nil;
  case tag of
    0 : begin
      App := new MetalExample1 InitWithMetalKitView(ViewGL);
      TimeLabel.label := 'Example Triangle running';
    end;

    1 : begin
      App := new MetalExample2 InitWithMetalKitView(ViewGL);
      TimeLabel.label := 'Example Buffers running';
    end;

    2 : begin
      App := new MetalExample3 InitWithMetalKitView(ViewGL);
      TimeLabel.label := 'Example Texture running';
    end;

  end;


 if App = nil then
  begin
  App  := new MetalRenderer InitWithMetalKitView(ViewGL);
  TimeLabel.label := BaseExample;
end;

  if App <> nil then
  begin
    renderer := App;
    renderer.mtkView(ViewGL) drawableSizeWillChange(ViewGL.drawableSize);
    ViewGL.delegate := renderer;
  end;

end;




end.