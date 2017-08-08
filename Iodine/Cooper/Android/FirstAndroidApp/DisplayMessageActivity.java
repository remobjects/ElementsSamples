package org.me.firstandroidapp;

import java.util.*;
import android.app.*;
import android.content.*;
import android.os.*;
import android.util.*;
import android.view.*;
import android.widget.*;

public class DisplayMessageActivity extends Activity
{
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		Intent intent = getIntent();
		String message = intent.getStringExtra(MainActivity.EXTRA_MESSAGE);

		TextView textView = new TextView(this);
		textView.TextSize = 40;
		textView.Text = message;
		ContentView = textView;
	}

}