using java.util;
using android.app;
using android.content;
using android.os;
using android.util;
using android.view;
using android.widget;

namespace com.remobjects.actionbar
{
	public class SettingsActivity : Activity
	{
		public override void onCreate(Bundle savedInstanceState)
		{
			base.onCreate(savedInstanceState);

			TextView textView = new TextView(this);
			textView.TextSize = 40;
			textView.Text = "Settings Activity";
			ContentView = textView;

			getActionBar().setDisplayHomeAsUpEnabled(true);

		}
	}
}