# A native Windows Forms window, button and event handler written in Python.
@namespace("BasicWindowsApp")
from System import EventArgs, EventHandler, Object, STAThread
from System.Drawing import Point, Size
from System.Windows.Forms import Application, Button, Form, Label

class MainForm(Form):
    message: Label
    button: Button

    def __init__(self):
        super().__init__()
        self.Text = "Python Windows App"
        self.ClientSize = Size(400, 180)
        self.message = Label()
        self.message.Text = "Hello from Python!"
        self.message.AutoSize = True
        self.message.Location = Point(24, 28)
        self.button = Button()
        self.button.Text = "Click me"
        self.button.Location = Point(24, 72)
        self.button.Size = Size(120, 32)
        self.button.Click += EventHandler(self.button_click)
        self.Controls.Add(self.message)
        self.Controls.Add(self.button)

    def button_click(self, sender: Object, args: EventArgs) -> None:
        self.message.Text = "You clicked the button."

class Program:
    @staticmethod
    @attribute(STAThread)
    def Main() -> None:
        Application.EnableVisualStyles()
        Application.SetCompatibleTextRenderingDefault(False)
        Application.Run(MainForm())
