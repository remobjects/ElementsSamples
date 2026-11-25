namespace NewtonObservatory;

type
  ExplorerAction = public enum (None, Left, Right, Up, Down, ZoomIn, ZoomOut, Reset, Quit);

  TerminalExplorer = public sealed class
  private

    const FrameOverheadRows: Integer = 4; // Controls, two borders, and status.

    class method DecodeAction(aKey: Integer): ExplorerAction;
    begin
      case aKey of
        Terminal.UpArrow: exit ExplorerAction.Up;
        Terminal.DownArrow: exit ExplorerAction.Down;
        Terminal.LeftArrow: exit ExplorerAction.Left;
        Terminal.RightArrow: exit ExplorerAction.Right;
        Terminal.EndOfInput, 3, 4, ord('q'), ord('Q'): exit ExplorerAction.Quit;
        ord('r'), ord('R'): exit ExplorerAction.Reset;
        ord('+'), ord('='): exit ExplorerAction.ZoomIn;
        ord('-'), ord('_'): exit ExplorerAction.ZoomOut;
      else
        exit ExplorerAction.None;
      end;
    end;

    class method Draw(aFrame: not nullable TerminalFrame; aReal, aImaginary, aZoom: Double);
    begin
      var lRows := aFrame.Rows;
      var lColumns := aFrame.Columns;
      if (lColumns = 0) or (lRows = 0) then
        exit;

      if (lColumns < 16) or (lRows < FrameOverheadRows + 3) then begin
        aFrame.Clear;
        const SmallWindow: String = 'Enlarge window; Q quits.';
        const ShortNotice: String = 'Resize / Q';
        if lColumns ≥ length(SmallWindow) then
          aFrame.WriteLine(1, SmallWindow)
        else
          aFrame.WriteLine(1, ShortNotice);
        exit;
      end;

      var lWidth := lColumns - 2;
      var lHeight := lRows - FrameOverheadRows;
      var lExposure := Observatory.RenderViewport(lWidth, lHeight, aReal, aImaginary, aZoom);
      var lRuleStart: String := '+';
      var lRule := lRuleStart.PadEnd(lWidth + 1, '-') + '+';
      const Controls: String = 'Arrows: pan  +/-: zoom  R: reset  Q: quit';
      const Title: String = 'NEWTON OBSERVATORY / z^3 - 1  |  ';
      if lColumns ≥ length(Title) + length(Controls) then
        aFrame.WriteLine(1, Title + Controls)
      else if lColumns ≥ length(Controls) then
        aFrame.WriteLine(1, Controls)
      else
        aFrame.WriteLine(1, 'Arrows +/- R Q');

      aFrame.WriteLine(2, lRule);
      for each lRow in lExposure.Rows index i do
        aFrame.WriteLine(i + 3, '|' + lRow + '|');
      aFrame.WriteLine(lRows - 1, lRule);

      var lZoomPercent := Integer(aZoom * 100);
      var lView := $'{lWidth}x{lHeight}  Zoom {lZoomPercent}%';
      var lStatus := lView + $'  |  @E {lExposure.RootCounts[0]}  ON {lExposure.RootCounts[1]}  WS {lExposure.RootCounts[2]}  ? {lExposure.UnresolvedCount}';
      if length(lStatus) > lColumns then
        lStatus := lView;
      if length(lStatus) > lColumns then
        lStatus := $'{lWidth}x{lHeight} {lZoomPercent}%';
      aFrame.WriteLine(lRows, lStatus as not nullable);
    end;

  public

    // Wait for a navigation key. Repaint the current view whenever the
    // terminal changes size, including while the keyboard is idle.
    method NextAction(aReal, aImaginary, aZoom: Double): ExplorerAction;
    begin
      loop begin
        var lAction := DecodeAction(Terminal.ReadKey(aFrame -> Draw(aFrame, aReal, aImaginary, aZoom)));
        if lAction ≠ ExplorerAction.None then exit lAction;
      end;
    end;

    class method Run: Int32;
    begin
      try
{$IF COOPER}
        if JvmConsole.Run() then exit 0;
{$ELSE}
        if Terminal.RunFullScreen(-> begin Explorer.Navigate(new TerminalExplorer); end) then exit 0;
{$ENDIF}
        writeLn('--explore requires interactive terminal input and output.');
      except
        on E: Exception do writeLn(E.Message);
      end;
      exit 1;
    end;
  end;
end.
