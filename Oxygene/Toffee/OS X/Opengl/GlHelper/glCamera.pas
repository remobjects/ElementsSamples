namespace GlHelper;


interface

uses
 rtl;


type
 TRectF = record

 public

    Left, Top, Right, Bottom: Single;
 end;


  { Implements ICamera }
  Camera = public class
  public const
    DEFAULT_YAW = - 90;
    DEFAULT_PITCH = 0;
    DEFAULT_SPEED = 3;
    DEFAULT_SENSITIVITY = 0.25;
    DEFAULT_ZOOM = 45;
    {$REGION 'Internal Declarations'}

  private
    FPosition: TVector3;
    FFront: TVector3;
    FUp: TVector3;
    FRight: TVector3;
    FWorldUp: TVector3;
    FYaw: Single;
    FPitch: Single;
    FMovementSpeed: Single;
    FSensitivity: Single;
    FZoom: Single;

  private
    { Input }
    FLastX: Single;
    FLastY: Single;
    FScreenEdge: TRectF;
    FLookAround: Boolean;
    FKeyW: Boolean;
    FKeyA: Boolean;
    FKeyS: Boolean;
    FKeyD: Boolean;

  protected

    method _GetPosition: TVector3;
    method _SetPosition(const AValue: TVector3);
    method _GetFront: TVector3;
    method _SetFront(const AValue: TVector3);
    method _GetUp: TVector3;
    method _SetUp(const AValue: TVector3);
    method _GetRight: TVector3;
    method _SetRight(const AValue: TVector3);
    method _GetWorldUp: TVector3;
    method _SetWorldUp(const AValue: TVector3);
    method _GetYaw: Single;
    method _SetYaw(const AValue: Single);
    method _GetPitch: Single;
    method _SetPitch(const AValue: Single);
    method _GetMovementSpeed: Single;
    method _SetMovementSpeed(const AValue: Single);
    method _GetSensitivity: Single;
    method _SetSensitivity(const AValue: Single);
    method _GetZoom: Single;
    method _SetZoom(const AValue: Single);

    method GetViewMatrix: TMatrix4;

    method ProcessKeyDown(const AKey: Integer);
    method ProcessKeyUp(const AKey: Integer);
    method ProcessMouseDown(const AX, AY: Single);
    method ProcessMouseMove(const AX, AY: Single);
    method ProcessMouseUp;
    method ProcessMouseWheel(const AWheelDelta: Integer);
    method HandleInput(const ADeltaTimeSec: Single);

  private
    method ProcessMouseMovement(const AXOffset, AYOffset: Single; const AConstrainPitch: Boolean := True);
    method UpdateScreenEdge(const AViewWidth, AViewHeight: Single);
    method UpdateCameraVectors;
    {$ENDREGION 'Internal Declarations'}

  public
    { Creates a camera.

      Parameters:
      AViewWidth: width of the view (screen)
      AViewHeight: width of the view (screen)
      APosition: (optional) position of the camera in 3D space.
      Defaults to world origin (0, 0, 0).
      AUp: (optional) world up vector. Defaults to (0, 1, 0).
      AYaw: (optional) yaw angle in degrees. Defaults to -90.
      APitch: (optional) pitch angle in degrees. Defaults to 0. }
    constructor (const AViewWidth, AViewHeight: Integer; const AYaw: Single := DEFAULT_YAW; const APitch: Single := DEFAULT_PITCH);
    constructor (const AViewWidth, AViewHeight: Integer; const APosition: TVector3; const AYaw: Single := DEFAULT_YAW; const APitch: Single := DEFAULT_PITCH);
    constructor (const AViewWidth, AViewHeight: Integer; const APosition, AUp: TVector3; const AYaw: Single := DEFAULT_YAW; const APitch: Single := DEFAULT_PITCH);

    method ViewResized(const AWidth, AHeight: Integer);

    { Position of the camera in the world.
      Defaults to the world origin (0, 0, 0). }
    property Position: TVector3 read _GetPosition write _SetPosition;

    { Camera vector pointing forward.
      Default to negative Z identity (0, 0, -1) }
    property Front: TVector3 read _GetFront write _SetFront;

    { Camera vector pointing up. }
    property Up: TVector3 read _GetUp write _SetUp;

    { Camera vector pointing right. }
    property Right: TVector3 read _GetRight write _SetRight;

    { World up direction.
      Defaults to Y identity (0, 1, 0) }
    property WorldUp: TVector3 read _GetWorldUp write _SetWorldUp;

    { Yaw angle in degrees.
      Defaults to -90 }
    property Yaw: Single read _GetYaw write _SetYaw;

    { Pitch angle in degrees.
      Defaults to 0 }
    property Pitch: Single read _GetPitch write _SetPitch;

    { Movement speed in units per second.
      Defaults to 3. }
    property MovementSpeed: Single read _GetMovementSpeed write _SetMovementSpeed;

    { Movement sensitivity.
      Defaults to 0.25 }
    property Sensitivity: Single read _GetSensitivity write _SetSensitivity;

    { Zoom angle in degrees (aka Field of View).
      Defaults to 45 }
    property Zoom: Single read _GetZoom write _SetZoom;


     property ViewMatrix : TMatrix4 read GetViewMatrix;


  end;

implementation

{ TCamera }

constructor Camera(const AViewWidth, AViewHeight: Integer; const AYaw: Single := DEFAULT_YAW; const APitch: Single := DEFAULT_PITCH);
begin
  constructor(AViewWidth, AViewHeight, TVector3.Vector3(0, 0, 0), TVector3.Vector3(0, 1, 0), AYaw, APitch);
end;

constructor Camera(const AViewWidth, AViewHeight: Integer; const APosition: TVector3; const AYaw: Single := DEFAULT_YAW; const APitch: Single := DEFAULT_PITCH);
begin
  constructor(AViewWidth, AViewHeight, APosition, TVector3.Vector3(0, 1, 0), AYaw, APitch);
end;

constructor Camera(const AViewWidth, AViewHeight: Integer; const APosition, AUp: TVector3; const AYaw: Single := DEFAULT_YAW; const APitch: Single := DEFAULT_PITCH);
begin
  inherited ();
  FFront := TVector3.Vector3(0, 0, - 1);
  FMovementSpeed := DEFAULT_SPEED;
  FSensitivity := DEFAULT_SENSITIVITY;
  FZoom := DEFAULT_ZOOM;
  FPosition := APosition;
  FWorldUp := AUp;
  FYaw := AYaw;
  FPitch := APitch;
  UpdateScreenEdge(AViewWidth, AViewHeight);
  UpdateCameraVectors;
end;

method Camera.GetViewMatrix: TMatrix4;
begin
  Result.InitLookAtRH(FPosition, FPosition + FFront, FUp);
end;

method Camera.HandleInput(const ADeltaTimeSec: Single);
var
  Velocity: Single;
begin
  Velocity := FMovementSpeed * ADeltaTimeSec;
  if (FKeyW) then
    FPosition := FPosition + (FFront * Velocity);

  if (FKeyS) then
    FPosition := FPosition - (FFront * Velocity);

  if (FKeyA) then
    FPosition := FPosition - (FRight * Velocity);

  if (FKeyD) then
    FPosition := FPosition + (FRight * Velocity);
end;

method Camera.ProcessKeyDown(const AKey: Integer);
begin
//  if (AKey = vkW) or (AKey = vkUp) then
//    FKeyW := True;
//
//  if (AKey = vkA) or (AKey = vkLeft) then
//    FKeyA := True;
//
//  if (AKey = vkS) or (AKey = vkDown) then
//    FKeyS := True;
//
//  if (AKey = vkD) or (AKey = vkRight) then
//    FKeyD := True;
end;

method Camera.ProcessKeyUp(const AKey: Integer);
begin
//  if (AKey = vkW) or (AKey = vkUp) then
//    FKeyW := False;
//
//  if (AKey = vkA) or (AKey = vkLeft) then
//    FKeyA := False;
//
//  if (AKey = vkS) or (AKey = vkDown) then
//    FKeyS := False;
//
//  if (AKey = vkD) or (AKey = vkRight) then
//    FKeyD := False;
end;

method Camera.ProcessMouseDown(const AX, AY: Single);
begin
  { Check if mouse/finger is pressed near the edge of the screen.
    If so, simulate a WASD key event. This way, we can move the camera around
    on mobile devices that don't have a keyboard. }
  FLookAround := True;

  if (AX < FScreenEdge.Left) then
    begin
      FKeyA := True;
      FLookAround := False;
    end
  else if (AX > FScreenEdge.Right) then
    begin
      FKeyD := True;
      FLookAround := False;
    end;

  if (AY < FScreenEdge.Top) then
    begin
      FKeyW := True;
      FLookAround := False;
    end
  else if (AY > FScreenEdge.Bottom) then
    begin
      FKeyS := True;
      FLookAround := False;
    end;

  if (FLookAround) then
    begin
      { Mouse/finger was pressed in center area of screen.
        This is used for Look Around mode. }
      FLastX := AX;
      FLastY := AY;
    end;
end;

method Camera.ProcessMouseMove(const AX, AY: Single);
var
  XOffset, YOffset: Single;
begin
  if (FLookAround) then
    begin
      XOffset := AX - FLastX;
      YOffset := FLastY - AY; { Reversed since y-coordinates go from bottom to left }

      FLastX := AX;
      FLastY := AY;

      ProcessMouseMovement(XOffset, YOffset);
    end;
end;

method Camera.ProcessMouseMovement(const AXOffset, AYOffset: Single; const AConstrainPitch: Boolean);
var
  XOff, YOff: Single;
begin
  XOff := AXOffset * FSensitivity;
  YOff := AYOffset * FSensitivity;

  FYaw := FYaw + XOff;
  FPitch := FPitch + YOff;

  if (AConstrainPitch) then
    { Make sure that when pitch is out of bounds, screen doesn't get flipped }
    FPitch := EnsureRange(FPitch, - 89, 89);

  UpdateCameraVectors;
end;

method Camera.ProcessMouseUp;
begin
  if (not FLookAround) then
    begin
      { Mouse/finger was pressed near edge of screen to emulate WASD keys.
        "Release" those keys now. }
      FKeyW := False;
      FKeyA := False;
      FKeyS := False;
      FKeyD := False;
    end;
  FLookAround := False;
end;

method Camera.ProcessMouseWheel(const AWheelDelta: Integer);
begin
  FZoom := EnsureRange(FZoom - AWheelDelta, 1, 45);
end;



method Camera.UpdateCameraVectors;
{ Calculates the front vector from the Camera's (updated) Euler Angles }
var
  lFront: TVector3;
  SinYaw, CosYaw, SinPitch, CosPitch: Single;
begin
  { Calculate the new Front vector }
  SinCos(Radians(FYaw), out SinYaw, out CosYaw);
  SinCos(Radians(FPitch), out SinPitch, out CosPitch);

  lFront.X := CosYaw * CosPitch;
  lFront.Y := SinPitch;
  lFront.Z := SinYaw * CosPitch;

  FFront := lFront.NormalizeFast;

  { Also re-calculate the Right and Up vector.
    Normalize the vectors, because their length gets closer to 0 the more you
    look up or down which results in slower movement. }
  FRight := FFront.Cross(FWorldUp).NormalizeFast;
  FUp := FRight.Cross(FFront).NormalizeFast;
end;

method Camera.UpdateScreenEdge(const AViewWidth, AViewHeight: Single);
const
  EDGE_THRESHOLD = 0.15; // 15%
var
  ViewWidth, ViewHeight: Single;
begin
  { Set the screen edge thresholds based on the dimensions of the screen/view.
    These threshold are used to emulate WASD keys when a mouse/finger is
    pressed near the edge of the screen. }
  ViewWidth := AViewWidth ;// TPlatform.ScreenScale;
  ViewHeight := AViewHeight; //  TPlatform.ScreenScale;
  FScreenEdge.Left := EDGE_THRESHOLD * ViewWidth;
  FScreenEdge.Top := EDGE_THRESHOLD * ViewHeight;
  FScreenEdge.Right := (1 - EDGE_THRESHOLD) * ViewWidth;
  FScreenEdge.Bottom := (1 - EDGE_THRESHOLD) * ViewHeight;
end;

method Camera.ViewResized(const AWidth, AHeight: Integer);
begin
  UpdateScreenEdge(AWidth, AHeight);
end;

method Camera._GetFront: TVector3;
begin
  Result := FFront;
end;

method Camera._GetMovementSpeed: Single;
begin
  Result := FMovementSpeed;
end;

method Camera._GetPitch: Single;
begin
  Result := FPitch;
end;

method Camera._GetPosition: TVector3;
begin
  Result := FPosition;
end;

method Camera._GetRight: TVector3;
begin
  Result := FRight;
end;

method Camera._GetSensitivity: Single;
begin
  Result := FSensitivity;
end;

method Camera._GetUp: TVector3;
begin
  Result := FUp;
end;

method Camera._GetWorldUp: TVector3;
begin
  Result := FWorldUp;
end;

method Camera._GetYaw: Single;
begin
  Result := FYaw;
end;

method Camera._GetZoom: Single;
begin
  Result := FZoom;
end;

method Camera._SetFront(const AValue: TVector3);
begin
  FFront := AValue;
end;

method Camera._SetMovementSpeed(const AValue: Single);
begin
  FMovementSpeed := AValue;
end;

method Camera._SetPitch(const AValue: Single);
begin
  FPitch := AValue;
end;

method Camera._SetPosition(const AValue: TVector3);
begin
  FPosition := AValue;
end;

method Camera._SetRight(const AValue: TVector3);
begin
  FRight := AValue;
end;

method Camera._SetSensitivity(const AValue: Single);
begin
  FSensitivity := AValue;
end;

method Camera._SetUp(const AValue: TVector3);
begin
  FUp := AValue;
end;

method Camera._SetWorldUp(const AValue: TVector3);
begin
  FWorldUp := AValue;
end;

method Camera._SetYaw(const AValue: Single);
begin
  FYaw := AValue;
end;

method Camera._SetZoom(const AValue: Single);
begin
  FZoom := AValue;
end;

end.