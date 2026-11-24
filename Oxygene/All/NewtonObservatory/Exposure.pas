namespace NewtonObservatory;

type
  Exposure = public sealed class
  public

    property Rows: not nullable array of String; readonly;
    property RootCounts: not nullable array of Integer; readonly;
    property UnresolvedCount: Integer;

    constructor(aRowCount: Integer);
    begin
      Rows := new String[aRowCount];
      RootCounts := new Integer[3];
    end;

    method Mark(aRoot: Integer);
    begin
      if aRoot < 0 then
        inc(UnresolvedCount)
      else
        inc(RootCounts[aRoot]);
    end;

  end;

end.
