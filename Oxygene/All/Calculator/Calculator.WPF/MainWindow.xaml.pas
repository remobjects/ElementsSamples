namespace Calculator.WPF;

interface

uses
  System,
  System.Collections.Generic,
  System.Linq,
  System.Text,
  System.Threading.Tasks,
  System.Windows,
  System.Windows.Controls,
  System.Windows.Data,
  System.Windows.Documents,
  System.Windows.Input,
  System.Windows.Media,
  System.Windows.Media.Imaging,
  System.Windows.Navigation,
  System.Windows.Shapes,
  Calculator.Engine;

type
  MainWindow = public partial class(Window)
  public
    constructor;
  private
    method Exit_Clicked(sender: System.Object; e: System.Windows.RoutedEventArgs);
    method Backspace_Clicked(sender: System.Object; e: System.Windows.RoutedEventArgs);
  public
    method Refocus;
  private
    method Evaluate_Clicked(sender: System.Object; e: System.Windows.RoutedEventArgs);
    method Text_Clicked(sender: System.Object; e: System.Windows.RoutedEventArgs);
  end;

implementation

constructor MainWindow;
begin
  InitializeComponent();
end;

method MainWindow.Exit_Clicked(sender: System.Object; e: System.Windows.RoutedEventArgs);
begin
  Close();
end;

method MainWindow.Backspace_Clicked(sender: System.Object; e: System.Windows.RoutedEventArgs);
begin
  var s: String := tbValue.Text;
  if s.Length > 0 then
    s := s.Substring(0, s.Length - 1);
  tbValue.Text := s;
  Refocus();
end;

method MainWindow.Refocus;
begin
  tbValue.Focus();
  tbValue.SelectionStart := tbValue.Text.Length;
end;

method MainWindow.Evaluate_Clicked(sender: System.Object; e: System.Windows.RoutedEventArgs);
begin
  try
    var eval := new Evaluator();
    var res := eval.Evaluate(tbValue.Text);
    tbValue.Text := res.ToString(System.Globalization.CultureInfo.InvariantCulture);
  except
    on ex: Exception do
    begin
      MessageBox.Show('Error evaluating: ' + ex.Message);
    end;
  end;
  Refocus();
end;

method MainWindow.Text_Clicked(sender: System.Object; e: System.Windows.RoutedEventArgs);
begin
  tbValue.Text := tbValue.Text + (Button(sender)).Content.ToString();
  Refocus();
end;

end.