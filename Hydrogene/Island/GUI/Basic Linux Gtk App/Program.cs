// based on https://developer.gnome.org/gtk3/stable/gtk-getting-started.html

using atk;
using gobject;
using gio;
using gtk;

namespace BasicGtkApp {
  
	class Program {

		static GtkWindow *window; 

		static void clicked(GtkApplication app, Void *userdata)
		{
			var dialog = (GtkDialog *)gtk_message_dialog_new(null,
															 GtkDialogFlags.GTK_DIALOG_DESTROY_WITH_PARENT,
															 GtkMessageType.GTK_MESSAGE_INFO,
															 GtkButtonsType.GTK_BUTTONS_OK,
															 "Hello World!");
			gtk_dialog_run(dialog);
			gtk_widget_destroy(dialog);
		}

		static void activate(GtkApplication *app, Void *userdata)
		{
			window = (GtkWindow *)gtk_application_window_new(app);
			gtk_window_set_title(window, "RemObjects Elements - Island GTK Sample");
			gtk_window_set_default_size(window, 200, 200);

			var button_box = gtk_button_box_new(GtkOrientation.GTK_ORIENTATION_HORIZONTAL);
			gtk_container_add(window, button_box);

			var button = gtk_button_new_with_label("Hello World");
			g_signal_connect_data((glib.gpointer)button, "clicked", (glib.GVoidFunc)((void *)(clicked)), null, null, (GConnectFlags)0);
			gtk_container_add((GtkContainer *)button_box, button);
			gtk_widget_show_all(window);
		}
	
		static Int32 Main(string[] args)
		{
			var app = gtk_application_new ("org.gtk.example", gio.GApplicationFlags.G_APPLICATION_FLAGS_NONE);
			g_signal_connect_data((glib.gpointer)app, "activate", (glib.GVoidFunc)((void *)(activate)), null, null, (GConnectFlags)0);
			var status = g_application_run (app, ExternalCalls.nargs, ExternalCalls.args);
			g_object_unref((glib.gpointer)app);
			return status;
		}
	}

}