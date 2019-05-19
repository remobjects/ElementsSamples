namespace GLExample;

interface

uses
  AppKit,
  GlHelper,
  Foundation;

type
  [IBObject]
  MainWindowController = public class(NSWindowController)
  private
    ftimer: NSTimer;
  protected
  public
    [IBOutlet]
    var ViewGL: Gl_View;
    [IBOutlet]
    var TimeLabel : NSToolbarItem;

    method init: instancetype; override;
    method windowDidLoad; override;
    method awakeFromNib; override;

    [IBAction]
    method pressFillButton(sender: id);
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
    // One of the 3 app should be activ!!!
    TimeLabel.label := 'No Example running';

    //ftimer :=  NSTimer.timerWithTimeInterval(1.0 / 60.0) repeats(true) &block(method (aTimer : NSTimer)
    //begin
      //ViewGL.Repaint;
    //end
    //);
    //RunLoop.mainRunLoop.addTimer(ftimer) forMode(NSDefaultRunLoopMode);
  end;
end;

method MainWindowController.pressFillButton(sender: id);
begin
  ViewGL.app.ChangeFillmode;
end;

method MainWindowController.pressAppButton(sender: id);
begin
  var tag := NSToolbarItem(sender).tag;
  var App : IAppInterface := nil;
  case tag of
    0 : App := new GL_Example_1();
    1 : App := new GL_Example_2();
    2 : App := new GL_Example_3();
  end;

  TimeLabel.label := 'Example '+(tag+1).ToString;

  if App <> nil then
  begin
    App.Initialize;
    ViewGL.app := App;


    if ftimer = nil then
    begin
      ftimer :=  NSTimer.timerWithTimeInterval(1.0 / 60.0) repeats(true) &block(method (aTimer : NSTimer)
      begin
        ViewGL.Repaint;
      end
      );
      RunLoop.mainRunLoop.addTimer(ftimer) forMode(NSDefaultRunLoopMode);
    end;
  end;

end;

method MainWindowController.awakeFromNib;
begin
  inherited;
end;



end.