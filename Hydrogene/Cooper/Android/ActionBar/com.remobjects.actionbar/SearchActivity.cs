using java.util;
using android.app;
using android.content;
using android.os;
using android.util;
using android.view;
using android.widget;

namespace com.remobjects.actionbar
{
	public class SearchActivity : Activity
	{
		public override void onCreate(Bundle savedInstanceState)
		{
			base.onCreate(savedInstanceState);

			TextView textView = new TextView(this);
			textView.TextSize = 40;
			textView.Text = "Search Activity";
			ContentView = textView;
			getActionBar().setDisplayHomeAsUpEnabled(true);
		}
	}
}