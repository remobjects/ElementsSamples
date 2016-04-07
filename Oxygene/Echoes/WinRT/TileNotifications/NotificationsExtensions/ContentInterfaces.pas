namespace BadgeContent;

interface

uses
  Windows.UI.Notifications,
  Windows.Data.Xml.Dom;

type
  /// <summary>
  /// Base notification content interface to retrieve notification Xml as a string.
  /// </summary>
  INotificationContent = public interface
/// <summary>
/// Retrieves the notification Xml content as a string.
/// </summary>
/// <returns>The notification Xml content as a string.</returns>
    method GetContent: String;

/// <summary>
/// Retrieves the notification Xml content as a WinRT Xml document.
/// </summary>
/// <returns>The notification Xml content as a WinRT Xml document.</returns>
    method GetXml: XmlDocument;
  end;


  /// <summary>
  /// A type contained by the tile and toast notification content objects that
  /// represents a text field in the template.
  /// </summary>
  INotificationContentText = public interface
   /// <summary>
   /// The text value that will be shown in the text field.
   /// </summary>
   property Text: String read write;

/// <summary>
/// The language of the text field.  This proprety overrides the language provided in the
/// containing notification object.  The language should be specified using the
/// abbreviated language code as defined by BCP 47.
    /// </summary>
    property Lang: String read write;
  end;


  /// <summary>
  /// A type contained by the tile and toast notification content objects that
  /// represents an image in a template.
  /// </summary>
  INotificationContentImage = public interface
    /// <summary>
    /// The location of the image.  Relative image paths use the BaseUri provided in the containing
    /// notification object.  If no BaseUri is provided, paths are relative to ms-appx:///.
    /// Only png and jpg images are supported.  Images must be 800x800 pixels or less, and smaller than
    /// 150 kB in size.
    /// </summary>
    property Src: String read write;

    /// <summary>
    /// Alt text that describes the image.
    /// </summary>
    property Alt: String read write;
  end;


type
  /// <summary>
  /// Base tile notification content interface.
  /// </summary>
  ITileNotificationContent = public interface(INotificationContent)
    /// <summary>
    /// Whether strict validation should be applied when the Xml or notification object is created,
    /// and when some of the properties are assigned.
    /// </summary>
    property StrictValidation: Boolean read write;

    /// <summary>
    /// The language of the content being displayed.  The language should be specified using the
    /// abbreviated language code as defined by BCP 47.
    /// </summary>
    property Lang: String read write;

    /// <summary>
    /// The BaseUri that should be used for image locations.  Relative image locations use this
    /// field as their base Uri.  The BaseUri must begin with http://, https://, ms-appx:///, or 
    /// ms-appdata:///local/.
    /// </summary>
    property BaseUri: String read write;

    /// <summary>
    /// Determines the application branding when tile notification content is displayed on the tile.
    /// </summary>
    property Branding: TileBranding read write;

    /// <summary>
    /// Creates a WinRT TileNotification object based on the content.
    /// </summary>
    /// <returns>The WinRT TileNotification object</returns>
    method CreateNotification: TileNotification;
  end;


  /// <summary>
  /// Base square tile notification content interface.
  /// </summary>
  ISquareTileNotificationContent = public interface(ITileNotificationContent)
  end;


  /// <summary>
  /// Base wide tile notification content interface.
  /// </summary>
  IWideTileNotificationContent = public interface(ITileNotificationContent)
    /// <summary>
    /// Corresponding square tile notification content should be a part of every wide tile notification.
    /// </summary>
    property SquareContent: ISquareTileNotificationContent read write;

    /// <summary>
    /// Whether square tile notification content needs to be added to pass
    /// validation.  Square content is required by default.
    /// </summary>
    property RequireSquareContent: Boolean read write;
  end;


  /// <summary>
  /// A square tile template that displays two text captions.
  /// </summary>
  ITileSquareBlock = public interface(ISquareTileNotificationContent)
    /// <summary>
    /// A large block text field.
    /// </summary>
    property TextBlock: INotificationContentText read;

    /// <summary>
    /// The description under the large block text field.
    /// </summary>
    property TextSubBlock: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays an image.
  /// </summary>
  ITileSquareImage = public interface(ISquareTileNotificationContent)
    /// <summary>
    /// The main image on the tile.
    /// </summary>
    property Image: INotificationContentImage read;
  end;


  /// <summary>
  /// A square tile template that displays an image, then transitions to show
  /// four text fields.
  /// </summary>
  ITileSquarePeekImageAndText01 = public interface(ISquareTileNotificationContent)
    /// <summary>
    /// The main image on the tile.
    /// </summary>
    property Image: INotificationContentImage read;

    /// <summary>
    /// A heading text field.
    /// </summary>
    property TextHeading: INotificationContentText read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBody1: INotificationContentText read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBody2: INotificationContentText read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBody3: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays an image, then transitions to show
  /// two text fields.
  /// </summary>
  ITileSquarePeekImageAndText02 = public interface(ISquareTileNotificationContent)
    /// <summary>
    /// The main image on the tile.
    /// </summary>
    property Image: INotificationContentImage read;

    /// <summary>
    /// A heading text field.
    /// </summary>
    property TextHeading: INotificationContentText read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays an image, then transitions to show
  /// four text fields.
  /// </summary>
  ITileSquarePeekImageAndText03 = public interface(ISquareTileNotificationContent)
    /// <summary>
    /// The main image on the tile.
    /// </summary>
    property Image: INotificationContentImage read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBody1: INotificationContentText read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBody2: INotificationContentText read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBody3: INotificationContentText read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBody4: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays an image, then transitions to 
  /// show a text field.
  /// </summary>
  ITileSquarePeekImageAndText04 = public interface(ISquareTileNotificationContent)
    /// <summary>
    /// The main image on the tile.
    /// </summary>
    property Image: INotificationContentImage read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays four text fields.
  /// </summary>
  ITileSquareText01 = public interface(ISquareTileNotificationContent)
    /// <summary>
    /// A heading text field.
    /// </summary>
    property TextHeading: INotificationContentText read;

    /// <summary>
    /// A body text field.
    /// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;
  end;


/// <summary>
/// A square tile template that displays two text fields.
/// </summary>
  ITileSquareText02 = public interface(ISquareTileNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays four text fields.
  /// </summary>
  ITileSquareText03 = public interface(ISquareTileNotificationContent)
/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody4: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays a text field.
  /// </summary>
  ITileSquareText04 = public interface(ISquareTileNotificationContent)
/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays six text fields.
  /// </summary>
  ITileWideBlockAndText01 = public interface(IWideTileNotificationContent)
/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody4: INotificationContentText read;

/// <summary>
/// A large block text field.
/// </summary>
    property TextBlock: INotificationContentText read;

/// <summary>
/// The description under the large block text field.
/// </summary>
    property TextSubBlock: INotificationContentText read;
  end;


  /// <summary>
  /// A square tile template that displays three text fields.
  /// </summary>
  ITileWideBlockAndText02 = public interface(IWideTileNotificationContent)
/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;

/// <summary>
/// A large block text field.
/// </summary>
    property TextBlock: INotificationContentText read;

/// <summary>
/// The description under the large block text field.
/// </summary>
    property TextSubBlock: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image.
  /// </summary>
  ITileWideImage = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;
  end;


  /// <summary>
  /// A wide tile template that displays an image and a text caption.
  /// </summary>
  ITileWideImageAndText01 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A caption for the image.
/// </summary>
    property TextCaptionWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image and two text captions.
  /// </summary>
  ITileWideImageAndText02 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// The first caption for the image.
/// </summary>
    property TextCaption1: INotificationContentText read;

/// <summary>
/// The second caption for the image.
/// </summary>
    property TextCaption2: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays five images - one main image,
  /// and four square images in a grid.
  /// </summary>
  ITileWideImageCollection = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property ImageMain: INotificationContentImage read;

/// <summary>
/// A small square image on the tile.
/// </summary>
    property ImageSmallColumn1Row1: INotificationContentImage read;

/// <summary>
/// A small square image on the tile.
/// </summary>
    property ImageSmallColumn2Row1: INotificationContentImage read;

/// <summary>
/// A small square image on the tile.
/// </summary>
    property ImageSmallColumn1Row2: INotificationContentImage read;

/// <summary>
/// A small square image on the tile.
/// </summary>
    property ImageSmallColumn2Row2: INotificationContentImage read;
  end;


  /// <summary>
  /// A wide tile template that displays an image, then transitions to show
  /// two text fields.
  /// </summary>
  ITileWidePeekImage01 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image, then transitions to show
  /// five text fields.
  /// </summary>
  ITileWidePeekImage02 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody4: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image, then transitions to show
  /// a text field.
  /// </summary>
  ITileWidePeekImage03 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeadingWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image, then transitions to show
  /// a text field.
  /// </summary>
  ITileWidePeekImage04 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image, then transitions to show
  /// another image and two text fields.
  /// </summary>
  ITileWidePeekImage05 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property ImageMain: INotificationContentImage read;

/// <summary>
/// The secondary image on the tile.
/// </summary>
    property ImageSecondary: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image, then transitions to show
  /// another image and a text field.
  /// </summary>
  ITileWidePeekImage06 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property ImageMain: INotificationContentImage read;

/// <summary>
/// The secondary image on the tile.
/// </summary>
    property ImageSecondary: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeadingWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image and a portion of a text field,
  /// then transitions to show all of the text field.
  /// </summary>
  ITileWidePeekImageAndText01 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays an image and a text field,
  /// then transitions to show the text field and four other text fields.
  /// </summary>
  ITileWidePeekImageAndText02 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody4: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody5: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays five images - one main image,
  /// and four square images in a grid, then transitions to show two
  /// text fields.
  /// </summary>
  ITileWidePeekImageCollection01 = public interface(ITileWideImageCollection)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays five images - one main image,
  /// and four square images in a grid, then transitions to show five
  /// text fields.
  /// </summary>
  ITileWidePeekImageCollection02 = public interface(ITileWideImageCollection)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody4: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays five images - one main image,
  /// and four square images in a grid, then transitions to show a
  /// text field.
  /// </summary>
  ITileWidePeekImageCollection03 = public interface(ITileWideImageCollection)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeadingWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays five images - one main image,
  /// and four square images in a grid, then transitions to show a
  /// text field.
  /// </summary>
  ITileWidePeekImageCollection04 = public interface(ITileWideImageCollection)
/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays five images - one main image,
  /// and four square images in a grid, then transitions to show an image
  /// and two text fields.
  /// </summary>
  ITileWidePeekImageCollection05 = public interface(ITileWideImageCollection)
/// <summary>
/// The secondary image on the tile.
/// </summary>
    property ImageSecondary: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


/// <summary>
/// A wide tile template that displays five images - one main image,
/// and four square images in a grid, then transitions to show an image
/// and a text field.
/// </summary>
  ITileWidePeekImageCollection06 = public interface(ITileWideImageCollection)
/// <summary>
/// The secondary image on the tile.
/// </summary>
    property ImageSecondary: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeadingWrap: INotificationContentText read;
  end;


/// <summary>
/// A wide tile template that displays an image and a text field.
/// </summary>
  ITileWideSmallImageAndText01 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeadingWrap: INotificationContentText read;
  end;


/// <summary>
/// A wide tile template that displays an image and 5 text fields.
/// </summary>
  ITileWideSmallImageAndText02 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody4: INotificationContentText read;
  end;


/// <summary>
/// A wide tile template that displays an image and a text field.
/// </summary>
  ITileWideSmallImageAndText03 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


/// <summary>
/// A wide tile template that displays an image and two text fields.
/// </summary>
  ITileWideSmallImageAndText04 = public interface(IWideTileNotificationContent)
/// <summary>
/// The main image on the tile.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


/// <summary>
/// A wide tile template that displays five text fields.
/// </summary>
  ITileWideText01 = public interface(IWideTileNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody4: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays nine text fields - a heading and two columns
  /// of four text fields.
  /// </summary>
  ITileWideText02 = public interface(IWideTileNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row4: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays a text field.
  /// </summary>
  ITileWideText03 = public interface(IWideTileNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeadingWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays a text field.
  /// </summary>
  ITileWideText04 = public interface(IWideTileNotificationContent)
/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays five text fields.
  /// </summary>
  ITileWideText05 = public interface(IWideTileNotificationContent)
/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody3: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody4: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody5: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays ten text fields - two columns
  /// of five text fields.
  /// </summary>
  ITileWideText06 = public interface(IWideTileNotificationContent)
/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn1Row5: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row5: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays nine text fields - a heading and two columns
  /// of four text fields.
  /// </summary>
  ITileWideText07 = public interface(IWideTileNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row4: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays ten text fields - two columns
  /// of five text fields.
  /// </summary>
  ITileWideText08 = public interface(IWideTileNotificationContent)
/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextShortColumn1Row5: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row5: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays two text fields.
  /// </summary>
  ITileWideText09 = public interface(IWideTileNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays nine text fields - a heading and two columns
  /// of four text fields.
  /// </summary>
  ITileWideText10 = public interface(IWideTileNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row4: INotificationContentText read;
  end;


  /// <summary>
  /// A wide tile template that displays ten text fields - two columns
  /// of five text fields.
  /// </summary>
  ITileWideText11 = public interface(IWideTileNotificationContent)
/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row1: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row2: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row3: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row4: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextPrefixColumn1Row5: INotificationContentText read;

/// <summary>
/// A text field displayed in a column and row.
/// </summary>
    property TextColumn2Row5: INotificationContentText read;
  end;


  /// <summary>
  /// The types of behavior that can be used for application branding when
  /// tile notification content is displayed on the tile.
  /// </summary>
  TileBranding = public enum(/// <summary>
/// No application branding will be displayed on the tile content.
/// </summary>

    None = 0, /// <summary>
/// The application logo will be displayed with the tile content.
/// </summary>

    Logo, /// <summary>
/// The application name will be displayed with the tile content.
/// </summary>

    Name
  );

type
  /// <summary>
  /// Type representing the toast notification audio properties which is contained within
  /// a toast notification content object.
  /// </summary>
  IToastAudio = public interface
/// <summary>
/// The audio content that should be played when the toast is shown.
/// </summary>
    property Content: ToastAudioContent read write;

/// <summary>
/// Whether the audio should loop.  If this property is set to true, the toast audio content
/// must be a looping sound.
/// </summary>
    property &Loop: Boolean read write;
  end;


  /// <summary>
  /// Base toast notification content interface.
  /// </summary>
  IToastNotificationContent = public interface(INotificationContent)
/// <summary>
/// Whether strict validation should be applied when the Xml or notification object is created,
/// and when some of the properties are assigned.
/// </summary>
    property StrictValidation: Boolean read write;

/// <summary>
/// The language of the content being displayed.  The language should be specified using the
/// abbreviated language code as defined by BCP 47.
/// </summary>
    property Lang: String read write;

/// <summary>
/// The BaseUri that should be used for image locations.  Relative image locations use this
/// field as their base Uri.  The BaseUri must begin with http://, https://, ms-appx:///, or 
/// ms-appdata:///local/.
/// </summary>
    property BaseUri: String read write;

/// <summary>
/// The launch parameter passed into the metro application when the toast is activated.
/// </summary>
    property Launch: String read write;

/// <summary>
/// The audio that should be played when the toast is displayed.
/// </summary>
    property Audio: IToastAudio read;

/// <summary>
/// The length that the toast should be displayed on screen.
/// </summary>
    property Duration: ToastDuration read write;

/// <summary>
/// Creates a WinRT ToastNotification object based on the content.
/// </summary>
/// <returns>A WinRT ToastNotification object based on the content.</returns>
    method CreateNotification: ToastNotification;
  end;


  /// <summary>
  /// The audio options that can be played while the toast is on screen.
  /// </summary>
  ToastAudioContent = public enum(    
/// <summary>
/// The default toast audio sound.
/// </summary>
    &Default = 0,     

/// <summary>
/// Audio that corresponds to new mail arriving.
/// </summary>
    Mail,     
    
/// <summary>
/// Audio that corresponds to a new SMS message arriving.
/// </summary>
    SMS,     
    
/// <summary>
/// Audio that corresponds to a new IM arriving.
/// </summary>
    IM,     
    
/// <summary>
/// Audio that corresponds to a reminder.
/// </summary>
    Reminder,     
    
/// <summary>
/// The default looping sound.  Audio that corresponds to a call.
/// Only valid for toasts that are have the duration set to "Long".
/// </summary>
    LoopingCall,     
    
/// <summary>
/// Audio that corresponds to a call.
/// Only valid for toasts that are have the duration set to "Long".
/// </summary>
    LoopingCall2,     
    
/// <summary>
/// Audio that corresponds to an alarm.
/// Only valid for toasts that are have the duration set to "Long".
/// </summary>
    LoopingAlarm,     
    
/// <summary>
/// Audio that corresponds to an alarm.
/// Only valid for toasts that are have the duration set to "Long".
/// </summary>
    LoopingAlarm2,     
    
/// <summary>
/// No audio should be played when the toast is displayed.
/// </summary>
    Silent
  );

  /// <summary>
  /// The duration the toast should be displayed on screen.
  /// </summary>
  ToastDuration = public enum(    
  
/// <summary>
/// Default behavior.  The toast will be on screen for a short amount of time.
/// </summary>
    Short = 0,     
    
/// <summary>
/// The toast will be on screen for a longer amount of time.
/// </summary>
    Long
  );

  /// <summary>
  /// A toast template that displays an image and a text field.
  /// </summary>
  IToastImageAndText01 = public interface(IToastNotificationContent)
/// <summary>
/// The main image on the toast.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A toast template that displays an image and two text fields.
  /// </summary>
  IToastImageAndText02 = public interface(IToastNotificationContent)
/// <summary>
/// The main image on the toast.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A toast template that displays an image and two text fields.
  /// </summary>
  IToastImageAndText03 = public interface(IToastNotificationContent)
/// <summary>
/// The main image on the toast.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeadingWrap: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody: INotificationContentText read;
  end;


  /// <summary>
  /// A toast template that displays an image and three text fields.
  /// </summary>
  IToastImageAndText04 = public interface(IToastNotificationContent)
/// <summary>
/// The main image on the toast.
/// </summary>
    property Image: INotificationContentImage read;

/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;
  end;


  /// <summary>
  /// A toast template that displays a text fields.
  /// </summary>
  IToastText01 = public interface(IToastNotificationContent)
/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A toast template that displays two text fields.
  /// </summary>
  IToastText02 = public interface(IToastNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBodyWrap: INotificationContentText read;
  end;


  /// <summary>
  /// A toast template that displays two text fields.
  /// </summary>
  IToastText03 = public interface(IToastNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeadingWrap: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody: INotificationContentText read;
  end;


  /// <summary>
  /// A toast template that displays three text fields.
  /// </summary>
  IToastText04 = public interface(IToastNotificationContent)
/// <summary>
/// A heading text field.
/// </summary>
    property TextHeading: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody1: INotificationContentText read;

/// <summary>
/// A body text field.
/// </summary>
    property TextBody2: INotificationContentText read;
  end;


type
  /// <summary>
  /// Base badge notification content interface.
  /// </summary>
  IBadgeNotificationContent = public interface(INotificationContent)
/// <summary>
/// Creates a WinRT BadgeNotification object based on the content.
/// </summary>
/// <returns>A WinRT BadgeNotification object based on the content.</returns>
    method CreateNotification: BadgeNotification;
  end;


  /// <summary>
  /// The types of glyphs that can be placed on a badge.
  /// </summary>
  GlyphValue = public enum(    
/// <summary>
/// No glyph.  If there is a numeric badge, or a glyph currently on the badge,
/// it will be removed.
/// </summary>
    None = 0,     
    
/// <summary>
/// A glyph representing application activity.
/// </summary>
    Activity,     
    
/// <summary>
/// A glyph representing an alert.
/// </summary>
    Alert,     
    
/// <summary>
/// A glyph representing availability status.
/// </summary>
    Available,     
    
/// <summary>
/// A glyph representing away status
/// </summary>
    Away,     
    
/// <summary>
/// A glyph representing busy status.
/// </summary>
    Busy,     
    
/// <summary>
/// A glyph representing that a new message is available.
/// </summary>
    NewMessage,     
    
/// <summary>
/// A glyph representing that media is paused.
/// </summary>
    Paused,     
    
/// <summary>
/// A glyph representing that media is playing.
/// </summary>
    Playing,     
    
/// <summary>
/// A glyph representing unavailable status.
/// </summary>
    Unavailable,     
    
/// <summary>
/// A glyph representing an error.
/// </summary>
    Error
  );

implementation


end.
