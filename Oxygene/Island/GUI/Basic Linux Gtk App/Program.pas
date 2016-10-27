// based on https://developer.gnome.org/gtk3/stable/gtk-getting-started.html

namespace BasicGtkApp;

uses
  atk,
  gobject,
  gio,
  gtk;
  
type
  Program = class
  public
    class var window :^GtkWindow;

    class method clicked(app: ^GtkApplication; userdata: ^Void);
    begin 
      var dialog := ^GtkDialog(gtk_message_dialog_new(nil,
                                                      GtkDialogFlags.GTK_DIALOG_DESTROY_WITH_PARENT,
                                                      GtkMessageType.GTK_MESSAGE_INFO,
                                                      GtkButtonsType.GTK_BUTTONS_OK,
                                                      'Hello World'));
      gtk_dialog_run (dialog);
      gtk_widget_destroy (dialog);
    end;

    class method activate(app: ^GtkApplication; userdata: ^Void);
    begin 
      window := ^GtkWindow(gtk_application_window_new(app));
      gtk_window_set_title(window, 'RemObjects Elements - Island GTK Sample');
      gtk_window_set_default_size(window, 200, 200);

      var button_box := gtk_button_box_new(GtkOrientation.GTK_ORIENTATION_HORIZONTAL);
      gtk_container_add(window, button_box);

      var button := gtk_button_new_with_label('Hello World');
      g_signal_connect_data(glib.gpointer(button), 'clicked', glib.GVoidFunc(^Void(@clicked)), nil, nil, GConnectFlags(0));
      gtk_container_add(^GtkContainer(button_box), button);
      gtk_widget_show_all(window);
    end;

    class method Main(args: array of String): Int32;
    begin
      var app := gtk_application_new('org.gtk.example', gio.GApplicationFlags.G_APPLICATION_FLAGS_NONE);
      g_signal_connect_data(glib.gpointer(app), "activate", glib.GVoidFunc(^Void(@activate)), nil, nil, GConnectFlags(0));
      var status := g_application_run (app, ExternalCalls.nargs, ExternalCalls.args);
      g_object_unref(glib.gpointer(app));
      exit status;
    end;
    
  end;

end.