namespace MetalExample;

uses
  rtl,
  RemObjects.Elements.RTL;

  const
   { Default tolerance for comparing small floating-point values. }
    SINGLE_TOLERANCE = 0.000001;
    EPSILON: Single = 1E-40;


type MetalMath = class
public
  class method Sqrt(const A: Single): Single;
  begin
    Result := Math.Sqrt(A);
  end;

  class method InverseSqrt(const A: Single): Single;
  begin
    Result := 1 / Sqrt(A)
  end;

  class method ArcTan2(const Y, X: Single): Single;
  begin
    Result := Math.Atan2(Y, X);
  end;

  class method Abs(const A: Single): Single;
  begin
    Result := Math.Abs(A);
  end;

  class method Mix(const A, B, T: Single): Single;
  begin
    Result := A + (T * (B - A)); // Faster
  end;

  class method Mix(const A, B: TVector2; const T: Single): TVector2;
  begin
    Result.Init(Mix(A.X, B.X, T), Mix(A.Y, B.Y, T));
  end;

  class method Mix(const A, B: TVector3; const T: Single): TVector3;
  begin
    Result.Init(Mix(A.X, B.X, T), Mix(A.Y, B.Y, T), Mix(A.Z, B.Z, T));
  end;

  class method Mix(const A, B, T: TVector3): TVector3;
  begin
    Result.Init(Mix(A.X, B.X, T.X), Mix(A.Y, B.Y, T.Y), Mix(A.Z, B.Z, T.Z));
  end;

  class method Mix(const A, B: TVector4; const T: Single): TVector4;
  begin
    Result.Init(Mix(A.X, B.X, T), Mix(A.Y, B.Y, T), Mix(A.Z, B.Z, T), Mix(A.W, B.W, T));
  end;

  class method Mix(const A, B, T: TVector4): TVector4;
  begin
    Result.Init(Mix(A.X, B.X, T.X), Mix(A.Y, B.Y, T.Y), Mix(A.Z, B.Z, T.Z), Mix(A.W, B.W, T.W));
  end;


  class method SinCos(const ARadians: Single; out ASin, ACos: Single);
  begin
    ASin := Math.Sin(ARadians);
    ACos := Math.Cos(ARadians);

  end;

  class method SinCos(const ARadians: TVector4; out ASin, ACos: TVector4);
  begin
    SinCos(ARadians.X, out ASin.X, out ACos.X);
    SinCos(ARadians.Y, out ASin.Y, out ACos.Y);
    SinCos(ARadians.Z, out ASin.Z, out ACos.Z);
    SinCos(ARadians.W, out ASin.W, out ACos.W);
  end;

  class  method Radians(const ADegrees: Single): Single;
  begin
    Result := ADegrees * (Consts.PI / 180);
  end;

  class method EnsureRange(const A, AMin, AMax: Single): Single;
  begin
    Result := A;

    if Result < AMin then
      Result := AMin;
    if Result > AMax then
      Result := AMax;
  end;
end;
end.