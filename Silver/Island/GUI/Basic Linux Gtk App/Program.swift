// based on https://developer.gnome.org/gtk3/stable/gtk-getting-started.html

import atk
import gobject
import gio
import gtk
  
class Program {

    static var window : UnsafePointer<GtkWindow>

    static func clicked(_ app: UnsafePointer<GtkApplication>, _ userdata: UnsafePointer<Void>) {
        let dialog = (gtk_message_dialog_new(nil,
                                             GtkDialogFlags.GTK_DIALOG_DESTROY_WITH_PARENT,
                                             GtkMessageType.GTK_MESSAGE_INFO,
                                             GtkButtonsType.GTK_BUTTONS_OK,
                                             "Hello World!")) as! UnsafePointer<GtkDialog>
        gtk_dialog_run(dialog)
        gtk_widget_destroy(dialog)
    }

    static func activate(_ app: UnsafePointer<GtkApplication>, _ userdata: UnsafePointer<Void>) {
        window = gtk_application_window_new(app) as! UnsafePointer<GtkWindow>
        gtk_window_set_title(window, "RemObjects Elements GTK Sample")
        gtk_window_set_default_size(window, 200, 200)

        var button_box = gtk_button_box_new(GtkOrientation.GTK_ORIENTATION_HORIZONTAL)
        gtk_container_add(window, button_box)

        var button = gtk_button_new_with_label("Hello World")
        g_signal_connect_data(glib.gpointer(button), "clicked", glib.GVoidFunc(clicked as! UnsafePointer<Void>, nil, nil, GConnectFlags(0)))
        gtk_container_add(button_box as! UnsafePointer<GtkContainer>, button)
        gtk_widget_show_all(window)
    }
    
    static func Run() -> Int32 {
        var app = gtk_application_new ("org.gtk.example", gio.GApplicationFlags.G_APPLICATION_FLAGS_NONE)
        g_signal_connect_data(glib.gpointer(app), "activate", glib.GVoidFunc(activate as! UnsafePointer<Void>, nil, nil, GConnectFlags(0)))
        var status = g_application_run (app, ExternalCalls.nargs, ExternalCalls.args)
        g_object_unref(glib.gpointer(app))
        return status
    }
}

return Program.Run()


