namespace TicTacToe;

interface

uses
  UIKit;

type TGridInfoArray=array[0..2, 0..2] of NSString;

type
  [IBObject]
  Board = public class(UIControl)
  private
    fGridOffset: CGPoint;
    fStatusLabel: UILabel;
    
    fTentativeView: UIImageView;
    fTentativeGridIndex: GridIndex;
    fTentativeInfo: String;
    fTentativeOk: Boolean;

    fTurnCount: Int32;
    fGridImages: NSMutableArray<UIImageView> := new NSMutableArray<UIImageView>;
    fGridInfo: array[0..2, 0..2] of NSString; 

    const 
      X1 = 92;
      X2 = 217;
      Y1 = 93;
      Y2 = 200;

    method gridIndexForPoint(aPoint: CGPoint): GridIndex;
    method drawingOffsetForGridIndex(aGridIndex: GridIndex): CGPoint;
    method playerAtCoordinates(x: Int32; y: Int32): String;

    method addMarkerNotAnimated(aX: Int32; aY: Int32; aPlayerAndVersion: String);

    method nextPlayerImageForTurn(aPlayer: String): String;
    method playerImage(aPlayerInfo: String): UIImageView;
    method getGridInfo(aX: Int32; aY: Int32): String;

  public
    method initWithFrame(aFrame: CGRect): id; override;

    property &delegate: weak IBoardDelegate;
    property player: String := 'X'; 
    property acceptingTurn: Boolean;
    property GridInfo[x,y: Int32]: String read getGridInfo;

    method markGrid(aX: Int32; aY: Int32; aPlayer: String); 
    method makeComputerMove(aPlayer: String);
    method isFull: Boolean; 
    method isEmpty: Boolean;
    method isGameOver: Boolean;
    method markWinner: String; 

    method clear(aCompletion: block := nil; aClearAnimated: Boolean);

    method saveToNSDictionary(aDictionary: NSMutableDictionary; aXPlayerID: String; aOPlayerID: String);
    method loadFromNSDictionary(aDictionary: NSDictionary; aXPlayerID: String; aOPlayerID: String);

    method setStatus(aStatus: String);


    method beginTrackingWithTouch(aTouch: not nullable UITouch) withEvent(aEvent: UIEvent): Boolean; override;
    method continueTrackingWithTouch(aTouch: not nullable UITouch) withEvent(aEvent: UIEvent): Boolean; override;
    method endTrackingWithTouch(aTouch: UITouch) withEvent(aEvent: UIEvent); override;
  end;

  IBoardDelegate = public interface(INSObject)
    method board(aBoard: Board) playerWillSelectGridIndex(aGridIndex: GridIndex): Boolean;
    method board(aBoard: Board) playerDidSelectGridIndex(aGridIndex: GridIndex);
  end;

  GridIndex = public record
  public
    X, Y: Integer;
  end;

implementation

method Board.initWithFrame(aFrame: CGRect): id;
begin
  self := inherited initWithFrame(aFrame);
  if assigned(self) then begin

    addSubview(new UIImageView withImage(UIImage.imageNamed('Paper')));

    var lGridImage := UIImage.imageNamed('Grid');

    var fGrid := new UIImageView withImage(lGridImage);
    fGrid.frame := CGRectMake( (frame.size.width-lGridImage.size.width)/2, 
                               (frame.size.width-lGridImage.size.width)*2,
                               lGridImage.size.width,
                               lGridImage.size.height);
    fGridOffset := fGrid.frame.origin;
    addSubview(fGrid);

    var lFont := UIFont.fontWithName('Bradley Hand') size(32);

    var f := frame;
    f.origin.y := fGrid.frame.origin.y + fGrid.frame.size.height + 10; // 30 on 4"?
    f.size.height := 'Xy'.sizeWithFont(lFont).height;

    fStatusLabel := new UILabel withFrame(f);
    fStatusLabel.opaque := false;
    fStatusLabel.backgroundColor := UIColor.colorWithRed(0) green(0) blue(0) alpha(0); 
    fStatusLabel.font := lFont; 
    fStatusLabel.textAlignment := NSTextAlignment.NSTextAlignmentCenter;
    fStatusLabel.lineBreakMode := NSLineBreakMode.NSLineBreakByTruncatingMiddle;
    addSubview(fStatusLabel);

  end;
  result := self;
end;

method Board.nextPlayerImageForTurn(aPlayer: String): String;
begin
  var lTurnSuffix := (fTurnCount/2+1).stringValue;
  inc(fTurnCount);

  result := aPlayer+lTurnSuffix;
end;

method Board.playerImage(aPlayerInfo: String): UIImageView;
begin
  result := new UIImageView withImage(UIImage.imageNamed(aPlayerInfo));
end;

method Board.addMarkerNotAnimated(aX: Int32; aY: Int32; aPlayerAndVersion: String); 
begin
  var lNewView := playerImage(aPlayerAndVersion);
  var g: GridIndex; g.X := aX; g.Y := aY;
  var f: CGRect;
  f.origin := drawingOffsetForGridIndex(g);
  f.size := lNewView.image.size;
  lNewView.frame := f;
  addSubview(lNewView);
  fGridImages.addObject(lNewView);
end;

method Board.markGrid(aX: Int32; aY: Int32; aPlayer: String); 
require
  0 ≤ aX ≤ 2;
  0 ≤ aY ≤ 2;
  fGridInfo[aX, aY] = nil;
  aPlayer in ['X','O'];
begin

  var lInfo  := nextPlayerImageForTurn(aPlayer);
  fGridInfo[aX, aY] := lInfo;
  var lNewView := playerImage(lInfo);
  lNewView.alpha := 0;

  var f: CGRect;
  
  var g: GridIndex; g.X := aX; g.Y := aY;
  f.origin := drawingOffsetForGridIndex(g);
  f.size := lNewView.image.size;
  lNewView.frame := f;
  addSubview(lNewView);
  fGridImages.addObject(lNewView);

  UIView.animateWithDuration(0.5) 
          animations(method begin
              lNewView.alpha := 1;
            end);
end;

method Board.beginTrackingWithTouch(aTouch: not nullable UITouch) withEvent(aEvent: UIEvent): Boolean;
begin
  if not acceptingTurn then exit false;
  
  continueTrackingWithTouch(aTouch) withEvent(aEvent);
  result := true;
end;

method Board.continueTrackingWithTouch(aTouch: not nullable UITouch) withEvent(aEvent: UIEvent): Boolean;
begin

  var lFirst: Boolean;

  if not assigned(fTentativeView) then begin
    fTentativeInfo := nextPlayerImageForTurn(player);
    fTentativeView := playerImage(fTentativeInfo);
    fTentativeView.alpha := 0;
    addSubview(fTentativeView);
    lFirst := true;
  end;

  var lTouchLocation := aTouch.locationInView(self);
  fTentativeGridIndex := gridIndexForPoint(lTouchLocation);
  fTentativeOk := fGridInfo[fTentativeGridIndex.X, fTentativeGridIndex.Y] = nil;

  var f: CGRect;
  f.origin := drawingOffsetForGridIndex(fTentativeGridIndex);
  f.size := fTentativeView.image.size;

  if lFirst then
    fTentativeView.frame := f;

  UIView.animateWithDuration(0.1) 
         animations(method begin
                          
             fTentativeView.frame := f;

             if fTentativeOk then
               fTentativeView.alpha := 0.8
            else
               fTentativeView.alpha := 0.0; 
                          
           end);
    
  result := true;
end;

method Board.endTrackingWithTouch(aTouch: UITouch) withEvent(aEvent: UIEvent);
begin
  if assigned(fTentativeView) then begin

    continueTrackingWithTouch(aTouch) withEvent(aEvent);

    if fTentativeOk then begin

      fGridImages.addObject(fTentativeView);
      fGridInfo[fTentativeGridIndex.X, fTentativeGridIndex.Y] := fTentativeInfo;
      if assigned(&delegate) then
        &delegate.board(self) playerDidSelectGridIndex(fTentativeGridIndex);

      var lTempView := fTentativeView;
      UIView.animateWithDuration(0.1) 
             animations(method begin
                 lTempView.alpha := 1.0;
               end);

    end 
    else begin

      var lTempView := fTentativeView;
      UIView.animateWithDuration(0.1) 
             animations(method begin
                 fTentativeView.alpha := 0;
               end) 
             completion(method begin
                 lTempView.removeFromSuperview();
               end);

    end;

  end;
  fTentativeView := nil;
end;

method Board.gridIndexForPoint(aPoint: CGPoint): GridIndex;
begin
  aPoint.x := aPoint.x-fGridOffset.x;
  aPoint.y := aPoint.y-fGridOffset.y;
  // := new GridIndex;
  result.X := if aPoint.x < X1 then 0 else if aPoint.x < X2 then 1 else 2;
  result.Y := if aPoint.y < Y1 then 0 else if aPoint.y < Y2 then 1 else 2;
end;

method Board.drawingOffsetForGridIndex(aGridIndex: GridIndex): CGPoint;
begin
  {result.x := case aGridIndex.X of
                0: 10;
                1: X1+10;
                2: X2+10;
              end;
  result.y := case aGridIndex.Y of
                0: 10;
                1: Y1+10;
                2: Y2+10;
              end;}
  result := CGPointMake(10+110*aGridIndex.X+fGridOffset.x, 10+100*aGridIndex.Y+fGridOffset.y);
end;

method Board.makeComputerMove(aPlayer: String);
begin
  var aMove:= new ComputerPlayer();
  aMove.makeBestMove(aPlayer, self);
end;

method Board.isFull: Boolean;
begin
  for x: Int32 := 0 to 2 do 
    for y: Int32 := 0 to 2 do
      if not assigned(fGridInfo[x,y]) then begin
        exit false;
      end;
  result := true;
end;

method Board.isEmpty: Boolean;
begin
  for x: Int32 := 0 to 2 do 
    for y: Int32 := 0 to 2 do
      if assigned(fGridInfo[x,y]) then begin
        exit false;
      end;
  result := true;
end;

method Board.isGameOver: Boolean;
begin
  result := isFull or assigned(markWinner); // ToDo: refactor once markWinner does more than just CALCULATE the winner
end;

method Board.playerAtCoordinates(x, y: Int32): String;
begin
  result := fGridInfo[x,y]:substringToIndex(1); 
end;


method Board.markWinner: String;
begin
  // won't win any nobel prizes for achievements in the computer sciences, but gets the job done:

  // horizontals
  for x: Int32 := 0 to 2 do begin
    if assigned(playerAtCoordinates(x, 0)) and 
      (playerAtCoordinates(x, 0) = playerAtCoordinates(x, 1)) and
      (playerAtCoordinates(x, 0) = playerAtCoordinates(x, 2)) then exit playerAtCoordinates(x, 0);
  end;
  // verticals
  for y: Int32 := 0 to 2 do begin
    if assigned(playerAtCoordinates(0, y)) and 
      (playerAtCoordinates(0, y) = playerAtCoordinates(1, y)) and
      (playerAtCoordinates(0, y) = playerAtCoordinates(2, y)) then exit playerAtCoordinates(0, y);
  end;
  // diagonally
  if assigned(playerAtCoordinates(0, 0)) and 
    (playerAtCoordinates(0, 0) = playerAtCoordinates(1, 1)) and
    (playerAtCoordinates(0, 0) = playerAtCoordinates(2, 2)) then exit playerAtCoordinates(0, 0);
  if assigned(playerAtCoordinates(0, 2)) and 
    (playerAtCoordinates(0, 2) = playerAtCoordinates(1, 1)) and
    (playerAtCoordinates(0, 2) = playerAtCoordinates(2, 0)) then exit playerAtCoordinates(0, 2);

  exit nil;
end;

method Board.setStatus(aStatus: String);
begin
  if length(fStatusLabel.text) > 0 then begin

    UIView.animateWithDuration(0.1) 
           animations(method begin
               fStatusLabel.alpha := 0;
             end) 
           completion(method begin
               fStatusLabel.text := aStatus;
               if length(aStatus) > 0 then begin

                 UIView.animateWithDuration(0.3) 
                        animations(method begin
                            fStatusLabel.alpha := 1.0;
                          end); 

               end;
             end);

  end
  else begin

    fStatusLabel.text := aStatus;
    if length(aStatus) > 0 then begin

      UIView.animateWithDuration(0.3) 
            animations(method begin
                fStatusLabel.alpha := 1.0;
              end);

    end;
  end;
end;

method Board.clear(aCompletion: block := nil; aClearAnimated: Boolean);
begin
  var lTempImages := fGridImages.copy;
  var lTempTentativeView := fTentativeView;

  fGridImages.removeAllObjects();
  for x: Int32 := 0 to 2 do 
    for y: Int32 := 0 to 2 do
      fGridInfo[x,y] := nil;
  fTurnCount := 0;

  if aClearAnimated then begin

    UIView.animateWithDuration(0.5) 
        animations(method begin
            for each i in lTempImages do
              i.alpha := 0.0;
            if assigned(lTempTentativeView) then
              lTempTentativeView.alpha := 0;
          end)
        completion(method begin
            for each i in lTempImages do
              i.removeFromSuperview();
            if assigned(lTempTentativeView) then
              lTempTentativeView.removeFromSuperview();
            if assigned(aCompletion) then
              aCompletion();
          end);

  end
  else begin

    for each i in lTempImages do
      i.removeFromSuperview();
    if assigned(lTempTentativeView) then 
      lTempTentativeView.removeFromSuperview();
    if assigned(aCompletion) then
      aCompletion();

  end;
end;

method Board.saveToNSDictionary(aDictionary: NSMutableDictionary; aXPlayerID: String; aOPlayerID: String);
begin
  if not assigned(aOPlayerID) then aOPlayerID := 'unknown';
  for x: Int32 := 0 to 2 do begin
    for y: Int32 := 0 to 2 do begin
      var v := fGridInfo[x,y];
      if length(v) > 0 then begin
        var lKey := x.stringValue+'/'+y.stringValue;
        var lPlayer := if v.hasPrefix('X') then aXPlayerID else aOPlayerID;
        var lTokenVersion := v.substringFromIndex(1);
        aDictionary.setValue(NSArray.arrayWithObjects(lPlayer, lTokenVersion, nil)) forKey(lKey); 
      end;
    end;
  end;
  //NSLog('saved %@ *X: %@, O: %@)', aDictionary, aXPlayerID, aOPlayerID);
end;

method Board.loadFromNSDictionary(aDictionary: NSDictionary; aXPlayerID: String; aOPlayerID: String);
begin
  clear(nil, false);
  //NSLog('loading %@ *X: %@, O: %@)', aDictionary, aXPlayerID, aOPlayerID);
  for x: Int32 := 0 to 2 do begin
    for y: Int32 := 0 to 2 do begin
      var lKey := x.stringValue+'/'+y.stringValue;
      var lInfo := aDictionary.valueForKey(lKey);
      if assigned(lInfo) and (lInfo.count = 2) then begin
        var lPlayer := (if lInfo[0]:isEqualToString(aXPlayerID)then "X" else "O")+lInfo[1];
        fGridInfo[x,y] := lPlayer;
        addMarkerNotAnimated(x, y, lPlayer);
        inc(fTurnCount);
      end;
    end;
  end;
end;

method Board.getGridInfo(aX: Int32; aY: Int32): String;
require
  0 ≤ aX ≤ 2;
  0 ≤ aY ≤ 2;
begin
  result := fGridInfo[aX, aY];
end;

end.
