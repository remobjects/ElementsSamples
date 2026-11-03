# Display the message carried by the launching Intent.
@namespace("org.me.firstpythonapp")
from android.app import Activity
from android.os import Bundle
from android.widget import TextView

class DisplayMessageActivity(Activity):
    @override
    def onCreate(self, savedInstanceState: Bundle) -> None:
        super().onCreate(savedInstanceState)
        self.setContentView(R.layout.message)
        label: TextView = self.findViewById(R.id.message)
        message: str = self.getIntent().getStringExtra("message")
        label.setText(message)
