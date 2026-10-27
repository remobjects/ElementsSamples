namespace GlHelper;
{$IF TOFFEE}
interface
uses
  rtl,
  Foundation,
  CoreGraphics,
  RemObjects.Elements.RTL,
  OpenGL;


type GlImage = public class
  private
  fImg : glImageData;
  fValid : Boolean;


   method LoadCoreImage(const fullname : String) : Boolean;
  public
    constructor (const aPath : String);
    property Valid : Boolean read fValid;
    property Data : glImageData read fImg;

end;


implementation

constructor GlImage(const aPath: String);
begin
  inherited ();
  fValid := LoadCoreImage(Asset.getFullname(  aPath));
end;

method GlImage.LoadCoreImage(const fullname: String): Boolean;

begin
  result := false;
  if fullname.FileExists then
  begin
    //var isPng := RemObjects.Elements.RTL.String(
    var isPng := fullname.&PathExtension.ToUpperInvariant.contains('PNG');


    //var mainBundle :CFBundleRef := CFBundleGetMainBundle();
    //var FileURLRef : CFURLRef := CFBundleCopyResourceURL(mainBundle, CFStringRef('coral'), CFStringRef('png'), NULL);
    //var dataProvider := CGDataProviderCreateWithURL(FileURLRef);

    var dataProvider := CGDataProviderCreateWithFilename(NSString(fullname).cStringUsingEncoding(NSStringEncoding.NSUTF8StringEncoding));

    if dataProvider <> nil then
    begin
    // We do have a valid Provider
    // now try to read the Image
      var image : CGImageRef;
    if isPng then
      image := CGImageCreateWithPNGDataProvider(
      dataProvider,
      nil,
      false,
      CGColorRenderingIntent.kCGRenderingIntentDefault
      )

    else
      image := CGImageCreateWithJPEGDataProvider(
      dataProvider,
      nil,
      false,
      CGColorRenderingIntent.kCGRenderingIntentDefault
      );

      if image <> nil then
      begin
        result := true;
        //var imageDataProvider := CGImageGetDataProvider(image);
        var CGData  := CGDataProviderCopyData(CGImageGetDataProvider(image));
        fImg.imgData := CFDataGetBytePtr(CGData);  // not premultiplied RGBA8 data

        fImg.width :=  CGImageGetWidth(image);
        fImg.Height := CGImageGetHeight(image);
        fImg.Components := CGImageGetBitsPerPixel(image) div 8;

        CGImageRelease(image);
      end;

      CGDataProviderRelease(dataProvider);

    end;
  end
  else exit false;
end;
{$ENDIF} // TOFFFE
end.