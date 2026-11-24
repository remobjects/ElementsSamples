Namespace Global.NewtonObservatory

  NotInheritable Class RootPalette

    Private fRamps As String()

    Public ReadOnly Property Channel As String

    Public ReadOnly Property Size As Integer
      Get
        Return length(fRamps)
      End Get
    End Property

    Public Sub New(aChannel As String, aRamps As String())
      Channel = aChannel
      fRamps = aRamps
    End Sub

    Public Function ShadeFor(aOrbit As OrbitSample, aTileLabel As String, aColumn As Integer, aRow As Integer) As Char
      Dim lRootIndex = aOrbit.RootIndex
      If lRootIndex < 0 Then
        Return "?"c
      End If
      Dim lPaletteSize = Size
      If lRootIndex >= lPaletteSize Then
        Dim lReason = $"Palette ""{Channel}"" has {lPaletteSize} ramps; root index {lRootIndex} has no ramp. " + $"Tile {aTileLabel}, pixel ({aColumn}, {aRow}), converged in {aOrbit.Steps} steps."
        Throw New RemObjects.Elements.RTL.RTLException(lReason)
      End If
      Dim lRamp = fRamps(lRootIndex)
      Dim lShadeIndex = aOrbit.Steps \ 2
      If lShadeIndex >= lRamp.Length Then
        lShadeIndex = lRamp.Length - 1
      End If
      Return lRamp(lShadeIndex)
    End Function

  End Class

End Namespace
