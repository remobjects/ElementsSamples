namespace SharedUI.Shared;

type
  MainWindowController = public partial class
  public

    //
    // Add Shared code here
    //

    [Notify] property valueA: String;
    [Notify] property valueB: String;
    [Notify] property &result: String read private write;

    [IBAction]
    method calculateResult(aSender: id);
    begin
      if (length(valueA) = 0) or (length(valueB) = 0) then begin
        &result := '(value required)';
      end
      else begin
        var a := Convert.TryToDoubleInvariant(valueA);
        var b := Convert.TryToDoubleInvariant(valueB);
        if assigned(a) and assigned(b) then begin
          &result := Convert.ToString(a + b);
        end
        else begin
          &result := valueA + valueB;
        end;
      end;
    end;

  private

    method setup;
    begin
      //
      //  Do any shared initilaization, here
      //
      //
    end;

  end;

end.