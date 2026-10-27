namespace GlHelper;
{$IF ISLAND}

interface
uses rtl,
STB,
RemObjects.Elements.RTL;

type GlImage = public class
private
  fImg : glImageData;
  fValid : Boolean;

  method LoadCoreImage(const fullname : String) : Boolean;
public
  constructor (const aPath : String);
  finalizer;
  property Valid : Boolean read fValid;
  property Data : glImageData read fImg;

end;
implementation

method GlImage.LoadCoreImage(const fullname: String): Boolean;
begin
  Var memData := Asset.loadFileBytes(fullname);
 if assigned(memData) then
  if length(memData) > 0 then
    begin
    //  writeLn('Fullname '+Fullname);
     fImg.imgData := stbi_load_from_memory(@memData[0],length(memData), var fImg.width, var fImg.Height, var fImg.Components, 3);

    //  var s := String.Format('W {0} H {1} C{3}',[fImg.width, fImg.Height, fImg.Components]);
   // writeLn('w '+fImg.width.ToString + ' H '+fImg.Height.ToString+' C '+fImg.Components.ToString);
    end;
//  fImg.Data := stbi_load(glStringHelper.toPansichar(Asset.getFullname(fullname)), var fImg.width, var fImg.Height, var fImg.Components, 4);

  result := fImg.imgData <> nil;
end;

constructor GlImage(const aPath: String);
begin
  inherited ();
  fValid := LoadCoreImage(aPath);
end;

finalizer GlImage;
begin
  if fValid then if fImg.imgData <> nil then
    stbi_image_free(fImg.imgData);
end;

{$ENDIF} // Island
end.