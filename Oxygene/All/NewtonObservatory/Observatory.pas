namespace NewtonObservatory;

type
  SurveyTile = record
  public

    property Name: not nullable String; readonly;
    property Left: Integer; readonly;
    property Top: Integer; readonly;
    property Width: Integer; readonly;
    property Height: Integer; readonly;
    property CenterReal: Double; readonly;
    property CenterImaginary: Double; readonly;
    property Zoom: Double; readonly;

    constructor(aName: not nullable String; aLeft, aTop, aWidth, aHeight: Integer;
                aCenterReal: Double := 0; aCenterImaginary: Double := 0; aZoom: Double := 1);
    begin
      Name := aName;
      Left := aLeft;
      Top := aTop;
      Width := aWidth;
      Height := aHeight;
      CenterReal := aCenterReal;
      CenterImaginary := aCenterImaginary;
      Zoom := aZoom;
    end;

  end;

  Exposure = sealed class
  public

    property Rows: not nullable array of String; readonly;
    property RootCounts: not nullable array of Integer; readonly;
    property UnresolvedCount: Integer;

    constructor(aRowCount: Integer);
    begin
      Rows := new String[aRowCount];
      RootCounts := new Integer[NewtonSolver.RootCount];
    end;

    method Tally(aOrbit: OrbitSample);
    begin
      var lRootIndex := aOrbit.RootIndex;
      if lRootIndex < 0 then
        UnresolvedCount := UnresolvedCount + 1
      else
        RootCounts[lRootIndex] := RootCounts[lRootIndex] + 1;
    end;

  end;

  Observatory = static class
  public

    const PlateWidth = 77;
    const PlateHeight = 25;

  private

    const RealPitch = 0.045;
    const ImaginaryPitch = 0.105;
    const EastRamp = '@#%*+=:.';
    const NorthRamp = 'OXxo/;:, ';
    const SouthRamp = 'WMmvn~-.';

    class method SamplePixel(aTile: SurveyTile; aPalette: not nullable RootPalette;
                             aPlate: not nullable Exposure; aColumn, aRow: Integer): Char;
    begin
      // Unequal pitches compensate for the taller-than-wide console cells.
      var lReal := aTile.CenterReal + (aColumn - PlateWidth div 2) * RealPitch / aTile.Zoom;
      var lImaginary := aTile.CenterImaginary + (PlateHeight div 2 - aRow) * ImaginaryPitch / aTile.Zoom;
      var lOrbit := NewtonSolver.Classify(lReal, lImaginary);
      aPlate.Tally(lOrbit);
      result := aPalette.ShadeFor(lOrbit, aTile.Name, aColumn, aRow);
    end;

    class method RenderRow(aTile: SurveyTile; aPalette: not nullable RootPalette;
                           aPlate: not nullable Exposure; aRow: Integer): not nullable String;
    begin
      var lRow := new StringBuilder;
      for lColumn: Integer := aTile.Left to aTile.Left + aTile.Width - 1 do
        lRow.Append(SamplePixel(aTile, aPalette, aPlate, lColumn, aRow));
      result := lRow.ToString as not nullable;
    end;

    class method RenderTile(aTile: SurveyTile; aPalette: not nullable RootPalette): not nullable Exposure;
    begin
      var lExposure := new Exposure(aTile.Height);
      for lLocalRow: Integer := 0 to aTile.Height - 1 do
        lExposure.Rows[lLocalRow] := RenderRow(aTile, aPalette, lExposure, aTile.Top + lLocalRow);
      result := lExposure;
    end;

    class method PrintPlate(aExposure: not nullable Exposure);
    begin
      var lRuleStart: String := '+';
      var lRule := lRuleStart.PadEnd(PlateWidth + 1, '-') + '+';
      writeLn(lRule);
      writeLn('|  N E W T O N   O B S E R V A T O R Y'.PadEnd(PlateWidth + 1) + '|');
      writeLn('|  PLATE 01  /  BASINS OF z^3 - 1  /  77 x 25 SAMPLES'.PadEnd(PlateWidth + 1) + '|');
      writeLn(lRule);
      for each lRow in aExposure.Rows do
        writeLn('|' + lRow + '|');
      writeLn(lRule);
      writeLn($'  @ EAST   {aExposure.RootCounts[0]}   O NORTH  {aExposure.RootCounts[1]}   '
        + $'W SOUTH  {aExposure.RootCounts[2]}   ? UNRESOLVED  {aExposure.UnresolvedCount}');
      writeLn($'  Each ramp runs fast -> slow convergence (limit: {NewtonSolver.StepLimit} steps).');
    end;

    class method DevelopCalibrationTile;
    begin
      var lCalibrationPalette := new RootPalette('calibration/3-ramp', [EastRamp, NorthRamp, SouthRamp]);
      var lCalibrationTile := new SurveyTile('SOUTH-03', 24, 20, 9, 4);
      RenderTile(lCalibrationTile, lCalibrationPalette);
    end;

    class method RenderWithMasterPalette(aTile: SurveyTile): not nullable Exposure;
    begin
      var lMasterPalette := new RootPalette('master/3-ramp', [EastRamp, NorthRamp, SouthRamp]);
      result := RenderTile(aTile, lMasterPalette);
    end;

  public

    class method RenderViewport(aWidth, aHeight: Integer; aCenterReal, aCenterImaginary, aZoom: Double): not nullable Exposure;
    begin
      var lView := new SurveyTile('EXPLORER', PlateWidth div 2 - aWidth div 2, PlateHeight div 2 - aHeight div 2,
                                 aWidth, aHeight, aCenterReal, aCenterImaginary, aZoom);
      result := RenderWithMasterPalette(lView);
    end;

    class method Run;
    begin
      var lSurvey := new SurveyTile('PLATE-01', 0, 0, PlateWidth, PlateHeight);
      var lPlate := RenderWithMasterPalette(lSurvey);
      PrintPlate(lPlate);
      writeLn('');
      writeLn('  [02 / CALIBRATION] Developing SOUTH-03 with calibration/3-ramp...');
      DevelopCalibrationTile;
    end;

  end;

end.
