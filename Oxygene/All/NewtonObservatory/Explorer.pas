namespace NewtonObservatory;

type
  Explorer = static class
  public

    class method Navigate(aScreen: TerminalExplorer): Int32;
    begin
      var x := 0.0;
      var y := 0.0;
      var zoom := 1.0;
      loop begin
        case aScreen.NextAction(x, y, zoom) of
          ExplorerAction.Left: x := x - 0.36 / zoom;
          ExplorerAction.Right: x := x + 0.36 / zoom;
          ExplorerAction.Up: y := y + 0.42 / zoom;
          ExplorerAction.Down: y := y - 0.42 / zoom;
          ExplorerAction.ZoomIn: if zoom < 100 then
            zoom := zoom * 1.25;
          ExplorerAction.ZoomOut: if zoom > 0.125 then
            zoom := zoom / 1.25;
          ExplorerAction.Reset: begin
            x := 0;
            y := 0;
            zoom := 1;
          end;
          ExplorerAction.Quit: exit 0;
        end;
      end;
    end;

  end;

end.
