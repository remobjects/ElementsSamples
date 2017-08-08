package com.remobjects.actionbar;

import java.util.*;
import android.app.*;
import android.content.*;
import android.os.*;
import android.util.*;
import android.view.*;
import android.widget.*;

public class MainActivity extends Activity
{
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		// Set our view from the "main" layout resource
		ContentView = R.layout.main;
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu)
	{
		MenuInflater  inflater = getMenuInflater();
		inflater.inflate(R.menu.main_activity_actions, menu);
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
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
			return super.onOptionsItemSelected(item);
		}
	}

	public void openSearch()
	{
		Intent intent = new Intent(this, typeOf(SearchActivity));
		startActivity(intent);
	}

	public void openSettings()
	{
		Intent intent = new Intent(this, typeOf(SettingsActivity));
		startActivity(intent);
	}
}