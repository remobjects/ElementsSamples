# The XIB connects the native button to this Python action.
@namespace("BasicPythonApp")
from AppKit import INSApplicationDelegate, NSButton

@attribute(IBObject)
class AppDelegate(INSApplicationDelegate):
    @attribute(IBAction)
    def buttonClick(self, sender: NSButton) -> None:
        sender.title = "Hello from Python!"
