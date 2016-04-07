using java.util;
using android.app;
using android.content;
using android.os;
using android.util;
using android.view;
using android.widget;

namespace com.remobjects.actionbar
{
	public class MainActivity: Activity
	{
	

		public override void onCreate(Bundle savedInstanceState)
		{
			base.onCreate(savedInstanceState);

			// Set our view from the "main" layout resource
			ContentView = R.layout.main;
		}

    public override bool onCreateOptionsMenu(Menu menu)
    {
     MenuInflater  inflater = getMenuInflater();
     inflater.inflate(R.menu.main_activity_actions, menu);
     return base.onCreateOptionsMenu(menu);
     }

     public override bool onOptionsItemSelected(MenuItem item)
     {
        switch (item.getItemId())
        {
          case R.id.action_search:
            this.openSearch();
            return true;
          case R.id.action_settings:
            this.openSettings();
            return true;
          default: 
              return base.onOptionsItemSelected(item);
        }
	   }

    public void openSearch()
    {
        Intent intent = new Intent(this, typeof(SearchActivity));
        startActivity(intent);
    }

    public void openSettings()
    {
        Intent intent = new Intent(this, typeof(SettingsActivity));
        startActivity(intent);
    }

	
	}
}
