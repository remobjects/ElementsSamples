namespace OxygeneQueue;

interface

type
  QueueItem<T> = class
  public
    property Data: T;
    property Next: QueueItem<T>;
  end;

  Queue<T> = public class
  private
    property First: QueueItem<T>;
  public
    method Count: Integer;
    method Pop: T;
    method Push(aData: T);
  end;

implementation

method Queue<T>.Pop: T;
begin
  if First=nil then Result := default(T)
  else begin
    Result := First.Data;
    First := First.Next;
  end;
end;

method Queue<T>.Push(aData: T);
var last: QueueItem<T>;
begin
  if First=nil then begin
    First := new QueueItem<T>;
    First.Data := aData;
  end
  else begin
    last := First;
    while last.Next <> nil do last := last.Next;
    last.Next := new QueueItem<T>;
    last.Next.Data := aData;
  end;
end;

method Queue<T>.Count: integer;
var last: QueueItem<T>;
begin
  if First = nil then exit(0);

  last := First;
  repeat
    inc(Result);
    last := last.Next;
  until last = nil;
end;

end.