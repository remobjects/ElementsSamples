package org.me.firstandroidapp;

import java.util.*;
import android.app.*;
import android.content.*;
import android.os.*;
import android.util.*;
import android.view.*;
import android.widget.*;

public class MainActivity extends Activity
{

	public static final String EXTRA_MESSAGE = "com.example.firstandroidapp.MESSAGE";

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		// Set our view from the "main" layout resource
		ContentView = R.layout.main;
	}

	public void sendMessage(View view)
	{
	   Intent intent = new Intent(this, typeOf(DisplayMessageActivity));
	   EditText editText = (EditText)findViewById(R.id.edit_message);
	   String message = editText.getText().toString();
	   intent.putExtra(EXTRA_MESSAGE, message);
	   startActivity(intent);
	}
}