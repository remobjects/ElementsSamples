using java.util;
using android.app;
using android.content;
using android.os;
using android.util;
using android.view;
using android.widget;
using Calculator.Engine;

namespace org.remobjects.calculator
{
	public class MainActivity: Activity 
	{
		private TextView TbValue;

		void btnBackspace(View v) 
		{
			var s = TbValue.Text.toString();
			if (s.length() > 0) 
			{
				s = s.substring(0, s.length() - 1);
				TbValue.Text = s;
			}
		}

		void btnExecute(View v) 
		{
			try 
			{
				var eval = new Evaluator();
				var res = eval.Evaluate(TbValue.Text.toString());
				TbValue.Text = res.toString();
			}
			catch (Exception e)
			{
				var dlg = new AlertDialog.Builder(this);
				dlg.Message = "Error evaluating: " + e.Message;
				dlg.setPositiveButton("OK", null);
				dlg.Cancelable = true;
				dlg.create().show();
			}
		}

		void btnExit(View v) 
		{
			finish();
		}

		void btnChar(View v) 
		{
			TbValue.Text = TbValue.Text.toString() + ((Button)v).Text.toString();
		}

		public override void onCreate(Bundle savedInstanceState) 
		{
			base.onCreate(savedInstanceState);
			ContentView = R.layout.main;
			TbValue = (TextView)findViewById(R.id.tbValue);
			((Button)findViewById(R.id.btnBackspace)).OnClickListener = btnBackspace;
			((Button)findViewById(R.id.btnExit)).OnClickListener = btnExit;
			((Button)findViewById(R.id.btnEval)).OnClickListener = btnExecute;
			((Button)findViewById(R.id.btn0)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn1)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn2)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn3)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn4)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn5)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn6)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn7)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn8)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btn9)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btnAdd)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btnSub)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btnDiv)).OnClickListener = btnChar;
			((Button)findViewById(R.id.btnMul)).OnClickListener = btnChar;

		}
	}
}
