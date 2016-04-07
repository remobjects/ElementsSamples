namespace NotificationsExtensions.ToastContent;

interface

uses
  System,
  BadgeContent,
  NotificationsExtensions,
  System.Text,
  Windows.Data.Xml.Dom,
  Windows.UI.Notifications;

type
  ToastAudio = assembly sealed class(IToastAudio)
    constructor ;

  public
    property Content: ToastAudioContent read m_Content write set_Content;
    method set_Content(value: ToastAudioContent);

    property &Loop: Boolean read m_Loop write m_Loop;

  private
    var m_Content: ToastAudioContent := ToastAudioContent.Default;
    var m_Loop: Boolean := false;
  end;


  ToastNotificationBase = assembly class(NotificationBase, IToastNotificationContent)
  public
    constructor (templateName: String; imageCount: Integer; textCount: Integer);

  private
    method AudioSrcIsLooping: Boolean;
    method ValidateAudio;
    method AppendAudioTag(builder: StringBuilder);

  public
    method GetContent: String; override;
    method CreateNotification: ToastNotification;

    property Audio: IToastAudio read m_Audio;
    property Launch: String read m_Launch write m_Launch;
    property Duration: ToastDuration read m_Duration write set_Duration;
    method set_Duration(value: ToastDuration);

  private
    var m_Launch: String;
    var m_Audio: IToastAudio := new ToastAudio();
    var m_Duration: ToastDuration := ToastDuration.Short;
  end;

  ToastImageAndText01 = assembly class(ToastNotificationBase, IToastImageAndText01)
  private
    fImage: INotificationContentImage;
    fTextBodyWrap: INotificationContentText;
    method GetImage: INotificationContentImage;
    method GetTextBodyWrap: INotificationContentText;
  public
    property Image: INotificationContentImage read GetImage write fImage;
    property TextBodyWrap: INotificationContentText read GetTextBodyWrap write fTextBodyWrap;
  end;

implementation

method ToastImageAndText01.GetImage: INotificationContentImage;
begin
  exit fImage;
end;

method ToastImageAndText01.GetTextBodyWrap: INotificationContentText;
begin
  exit fTextBodyWrap;
end;

constructor ToastAudio;
begin

end;

method ToastAudio.set_Content(value: ToastAudioContent); begin
  if not &Enum.IsDefined(typeOf(ToastAudioContent), value) then begin
    raise new ArgumentOutOfRangeException('value')
  end;
  m_Content := value
end;

constructor ToastNotificationBase(templateName: String; imageCount: Integer; textCount: Integer);
begin
  inherited constructor(templateName, imageCount, textCount);

end;

method ToastNotificationBase.AudioSrcIsLooping: Boolean;
begin
  exit ((((Audio.Content = ToastAudioContent.LoopingAlarm)) or ((Audio.Content = ToastAudioContent.LoopingAlarm2))) or ((Audio.Content = ToastAudioContent.LoopingCall))) or ((Audio.Content = ToastAudioContent.LoopingCall2))
end;

method ToastNotificationBase.ValidateAudio;
begin
  if StrictValidation then begin
    if (Audio.Loop) and (Duration <> ToastDuration.Long) then begin
      raise new NotificationContentValidationException('Looping audio is only available for long duration toasts.')
    end;
    if (Audio.Loop) and (not AudioSrcIsLooping()) then begin
      raise new NotificationContentValidationException('A looping audio src must be chosen if the looping audio property is set.')
    end;
    if (not Audio.Loop) and (AudioSrcIsLooping()) then begin
      raise new NotificationContentValidationException('The looping audio property needs to be set if a looping audio src is chosen.')
    end
  end
end;

method ToastNotificationBase.AppendAudioTag(builder: StringBuilder);
begin
  if Audio.Content <> ToastAudioContent.Default then begin
    builder.Append('<audio');
    if Audio.Content = ToastAudioContent.Silent then begin
      builder.Append(' silent=''true''/>')
    end
    else begin
      if Audio.Loop = true then begin
        builder.Append(' loop=''true''')
      end;

      // The default looping sound is LoopingCall - save size by not adding it
      if Audio.Content <> ToastAudioContent.LoopingCall then begin
        var audioSrc: String := nil;
        case Audio.Content of 
          ToastAudioContent.IM:  begin
            audioSrc := 'ms-winsoundevent:Notification.IM';
          end;
          ToastAudioContent.Mail:  begin
            audioSrc := 'ms-winsoundevent:Notification.Mail';
          end;
          ToastAudioContent.Reminder:  begin
            audioSrc := 'ms-winsoundevent:Notification.Reminder';
          end;
          ToastAudioContent.SMS:  begin
            audioSrc := 'ms-winsoundevent:Notification.SMS';
          end;
          ToastAudioContent.LoopingAlarm:  begin
            audioSrc := 'ms-winsoundevent:Notification.Looping.Alarm';
          end;
          ToastAudioContent.LoopingAlarm2:  begin
            audioSrc := 'ms-winsoundevent:Notification.Looping.Alarm2';
          end;
          ToastAudioContent.LoopingCall:  begin
            audioSrc := 'ms-winsoundevent:Notification.Looping.Call';
          end;
          ToastAudioContent.LoopingCall2:  begin
            audioSrc := 'ms-winsoundevent:Notification.Looping.Call2';
          end;        end;
        builder.AppendFormat(' src=''{0}''', audioSrc)
      end
    end;
    builder.Append('/>')
  end
end;

method ToastNotificationBase.GetContent: String;
begin
  ValidateAudio();

  var builder: StringBuilder := new StringBuilder('<toast');
  if not String.IsNullOrEmpty(Launch) then begin
    builder.AppendFormat(' launch=''{0}''', Util.HttpEncode(Launch))
  end;
  if Duration <> ToastDuration.Short then begin
    builder.AppendFormat(' duration=''{0}''', Duration.ToString().ToLowerInvariant())
  end;
  builder.Append('>');

  builder.AppendFormat('<visual version=''{0}''', Util.NOTIFICATION_CONTENT_VERSION);
  if not String.IsNullOrWhiteSpace(Lang) then begin
    builder.AppendFormat(' lang=''{0}''', Util.HttpEncode(Lang))
  end;
  if not String.IsNullOrWhiteSpace(BaseUri) then begin
    builder.AppendFormat(' baseUri=''{0}''', Util.HttpEncode(BaseUri))
  end;
  builder.Append('>');

  builder.AppendFormat('<binding template=''{0}''>{1}</binding>', TemplateName, SerializeProperties(Lang, BaseUri));
  builder.Append('</visual>');

  AppendAudioTag(builder);

  builder.Append('</toast>');

  exit builder.ToString()
end;

method ToastNotificationBase.CreateNotification: ToastNotification;
begin
  var xmlDoc: XmlDocument := new XmlDocument();
  xmlDoc.LoadXml(GetContent());
  exit new ToastNotification(xmlDoc)
end;

method ToastNotificationBase.set_Duration(value: ToastDuration); begin
  if not &Enum.IsDefined(typeOf(ToastDuration), value) then begin
    raise new ArgumentOutOfRangeException('value')
  end;
  m_Duration := value
end;

end.
