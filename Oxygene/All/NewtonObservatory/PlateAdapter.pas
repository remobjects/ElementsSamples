namespace NewtonObservatory;

type
  Explorer = static class
  public

    class method Navigate(aScreen: TerminalExplorer): Int32;
    begin
      exit NewtonObservatory.Navigate(aScreen);
    end;

  end;

  Observatory = static class
  public

    class method RenderViewport(aWidth, aHeight: Integer; aReal, aImaginary, aZoom: Double): Exposure;
    begin
      exit RenderRegion(aWidth, aHeight, -(aWidth div 2), -(aHeight div 2), aReal, aImaginary, aZoom);
    end;

    class method Run;
    begin
      PrintSurvey;
    end;

  end;

end.
