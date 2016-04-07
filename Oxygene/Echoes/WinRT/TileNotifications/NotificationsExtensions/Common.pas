namespace NotificationsExtensions;

interface

uses
  System,
  System.Collections.ObjectModel,
  System.Runtime.InteropServices,
  System.Text,
  BadgeContent,
  Windows.Data.Xml.Dom;

type
  NotificationContentText = assembly sealed class(INotificationContentText)
    constructor ;

  public
    property Text: String read m_Text write m_Text;

    property Lang: String read m_Lang write m_Lang;

  private
    var     m_Text: String;
    var     m_Lang: String;
  end;


  NotificationContentImage = assembly sealed class(INotificationContentImage)
    constructor ;

  public
    property Src: String read m_Src write m_Src;

    property Alt: String read m_Alt write m_Alt;

  private
    var     m_Src: String;
    var     m_Alt: String;
  end;


  Util = assembly static class
  public
    const     NOTIFICATION_CONTENT_VERSION: Integer = 1;

    class method HttpEncode(value: String): String;
  end;


/// <summary>
/// Base class for the notification content creation helper classes.
/// </summary>
  NotificationBase = abstract assembly class
  protected
    constructor (aTemplateName: String; aImageCount: Integer; aTextCount: Integer);

  public
    property StrictValidation: Boolean read m_StrictValidation write m_StrictValidation;
    method GetContent: String; abstract;

    method ToString: String; override;

    method GetXml: XmlDocument;

/// <summary>
/// Retrieves the list of images that can be manipulated on the notification content.
/// </summary>
    property Images: array of INotificationContentImage read m_Images;

/// <summary>
/// Retrieves the list of text fields that can be manipulated on the notification content.
/// </summary>
    property TextFields: array of INotificationContentText read m_TextFields;

/// <summary>
/// The base Uri path that should be used for all image references in the notification.
/// </summary>
    property BaseUri: String read m_BaseUri write set_BaseUri;
    method set_BaseUri(value: String);

    property Lang: String read m_Lang write m_Lang;

  protected
    method SerializeProperties(globalLang: String; globalBaseUri: String): String;

  public
    property TemplateName: String read m_TemplateName;

  private
    var     m_StrictValidation: Boolean := true;
    var     m_Images: array of INotificationContentImage;
    var     m_TextFields: array of INotificationContentText;
// Remove when "lang" is not required on the visual element
    var     m_Lang: String := 'en-US';
    var     m_BaseUri: String;
    var     m_TemplateName: String;
  end;


/// <summary>
/// Exception returned when invalid notification content is provided.
/// </summary>
  NotificationContentValidationException = assembly sealed class(COMException)
  public
    constructor (message: String);
  end;


implementation


constructor NotificationContentText;
begin

end;

constructor NotificationContentImage;
begin

end;

class method Util.HttpEncode(value: String): String;
begin
  exit value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;').Replace(#39, '&apos;')
end;

constructor NotificationBase(aTemplateName: String; aImageCount: Integer; aTextCount: Integer);
begin
  m_TemplateName := aTemplateName;

  m_Images := new INotificationContentImage[aImageCount];
  begin
    var i: Integer := 0;
    while i < m_Images.Length do begin begin
        m_Images[i] := new NotificationContentImage()
      end;
      inc(i);
    end;
  end;

  m_TextFields := new INotificationContentText[aTextCount];
  begin
    var i: Integer := 0;
    while i < m_TextFields.Length do begin begin
        m_TextFields[i] := new NotificationContentText()
      end;
      inc(i);
    end;
  end

end;

method NotificationBase.ToString: String;
begin
  exit GetContent()
end;

method NotificationBase.GetXml: XmlDocument;
begin
  var xml: XmlDocument := new XmlDocument();
  xml.LoadXml(GetContent());
  exit xml
end;

method NotificationBase.set_BaseUri(value: String); begin
  var goodPrefix: Boolean := (self.StrictValidation) or (value = nil);
  goodPrefix := (goodPrefix) or (value.StartsWith('http://', StringComparison.OrdinalIgnoreCase));
  goodPrefix := (goodPrefix) or (value.StartsWith('https://', StringComparison.OrdinalIgnoreCase));
  goodPrefix := (goodPrefix) or (value.StartsWith('ms-appx:///', StringComparison.OrdinalIgnoreCase));
  goodPrefix := (goodPrefix) or (value.StartsWith('ms-appdata:///local/', StringComparison.OrdinalIgnoreCase));
  if not goodPrefix then begin
    raise new ArgumentException('The BaseUri must begin with http://, https://, ms-appx:///, or ms-appdata:///local/.', 'value')
  end;
  m_BaseUri := value
end;

method NotificationBase.SerializeProperties(globalLang: String; globalBaseUri: String): String;
begin
  globalLang := iif((globalLang <> nil), globalLang, String.Empty);
  globalBaseUri := iif(String.IsNullOrWhiteSpace(globalBaseUri), nil, globalBaseUri);

  var builder: StringBuilder := new StringBuilder(String.Empty);
  begin
    var i: Integer := 0;
    while i < m_Images.Length do begin begin
        if not String.IsNullOrEmpty(m_Images[i].Src) then begin
          var escapedSrc: String := Util.HttpEncode(m_Images[i].Src);
          if not String.IsNullOrWhiteSpace(m_Images[i].Alt) then begin
            var escapedAlt: String := Util.HttpEncode(m_Images[i].Alt);
            builder.AppendFormat('<image id=''{0}'' src=''{1}'' alt=''{2}''/>', i + 1, escapedSrc, escapedAlt)
          end
          else begin
            builder.AppendFormat('<image id=''{0}'' src=''{1}''/>', i + 1, escapedSrc)
          end
        end
      end;
// TODO: not supported Increment might not get called when using continue
      {POST}inc(i);
    end;
  end;

  begin
    var i: Integer := 0;
    while i < m_TextFields.Length do begin begin
        if not String.IsNullOrWhiteSpace(m_TextFields[i].Text) then begin
          var escapedValue: String := Util.HttpEncode(m_TextFields[i].Text);
          if (not String.IsNullOrWhiteSpace(m_TextFields[i].Lang)) and (not m_TextFields[i].Lang.Equals(globalLang)) then begin
            var escapedLang: String := Util.HttpEncode(m_TextFields[i].Lang);
            builder.AppendFormat('<text id=''{0}'' lang=''{1}''>{2}</text>', i + 1, escapedLang, escapedValue)
          end
          else begin
            builder.AppendFormat('<text id=''{0}''>{1}</text>', i + 1, escapedValue)
          end
        end
      end;
// TODO: not supported Increment might not get called when using continue
      {POST}inc(i);
    end;
  end;

  exit builder.ToString()
end;

constructor NotificationContentValidationException(message: String);
begin
  inherited constructor(message, $80070057 as Integer);

end;

end.
