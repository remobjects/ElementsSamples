using java.util;
using android.app;
using android.content;
using android.os;
using android.util;
using android.view;
using android.widget;

namespace org.me.firstandroidapp
{
    public class DisplayMessageActivity : Activity
    {
		
		public override void onCreate(Bundle savedInstanceState)
		{
			base.onCreate(savedInstanceState);
			
      Intent intent = getIntent();
      string message = intent.getStringExtra(MainActivity.EXTRA_MESSAGE);

      TextView textView = new TextView(this);
      textView.TextSize = 40;
      textView.Text = message;
      ContentView = textView;
		}

    }
}
