using java.util;
using android.app;
using android.content;
using android.os;
using android.util;
using android.view;
using android.widget;

namespace org.me.firstandroidapp
{
	public class MainActivity: Activity
	{

    public const string EXTRA_MESSAGE = "com.example.firstandroidapp.MESSAGE";

		public override void onCreate(Bundle savedInstanceState)
		{
			base.onCreate(savedInstanceState);

			// Set our view from the "main" layout resource
			ContentView = R.layout.main;
		}

    public void sendMessage(View view)
    {
       Intent intent = new Intent(this, typeof(DisplayMessageActivity));
       EditText editText = (EditText)findViewById(R.id.edit_message);
       string message = editText.getText().toString();
       intent.putExtra(EXTRA_MESSAGE, message);
       startActivity(intent);
    }
	}
}
