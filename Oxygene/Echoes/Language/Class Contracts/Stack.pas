namespace Stack;

interface

type
  // An implementation of a generic stack. Based on the example in
  // ch. 11 of Bertrand Meyer's "Object Oriented Software Construction" 2nd Ed
  Stack<T> = public class
  private
    fCount: Integer;
    fCapacity: Integer;
    representation: array of T;

    method GetIsEmpty: Boolean;
    method GetIsFull: Boolean;
    method GetItem: T;
  public
    constructor(capacity: Integer);

    method PutItem(newItem: T);
    method RemoveItem;

    property Count: Integer read fCount;
    property Item: T read GetItem;
    property IsEmpty: Boolean read GetIsEmpty;
    property IsFull: Boolean read GetIsFull;

  public invariants
    fCount >= 0;
    fCount <= fCapacity;
    fCapacity <= length(representation);
    IsEmpty = (fCount = 0);
    (fCount > 0) implies (representation[fCount].equals(Item));
  end;

implementation

constructor Stack<T>(capacity: Integer);
require
  capacity >= 0;
begin
  fCount := 0;
  fCapacity := capacity;
  representation := new T[fCapacity];
ensure
  fCapacity = capacity;
  assigned(representation);
  IsEmpty;
end;

method Stack<T>.GetIsFull: Boolean;
begin
  result := fCount = (fCapacity - 1);
ensure
  // The imperative and the applicative
  result = (fCount = (fCapacity - 1));
end;

method Stack<T>.GetIsEmpty: boolean;
begin
  result := fCount = 0;
ensure
  result = (fCount = 0);
end;

method Stack<T>.GetItem: T;
require
  not IsEmpty;
begin
  result := representation[Count];
end;

method Stack<T>.PutItem(newItem: T);
require
  not IsFull;
begin
  inc(fCount);
  representation[fCount] := newItem;
ensure
  not IsEmpty;
  Item.equals(newItem);
  fCount = old fCount + 1;
end;

method Stack<T>.RemoveItem;
require
  not IsEmpty;
begin
  dec(fCount);
ensure
  not IsFull;
  fCount = old fCount - 1;
end;

end.