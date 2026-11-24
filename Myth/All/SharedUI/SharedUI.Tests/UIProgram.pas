// Positive integration guards: exercise the actual Myth adapters, native layouts,
// control events and result notifications; GC checks guard callback/widget lifetime.
namespace SharedUI.Shared;

uses RemObjects.Elements.RTL;
{$IF WPF}
uses System.Windows, System.Windows.Controls, System.Windows.Threading;
{$ENDIF}
{$IF GTK}
uses Gtk;
{$ENDIF}
{$IF VCL}
uses Vcl.Forms;
{$ENDIF}

type
  {$IF VCL}
  MainWindowController = public partial class
  public
    method TestWindow: MainWindow;
    begin
      exit self._window;
    end;
  end;
  {$ENDIF}

  UIProgram = public static class
  private
    class var fController: MainWindowController;
    {$IF WPF}
    class var fValueA, fValueB: TextBox;
    class var fButton: Button;
    class var fResult: TextBlock;
    {$ELSEIF GTK}
    class var fValueA, fValueB: Gtk.Entry;
    class var fButton: Gtk.Button;
    class var fResult: Gtk.Label;
    {$ELSEIF VCL}
    class var fWindow: MainWindow;
    {$ENDIF}

    class method Check(aCondition: Boolean; aMessage: String);
    begin
      if not aCondition then
        raise new Exception(aMessage);
    end;

    {$IF GTK}
    class method FindControl(aWidget: Gtk.Widget; aId: String): Gtk.Widget;
    begin
      if (aWidget is Gtk.Buildable) and ((aWidget as Gtk.Buildable).GetBuildableId = aId) then
        exit aWidget;
      var lChild := aWidget.GetFirstChild;
      while assigned(lChild) do begin
        var lFound := FindControl(lChild, aId);
        if assigned(lFound) then
          exit lFound;
        lChild := lChild.GetNextSibling;
      end;
      exit nil;
    end;
    {$ENDIF}

    class method DisplayedResult: String;
    begin
      {$IF WPF}
      exit fResult.Text;
      {$ELSEIF GTK}
      exit fResult.GetText;
      {$ELSEIF VCL}
      exit fWindow._resultLabel.Caption;
      {$ENDIF}
    end;

    class method FindNativeControls;
    begin
      {$IF WPF}
      fValueA := TextBox(fController.Window.FindName('ValueAInput'));
      fValueB := TextBox(fController.Window.FindName('ValueBInput'));
      fButton := Button(fController.Window.FindName('CalculateButton'));
      fResult := TextBlock(fController.Window.FindName('ResultOutput'));
      {$ELSEIF GTK}
      fValueA := Gtk.Entry(FindControl(fController.Window, 'ValueAEntry'));
      fValueB := Gtk.Entry(FindControl(fController.Window, 'ValueBEntry'));
      fButton := Gtk.Button(FindControl(fController.Window, 'CalculateButton'));
      fResult := Gtk.Label(FindControl(fController.Window, 'ResultLabel'));
      {$ELSEIF VCL}
      fWindow := fController.TestWindow;
      {$ENDIF}
    end;

    class method CheckCase(aA, aB, aExpected: String);
    begin
      {$IF WPF}
      fValueA.Text := aA;
      fValueB.Text := aB;
      fController.Window.Dispatcher.Invoke(new Action(method begin end), DispatcherPriority.ApplicationIdle);
      {$ELSEIF GTK}
      fValueA.SetText(aA);
      fValueB.SetText(aB);
      {$ELSEIF VCL}
      fWindow._valueAEdit.Text := aA;
      fWindow._valueBEdit.Text := aB;
      {$ENDIF}
      Check(fController.ValueA = aA, 'The first native input did not reach the controller');
      Check(fController.ValueB = aB, 'The second native input did not reach the controller');
      {$IF WPF}
      fButton.RaiseEvent(new RoutedEventArgs(Button.ClickEvent, fButton));
      fController.Window.Dispatcher.Invoke(new Action(method begin end), DispatcherPriority.ApplicationIdle);
      {$ELSEIF GTK}
      Check(fButton.Activate, 'GTK did not activate the native button');
      var lTimer := System.Diagnostics.Stopwatch.StartNew;
      while (fController.Result <> aExpected) and (lTimer.ElapsedMilliseconds < 2000) do begin
        GLib.MainContext.Default.Iteration(false);
        System.Threading.Thread.Sleep(1);
      end;
      {$ELSEIF VCL}
      fWindow._calculateButton.Click;
      {$ENDIF}
      Check(fController.Result = aExpected, 'The native action did not calculate the expected result');
      Check(DisplayedResult = aExpected, 'The native result display did not receive the notification');
    end;

  public
    {$IF WPF}[STAThread]{$ENDIF}
    class method Main: Integer;
    begin
      {$IF WPF}
      var lApplication := new Application;
      {$ELSEIF GTK}
      Gtk.Module.Initialize;
      Check(Gtk.Functions.InitCheck, 'GTK initialization failed; a graphical session and GTK 4 are required');
      var lApplication := Gtk.Application.New('com.remobjects.samples.sharedui.tests', Gio.ApplicationFlags.FlagsNone);
      Check(lApplication.Register(nil), 'GTK application registration failed');
      // Keep the production application's setter private; this only supplies test hosting.
      typeOf(Program).GetProperty('Application').SetValue(nil, lApplication);
      {$ELSEIF VCL}
      Application.Initialize;
      {$ENDIF}
      fController := new MainWindowController;
      FindNativeControls;
      try
        fController.Show(nil);
        {$IF WPF}
        fController.Window.Dispatcher.Invoke(new Action(method begin end), DispatcherPriority.ApplicationIdle);
        {$ENDIF}
        Check(DisplayedResult = 'N/A', 'Initial result was not displayed');
        CheckCase('21', '21', '42');
        CheckCase('-1.5', '2.5', '1');
        CheckCase('Hello, ', 'world', 'Hello, world');
        CheckCase('', '1', '(value required)');
        CheckCase('1', '', '(value required)');
        {$IF ECHOES}
        fValueA := nil;
        fValueB := nil;
        fButton := nil;
        fResult := nil;
        System.GC.Collect;
        System.GC.WaitForPendingFinalizers;
        System.GC.Collect;
        FindNativeControls;
        {$ENDIF}
        CheckCase('2', '3', '5');
        writeLn('SharedUI native UI checks passed');
        exit 0;
      finally
        {$IF WPF}
        fController.Window.Close;
        lApplication.Shutdown;
        {$ELSEIF GTK}
        fController.Window.Destroy;
        lApplication.Quit;
        {$ELSEIF VCL}
        fWindow.Close;
        {$ENDIF}
      end;
    end;
  end;

end.
