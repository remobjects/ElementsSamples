// Positive parity guard: shared state, numeric addition, text joining and missing-value
// validation must behave identically regardless of which native UI hosts the controller.
namespace SharedUI.Shared;

uses System.ComponentModel;

type
  MainWindowController = public partial class
  public

    constructor;
    begin
      setup;
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
      aController.valueA := aA;
      aController.valueB := aB;
      aController.calculateResult(nil);
      check(aController.result = aExpected, "Unexpected result: " + aController.result);
    end;

  public

    class method Main: Integer;
    begin
      var lController := new MainWindowController;
      check(lController.result = "N/A", "Initial state differs");
      var lResultChanges := 0;
      (lController as INotifyPropertyChanged).PropertyChanged += (aSender, aEvent) -> begin
        if aEvent.PropertyName = "result" then
          inc(lResultChanges);
      end;
      checkCase(lController, nil, "1", "(value required)");
      checkCase(lController, "1", "", "(value required)");
      checkCase(lController, "21", "21", "42");
      checkCase(lController, "-1.5", "2.5", "1");
      checkCase(lController, "Hello, ", "world", "Hello, world");
      checkCase(lController, "1", "x", "1x");
      check(lResultChanges ≥ 5, "Result changes must notify native views");
      writeLn("SharedUI controller checks passed");
      result := 0;
    end;

  end;

end.
