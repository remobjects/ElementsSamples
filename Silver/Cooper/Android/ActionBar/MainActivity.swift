import java.util
import android.app
import android.content
import android.os
import android.util
import android.view
import android.widget

public class MainActivity: Activity {
	
	public override func onCreate(savedInstanceState: Bundle!) {

		super.onCreate(savedInstanceState);

		// Set our view from the "main" layout resource
		ContentView = R.layout.main;
	}

	public override func onCreateOptionsMenu(menu: Menu!) -> Bool {
		
		let inflater = getMenuInflater();
		inflater.inflate(R.menu.main_activity_actions, menu);
		return super.onCreateOptionsMenu(menu);
	}

	public override func onOptionsItemSelected(item: MenuItem!) -> Bool {
		switch (item.getItemId())
		{
			case R.id.action_search:
				openSearch();
				return true;
			case R.id.action_settings:
				openSettings();
				return true;
			default: 
				return super.onOptionsItemSelected(item);
		}
	}
	
	func openSearch() {
		let intent = android.content.Intent(self, typeOf(SearchActivity));
		startActivity(intent);
	}

	func openSettings() {
		let intent = android.content.Intent(self, typeOf(SettingsActivity));
		startActivity(intent);
	}


}