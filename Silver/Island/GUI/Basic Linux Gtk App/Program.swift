// based on https://developer.gnome.org/gtk3/stable/gtk-getting-started.html

import atk
import gobject
import gio
import gtk

/*
  !!! Please note: in order to run this sample, you need to manually copy it to a Linux PC or VM with an active GUI, and run it.
  !!!
  !!! GUI applications cannot be run via SSH or CrossBox 2, and they are also not supported on "Bash on Windows".
*/

class Program {

	static var window: UnsafePointer<GtkWindow>

	static func clicked(_ app: UnsafePointer<GtkWidget>, _ userdata: UnsafePointer<Void>) {
		let dialog = (gtk_message_dialog_new(nil,
											 GtkDialogFlags.GTK_DIALOG_DESTROY_WITH_PARENT,
											 GtkMessageType.GTK_MESSAGE_INFO,
											 GtkButtonsType.GTK_BUTTONS_OK,
											 "Hello World!")) as! UnsafePointer<GtkDialog>
		gtk_dialog_run(dialog)
		gtk_widget_destroy(dialog)
	}

	static func Run() -> Int32 {
		window = gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL) as! UnsafePointer<GtkWindow>

		gtk_window_set_title(window, "RemObjects Swift - Island GTK Sample")
		gtk_window_set_default_size(window, 200, 200)

		var button_box = gtk_hbutton_box_new()
		gtk_container_add(window, button_box)

		var button = gtk_button_new_with_label("Hello World")
		g_signal_connect_data(button as! glib.gpointer, "clicked", (clicked as! UnsafePointer<Void>) as! glib.GVoidFunc, nil, nil, 0 as! GConnectFlags)
		gtk_container_add(button_box as! UnsafePointer<GtkContainer>, button)
		gtk_widget_show_all(window)

		gtk_main()
		return 0
	}
}

return Program.Run()