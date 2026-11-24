namespace NewtonObservatory;

type
  ExplorerInputState = enum (Ground, EscapePrefix, SequenceParameters);
  ExplorerAction = public enum (None, Left, Right, Up, Down, ZoomIn, ZoomOut, Reset, Quit);

  TerminalExplorer = public sealed class
  private

    const Escape = #27;
    const FrameOverheadRows = 4; // Controls, two borders, and status.


    class method DecodeAction(aByte: Byte; var aState: ExplorerInputState): ExplorerAction;
    begin
      case Char(aByte) of
        #3, #4: exit ExplorerAction.Quit;
        Escape: begin
          aState := ExplorerInputState.EscapePrefix;
          exit ExplorerAction.None;
        end;
      end;

      case aState of
        ExplorerInputState.EscapePrefix: begin
          aState := ExplorerInputState.Ground;
          if (Char(aByte) = '[') or (Char(aByte) = 'O') then begin
            aState := ExplorerInputState.SequenceParameters;
            exit ExplorerAction.None;
          end;
        end;
        ExplorerInputState.SequenceParameters: begin
          // Allow CSI parameters (such as Shift+Arrow), as well as plain CSI and SS3 arrows.
          if (aByte ≥ $20) and (aByte ≤ $3f) then
            exit ExplorerAction.None;
          aState := ExplorerInputState.Ground;
          case Char(aByte) of
            'A': exit ExplorerAction.Up;
            'B': exit ExplorerAction.Down;
            'C': exit ExplorerAction.Right;
            'D': exit ExplorerAction.Left;
          else
            exit ExplorerAction.None;
          end;
        end;
      end;

      case Char(aByte) of
        'q', 'Q': exit ExplorerAction.Quit;
        'r', 'R': exit ExplorerAction.Reset;
        '+', '=': exit ExplorerAction.ZoomIn;
        '-', '_': exit ExplorerAction.ZoomOut;
      else
        exit ExplorerAction.None;
      end;
    end;

    class method AppendLine(aFrame: not nullable StringBuilder; aRow, aColumns: Integer; aText: not nullable String);
    begin
      aFrame.Append(Escape + $'[{aRow};1H');
      var lLength := length(aText);
      if lLength < aColumns then
        aFrame.Append(Escape + '[K');
      if lLength > aColumns then
        lLength := aColumns;

      // Position each ASCII cell to cancel pending wrap even if a resize clamps the cursor to the right edge.
      for lColumn: Integer := 1 to lLength do begin
        if lColumn > 1 then
          aFrame.Append(Escape + $'[{lColumn}G');
        aFrame.Append(aText[lColumn - 1]);
      end;
      aFrame.Append(#13);
    end;

    class method BuildFrame(aRows, aColumns: Integer; aReal, aImaginary, aZoom: Double): not nullable String;
    begin
      if (aColumns = 0) or (aRows = 0) then
        exit '';

      var lFrame := new StringBuilder;
      if (aColumns < 16) or (aRows < FrameOverheadRows + 3) then begin
        lFrame.Append(Escape + '[2J');
        const SmallWindow = 'Enlarge window; Q quits.';
        const ShortNotice = 'Resize / Q';
        if aColumns ≥ length(SmallWindow) then
          AppendLine(lFrame, 1, aColumns, SmallWindow)
        else
          AppendLine(lFrame, 1, aColumns, ShortNotice);
        exit lFrame.ToString as not nullable;
      end;

      var lWidth := aColumns - 2;
      var lHeight := aRows - FrameOverheadRows;
      var lExposure := Observatory.RenderViewport(lWidth, lHeight, aReal, aImaginary, aZoom);
      var lRuleStart: String := '+';
      var lRule := lRuleStart.PadEnd(lWidth + 1, '-') + '+';
      const Controls = 'Arrows: pan  +/-: zoom  R: reset  Q: quit';
      const Title = 'NEWTON OBSERVATORY / z^3 - 1  |  ';
      if aColumns ≥ length(Title) + length(Controls) then
        AppendLine(lFrame, 1, aColumns, Title + Controls)
      else if aColumns ≥ length(Controls) then
        AppendLine(lFrame, 1, aColumns, Controls)
      else
        AppendLine(lFrame, 1, aColumns, 'Arrows +/- R Q');

      AppendLine(lFrame, 2, aColumns, lRule);
      for each lRow in lExposure.Rows index i do
        AppendLine(lFrame, i + 3, aColumns, '|' + lRow + '|');
      AppendLine(lFrame, aRows - 1, aColumns, lRule);

      var lZoomPercent := Integer(aZoom * 100);
      var lView := $'{lWidth}x{lHeight}  Zoom {lZoomPercent}%';
      var lStatus := lView + $'  |  @E {lExposure.RootCounts[0]}  ON {lExposure.RootCounts[1]}  WS {lExposure.RootCounts[2]}  ? {lExposure.UnresolvedCount}';
      if length(lStatus) > aColumns then
        lStatus := lView;
      if length(lStatus) > aColumns then
        lStatus := $'{lWidth}x{lHeight} {lZoomPercent}%';
      AppendLine(lFrame, aRows, aColumns, lStatus as not nullable);
      result := lFrame.ToString as not nullable;
    end;

  public

    // Wait for a navigation key. Repaint the current view whenever the
    // terminal changes size, including while the keyboard is idle.
    method NextAction(aReal, aImaginary, aZoom: Double): ExplorerAction;
    begin
      var lViewChanged := true;
      var lDrawnRows := -1;
      var lDrawnColumns := -1;
      var lInputState := ExplorerInputState.Ground;
      loop begin
        var lRows, lColumns: Integer;
        if not Terminal.Size(out lRows, out lColumns) then
          raise new RTLException('Could not read the terminal size.');
        if lViewChanged or (lRows ≠ lDrawnRows) or (lColumns ≠ lDrawnColumns) then begin
          var lFrame := BuildFrame(lRows, lColumns, aReal, aImaginary, aZoom);
          // Resizing during a render invalidates its coordinates; don't send the stale frame.
          var lNewRows, lNewColumns: Integer;
          if not Terminal.Size(out lNewRows, out lNewColumns) then
            raise new RTLException('Could not read the terminal size.');
          if (lRows = lNewRows) and (lColumns = lNewColumns) then begin
            Terminal.Send(lFrame);
            lViewChanged := false;
            lDrawnRows := lRows;
            lDrawnColumns := lColumns;
          end
          else begin
            lViewChanged := true;
          end;
        end;

        var lKey := Terminal.ReadKey;
        if lKey = -2 then
          continue;
        if lKey < 0 then
          exit ExplorerAction.Quit;
        var lAction := DecodeAction(Byte(lKey), var lInputState);
        if lAction = ExplorerAction.None then
          continue;
        exit lAction;
      end;
    end;

  public

    class method Run: Int32;
    begin
      if not Terminal.Open then begin
        writeLn('--explore requires interactive terminal input and output.');
        exit 1;
      end;
      try
        try
          Terminal.Send(Escape + '[?1049h' + Escape + '[?25l');
          result := Explorer.Navigate(new TerminalExplorer);
        finally
          try
            Terminal.Send(Escape + '[?25h' + Escape + '[?1049l');
          finally
            Terminal.Close;
          end;
        end;
      except
        on E: Exception do begin
          writeLn(E.Message);
          result := 1;
        end;
      end;
    end;

  end;

end.
