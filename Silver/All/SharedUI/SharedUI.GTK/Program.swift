public class Program {
  private static var appDelegate: AppDelegate!
  public static var application: Gtk.Application!

  public static func Main() -> Int32 {
    application = Gtk.Application.New("com.remobjects.samples.sharedui", Gio.ApplicationFlags.FlagsNone)
    application.OnActivate += { sender, e in
      if appDelegate == nil {
        appDelegate = AppDelegate()
        appDelegate.start()
      } else {
        appDelegate.mainWindowController.showWindow(nil)
      }
    }
    return application.RunWithSynchronizationContext(System.Array.Empty<System.String>())
  }
}
