import java.util
import  android.app
import  android.content
import  android.os
import  android.util
import  android.view
import  android.widget

public class MainActivity: Activity {

	private var TbValue: TextView!
	func btnBackspace(v: View!) {
		var s = TbValue.Text.toString()
		if s.length() > 0 {
			s = s.substring(0, s.length() - 1)
			TbValue.Text = s
		}
	}

	func btnExecute(_ v: View!) {
		__try {
			var eval = Evaluator()
			var res = eval.Evaluate(TbValue.Text.toString())
			TbValue.Text = res.toString()
		} __catch e: Exception {
			var dlg = AlertDialog.Builder(self)
			dlg.Message = "Error evaluating: " + e.Message
			dlg.setPositiveButton("OK", nil)
			dlg.Cancelable = true
			dlg.create().show()
		}
	}

	func btnExit(_ v: View!) {
		finish();
	}

	func btnChar(_ v: View!) {
		TbValue.Text = TbValue.Text.toString() + (v as! Button).Text.toString()
	}

	public override func onCreate(_ savedInstanceState: Bundle!) {
		super.onCreate(savedInstanceState)
		ContentView = R.layout.main
		TbValue = findViewById(R.id.tbValue)as!TextView
		(findViewById(R.id.btnBackspace)as!Button).OnClickListener = btnBackspace
		(findViewById(R.id.btnExit)as!Button).OnClickListener = btnExit
		(findViewById(R.id.btnEval)as!Button).OnClickListener = btnExecute
		(findViewById(R.id.btn0)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn1)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn2)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn3)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn4)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn5)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn6)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn7)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn8)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btn9)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btnAdd)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btnSub)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btnDiv)as!Button).OnClickListener = btnChar
		(findViewById(R.id.btnMul)as!Button).OnClickListener = btnChar
	}
}
