namespace WxListboxDemo;

interface
uses
  Wx,
  System.IO,
  System.Drawing,
  System;
  
type
  MyFrame = class(Frame)
  protected
    mainsizer,
    editsizer,
    logosizer: BoxSizer;
    toppanel,
    logopanel,
    logofillerleft,
    logofillerright: Panel;
    textbox: TextCtrl;
    addbutton: Button;
    mainlistbox: ListBox;
    image: StaticBitmap;
  
    procedure InitializeComponents; 
    procedure AddButtonClick(sender: Object; ev: &Event);
  public
    constructor;
  end;
  
  ListboxApp = class(App)
  public
    function OnInit: Boolean; override;
    
    class procedure Main;
  end;
  
implementation

procedure MyFrame.InitializeComponents; 
begin
  toppanel := new Panel(self, -1);
  textbox := new TextCtrl(toppanel, -1, '');
  addbutton := new Button(toppanel, -1, '&Add', wxDefaultPosition, wxDefaultSize, 0);
  mainlistbox := new ListBox(self, -1, wxDefaultPosition, wxDefaultSize, 0, new string[0], 0);
  logopanel := new Panel(self, -1);
  logofillerleft := new Panel(logopanel, -1);
  image := new StaticBitmap(logopanel, -1, new wx.Bitmap(
    Path.Combine(Path.GetDirectoryName(typeof(MyFrame).Assembly.Location), 'powered-by-oxygene-transpare.png'), 
    BitmapType.wxBITMAP_TYPE_PNG));
  logofillerright := new Panel(logopanel, -1);
 
  Title := 'WxWidgets Listbox Demo';
  addbutton.SetDefault();
  addbutton.Click += AddButtonClick;
  mainlistbox.Selection := 0;

  editsizer := new BoxSizer(Orientation.wxHORIZONTAL);
  editsizer.Add(textbox, 1, wx.Direction.wxALL, 8);
  editsizer.Add(addbutton, 0, wx.Direction.wxALL, 8);
  editsizer.Fit(toppanel);
  editsizer.SetSizeHints(toppanel);
  toppanel.AutoLayout := true;
  toppanel.Sizer := editsizer;
 
  logosizer := new BoxSizer(Orientation.wxHORIZONTAL);
  logosizer.Add(logofillerleft, 1, wx.Stretch.wxEXPAND, 0);
  logosizer.Add(image, 0, wx.Stretch.wxEXPAND or wx.Alignment.wxALIGN_CENTER_HORIZONTAL, 0);
  logosizer.Add(logofillerright, 1, wx.Stretch.wxEXPAND, 0);
  logosizer.Fit(logopanel);
  logosizer.SetSizeHints(logopanel);
  logopanel.AutoLayout := true;
  logopanel.Sizer := logosizer;
 
  mainsizer := new BoxSizer(Orientation.wxVERTICAL);
  mainsizer.Add(toppanel, 0, wx.Stretch.wxEXPAND, 0);
  mainsizer.Add(mainlistbox, 1, wx.Stretch.wxEXPAND, 0);
  mainsizer.Add(logopanel, 0, wx.Stretch.wxEXPAND, 0);
  mainsizer.Fit(self);
  mainsizer.SetSizeHints(self);

  AutoLayout := true;
  SetSize(492, 499);
  SetSizer(mainsizer);
  Layout();
end;

constructor MyFrame; 
begin
  inherited constructor(nil, -1, 'WxWidgets ListBox Demo', 
    wxDefaultPosition, 
    new Size(492, 499),
    wxDEFAULT_DIALOG_STYLE, 'MyFrame');
  InitializeComponents;
end;

procedure MyFrame.AddButtonClick(sender: Object; ev: &Event); 
begin
  mainlistbox.Append(textbox.Title);
  textbox.Title := '';
  textbox.SetFocus;
end;

function ListboxApp.OnInit: Boolean; 
var
  Frame: MyFrame;
begin
  Frame := new MyFrame;
  Frame.Show(true);
  Result := true;
end;

[STAThread]
class procedure ListboxApp.Main; 
var
  app: ListboxApp := new ListboxApp;
begin
  app.Run;
end;

end.
