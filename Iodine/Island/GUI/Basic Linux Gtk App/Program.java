package BasicGtkApp;

// based on https://developer.gnome.org/gtk3/stable/gtk-getting-started.html

import atk.*;
import gobject.*;
import gio.*;
import gtk.*;

/*
  !!! Please note: in order to run this sample, you need to manually copy it to a Linux PC or VM with an active GUI, and run it.
  !!!
  !!! GUI applications cannot be run via SSH or CrossBox 2, and they are also not supported on "Bash on Windows".
*/

class Program
{
	static GtkWindow *window;

	static void clicked(GtkWidget app, Void *userdata)
	{
		var dialog = (GtkDialog *)gtk_message_dialog_new(null,
														 GtkDialogFlags.GTK_DIALOG_DESTROY_WITH_PARENT,
														 GtkMessageType.GTK_MESSAGE_INFO,
														 GtkButtonsType.GTK_BUTTONS_OK,
														 "Hello World!");
		gtk_dialog_run(dialog);
		gtk_widget_destroy(dialog);
	}

	static Int32 Main(String[] args)
	{
		window = (GtkWindow *)gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL);

		gtk_window_set_title(window, "RemObjects Iodine - Island GTK Sample");
		gtk_window_set_default_size(window, 200, 200);

		var button_box = gtk_hbutton_box_new();
		gtk_container_add(window, button_box);

		var button = gtk_button_new_with_label("Hello World");
		g_signal_connect_data((glib.gpointer)button, "clicked", (glib.GVoidFunc)((void *)clicked), null, null, (GConnectFlags)0);
		gtk_container_add((GtkContainer *)button_box, button);
		gtk_widget_show_all(window);

		gtk_main();
	}
}