namespace NewtonObservatory
{
  sealed class RootPalette
  {
    private String[] fRamps;

    public String Channel { get; }

    public int Size
    {
      get
      {
        return length(fRamps);
      }
    }

    public RootPalette(String aChannel, String[] aRamps)
    {
      Channel = aChannel;
      fRamps = aRamps;
    }

    public char ShadeFor(OrbitSample aOrbit, String aTileLabel, int aColumn, int aRow)
    {
      var lRootIndex = aOrbit.RootIndex;
      if (lRootIndex < 0)
        return '?';
      var lPaletteSize = Size;
      if (lRootIndex >= lPaletteSize)
      {
        var lReason = $"Palette \"{Channel}\" has {lPaletteSize} ramps; root index {lRootIndex} has no ramp. " + $"Tile {aTileLabel}, pixel ({aColumn}, {aRow}), converged in {aOrbit.Steps} steps.";
        throw new RemObjects.Elements.RTL.RTLException(lReason);
      }
      var lRamp = fRamps[lRootIndex];
      var lShadeIndex = aOrbit.Steps / 2;
      if (lShadeIndex >= lRamp.Length)
        lShadeIndex = lRamp.Length - 1;
      return lRamp[lShadeIndex];
    }
  }

}
