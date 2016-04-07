namespace TicTacToe;

interface

uses
  Foundation;

type
  ComputerPlayer = public class
  private
    fBoard: Board;
    fComputerPlayer: String;
    fForkSquares: Array[1..9] of NSInteger;

    method playerAtCoordinates(x: Int32; y: Int32): String;
    method OpponentInPosition(x, y : Int32):Boolean;
    method ComputerInPosition(x, y : Int32):Boolean;
    method OpponentInSquare(a : Int32):Boolean;
    method ComputerInSquare(a : Int32):Boolean;
    method EmptySquare(a : Int32):Boolean;

    method XforPos(p : Int32):Int32;
    method YforPos(p : Int32):Int32;
    method WinningSquare(a: Int32; b: Int32; c: Int32): Int32;
    method BlockingSquare(a: Int32; b: Int32; c: Int32): Int32;
    method CheckFork(a: Int32; b: Int32; c: Int32);
    method CheckForkBlock(a: Int32; b: Int32; c: Int32);

    method CanPlay(a: Int32):Boolean;
    method CanWin: Boolean;
    method CanBlock: Boolean;
    method CanFork: Boolean;
    method CanBlockFork: Boolean;
    method CanGoInCentre: Boolean;
    method CanGoInOppositeCorner: Boolean;
    method CanGoInEmptyCorner: Boolean;
    method CanGoInEmptySide: Boolean;

  protected
  public
    method makeBestMove(aPlayer: String; aBoard:Board);
    method SetGridInfo(x, y : Int32; aPlayer:String);
  end;

{ To make this clearer, the grid (which is in 2x2 array on the board) is referred to by number representing each of the nine squares, as follows:
  1 | 2 | 3
  ---------
  4 | 5 | 6
  ---------
  7 | 8 | 9

  The board calls makeBestMove which will work out the best location to go, and the board will go in this location.
  This calls a series of possible moves in the order most likely to win the game (or at least, not lose).}

implementation

method ComputerPlayer.playerAtCoordinates(x, y: Int32): String;
begin
  result := fBoard.GridInfo[x,y]:substringToIndex(1); 
end;

method ComputerPlayer.OpponentInPosition(x, y : Int32):Boolean;
begin
  result:=assigned(fBoard.GridInfo[x,y]) and (playerAtCoordinates(x, y) <> fComputerPlayer);
end;
 
method ComputerPlayer.ComputerInPosition(x, y : Int32):Boolean;
begin
  result:=assigned(fBoard.GridInfo[x,y]) and (playerAtCoordinates(x, y) = fComputerPlayer);
end;

method ComputerPlayer.OpponentInSquare(a: Int32): Boolean;
begin
  var x : Int32 := XforPos(a);
  var y : Int32 := YforPos(a);
  exit OpponentInPosition(x ,y);
end; 

method ComputerPlayer.ComputerInSquare(a: Int32): Boolean;
begin
  var x : Int32 := XforPos(a);
  var y : Int32 := YforPos(a);
  exit ComputerInPosition(x ,y);
end; 

method ComputerPlayer.EmptySquare(a : Int32):Boolean;
begin
  var x : Int32 := XforPos(a);
  var y : Int32 := YforPos(a);
  exit not assigned(fBoard.GridInfo[x,y]);
end; 

method ComputerPlayer.XforPos(p: Int32): Int32;
begin
  if p in [1,2,3] then exit 0
  else if p in [4,5,6] then exit 1
  else if p in [7,8,9] then exit 2;
end;

method ComputerPlayer.YforPos(p: Int32): Int32;
begin
  if p in [1,4,7] then exit 0
  else if p in [2,5,8] then exit 1
  else if p in [3,6,9] then exit 2;
end;

method ComputerPlayer.WinningSquare(a,b,c : Int32):Int32; //lookup to see if one of the squares in the triple is available to win
begin
  if ComputerInSquare(a) and ComputerInSquare(b) and EmptySquare(c) then exit c
  else if ComputerInSquare(a) and ComputerInSquare(c) and EmptySquare(b) then exit b
  else if ComputerInSquare(b) and ComputerInSquare(c) and EmptySquare(a) then exit a
  else exit 0;
end;

method ComputerPlayer.BlockingSquare(a,b,c : Int32):Int32;//lookup to see if one of the three is available for opponent to win
begin
  if OpponentInSquare(a) and OpponentInSquare(b) and EmptySquare(c) then exit c
  else if OpponentInSquare(a) and OpponentInSquare(c) and EmptySquare(b) then exit b
  else if OpponentInSquare(b) and OpponentInSquare(c) and EmptySquare(a) then exit a
  else exit 0;
end;

method ComputerPlayer.CheckFork(a: Int32; b: Int32; c: Int32);
begin
  if ComputerInSquare(a) and EmptySquare(b) and EmptySquare(c) then begin
    inc(fForkSquares[b]);
    inc(fForkSquares[c]);
  end;
  if ComputerInSquare(b) and EmptySquare(a) and EmptySquare(c) then begin
    inc(fForkSquares[a]);
    inc(fForkSquares[c]);
  end;
  if ComputerInSquare(c) and EmptySquare(b) and EmptySquare(a) then begin
    inc(fForkSquares[b]);
    inc(fForkSquares[a]);
  end;
end;

method ComputerPlayer.CheckForkBlock(a: Int32; b: Int32; c: Int32);
begin
  if OpponentInSquare(a) and EmptySquare(b) and EmptySquare(c) then begin
    inc(fForkSquares[b]);
    inc(fForkSquares[c]);
  end;
  if OpponentInSquare(b) and EmptySquare(a) and EmptySquare(c) then begin
    inc(fForkSquares[a]);
    inc(fForkSquares[c]);
  end;
  if OpponentInSquare(c) and EmptySquare(b) and EmptySquare(a) then begin
    inc(fForkSquares[b]);
    inc(fForkSquares[a]);
  end;
end;

method ComputerPlayer.CanPlay(a : Int32):Boolean;
begin    
  if a=0 then exit false;
  var x : Int32 := XforPos(a);
  var y : Int32 := YforPos(a);

  if not assigned(fBoard.GridInfo[x,y]) then begin
    fBoard.markGrid(x, y, fComputerPlayer);
    result:=True;
  end else result:=false;
end;

method ComputerPlayer.CanWin:Boolean;//User isn't concentrating
begin
  //the number triple is a potential winning line (there aren't many)
  result:=CanPlay(WinningSquare(1,2,3)) or
          CanPlay(WinningSquare(4,5,6)) or
          CanPlay(WinningSquare(7,8,9)) or
          CanPlay(WinningSquare(1,4,7)) or
          CanPlay(WinningSquare(2,5,8)) or
          CanPlay(WinningSquare(3,6,9)) or
          CanPlay(WinningSquare(1,5,9)) or
          CanPlay(WinningSquare(3,5,7));
end;

method ComputerPlayer.CanBlock:Boolean;//Stop the user winning
begin
  result:=CanPlay(BlockingSquare(1,2,3)) or
          CanPlay(BlockingSquare(4,5,6)) or
          CanPlay(BlockingSquare(7,8,9)) or
          CanPlay(BlockingSquare(1,4,7)) or
          CanPlay(BlockingSquare(2,5,8)) or
          CanPlay(BlockingSquare(3,6,9)) or
          CanPlay(BlockingSquare(1,5,9)) or
          CanPlay(BlockingSquare(3,5,7));
end;

method ComputerPlayer.CanFork:Boolean;
begin
  //a fork is where the same square appears in two triples that could be a winning line
  //so we need to find the empty square numbers a triple has the computer in the one square and the other two are empty
  //then see if a number appears more than once in the array, which means it is a pivot for the fork
  for i:Int32 :=1 to 9 do fForkSquares[i]:=0;
  CheckFork(1,2,3);
  CheckFork(4,5,6);
  CheckFork(7,8,9);
  CheckFork(1,4,7);
  CheckFork(2,5,8);
  CheckFork(3,6,9);
  CheckFork(1,5,9);
  CheckFork(3,5,7);
  //now check if any are 2 or more and select first one available
  for i:Int32 :=1 to 9 do 
    if ((fForkSquares[i]>1) and CanPlay(i)) then exit true;
  exit false;
end;

method ComputerPlayer.CanBlockFork:Boolean;
begin
  //Same as for a fork, but for the opponent, we need to prevent it
  for i:Int32 :=1 to 9 do fForkSquares[i]:=0;
  CheckForkBlock(1,2,3);
  CheckForkBlock(4,5,6);
  CheckForkBlock(7,8,9);
  CheckForkBlock(1,4,7);
  CheckForkBlock(2,5,8);
  CheckForkBlock(3,6,9);
  CheckForkBlock(1,5,9);
  CheckForkBlock(3,5,7);
  //now check if any are 2 or more and select first one available
  for i:Int32 :=1 to 9 do 
    if ((fForkSquares[i]>1) and CanPlay(i)) then exit true;
  exit false;
end;

method ComputerPlayer.CanGoInCentre:Boolean;
begin
  result:=CanPlay(5);
end;

method ComputerPlayer.CanGoInOppositeCorner:Boolean;
begin
  result:=(OpponentInSquare(1) and CanPlay(9))or
          (OpponentInSquare(3) and CanPlay(7))or
          (OpponentInSquare(7) and CanPlay(3))or
          (OpponentInSquare(9) and CanPlay(1));
end;

method ComputerPlayer.CanGoInEmptyCorner:Boolean;
begin
  result:=CanPlay(1) or CanPlay(3) or CanPlay(7) or CanPlay(7);
end;

method ComputerPlayer.CanGoInEmptySide:Boolean;
begin
  result:=CanPlay(2) or CanPlay(4) or CanPlay(6) or CanPlay(8);
end;

method ComputerPlayer.makeBestMove(aPlayer: String; aBoard:Board);
begin
  fComputerPlayer := aPlayer;
  fBoard := aBoard;
  if CanWin or 
     CanBlock or 
     CanFork or 
     CanBlockFork or
     CanGoInCentre or 
     CanGoInOppositeCorner or 
     CanGoInEmptyCorner or 
     CanGoInEmptySide then;
end;

method ComputerPlayer.SetGridInfo(x: Int32; y: Int32; aPlayer: String);
begin
  fBoard.markGrid(x, y, aPlayer);
end;

end.
