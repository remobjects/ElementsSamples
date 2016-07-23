import java.util
import android.app
import android.content
import android.os
import android.util
import android.view
import android.widget

public class DisplayMessageActivity : Activity {
		
	public override func onCreate(_ savedInstanceState: Bundle!) {
		
		super.onCreate(savedInstanceState);
		
		let intent = getIntent();
		let message = intent.getStringExtra(MainActivity.EXTRA_MESSAGE);
		
		let textView = TextView(self);
		textView.TextSize = 40;
		textView.Text = message;
		ContentView = textView;
	}
}
