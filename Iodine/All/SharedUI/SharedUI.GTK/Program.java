package SharedUI.Shared;
  public class Program
  {
    private static AppDelegate appDelegate;
    public static Gtk.Application application { __get; private __set; }

    public static int Main(System.String[] args)
    {
      application = Gtk.Application.New("com.remobjects.samples.sharedui", Gio.ApplicationFlags.FlagsNone);
      application.OnActivate += (sender, e) -> {
        if (appDelegate == null) {
          appDelegate = new AppDelegate();
          appDelegate.start();
        } else {
          appDelegate.mainWindowController.showWindow(null);
        }
      };
      return application.RunWithSynchronizationContext(args);
    }
  }
