// Positive parity guard: shared state, numeric addition, text joining and missing-value
// validation must behave identically regardless of which native UI hosts the controller.
namespace SharedUI.Shared;

uses System.ComponentModel;

type
  MainWindowController = public partial class
  public

    constructor;
    begin
      Setup;
    end;

  end;

  Program = public static class
  private

    class method check(aCondition: Boolean; aMessage: String);
    begin
      if not aCondition then
        raise new Exception(aMessage);
    end;

    class method checkCase(aController: MainWindowController; aA, aB, aExpected: String);
    begin
      aController.ValueA := aA;
      aController.ValueB := aB;
      aController.CalculateResult(nil);
      check(aController.Result = aExpected, "Unexpected result: " + aController.Result);
    end;

  public

    class method Main: Integer;
    begin
      var lController := new MainWindowController;
      check(lController.Result = "N/A", "Initial state differs");
      var lResultChanges := 0;
      lController.Observe((aSender, aEvent) -> begin
        if aEvent.PropertyName = "Result" then
          inc(lResultChanges);
      end);
      checkCase(lController, nil, "1", "(value required)");
      checkCase(lController, "1", "", "(value required)");
      checkCase(lController, "21", "21", "42");
      checkCase(lController, "-1.5", "2.5", "1");
      checkCase(lController, "Hello, ", "world", "Hello, world");
      checkCase(lController, "1", "x", "1x");
      check(lResultChanges ≥ 5, "Result changes must notify native views");
      System.Console.WriteLine("SharedUI controller checks passed");
      result := 0;
    end;

  end;

end.
