#If GTK Then
Imports System.ComponentModel

Public Partial Class MainWindowController
  Public Property window As Gtk.ApplicationWindow

  Public Sub New()
    setup()
    Dim stream = GetType(MainWindowController).Assembly.GetManifestResourceStream("MainWindow.ui")
    If stream Is Nothing Then
      Throw New System.InvalidOperationException("Embedded GTK layout MainWindow.ui was not found.")
    End If
    Dim builder As Gtk.Builder
    Using reader As New System.IO.StreamReader(stream)
      builder = Gtk.Builder.NewFromString(reader.ReadToEnd(), -1)
    End Using
    window = DirectCast(builder.GetObject("MainWindow"), Gtk.ApplicationWindow)
    window.SetApplication(Program.application)

    Dim inputA = DirectCast(builder.GetObject("ValueAEntry"), Gtk.Entry)
    inputA.SetText(If(valueA, ""))
    AddHandler inputA.OnChanged, Sub(sender, e)
      valueA = inputA.GetText()
    End Sub
    Dim inputB = DirectCast(builder.GetObject("ValueBEntry"), Gtk.Entry)
    inputB.SetText(If(valueB, ""))
    AddHandler inputB.OnChanged, Sub(sender, e)
      valueB = inputB.GetText()
    End Sub
    Dim button = DirectCast(builder.GetObject("CalculateButton"), Gtk.Button)
    AddHandler button.OnClicked, Sub(sender, e) calculateResult(sender)
    Dim resultLabel = DirectCast(builder.GetObject("ResultLabel"), Gtk.Label)
    resultLabel.SetText(If(result, ""))
    AddHandler DirectCast(Me, INotifyPropertyChanged).PropertyChanged, Sub(sender, e)
      If e.PropertyName = "result" Then resultLabel.SetText(If(result, ""))
    End Sub
  End Sub

  Public Sub showWindow(sender As id)
    window.Present()
  End Sub
End Class
#End If
