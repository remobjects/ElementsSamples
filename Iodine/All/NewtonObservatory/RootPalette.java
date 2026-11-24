package NewtonObservatory;

final class RootPalette
{
  private String[] fRamps;

  public String Channel { __get; }

  public int Size
  {
    __get
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
      var lReason = "Palette \"" + Channel + "\" has " + RemObjects.Elements.RTL.Convert.ToString(lPaletteSize) + " ramps; root index " + RemObjects.Elements.RTL.Convert.ToString(lRootIndex) + " has no ramp. " + "Tile " + aTileLabel + ", pixel (" + RemObjects.Elements.RTL.Convert.ToString(aColumn) + ", " + RemObjects.Elements.RTL.Convert.ToString(aRow) + "), converged in " + RemObjects.Elements.RTL.Convert.ToString(aOrbit.Steps) + " steps.";
      throw new RemObjects.Elements.RTL.RTLException(lReason);
    }
    var lRamp = fRamps[lRootIndex];
    var lShadeIndex = aOrbit.Steps / 2;
    if (lShadeIndex >= lRamp.Length)
      lShadeIndex = lRamp.Length - 1;
    return lRamp[lShadeIndex];
  }
}
