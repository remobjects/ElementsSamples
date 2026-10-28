package SharedUI.Shared;
import Vcl.Forms.*;

  public class Program
  {
    // Retain the Island controller for the lifetime of the Delphi-owned form.
    private static AppDelegate appDelegate;

    public static void Main()
    {
      Application.Initialize();
      Application.MainFormOnTaskBar = true;
      appDelegate = new AppDelegate();
      appDelegate.start();
      Application.Run();
    }
  }
