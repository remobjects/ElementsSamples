import System.Collections.Generic
import System.Linq
import System.Windows
import System.Windows.Controls
import System.Windows.Data
import System.Windows.Documents
import System.Windows.Media
import System.Windows.Navigation
import System.Windows.Shapes
import System.Windows.Input

public __partial class MainWindow: Window {

	public init() {
		InitializeComponent();
	}

	public func Exit_Clicked(_ sender: Object!, _ args: RoutedEventArgs!)
	{
		Close()
	}

	public func Backspace_Clicked(_ sender: Object!, _ args: RoutedEventArgs!)
	{
		var s = tbValue.Text
		if (s.Length > 0) {
			s = s.Substring(0, s.Length - 1)
			tbValue.Text = s
		}
		Refocus()
	}
	public func Refocus(){
		tbValue.Focus()
		tbValue.SelectionStart = tbValue.Text.Length
	}

	public func Text_Clicked(_ sender: Object!, _ args: RoutedEventArgs!)
	{
		tbValue.Text = tbValue.Text + (sender as! Button).Content.ToString()
		Refocus()
	}

	public func Evaluate_Clicked(_ sender: Object!, _ args: RoutedEventArgs!)
	{
		__try {
			var eval = Evaluator()
			var res = eval.Evaluate(tbValue.Text)
			tbValue.Text = res.ToString(System.Globalization.CultureInfo.InvariantCulture)
		} __catch e: Exception {
			MessageBox.Show("Error evaluating: " + e.Message)
		}
		Refocus()
	}

}
