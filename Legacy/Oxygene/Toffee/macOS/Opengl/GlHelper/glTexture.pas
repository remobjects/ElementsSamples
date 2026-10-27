namespace GlHelper;

interface
uses
  rtl,
  RemObjects.Elements.RTL,
  OpenGL;

type
  { The kind of a TTexture map }
  TextureKind  = public (Diffuse, Specular, Normal, Height);

type
  { Represents a texture (map) as used by a TMesh }
  Texture = public class
  private
    FId: GLuint;
    FKind: TextureKind;
    fValid : Boolean;

    method  IsPowerOfTwo(const AValue: Cardinal): Boolean; inline;
    begin
      exit ((AValue and (AValue - 1)) = 0);
    end;

    method prepareGlTexture(const img : glImageData);



  public
    constructor (const APath: String; const AKind: TextureKind := TextureKind.Normal);
    finalizer;

    { OpenGL id of texture }
    property Id: GLuint read FId;

    { Kind of texture }
    property Kind: TextureKind read FKind;

    property Valid : Boolean read fValid;
  end;
implementation


constructor Texture(const APath: String; const AKind: TextureKind := TextureKind.Normal);
begin
  inherited constructor();
  FKind := AKind;
  { Generate OpenGL texture }
  glGenTextures(1, @FId);
  glBindTexture(GL_TEXTURE_2D, FId);

 // Try load the Data
  var  Image := new GlImage(APath);
    if Image.Valid then
       prepareGlTexture(Image.Data);

     { Unbind }
    glBindTexture(GL_TEXTURE_2D, 0);
    glErrorCheck;

end;

method Texture.prepareGlTexture(const img : glImageData);

begin
  if img.imgData <> nil then
  begin
// writeLn('w '+Img.width.ToString + ' H '+Img.Height.ToString+' C '+Img.Components.ToString);

    fValid := true;
    var format: GLint;
    case img.Components of

      1: format := GL_RED;
      3: format := GL_RGB;
      4: format := GL_RGBA;
      else
        format := GL_RGBA;
    end;


   { Set texture data }
    glTexImage2D(GL_TEXTURE_2D, 0, format, img.width, img.Height, 0, format, GL_UNSIGNED_BYTE, img.imgData);

   { Generate mipmaps if possible. With OpenGL ES, mipmaps are only supported
     if both dimensions are a power of two. }
    var SupportsMipmaps := IsPowerOfTwo(img.width) and IsPowerOfTwo(img.Height);
    if (SupportsMipmaps) then
      glGenerateMipmap(GL_TEXTURE_2D);

   { Set texture parameters }
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    if (SupportsMipmaps) then
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
    else
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  end;
end;

finalizer Texture;
begin
  glDeleteTextures(1, @FId);
end;


end.