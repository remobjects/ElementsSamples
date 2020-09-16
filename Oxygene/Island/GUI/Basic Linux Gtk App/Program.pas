// based on https://developer.gnome.org/gtk-tutorial/stable/c489.html

namespace BasicGtkApp;

uses
  atk,
  gobject,
  gio,
  gtk;

/*
  !!! Please note: in order to run this sample, you need to manually copy it to a Linux PC or VM with an active GUI, and run it.
  !!!
  !!! GUI applications cannot be run via SSH or CrossBox 2.
  !!! To run this on Bash on Windows, set the :DISPLAY=:0 variable, and run an XServer locally, like Xming.
*/

type
  Program = class
  public
    class var window: ^GtkWindow;

    class method clicked(app: ^GtkWidget; userdata: ^Void);
    begin
      var dialog := ^GtkDialog(gtk_message_dialog_new(nil,
                                                      GtkDialogFlags.GTK_DIALOG_DESTROY_WITH_PARENT,
                                                      GtkMessageType.GTK_MESSAGE_INFO,
                                                      GtkButtonsType.GTK_BUTTONS_OK,
                                                      'Hello World'));
      gtk_dialog_run (dialog);
      gtk_widget_destroy (dialog);
    end;

    class method Main(args: array of String): Int32;
    begin
      gtk_init(@ExternalCalls.nargs, @ExternalCalls.args);

      window := ^GtkWindow(gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL));

      gtk_window_set_title(window, 'RemObjects Oxygene - Island GTK Sample');
      gtk_window_set_default_size(window, 200, 200);

      var button_box := gtk_hbutton_box_new();
      gtk_container_add(window, button_box);

      var button := gtk_button_new_with_label('Hello World');
      g_signal_connect_data(glib.gpointer(button), 'clicked', glib.GVoidFunc(^Void(@clicked)), nil, nil, GConnectFlags(0));
      gtk_container_add(^GtkContainer(button_box), button);
      gtk_widget_show_all(window);

      gtk_main;
    end;

  end;

end.