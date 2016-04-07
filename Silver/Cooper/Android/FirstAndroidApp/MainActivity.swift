import java.util
import android.app
import android.content
import android.os
import android.util
import android.view
import android.widget

public class MainActivity: Activity {

	static let EXTRA_MESSAGE = "com.example.firstandroidapp.MESSAGE";

	public override func onCreate(savedInstanceState: Bundle!) {
		super.onCreate(savedInstanceState);

		// Set our view from the "main" layout resource
		ContentView = R.layout.main;
	}

	public func sendMessage(view: View) {

		let intent = android.content.Intent(self, typeOf(DisplayMessageActivity));
		let editText = findViewById(R.id.edit_message) as! EditText;
		let message = editText.getText().toString();
		intent.putExtra(EXTRA_MESSAGE, message);
		startActivity(intent);
	}
}

