namespace GlHelper;

interface
 uses
 rtl,
 {$IF TOFFEE}
 Foundation,
{$ELSEIF ISLAND}
 Remobjects.Elements.System,
 {$ENDIF}
 RemObjects.Elements.RTL;


 type
  Pointer = ^Void;

  glImageData = public record
    imgData : ^Void;
    width : Integer;
    Height : Integer;
    Components : Integer;
  end;


  glStringHelper = static class
  private
  public
     method toPansichar(const Value : String) : ^AnsiChar;
  end;


implementation

method glStringHelper.toPansichar(const Value: String): ^AnsiChar;
begin
  {$IF TOFFEE}
   exit   NSString(Value).cStringUsingEncoding(NSStringEncoding.NSUTF8StringEncoding);
  {$ELSEIF ISLAND}
    exit     @Remobjects.Elements.System.String(Value).ToAnsiChars(true)[0];
  {$ELSEIF}
  exit nil;

  {$ENDIF}
end;



end.