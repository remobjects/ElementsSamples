# Enter a message and pass it to a second native Android activity.
@namespace("org.me.firstpythonapp")
from android.app import Activity
from android.os import Bundle
from android.view import View
from android.widget import EditText
from android.content import Intent

class MainActivity(Activity):
    @override
    def onCreate(self, savedInstanceState: Bundle) -> None:
        super().onCreate(savedInstanceState)
        self.setContentView(R.layout.main)

    def sendMessage(self, view: View) -> None:
        editor: EditText = self.findViewById(R.id.edit_message)
        intent: Intent = Intent()
        intent.setClassName(self, "org.me.firstpythonapp.DisplayMessageActivity")
        intent.putExtra("message", editor.getText().toString())
        self.startActivity(intent)
