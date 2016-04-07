import java.util
import android.app
import android.content
import android.os
import android.util
import android.view
import android.widget

public class SearchActivity : Activity {
	
	public override func onCreate(savedInstanceState: Bundle!) {
		
		super.onCreate(savedInstanceState);
		
		let textView = TextView(self);
		textView.TextSize = 40;
		textView.Text = "Search Activity";
		ContentView = textView;
		
		getActionBar().setDisplayHomeAsUpEnabled(true);
	}
}
