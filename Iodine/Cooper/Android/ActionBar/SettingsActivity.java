package com.remobjects.actionbar;

import java.util.*;
import android.app.*;
import android.content.*;
import android.os.*;
import android.util.*;
import android.view.*;
import android.widget.*;

public class SettingsActivity extends Activity
{
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		TextView textView = new TextView(this);
		textView.TextSize = 40;
		textView.Text = "Settings Activity";
		ContentView = textView;

		getActionBar().setDisplayHomeAsUpEnabled(true);

	}
}