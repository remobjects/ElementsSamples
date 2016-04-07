namespace NotificationsExtensions.TileContent;

interface

uses
  System,
  System.Text,
  BadgeContent,
  NotificationsExtensions,
  Windows.Data.Xml.Dom,
  Windows.UI.Notifications;

type
  TileNotificationBase = assembly abstract class(NotificationBase)
  public
    constructor (templateName: System.String; imageCount: System.Int32; textCount: System.Int32);
    
    property Branding: TileBranding read m_Branding write set_Branding;
    method set_Branding(value: TileBranding);
    method CreateNotification: TileNotification;

  private
    var m_Branding: TileBranding := TileBranding.Logo;
  end;

  ISquareTileInternal = assembly interface
    method SerializeBinding(globalLang: System.String; globalBaseUri: System.String; globalBranding: TileBranding): System.String;
  end;

  TileSquareBase = assembly class(TileNotificationBase, ISquareTileInternal)
  public
    constructor (templateName: System.String; imageCount: System.Int32; textCount: System.Int32);
    method GetContent: System.String; override;
    method SerializeBinding(globalLang: System.String; globalBaseUri: System.String; globalBranding: TileBranding): System.String;
  end;

  TileWideBase = assembly class(TileNotificationBase)
  public
    constructor (templateName: System.String; imageCount: System.Int32; textCount: System.Int32);
    property SquareContent: ISquareTileNotificationContent read m_SquareContent write m_SquareContent;
    property RequireSquareContent: System.Boolean read m_RequireSquareContent write m_RequireSquareContent;
    method GetContent: System.String; override;

  private
    var m_SquareContent: ISquareTileNotificationContent := nil;
    var m_RequireSquareContent: System.Boolean := true;
  end;


  TileSquareBlock = assembly class(TileSquareBase, ITileSquareBlock)
  public
    constructor ;
	
    property TextBlock: INotificationContentText read TextFields[0];
    property TextSubBlock: INotificationContentText read TextFields[1];
  end;


  TileSquareImage = assembly class(TileSquareBase, ITileSquareImage)
  public
    constructor ;
	
    property Image: INotificationContentImage read Images[0];
  end;


  TileSquarePeekImageAndText01 = assembly class(TileSquareBase, ITileSquarePeekImageAndText01)
  public
    constructor ;
	
    property Image: INotificationContentImage read Images[0];
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBody1: INotificationContentText read TextFields[1];
    property TextBody2: INotificationContentText read TextFields[2];
    property TextBody3: INotificationContentText read TextFields[3];
  end;


  TileSquarePeekImageAndText02 = assembly class(TileSquareBase, ITileSquarePeekImageAndText02)
  public
    constructor ;
	
    property Image: INotificationContentImage read Images[0];
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBodyWrap: INotificationContentText read TextFields[1];
  end;


  TileSquarePeekImageAndText03 = assembly class(TileSquareBase, ITileSquarePeekImageAndText03)
  public
    constructor ;
	
    property Image: INotificationContentImage read Images[0];
    property TextBody1: INotificationContentText read TextFields[0];
    property TextBody2: INotificationContentText read TextFields[1];
    property TextBody3: INotificationContentText read TextFields[2];
    property TextBody4: INotificationContentText read TextFields[3];
  end;


  TileSquarePeekImageAndText04 = assembly class(TileSquareBase, ITileSquarePeekImageAndText04)
  public
    constructor ;
	
    property Image: INotificationContentImage read Images[0];
    property TextBodyWrap: INotificationContentText read TextFields[0];
  end;


  TileSquareText01 = assembly class(TileSquareBase, ITileSquareText01)
  public
    constructor ;
	
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBody1: INotificationContentText read TextFields[1];
    property TextBody2: INotificationContentText read TextFields[2];
    property TextBody3: INotificationContentText read TextFields[3];
  end;


  TileSquareText02 = assembly class(TileSquareBase, ITileSquareText02)
  public
    constructor ;
	
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBodyWrap: INotificationContentText read TextFields[1];
  end;


  TileSquareText03 = assembly class(TileSquareBase, ITileSquareText03)
  public
    constructor ;
	
    property TextBody1: INotificationContentText read TextFields[0];
    property TextBody2: INotificationContentText read TextFields[1];
    property TextBody3: INotificationContentText read TextFields[2];
    property TextBody4: INotificationContentText read TextFields[3];
  end;


  TileSquareText04 = assembly class(TileSquareBase, ITileSquareText04)
  public
    constructor ;
	
    property TextBodyWrap: INotificationContentText read TextFields[0];
  end;


  TileWideBlockAndText01 = assembly class(TileWideBase, ITileWideBlockAndText01)
  public
    constructor ;

    property TextBody1: INotificationContentText read TextFields[0];
    property TextBody2: INotificationContentText read TextFields[1];
    property TextBody3: INotificationContentText read TextFields[2];
    property TextBody4: INotificationContentText read TextFields[3];
    property TextBlock: INotificationContentText read TextFields[4];
    property TextSubBlock: INotificationContentText read TextFields[5];
  end;


  TileWideBlockAndText02 = assembly class(TileWideBase, ITileWideBlockAndText02)
  public
    constructor ;

    property TextBodyWrap: INotificationContentText read TextFields[0];
    property TextBlock: INotificationContentText read TextFields[1];
    property TextSubBlock: INotificationContentText read TextFields[2];
  end;


  TileWideImage = assembly class(TileWideBase, ITileWideImage)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
  end;


  TileWideImageAndText01 = assembly class(TileWideBase, ITileWideImageAndText01)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextCaptionWrap: INotificationContentText read TextFields[0];
  end;


  TileWideImageAndText02 = assembly class(TileWideBase, ITileWideImageAndText02)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextCaption1: INotificationContentText read TextFields[0];
    property TextCaption2: INotificationContentText read TextFields[1];
  end;


  TileWideImageCollection = assembly class(TileWideBase, ITileWideImageCollection)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSmallColumn1Row1: INotificationContentImage read Images[1];
    property ImageSmallColumn2Row1: INotificationContentImage read Images[2];
    property ImageSmallColumn1Row2: INotificationContentImage read Images[3];
    property ImageSmallColumn2Row2: INotificationContentImage read Images[4];
  end;


  TileWidePeekImage01 = assembly class(TileWideBase, ITileWidePeekImage01)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBodyWrap: INotificationContentText read TextFields[1];
  end;


  TileWidePeekImage02 = assembly class(TileWideBase, ITileWidePeekImage02)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBody1: INotificationContentText read TextFields[1];
    property TextBody2: INotificationContentText read TextFields[2];
    property TextBody3: INotificationContentText read TextFields[3];
    property TextBody4: INotificationContentText read TextFields[4];
  end;


  TileWidePeekImage03 = assembly class(TileWideBase, ITileWidePeekImage03)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextHeadingWrap: INotificationContentText read TextFields[0];
  end;


  TileWidePeekImage04 = assembly class(TileWideBase, ITileWidePeekImage04)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextBodyWrap: INotificationContentText read TextFields[0];
  end;


  TileWidePeekImage05 = assembly class(TileWideBase, ITileWidePeekImage05)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSecondary: INotificationContentImage read Images[1];
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBodyWrap: INotificationContentText read TextFields[1];
  end;


  TileWidePeekImage06 = assembly class(TileWideBase, ITileWidePeekImage06)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSecondary: INotificationContentImage read Images[1];
    property TextHeadingWrap: INotificationContentText read TextFields[0];
  end;


  TileWidePeekImageAndText01 = assembly class(TileWideBase, ITileWidePeekImageAndText01)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextBodyWrap: INotificationContentText read TextFields[0];
  end;


  TileWidePeekImageAndText02 = assembly class(TileWideBase, ITileWidePeekImageAndText02)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextBody1: INotificationContentText read TextFields[0];
    property TextBody2: INotificationContentText read TextFields[1];
    property TextBody3: INotificationContentText read TextFields[2];
    property TextBody4: INotificationContentText read TextFields[3];
    property TextBody5: INotificationContentText read TextFields[4];
  end;


  TileWidePeekImageCollection01 = assembly class(TileWideBase, ITileWidePeekImageCollection01)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSmallColumn1Row1: INotificationContentImage read Images[1];
    property ImageSmallColumn2Row1: INotificationContentImage read Images[2];
    property ImageSmallColumn1Row2: INotificationContentImage read Images[3];
    property ImageSmallColumn2Row2: INotificationContentImage read Images[4];
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBodyWrap: INotificationContentText read TextFields[1];
  end;


  TileWidePeekImageCollection02 = assembly class(TileWideBase, ITileWidePeekImageCollection02)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSmallColumn1Row1: INotificationContentImage read Images[1];
    property ImageSmallColumn2Row1: INotificationContentImage read Images[2];
    property ImageSmallColumn1Row2: INotificationContentImage read Images[3];
    property ImageSmallColumn2Row2: INotificationContentImage read Images[4];
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBody1: INotificationContentText read TextFields[1];
    property TextBody2: INotificationContentText read TextFields[2];
    property TextBody3: INotificationContentText read TextFields[3];
    property TextBody4: INotificationContentText read TextFields[4];
  end;


  TileWidePeekImageCollection03 = assembly class(TileWideBase, ITileWidePeekImageCollection03)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSmallColumn1Row1: INotificationContentImage read Images[1];
    property ImageSmallColumn2Row1: INotificationContentImage read Images[2];
    property ImageSmallColumn1Row2: INotificationContentImage read Images[3];
    property ImageSmallColumn2Row2: INotificationContentImage read Images[4];
    property TextHeadingWrap: INotificationContentText read TextFields[0];
  end;


  TileWidePeekImageCollection04 = assembly class(TileWideBase, ITileWidePeekImageCollection04)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSmallColumn1Row1: INotificationContentImage read Images[1];
    property ImageSmallColumn2Row1: INotificationContentImage read Images[2];
    property ImageSmallColumn1Row2: INotificationContentImage read Images[3];
    property ImageSmallColumn2Row2: INotificationContentImage read Images[4];
    property TextBodyWrap: INotificationContentText read TextFields[0];
  end;


  TileWidePeekImageCollection05 = assembly class(TileWideBase, ITileWidePeekImageCollection05)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSmallColumn1Row1: INotificationContentImage read Images[1];
    property ImageSmallColumn2Row1: INotificationContentImage read Images[2];
    property ImageSmallColumn1Row2: INotificationContentImage read Images[3];
    property ImageSmallColumn2Row2: INotificationContentImage read Images[4];
    property ImageSecondary: INotificationContentImage read Images[5];
    property TextHeading: INotificationContentText read TextFields[0];
    property TextBodyWrap: INotificationContentText read TextFields[1];
  end;


  TileWidePeekImageCollection06 = assembly class(TileWideBase, ITileWidePeekImageCollection06)
  public
    constructor ;

    property ImageMain: INotificationContentImage read Images[0];
    property ImageSmallColumn1Row1: INotificationContentImage read Images[1];
    property ImageSmallColumn2Row1: INotificationContentImage read Images[2];
    property ImageSmallColumn1Row2: INotificationContentImage read Images[3];
    property ImageSmallColumn2Row2: INotificationContentImage read Images[4];
    property ImageSecondary: INotificationContentImage read Images[5];
    property TextHeadingWrap: INotificationContentText read TextFields[0];
  end;


  TileWideSmallImageAndText01 = assembly class(TileWideBase, ITileWideSmallImageAndText01)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];
    property TextHeadingWrap: INotificationContentText read TextFields[0];
  end;


  TileWideSmallImageAndText02 = assembly class(TileWideBase, ITileWideSmallImageAndText02)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];

    property TextHeading: INotificationContentText read TextFields[0];
    property TextBody1: INotificationContentText read TextFields[1];
    property TextBody2: INotificationContentText read TextFields[2];
    property TextBody3: INotificationContentText read TextFields[3];
    property TextBody4: INotificationContentText read TextFields[4];
  end;


  TileWideSmallImageAndText03 = assembly class(TileWideBase, ITileWideSmallImageAndText03)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];

    property TextBodyWrap: INotificationContentText read TextFields[0];
  end;


  TileWideSmallImageAndText04 = assembly class(TileWideBase, ITileWideSmallImageAndText04)
  public
    constructor ;

    property Image: INotificationContentImage read Images[0];

    property TextHeading: INotificationContentText read TextFields[0];
    property TextBodyWrap: INotificationContentText read TextFields[1];
  end;


  TileWideText01 = assembly class(TileWideBase, ITileWideText01)
  public
    constructor ;

    property TextHeading: INotificationContentText read TextFields[0];
    property TextBody1: INotificationContentText read TextFields[1];
    property TextBody2: INotificationContentText read TextFields[2];
    property TextBody3: INotificationContentText read TextFields[3];
    property TextBody4: INotificationContentText read TextFields[4];
  end;


  TileWideText02 = assembly class(TileWideBase, ITileWideText02)
  public
    constructor ;

    property TextHeading: INotificationContentText read TextFields[0];
    property TextColumn1Row1: INotificationContentText read TextFields[1];
    property TextColumn2Row1: INotificationContentText read TextFields[2];
    property TextColumn1Row2: INotificationContentText read TextFields[3];
    property TextColumn2Row2: INotificationContentText read TextFields[4];
    property TextColumn1Row3: INotificationContentText read TextFields[5];
    property TextColumn2Row3: INotificationContentText read TextFields[6];
    property TextColumn1Row4: INotificationContentText read TextFields[7];
    property TextColumn2Row4: INotificationContentText read TextFields[8];
  end;


  TileWideText03 = assembly class(TileWideBase, ITileWideText03)
  public
    constructor ;

    property TextHeadingWrap: INotificationContentText read TextFields[0];
  end;


  TileWideText04 = assembly class(TileWideBase, ITileWideText04)
  public
    constructor ;

    property TextBodyWrap: INotificationContentText read TextFields[0];
  end;


  TileWideText05 = assembly class(TileWideBase, ITileWideText05)
  public
    constructor ;

    property TextBody1: INotificationContentText read TextFields[0];
    property TextBody2: INotificationContentText read TextFields[1];
    property TextBody3: INotificationContentText read TextFields[2];
    property TextBody4: INotificationContentText read TextFields[3];
    property TextBody5: INotificationContentText read TextFields[4];
  end;


  TileWideText06 = assembly class(TileWideBase, ITileWideText06)
  public
    constructor ;

    property TextColumn1Row1: INotificationContentText read TextFields[0];
    property TextColumn2Row1: INotificationContentText read TextFields[1];
    property TextColumn1Row2: INotificationContentText read TextFields[2];
    property TextColumn2Row2: INotificationContentText read TextFields[3];
    property TextColumn1Row3: INotificationContentText read TextFields[4];
    property TextColumn2Row3: INotificationContentText read TextFields[5];
    property TextColumn1Row4: INotificationContentText read TextFields[6];
    property TextColumn2Row4: INotificationContentText read TextFields[7];
    property TextColumn1Row5: INotificationContentText read TextFields[8];
    property TextColumn2Row5: INotificationContentText read TextFields[9];
  end;


  TileWideText07 = assembly class(TileWideBase, ITileWideText07)
  public
    constructor ;

    property TextHeading: INotificationContentText read TextFields[0];
    property TextShortColumn1Row1: INotificationContentText read TextFields[1];
    property TextColumn2Row1: INotificationContentText read TextFields[2];
    property TextShortColumn1Row2: INotificationContentText read TextFields[3];
    property TextColumn2Row2: INotificationContentText read TextFields[4];
    property TextShortColumn1Row3: INotificationContentText read TextFields[5];
    property TextColumn2Row3: INotificationContentText read TextFields[6];
    property TextShortColumn1Row4: INotificationContentText read TextFields[7];
    property TextColumn2Row4: INotificationContentText read TextFields[8];
  end;


  TileWideText08 = assembly class(TileWideBase, ITileWideText08)
  public
    constructor ;

    property TextShortColumn1Row1: INotificationContentText read TextFields[0];
    property TextColumn2Row1: INotificationContentText read TextFields[1];
    property TextShortColumn1Row2: INotificationContentText read TextFields[2];
    property TextColumn2Row2: INotificationContentText read TextFields[3];
    property TextShortColumn1Row3: INotificationContentText read TextFields[4];
    property TextColumn2Row3: INotificationContentText read TextFields[5];
    property TextShortColumn1Row4: INotificationContentText read TextFields[6];
    property TextColumn2Row4: INotificationContentText read TextFields[7];
    property TextShortColumn1Row5: INotificationContentText read TextFields[8];
    property TextColumn2Row5: INotificationContentText read TextFields[9];
  end;


  TileWideText09 = assembly class(TileWideBase, ITileWideText09)
  public
    constructor ;

    property TextHeading: INotificationContentText read TextFields[0];
    property TextBodyWrap: INotificationContentText read TextFields[1];
  end;


  TileWideText10 = assembly class(TileWideBase, ITileWideText10)
  public
    constructor ;

    property TextHeading: INotificationContentText read TextFields[0];
    property TextPrefixColumn1Row1: INotificationContentText read TextFields[1];
    property TextColumn2Row1: INotificationContentText read TextFields[2];
    property TextPrefixColumn1Row2: INotificationContentText read TextFields[3];
    property TextColumn2Row2: INotificationContentText read TextFields[4];
    property TextPrefixColumn1Row3: INotificationContentText read TextFields[5];
    property TextColumn2Row3: INotificationContentText read TextFields[6];
    property TextPrefixColumn1Row4: INotificationContentText read TextFields[7];
    property TextColumn2Row4: INotificationContentText read TextFields[8];
  end;


  TileWideText11 = assembly class(TileWideBase, ITileWideText11)
  public
    constructor ;

    property TextPrefixColumn1Row1: INotificationContentText read TextFields[0];
    property TextColumn2Row1: INotificationContentText read TextFields[1];
    property TextPrefixColumn1Row2: INotificationContentText read TextFields[2];
    property TextColumn2Row2: INotificationContentText read TextFields[3];
    property TextPrefixColumn1Row3: INotificationContentText read TextFields[4];
    property TextColumn2Row3: INotificationContentText read TextFields[5];
    property TextPrefixColumn1Row4: INotificationContentText read TextFields[6];
    property TextColumn2Row4: INotificationContentText read TextFields[7];
    property TextPrefixColumn1Row5: INotificationContentText read TextFields[8];
    property TextColumn2Row5: INotificationContentText read TextFields[9];
  end;


  /// <summary>
  /// A factory which creates tile content objects for all of the toast template types.
  /// </summary>
  TileContentFactory = public sealed class

  public
    /// <summary>
    /// Creates a tile content object for the TileSquareBlock template.
    /// </summary>
    /// <returns>A tile content object for the TileSquareBlock template.</returns>
    class method CreateTileSquareBlock: ITileSquareBlock;

    /// <summary>
    /// Creates a tile content object for the TileSquareImage template.
    /// </summary>
    /// <returns>A tile content object for the TileSquareImage template.</returns>
    class method CreateTileSquareImage: ITileSquareImage;

    /// <summary>
    /// Creates a tile content object for the TileSquarePeekImageAndText01 template.
    /// </summary>
    /// <returns>A tile content object for the TileSquarePeekImageAndText01 template.</returns>
    class method CreateTileSquarePeekImageAndText01: ITileSquarePeekImageAndText01;

    /// <summary>
    /// Creates a tile content object for the TileSquarePeekImageAndText02 template.
    /// </summary>
    /// <returns>A tile content object for the TileSquarePeekImageAndText02 template.</returns>
    class method CreateTileSquarePeekImageAndText02: ITileSquarePeekImageAndText02;

    /// <summary>
    /// Creates a tile content object for the TileSquarePeekImageAndText03 template.
    /// </summary>
    /// <returns>A tile content object for the TileSquarePeekImageAndText03 template.</returns>
    class method CreateTileSquarePeekImageAndText03: ITileSquarePeekImageAndText03;

    /// <summary>
    /// Creates a tile content object for the TileSquarePeekImageAndText04 template.
    /// </summary>
    /// <returns>A tile content object for the TileSquarePeekImageAndText04 template.</returns>
    class method CreateTileSquarePeekImageAndText04: ITileSquarePeekImageAndText04;

    /// <summary>
    /// Creates a tile content object for the TileSquareText01 template.
    /// </summary>
    /// <returns>A tile content object for the TileSquareText01 template.</returns>
    class method CreateTileSquareText01: ITileSquareText01;

    /// <summary>
    /// Creates a tile content object for the TileSquareText02 template.
    /// </summary>
    /// <returns>A tile content object for the TileSquareText02 template.</returns>
    class method CreateTileSquareText02: ITileSquareText02;

    /// <summary>
    /// Creates a tile content object for the TileSquareText03 template.
    /// </summary>
    /// <returns>A tile content object for the TileSquareText03 template.</returns>
    class method CreateTileSquareText03: ITileSquareText03;

    /// <summary>
    /// Creates a tile content object for the TileSquareText04 template.
    /// </summary>
    /// <returns>A tile content object for the TileSquareText04 template.</returns>
    class method CreateTileSquareText04: ITileSquareText04;

    /// <summary>
    /// Creates a tile content object for the TileWideBlockAndText01 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideBlockAndText01 template.</returns>
    class method CreateTileWideBlockAndText01: ITileWideBlockAndText01;

    /// <summary>
    /// Creates a tile content object for the TileWideBlockAndText02 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideBlockAndText02 template.</returns>
    class method CreateTileWideBlockAndText02: ITileWideBlockAndText02;

    /// <summary>
    /// Creates a tile content object for the TileWideImage template.
    /// </summary>
    /// <returns>A tile content object for the TileWideImage template.</returns>
    class method CreateTileWideImage: ITileWideImage;

    /// <summary>
    /// Creates a tile content object for the TileWideImageAndText01 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideImageAndText01 template.</returns>
    class method CreateTileWideImageAndText01: ITileWideImageAndText01;

    /// <summary>
    /// Creates a tile content object for the TileWideImageAndText02 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideImageAndText02 template.</returns>
    class method CreateTileWideImageAndText02: ITileWideImageAndText02;

    /// <summary>
    /// Creates a tile content object for the TileWideImageCollection template.
    /// </summary>
    /// <returns>A tile content object for the TileWideImageCollection template.</returns>
    class method CreateTileWideImageCollection: ITileWideImageCollection;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImage01 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImage01 template.</returns>
    class method CreateTileWidePeekImage01: ITileWidePeekImage01;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImage02 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImage02 template.</returns>
    class method CreateTileWidePeekImage02: ITileWidePeekImage02;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImage03 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImage03 template.</returns>
    class method CreateTileWidePeekImage03: ITileWidePeekImage03;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImage04 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImage04 template.</returns>
    class method CreateTileWidePeekImage04: ITileWidePeekImage04;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImage05 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImage05 template.</returns>
    class method CreateTileWidePeekImage05: ITileWidePeekImage05;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImage06 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImage06 template.</returns>
    class method CreateTileWidePeekImage06: ITileWidePeekImage06;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImageAndText01 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImageAndText01 template.</returns>
    class method CreateTileWidePeekImageAndText01: ITileWidePeekImageAndText01;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImageAndText02 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImageAndText02 template.</returns>
    class method CreateTileWidePeekImageAndText02: ITileWidePeekImageAndText02;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImageCollection01 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImageCollection01 template.</returns>
    class method CreateTileWidePeekImageCollection01: ITileWidePeekImageCollection01;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImageCollection02 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImageCollection02 template.</returns>
    class method CreateTileWidePeekImageCollection02: ITileWidePeekImageCollection02;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImageCollection03 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImageCollection03 template.</returns>
    class method CreateTileWidePeekImageCollection03: ITileWidePeekImageCollection03;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImageCollection04 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImageCollection04 template.</returns>
    class method CreateTileWidePeekImageCollection04: ITileWidePeekImageCollection04;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImageCollection05 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImageCollection05 template.</returns>
    class method CreateTileWidePeekImageCollection05: ITileWidePeekImageCollection05;

    /// <summary>
    /// Creates a tile content object for the TileWidePeekImageCollection06 template.
    /// </summary>
    /// <returns>A tile content object for the TileWidePeekImageCollection06 template.</returns>
    class method CreateTileWidePeekImageCollection06: ITileWidePeekImageCollection06;

    /// <summary>
    /// Creates a tile content object for the TileWideSmallImageAndText01 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideSmallImageAndText01 template.</returns>
    class method CreateTileWideSmallImageAndText01: ITileWideSmallImageAndText01;

    /// <summary>
    /// Creates a tile content object for the TileWideSmallImageAndText02 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideSmallImageAndText02 template.</returns>
    class method CreateTileWideSmallImageAndText02: ITileWideSmallImageAndText02;

    /// <summary>
    /// Creates a tile content object for the TileWideSmallImageAndText03 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideSmallImageAndText03 template.</returns>
    class method CreateTileWideSmallImageAndText03: ITileWideSmallImageAndText03;

    /// <summary>
    /// Creates a tile content object for the TileWideSmallImageAndText04 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideSmallImageAndText04 template.</returns>
    class method CreateTileWideSmallImageAndText04: ITileWideSmallImageAndText04;

    /// <summary>
    /// Creates a tile content object for the TileWideText01 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText01 template.</returns>
    class method CreateTileWideText01: ITileWideText01;

    /// <summary>
    /// Creates a tile content object for the TileWideText02 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText02 template.</returns>
    class method CreateTileWideText02: ITileWideText02;

    /// <summary>
    /// Creates a tile content object for the TileWideText03 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText03 template.</returns>
    class method CreateTileWideText03: ITileWideText03;

    /// <summary>
    /// Creates a tile content object for the TileWideText04 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText04 template.</returns>
    class method CreateTileWideText04: ITileWideText04;

    /// <summary>
    /// Creates a tile content object for the TileWideText05 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText05 template.</returns>
    class method CreateTileWideText05: ITileWideText05;

    /// <summary>
    /// Creates a tile content object for the TileWideText06 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText06 template.</returns>
    class method CreateTileWideText06: ITileWideText06;

    /// <summary>
    /// Creates a tile content object for the TileWideText07 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText07 template.</returns>
    class method CreateTileWideText07: ITileWideText07;

    /// <summary>
    /// Creates a tile content object for the TileWideText08 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText08 template.</returns>
    class method CreateTileWideText08: ITileWideText08;

    /// <summary>
    /// Creates a tile content object for the TileWideText09 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText09 template.</returns>
    class method CreateTileWideText09: ITileWideText09;

    /// <summary>
    /// Creates a tile content object for the TileWideText10 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText10 template.</returns>
    class method CreateTileWideText10: ITileWideText10;

    /// <summary>
    /// Creates a tile content object for the TileWideText11 template.
    /// </summary>
    /// <returns>A tile content object for the TileWideText11 template.</returns>
    class method CreateTileWideText11: ITileWideText11;
  end;


implementation


constructor TileNotificationBase(templateName: System.String; imageCount: System.Int32; textCount: System.Int32);
begin
  inherited constructor(templateName, imageCount, textCount);

end;

method TileNotificationBase.set_Branding(value: TileBranding); begin
  if not &Enum.IsDefined(typeOf(TileBranding), value) then begin
    raise new ArgumentOutOfRangeException('value')
  end;
  m_Branding := value
end;

method TileNotificationBase.CreateNotification: TileNotification;
begin
  var xmlDoc: XmlDocument := new XmlDocument();
  xmlDoc.LoadXml(GetContent());
  exit new TileNotification(xmlDoc)
end;

constructor TileSquareBase(templateName: System.String; imageCount: System.Int32; textCount: System.Int32);
begin
  inherited constructor(templateName, imageCount, textCount);

end;

method TileSquareBase.GetContent: System.String;
begin
  var builder: StringBuilder := new StringBuilder(String.Empty);
  builder.AppendFormat('<tile><visual version=''{0}''', Util.NOTIFICATION_CONTENT_VERSION);
  if not String.IsNullOrWhiteSpace(Lang) then begin
    builder.AppendFormat(' lang=''{0}''', Util.HttpEncode(Lang))
  end;
  if Branding <> TileBranding.Logo then begin
    builder.AppendFormat(' branding=''{0}''', Branding.ToString().ToLowerInvariant())
  end;
  if not String.IsNullOrWhiteSpace(BaseUri) then begin
    builder.AppendFormat(' baseUri=''{0}''', Util.HttpEncode(BaseUri))
  end;
  builder.Append('>');
  builder.Append(SerializeBinding(Lang, BaseUri, Branding));
  builder.Append('</visual></tile>');
  exit builder.ToString()
end;

method TileSquareBase.SerializeBinding(globalLang: System.String; globalBaseUri: System.String; globalBranding: TileBranding): System.String;
begin
  var bindingNode: StringBuilder := new StringBuilder(String.Empty);
  bindingNode.AppendFormat('<binding template=''{0}''', TemplateName);
  if (not String.IsNullOrWhiteSpace(Lang)) and (not Lang.Equals(globalLang)) then begin
    bindingNode.AppendFormat(' lang=''{0}''', Util.HttpEncode(Lang));
    globalLang := Lang
  end;
  if (Branding <> TileBranding.Logo) and (Branding <> globalBranding) then begin
    bindingNode.AppendFormat(' branding=''{0}''', Branding.ToString().ToLowerInvariant())
  end;
  if (not String.IsNullOrWhiteSpace(BaseUri)) and (not BaseUri.Equals(globalBaseUri)) then begin
    bindingNode.AppendFormat(' baseUri=''{0}''', Util.HttpEncode(BaseUri));
    globalBaseUri := BaseUri
  end;
  bindingNode.AppendFormat('>{0}</binding>', SerializeProperties(globalLang, globalBaseUri));

  exit bindingNode.ToString()
end;

constructor TileWideBase(templateName: System.String; imageCount: System.Int32; textCount: System.Int32);
begin
  inherited constructor(templateName, imageCount, textCount);

end;

method TileWideBase.GetContent: System.String;
begin
  if (RequireSquareContent) and (SquareContent = nil) then begin
    raise new NotificationContentValidationException('Square tile content should be included with each wide tile. ' + 'If this behavior is undesired, use the RequireSquareContent property.')
  end;

  var visualNode: StringBuilder := new StringBuilder(String.Empty);
  visualNode.AppendFormat('<visual version=''{0}''', Util.NOTIFICATION_CONTENT_VERSION);
  if not String.IsNullOrWhiteSpace(Lang) then begin
    visualNode.AppendFormat(' lang=''{0}''', Util.HttpEncode(Lang))
  end;
  if Branding <> TileBranding.Logo then begin
    visualNode.AppendFormat(' branding=''{0}''', Branding.ToString().ToLowerInvariant())
  end;
  if not String.IsNullOrWhiteSpace(BaseUri) then begin
    visualNode.AppendFormat(' baseUri=''{0}''', Util.HttpEncode(BaseUri))
  end;
  visualNode.Append('>');

  var builder: StringBuilder := new StringBuilder(String.Empty);
  builder.AppendFormat('<tile>{0}<binding template=''{1}''>{2}</binding>', visualNode, TemplateName, SerializeProperties(Lang, BaseUri));
  if SquareContent <> nil then begin
    var squareBase: ISquareTileInternal := ISquareTileInternal(SquareContent);
    if squareBase = nil then begin
      raise new NotificationContentValidationException('The provided square tile content class is unsupported.')
    end;
    builder.Append(squareBase.SerializeBinding(Lang, BaseUri, Branding))
  end;
  builder.Append('</visual></tile>');

  exit builder.ToString()
end;

constructor TileSquareBlock;
begin
  inherited constructor('TileSquareBlock', 0, 2);

end;

constructor TileSquareImage;
begin
  inherited constructor('TileSquareImage', 1, 0);

end;

constructor TileSquarePeekImageAndText01;
begin
  inherited constructor('TileSquarePeekImageAndText01', 1, 4);

end;

constructor TileSquarePeekImageAndText02;
begin
  inherited constructor('TileSquarePeekImageAndText02', 1, 2);

end;

constructor TileSquarePeekImageAndText03;
begin
  inherited constructor('TileSquarePeekImageAndText03', 1, 4);

end;

constructor TileSquarePeekImageAndText04;
begin
  inherited constructor('TileSquarePeekImageAndText04', 1, 1);

end;

constructor TileSquareText01;
begin
  inherited constructor('TileSquareText01', 0, 4);

end;

constructor TileSquareText02;
begin
  inherited constructor('TileSquareText02', 0, 2);

end;

constructor TileSquareText03;
begin
  inherited constructor('TileSquareText03', 0, 4);

end;

constructor TileSquareText04;
begin
  inherited constructor('TileSquareText04', 0, 1);

end;

constructor TileWideBlockAndText01;
begin
  inherited constructor('TileWideBlockAndText01', 0, 6);

end;

constructor TileWideBlockAndText02;
begin
  inherited constructor('TileWideBlockAndText02', 0, 6);

end;

constructor TileWideImage;
begin
  inherited constructor('TileWideImage', 1, 0);

end;

constructor TileWideImageAndText01;
begin
  inherited constructor('TileWideImageAndText01', 1, 1);

end;

constructor TileWideImageAndText02;
begin
  inherited constructor('TileWideImageAndText02', 1, 2);

end;

constructor TileWideImageCollection;
begin
  inherited constructor('TileWideImageCollection', 5, 0);

end;

constructor TileWidePeekImage01;
begin
  inherited constructor('TileWidePeekImage01', 1, 2);

end;

constructor TileWidePeekImage02;
begin
  inherited constructor('TileWidePeekImage02', 1, 5);

end;

constructor TileWidePeekImage03;
begin
  inherited constructor('TileWidePeekImage03', 1, 1);

end;

constructor TileWidePeekImage04;
begin
  inherited constructor('TileWidePeekImage04', 1, 1);

end;

constructor TileWidePeekImage05;
begin
  inherited constructor('TileWidePeekImage05', 2, 2);

end;

constructor TileWidePeekImage06;
begin
  inherited constructor('TileWidePeekImage06', 2, 1);

end;

constructor TileWidePeekImageAndText01;
begin
  inherited constructor('TileWidePeekImageAndText01', 1, 1);

end;

constructor TileWidePeekImageAndText02;
begin
  inherited constructor('TileWidePeekImageAndText02', 1, 5);

end;

constructor TileWidePeekImageCollection01;
begin
  inherited constructor('TileWidePeekImageCollection01', 5, 2);

end;

constructor TileWidePeekImageCollection02;
begin
  inherited constructor('TileWidePeekImageCollection02', 5, 5);

end;

constructor TileWidePeekImageCollection03;
begin
  inherited constructor('TileWidePeekImageCollection03', 5, 1);

end;

constructor TileWidePeekImageCollection04;
begin
  inherited constructor('TileWidePeekImageCollection04', 5, 1);

end;

constructor TileWidePeekImageCollection05;
begin
  inherited constructor('TileWidePeekImageCollection05', 6, 2);

end;

constructor TileWidePeekImageCollection06;
begin
  inherited constructor('TileWidePeekImageCollection06', 6, 1);

end;

constructor TileWideSmallImageAndText01;
begin
  inherited constructor('TileWideSmallImageAndText01', 1, 1);

end;

constructor TileWideSmallImageAndText02;
begin
  inherited constructor('TileWideSmallImageAndText02', 1, 5);

end;

constructor TileWideSmallImageAndText03;
begin
  inherited constructor('TileWideSmallImageAndText03', 1, 1);

end;

constructor TileWideSmallImageAndText04;
begin
  inherited constructor('TileWideSmallImageAndText04', 1, 2);

end;

constructor TileWideText01;
begin
  inherited constructor('TileWideText01', 0, 5);

end;

constructor TileWideText02;
begin
  inherited constructor('TileWideText02', 0, 9);

end;

constructor TileWideText03;
begin
  inherited constructor('TileWideText03', 0, 1);

end;

constructor TileWideText04;
begin
  inherited constructor('TileWideText04', 0, 1);

end;

constructor TileWideText05;
begin
  inherited constructor('TileWideText05', 0, 5);

end;

constructor TileWideText06;
begin
  inherited constructor('TileWideText06', 0, 10);

end;

constructor TileWideText07;
begin
  inherited constructor('TileWideText07', 0, 9);

end;

constructor TileWideText08;
begin
  inherited constructor('TileWideText08', 0, 10);

end;

constructor TileWideText09;
begin
  inherited constructor('TileWideText09', 0, 2);

end;

constructor TileWideText10;
begin
  inherited constructor('TileWideText10', 0, 9);

end;

constructor TileWideText11;
begin
  inherited constructor('TileWideText11', 0, 10);

end;

class method TileContentFactory.CreateTileSquareBlock: ITileSquareBlock;
begin
  exit new TileSquareBlock()
end;

class method TileContentFactory.CreateTileSquareImage: ITileSquareImage;
begin
  exit new TileSquareImage()
end;

class method TileContentFactory.CreateTileSquarePeekImageAndText01: ITileSquarePeekImageAndText01;
begin
  exit new TileSquarePeekImageAndText01()
end;

class method TileContentFactory.CreateTileSquarePeekImageAndText02: ITileSquarePeekImageAndText02;
begin
  exit new TileSquarePeekImageAndText02()
end;

class method TileContentFactory.CreateTileSquarePeekImageAndText03: ITileSquarePeekImageAndText03;
begin
  exit new TileSquarePeekImageAndText03()
end;

class method TileContentFactory.CreateTileSquarePeekImageAndText04: ITileSquarePeekImageAndText04;
begin
  exit new TileSquarePeekImageAndText04()
end;

class method TileContentFactory.CreateTileSquareText01: ITileSquareText01;
begin
  exit new TileSquareText01()
end;

class method TileContentFactory.CreateTileSquareText02: ITileSquareText02;
begin
  exit new TileSquareText02()
end;

class method TileContentFactory.CreateTileSquareText03: ITileSquareText03;
begin
  exit new TileSquareText03()
end;

class method TileContentFactory.CreateTileSquareText04: ITileSquareText04;
begin
  exit new TileSquareText04()
end;

class method TileContentFactory.CreateTileWideBlockAndText01: ITileWideBlockAndText01;
begin
  exit new TileWideBlockAndText01()
end;

class method TileContentFactory.CreateTileWideBlockAndText02: ITileWideBlockAndText02;
begin
  exit new TileWideBlockAndText02()
end;

class method TileContentFactory.CreateTileWideImage: ITileWideImage;
begin
  exit new TileWideImage()
end;

class method TileContentFactory.CreateTileWideImageAndText01: ITileWideImageAndText01;
begin
  exit new TileWideImageAndText01()
end;

class method TileContentFactory.CreateTileWideImageAndText02: ITileWideImageAndText02;
begin
  exit new TileWideImageAndText02()
end;

class method TileContentFactory.CreateTileWideImageCollection: ITileWideImageCollection;
begin
  exit new TileWideImageCollection()
end;

class method TileContentFactory.CreateTileWidePeekImage01: ITileWidePeekImage01;
begin
  exit new TileWidePeekImage01()
end;

class method TileContentFactory.CreateTileWidePeekImage02: ITileWidePeekImage02;
begin
  exit new TileWidePeekImage02()
end;

class method TileContentFactory.CreateTileWidePeekImage03: ITileWidePeekImage03;
begin
  exit new TileWidePeekImage03()
end;

class method TileContentFactory.CreateTileWidePeekImage04: ITileWidePeekImage04;
begin
  exit new TileWidePeekImage04()
end;

class method TileContentFactory.CreateTileWidePeekImage05: ITileWidePeekImage05;
begin
  exit new TileWidePeekImage05()
end;

class method TileContentFactory.CreateTileWidePeekImage06: ITileWidePeekImage06;
begin
  exit new TileWidePeekImage06()
end;

class method TileContentFactory.CreateTileWidePeekImageAndText01: ITileWidePeekImageAndText01;
begin
  exit new TileWidePeekImageAndText01()
end;

class method TileContentFactory.CreateTileWidePeekImageAndText02: ITileWidePeekImageAndText02;
begin
  exit new TileWidePeekImageAndText02()
end;

class method TileContentFactory.CreateTileWidePeekImageCollection01: ITileWidePeekImageCollection01;
begin
  exit new TileWidePeekImageCollection01()
end;

class method TileContentFactory.CreateTileWidePeekImageCollection02: ITileWidePeekImageCollection02;
begin
  exit new TileWidePeekImageCollection02()
end;

class method TileContentFactory.CreateTileWidePeekImageCollection03: ITileWidePeekImageCollection03;
begin
  exit new TileWidePeekImageCollection03()
end;

class method TileContentFactory.CreateTileWidePeekImageCollection04: ITileWidePeekImageCollection04;
begin
  exit new TileWidePeekImageCollection04()
end;

class method TileContentFactory.CreateTileWidePeekImageCollection05: ITileWidePeekImageCollection05;
begin
  exit new TileWidePeekImageCollection05()
end;

class method TileContentFactory.CreateTileWidePeekImageCollection06: ITileWidePeekImageCollection06;
begin
  exit new TileWidePeekImageCollection06()
end;

class method TileContentFactory.CreateTileWideSmallImageAndText01: ITileWideSmallImageAndText01;
begin
  exit new TileWideSmallImageAndText01()
end;

class method TileContentFactory.CreateTileWideSmallImageAndText02: ITileWideSmallImageAndText02;
begin
  exit new TileWideSmallImageAndText02()
end;

class method TileContentFactory.CreateTileWideSmallImageAndText03: ITileWideSmallImageAndText03;
begin
  exit new TileWideSmallImageAndText03()
end;

class method TileContentFactory.CreateTileWideSmallImageAndText04: ITileWideSmallImageAndText04;
begin
  exit new TileWideSmallImageAndText04()
end;

class method TileContentFactory.CreateTileWideText01: ITileWideText01;
begin
  exit new TileWideText01()
end;

class method TileContentFactory.CreateTileWideText02: ITileWideText02;
begin
  exit new TileWideText02()
end;

class method TileContentFactory.CreateTileWideText03: ITileWideText03;
begin
  exit new TileWideText03()
end;

class method TileContentFactory.CreateTileWideText04: ITileWideText04;
begin
  exit new TileWideText04()
end;

class method TileContentFactory.CreateTileWideText05: ITileWideText05;
begin
  exit new TileWideText05()
end;

class method TileContentFactory.CreateTileWideText06: ITileWideText06;
begin
  exit new TileWideText06()
end;

class method TileContentFactory.CreateTileWideText07: ITileWideText07;
begin
  exit new TileWideText07()
end;

class method TileContentFactory.CreateTileWideText08: ITileWideText08;
begin
  exit new TileWideText08()
end;

class method TileContentFactory.CreateTileWideText09: ITileWideText09;
begin
  exit new TileWideText09()
end;

class method TileContentFactory.CreateTileWideText10: ITileWideText10;
begin
  exit new TileWideText10()
end;

class method TileContentFactory.CreateTileWideText11: ITileWideText11;
begin
  exit new TileWideText11()
end;

end.
