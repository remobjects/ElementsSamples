namespace TileNotifications;

interface

uses
  System,
  System.Linq,
  System.Threading.Tasks,
  System.Collections.Generic,
  BadgeContent,
  Windows.Foundation,
  Windows.UI.Xaml,
  Windows.UI.Xaml.Controls,
  Windows.UI.Xaml.Data,

  Windows.UI.Notifications,

  NotificationsExtensions,
  NotificationsExtensions.BadgeContent,
  NotificationsExtensions.TileContent;

type
  MainPage = partial class
  private
    method TextTile_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
    method WebImage_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
    method ImageTile_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
    method ClearButton_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
    method timer_Tick(sender: Object; e: Object);
    timer: DispatcherTimer;
    count: Cardinal;
    rnd: Random;
  protected
  public
    constructor;

  end;
  
implementation

constructor MainPage;
begin
  InitializeComponent();
  timer := new DispatcherTimer;
  timer.Interval := new System.TimeSpan(0, 0, 1);
  timer.Tick += timer_Tick;
  timer.Start;
  rnd := new Random;
end;

method MainPage.ClearButton_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
begin
  TileUpdateManager.CreateTileUpdaterForApplication().Clear();
end;

method MainPage.TextTile_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
begin
  // Note: This sample contains an additional project, NotificationsExtensions.
  // NotificationsExtensions exposes an object model for creating notifications, but you can also modify the xml
  // of the notification directly using TileUpdateManager.GetTemplateContent(TileTemplateType)
            
  // create the wide template
  var tileContent := TileContentFactory.CreateTileWideText03;
  tileContent.TextHeadingWrap.Text := NotficationText.Text;

  // Users can resize tiles to square or wide.
  // Apps can choose to include only square assets (meaning the app's tile can never be wide), or
  // include both wide and square assets (the user can resize the tile to square or wide).
  // Apps cannot include only wide assets.

  // Apps that support being wide should include square tile notifications since users
  // determine the size of the tile.

  // create the square template and attach it to the wide template
  var squareContent := TileContentFactory.CreateTileSquareText04;
  squareContent.TextBodyWrap.Text := NotficationText.Text;
  tileContent.SquareContent := squareContent;

  // send the notification
  TileUpdateManager.CreateTileUpdaterForApplication.Update(tileContent.CreateNotification);

  //output.Text = tileContent.GetContent();

end;

method MainPage.ImageTile_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
begin
  // Note: This sample contains an additional project, NotificationsExtensions.
  // NotificationsExtensions exposes an object model for creating notifications, but you can also modify the xml
  // of the notification directly using TileUpdateManager.GetTemplateContent(TileTemplateType)

  // Create notification content based on a visual template.
  var tileContent := TileContentFactory.CreateTileWideImageAndText01();

  tileContent.TextCaptionWrap.Text := NotficationText.Text;
  tileContent.Image.Src := "ms-appx:///images/redWide.png";
  tileContent.Image.Alt := "Red image";

  // Users can resize tiles to square or wide.
  // Apps can choose to include only square assets (meaning the app's tile can never be wide), or
  // include both wide and square assets (the user can resize the tile to square or wide).
  // Apps should not include only wide assets.

  // Apps that support being wide should include square tile notifications since users
  // determine the size of the tile.

  // create the square template and attach it to the wide template
  var squareContent := TileContentFactory.CreateTileSquareImage();
  squareContent.Image.Src := "ms-appx:///images/graySquare.png";
  squareContent.Image.Alt := "Gray image";
  tileContent.SquareContent := squareContent;

  // Send the notification to the app's application tile.
  TileUpdateManager.CreateTileUpdaterForApplication().Update(tileContent.CreateNotification());
             
  //output.Text := tileContent.GetContent();
end;

method MainPage.WebImage_Click(sender: Object; e: Windows.UI.Xaml.RoutedEventArgs);
begin
  // Note: This sample contains an additional project, NotificationsExtensions.
  // NotificationsExtensions exposes an object model for creating notifications, but you can also modify the xml
  // of the notification directly using TileUpdateManager.GetTemplateContent(TileTemplateType)

  // Create notification content based on a visual template.
  var tileContent := TileContentFactory.CreateTileWideImageAndText01();

  tileContent.TextCaptionWrap.Text := "This tile notification uses web images.";

  // !Important!
  // The Internet (Client) capability must be checked in the manifest in the Capabilities tab
  // to display web images in tiles (either the http:// or https:// protocols)

  tileContent.Image.Src := WebUrl.Text;
  tileContent.Image.Alt := "Web image";

  // Users can resize tiles to square or wide.
  // Apps can choose to include only square assets (meaning the app's tile can never be wide), or
  // include both wide and square assets (the user can resize the tile to square or wide).
  // Apps cannot include only wide assets.

  // Apps that support being wide should include square tile notifications since users
  // determine the size of the tile.

  // Create square notification content based on a visual template.
  var squareContent := TileContentFactory.CreateTileSquareImage();

  squareContent.Image.Src := WebUrl.Text;
  squareContent.Image.Alt := "Web image";

  // include the square template.
  tileContent.SquareContent := squareContent;

  // send the notification to the app's application tile
  TileUpdateManager.CreateTileUpdaterForApplication().Update(tileContent.CreateNotification());

  //output.Text = tileContent.GetContent();

end;

method MainPage.timer_Tick(sender: Object; e: Object);
begin
  count := count + 1;
  var badgeContent : IBadgeNotificationContent;
  if rnd.Next(3) = 1 then 
    badgeContent := new BadgeGlyphNotificationContent(GlyphValue(rnd.Next(10) + 1))
  else
    badgeContent := new BadgeNumericNotificationContent(count);

  BadgeUpdateManager.CreateBadgeUpdaterForApplication().Update(badgeContent.CreateNotification());
end;

end.
