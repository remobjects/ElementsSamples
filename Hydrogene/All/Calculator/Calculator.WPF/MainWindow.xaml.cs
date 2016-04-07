using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Calculator.Engine;

namespace Calculator.WPF
{
	public partial class MainWindow : Window
	{
		public MainWindow()
		{
			InitializeComponent();		
		}		

		private void Exit_Clicked(System.Object sender, System.Windows.RoutedEventArgs e)
		{
		    Close();
		}
	
		private void Backspace_Clicked(System.Object sender, System.Windows.RoutedEventArgs e)
		{
		    string s = tbValue.Text;

			if (s.Length > 0) 
				s = s.Substring(0, s.Length - 1);

			tbValue.Text = s;
			Refocus();
		}

		public void Refocus()
		{
			tbValue.Focus();
			tbValue.SelectionStart = tbValue.Text.Length;
		}
				
		private void Evaluate_Clicked(System.Object sender, System.Windows.RoutedEventArgs e)
		{
		    try 
			{
				var eval = new Evaluator();
				var res = eval.Evaluate(tbValue.Text);
				tbValue.Text = res.ToString(System.Globalization.CultureInfo.InvariantCulture);
			} 
			catch (Exception ex)
			{
				MessageBox.Show("Error evaluating: " + ex.Message);
			}
			
			Refocus();
		}

		private void Text_Clicked(System.Object sender, System.Windows.RoutedEventArgs e)
		{
		    tbValue.Text = tbValue.Text + (sender as Button).Content.ToString();
			Refocus();
		}
   
   }
}