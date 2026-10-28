namespace TicTacToe;

uses UIKit;

type
  [IBObject]
  AppDelegate = public class(IUIApplicationDelegate)
  public
    method application(aApplication: UIApplication) didFinishLaunchingWithOptions(aOptions: NSDictionary): Boolean;
    begin
      // Process initialization belongs here; each SceneDelegate owns its window.
      result := true;
    end;

  end;

end.
