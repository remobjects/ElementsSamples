namespace NewtonObservatory;

type
  RootPalette = sealed class
  private

    field fRamps: not nullable array of String;

  public

    property Channel: not nullable String; readonly;
    property Size: Integer read length(fRamps);

    constructor(aChannel: not nullable String; aRamps: not nullable array of String);
    begin
      Channel := aChannel;
      fRamps := aRamps;
    end;

    method ShadeFor(aOrbit: OrbitSample; aTileLabel: not nullable String; aColumn, aRow: Integer): Char;
    begin
      var lRootIndex := aOrbit.RootIndex;
      if lRootIndex < 0 then
        exit '?';

      var lPaletteSize := Size;
      if lRootIndex ≥ lPaletteSize then begin
        var lReason := $'Palette "{Channel}" has {lPaletteSize} ramps; root index {lRootIndex} has no ramp. '
          + $'Tile {aTileLabel}, pixel ({aColumn}, {aRow}), converged in {aOrbit.Steps} steps.';
        raise new RemObjects.Elements.RTL.RTLException(lReason);
      end;

      var lRamp := fRamps[lRootIndex];
      var lShadeIndex := aOrbit.Steps div 2;
      if lShadeIndex ≥ length(lRamp) then
        lShadeIndex := length(lRamp) - 1;
      result := lRamp[lShadeIndex];
    end;

  end;

end.
