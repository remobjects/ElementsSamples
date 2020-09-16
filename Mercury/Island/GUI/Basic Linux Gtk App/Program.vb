// based on https://developer.gnome.org/gtk3/stable/gtk-getting-started.html

Imports atk
Imports gobject
Imports gio
Imports gtk

/*
  !!! Please note: in order to run this sample, you need to manually copy it to a Linux PC or VM with an active GUI, and run it.
  !!!
  !!! GUI applications cannot be run via SSH or CrossBox 2, and they are also not supported on "Bash on Windows".
*/

Class Program
  Shared Dim window As Ptr(Of GtkWindow)

  Shared Sub clicked(app As GtkWidget, userdata As Ptr(Of Void))
	Dim dialog = TryCast(gtk_message_dialog_new(Null, GtkDialogFlags.GTK_DIALOG_DESTROY_WITH_PARENT, GtkMessageType.GTK_MESSAGE_INFO, GtkButtonsType.GTK_BUTTONS_OK, "Hello World!"), Ptr(Of GtkDialog))
	gtk_dialog_run(dialog)
	gtk_widget_destroy(dialog)
  End Sub

  Shared Function Main(args As String()) As Int32
	window = TryCast(gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL), Ptr(Of GtkWindow))
	gtk_window_set_title(window, "RemObjects C# - Island GTK Sample")
	gtk_window_set_default_size(window, 200, 200)
	Dim button_box = gtk_hbutton_box_new()
	gtk_container_add(window, button_box)
	Dim button = gtk_button_new_with_label("Hello World")
	g_signal_connect_data(TryCast(button, glib.gpointer), "clicked", TryCast(TryCast(AddressOf(clicked), Ptr(Of Void)), glib.GVoidFunc), Null, Null, TryCast(0, GConnectFlags))
	gtk_container_add(TryCast(button_box, Ptr(Of GtkContainer)), button)
	gtk_widget_show_all(window)
	gtk_main()
  End Function
End Class