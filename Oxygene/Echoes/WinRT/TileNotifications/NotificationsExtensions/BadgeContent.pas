namespace NotificationsExtensions.BadgeContent;

interface

uses
  System,
  BadgeContent,
  NotificationsExtensions,
  Windows.Data.Xml.Dom,
  Windows.UI.Notifications;

/// <summary>
/// Notification content object to display a glyph on a tile's badge.
/// </summary>
type
  BadgeGlyphNotificationContent = public sealed class(BadgeContent.IBadgeNotificationContent)
/// <summary>
/// Default constructor to create a glyph badge content object.
/// </summary>
  public
    constructor ;

/// <summary>
/// Constructor to create a glyph badge content object with a glyph.
/// </summary>
/// <param name="glyph">The glyph to be displayed on the badge.</param>
    constructor (aGlyph: GlyphValue);

/// <summary>
/// The glyph to be displayed on the badge.
/// </summary>
    property Glyph: GlyphValue read m_Glyph write set_Glyph;
    method set_Glyph(value: GlyphValue);

/// <summary>
/// Retrieves the notification Xml content as a string.
/// </summary>
/// <returns>The notification Xml content as a string.</returns>
    method GetContent: String;

/// <summary>
/// Retrieves the notification Xml content as a string.
/// </summary>
/// <returns>The notification Xml content as a string.</returns>
    method ToString: String; override;

/// <summary>
/// Retrieves the notification Xml content as a WinRT Xml document.
/// </summary>
/// <returns>The notification Xml content as a WinRT Xml document.</returns>
    method GetXml: XmlDocument;

/// <summary>
/// Creates a WinRT BadgeNotification object based on the content.
/// </summary>
/// <returns>A WinRT BadgeNotification object based on the content.</returns>
    method CreateNotification: BadgeNotification;

  private
    var     m_Glyph: BadgeContent.GlyphValue := GlyphValue((-1));
  end;


/// <summary>
/// Notification content object to display a number on a tile's badge.
/// </summary>
  BadgeNumericNotificationContent = public sealed class(IBadgeNotificationContent)
/// <summary>
/// Default constructor to create a numeric badge content object.
/// </summary>
  public
    constructor ;

/// <summary>
/// Constructor to create a numeric badge content object with a number.
/// </summary>
/// <param name="number">
/// The number that will appear on the badge.  If the number is 0, the badge
/// will be removed.  The largest value that will appear on the badge is 99.
/// Numbers greater than 99 are allowed, but will be displayed as "99+".
/// </param>
    constructor (aNumber: Cardinal);

/// <summary>
/// The number that will appear on the badge.  If the number is 0, the badge
/// will be removed.  The largest value that will appear on the badge is 99.
/// Numbers greater than 99 are allowed, but will be displayed as "99+".
/// </summary>
    property Number: Cardinal read m_Number write m_Number;

/// <summary>
/// Retrieves the notification Xml content as a string.
/// </summary>
/// <returns>The notification Xml content as a string.</returns>
    method GetContent: String;

/// <summary>
/// Retrieves the notification Xml content as a string.
/// </summary>
/// <returns>The notification Xml content as a string.</returns>
    method ToString: String; override;

/// <summary>
/// Retrieves the notification Xml content as a WinRT Xml document.
/// </summary>
/// <returns>The notification Xml content as a WinRT Xml document.</returns>
    method GetXml: XmlDocument;

/// <summary>
/// Creates a WinRT BadgeNotification object based on the content.
/// </summary>
/// <returns>A WinRT BadgeNotification object based on the content.</returns>
    method CreateNotification: BadgeNotification;

  private
    var     m_Number: Cardinal := 0;
  end;


implementation


constructor BadgeGlyphNotificationContent;
begin

end;

constructor BadgeGlyphNotificationContent(aGlyph: GlyphValue);
begin
  m_Glyph := aGlyph

end;

method BadgeGlyphNotificationContent.set_Glyph(value: GlyphValue); begin
  if not &Enum.IsDefined(typeOf(GlyphValue), value) then begin
    raise new ArgumentOutOfRangeException('value')
  end;
  m_Glyph := value
end;

method BadgeGlyphNotificationContent.GetContent: String;
begin
  if not &Enum.IsDefined(typeOf(GlyphValue), m_Glyph) then begin
    raise new NotificationContentValidationException('The badge glyph property was left unset.')
  end;

  var glyphString: String := m_Glyph.ToString();
// lower case the first character of the enum value to match the Xml schema
  glyphString := String.Format('{0}{1}', Char.ToLowerInvariant(glyphString[0]), glyphString.Substring(1));
  exit String.Format('<badge version=''{0}'' value=''{1}''/>', Util.NOTIFICATION_CONTENT_VERSION, glyphString)
end;

method BadgeGlyphNotificationContent.ToString: String;
begin
  exit GetContent()
end;

method BadgeGlyphNotificationContent.GetXml: XmlDocument;
begin
  var xml: XmlDocument := new XmlDocument();
  xml.LoadXml(GetContent());
  exit xml
end;

method BadgeGlyphNotificationContent.CreateNotification: BadgeNotification;
begin
  var xmlDoc: XmlDocument := new XmlDocument();
  xmlDoc.LoadXml(GetContent());
  exit new BadgeNotification(xmlDoc)
end;

constructor BadgeNumericNotificationContent;
begin

end;

constructor BadgeNumericNotificationContent(aNumber: Cardinal);
begin
  m_Number := aNumber

end;

method BadgeNumericNotificationContent.GetContent: String;
begin
  exit String.Format('<badge version=''{0}'' value=''{1}''/>', Util.NOTIFICATION_CONTENT_VERSION, m_Number)
end;

method BadgeNumericNotificationContent.ToString: String;
begin
  exit GetContent()
end;

method BadgeNumericNotificationContent.GetXml: XmlDocument;
begin
  var xml: XmlDocument := new XmlDocument();
  xml.LoadXml(GetContent());
  exit xml
end;

method BadgeNumericNotificationContent.CreateNotification: BadgeNotification;
begin
  var xmlDoc: XmlDocument := new XmlDocument();
  xmlDoc.LoadXml(GetContent());
  exit new BadgeNotification(xmlDoc)
end;

end.
