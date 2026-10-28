import Vcl.Forms

public class Program {
  // Retain the shared Island controller while VCL owns the native form.
  private static var appDelegate: AppDelegate!

  public static func Main() {
    Application.Initialize()
    Application.MainFormOnTaskBar = true
    appDelegate = AppDelegate()
    appDelegate.start()
    Application.Run()
  }
}
