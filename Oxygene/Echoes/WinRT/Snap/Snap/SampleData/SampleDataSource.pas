namespace SnapTileSample;

interface

uses
  System,
  System.Collections.Generic,
  System.Linq,
  System.Text,
  Windows.UI.Xaml.Media,
  System,
  Windows.UI.Xaml.Data,
  Windows.UI.Xaml.Media,
  Windows.UI.Xaml.Media.Imaging;

type
  Item = public class(System.ComponentModel.INotifyPropertyChanged)
  public
    event PropertyChanged: System.ComponentModel.PropertyChangedEventHandler;

  protected
    method OnPropertyChanged(propertyName: System.String); virtual;

  private
    var     _Title: System.String := System.String.Empty;
  public
    property Title: System.String read self._Title write set_Title;

    method set_Title(value: System.String);

  private
    var     _Subtitle: System.String := System.String.Empty;
  public
    property Subtitle: System.String read self._Subtitle write set_Subtitle;

    method set_Subtitle(value: System.String);

  private
    var     _Image: ImageSource := nil;
  public
    property Image: ImageSource read self._Image write set_Image;

    method set_Image(value: ImageSource);

    method SetImage(baseUri: Uri; path: String);

  private
    var     _Link: System.String := System.String.Empty;
  public
    property Link: System.String read self._Link write set_Link;

    method set_Link(value: System.String);

  private
    var     _Category: System.String := System.String.Empty;
  public
    property Category: System.String read self._Category write set_Category;

    method set_Category(value: System.String);

  private
    var     _Description: System.String := System.String.Empty;
  public
    property Description: System.String read self._Description write set_Description;

    method set_Description(value: System.String);

  private
    var     _Content: System.String := System.String.Empty;
  public
    property Content: System.String read self._Content write set_Content;

    method set_Content(value: System.String);
  end;


  GroupInfoList<T> = public class(List<System.Object>)

  public
    property Key: System.Object;


    method GetEnumerator: IEnumerator<System.Object>; reintroduce;
  end;



  DataSource = public class
  public
    constructor ;

  private
    var     _Collection: ItemCollection := new ItemCollection();

  public
    property Collection: ItemCollection read _Collection;

  assembly
    method GetGroupsByCategory: List<GroupInfoList<System.Object>>;

    method GetGroupsByLetter: List<GroupInfoList<System.Object>>;
  end;

  // Workaround: data binding works best with an enumeration of objects that does not implement IList
  ItemCollection = public class(IEnumerable<Item>)
  private
    var     itemCollection: System.Collections.ObjectModel.ObservableCollection<Item> := new System.Collections.ObjectModel.ObservableCollection<Item>();

  public
    method GetEnumerator: IEnumerator<Item>;

  private
    method GetEnumeratorOld: System.Collections.IEnumerator; implements System.Collections.IEnumerable.GetEnumerator; 

  public
    method &Add(item: Item);
  end;


implementation


method Item.OnPropertyChanged(propertyName: System.String);
begin
  if self.PropertyChanged <> nil then begin
    self.PropertyChanged(self, new System.ComponentModel.PropertyChangedEventArgs(propertyName))
  end
end;

method Item.set_Title(value: System.String); begin
  if self._Title <> value then begin
    self._Title := value;
    self.OnPropertyChanged('Title')
  end
end;

method Item.set_Subtitle(value: System.String); begin
  if self._Subtitle <> value then begin
    self._Subtitle := value;
    self.OnPropertyChanged('Subtitle')
  end
end;

method Item.set_Image(value: ImageSource); begin
  if self._Image <> value then begin
    self._Image := value;
    self.OnPropertyChanged('Image')
  end
end;

method Item.SetImage(baseUri: Uri; path: String);
begin
  Image := new BitmapImage(new Uri(baseUri, path))
end;

method Item.set_Link(value: System.String); begin
  if self._Link <> value then begin
    self._Link := value;
    self.OnPropertyChanged('Link')
  end
end;

method Item.set_Category(value: System.String); begin
  if self._Category <> value then begin
    self._Category := value;
    self.OnPropertyChanged('Category')
  end
end;

method Item.set_Description(value: System.String); begin
  if self._Description <> value then begin
    self._Description := value;
    self.OnPropertyChanged('Description')
  end
end;

method Item.set_Content(value: System.String); begin
  if self._Content <> value then begin
    self._Content := value;
    self.OnPropertyChanged('Content')
  end
end;

method GroupInfoList<T>.GetEnumerator: IEnumerator<System.Object>;
begin
  exit System.Collections.Generic.IEnumerator<System.Object>(inherited GetEnumerator())
end;

constructor DataSource;
begin
  var item: Item;
  var LONG_LOREM_IPSUM: String := String.Format('{0}'#10#10'{0}'#10#10'{0}'#10#10'{0}', 'Curabitur class aliquam vestibulum nam curae maecenas sed integer cras phasellus suspendisse quisque donec dis praesent accumsan bibendum pellentesque condimentum adipiscing etiam consequat vivamus dictumst aliquam duis convallis scelerisque est parturient ullamcorper aliquet fusce suspendisse nunc hac eleifend amet blandit facilisi condimentum commodo scelerisque faucibus aenean ullamcorper ante mauris dignissim consectetuer nullam lorem vestibulum habitant conubia elementum pellentesque morbi facilisis arcu sollicitudin diam cubilia aptent vestibulum auctor eget dapibus pellentesque inceptos leo egestas interdum nulla consectetuer suspendisse adipiscing pellentesque proin lobortis sollicitudin augue elit mus congue fermentum parturient fringilla euismod feugiat');
  var _baseUri: Uri := new Uri('ms-appx:///');

  item := new Item(
    Title := 'Data Abstract',
    Subtitle := 'Data Abstract for Java',
    Link := 'http://www.remobjects.com/da/java',
    Category := 'Java',
    Description := 'Premier multi-tier data access.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/da.png');
  Collection.Add(item);

  item := new Item(
    Title := 'Data Abstract',
    Subtitle := 'Data Abstract for .NET',
    Link := 'http://www.remobjects.com/da/net',
    Category := '.NET',
    Description := 'Premier multi-tier data access.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/da.png');
  Collection.Add(item);

  item := new Item(
    Title := 'Data Abstract',
    Subtitle := 'Data Abstract for Delphi',
    Link := 'http://www.remobjects.com/da/delphi',
    Category := 'Delphi',
    Description := 'Premier multi-tier data access.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/da.png');
  Collection.Add(item);

  item := new Item(
    Title := 'Data Abstract',
    Subtitle := 'Data Abstract for Xcode',
    Link := 'http://www.remobjects.com/da/xcode',
    Category := 'Xcode',
    Description := 'Premier multi-tier data access.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/da.png');
  Collection.Add(item);

  item := new Item(
    Title := 'RemObjects SDK',
    Subtitle := 'Data Abstract for Xcode',
    Link := 'http://www.remobjects.com/ro/xcode',
    Category := 'Xcode',
    Description := 'Award-winning cross-platform remoting.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/ro.png');
  Collection.Add(item);

  item := new Item(
    Title := 'RemObjects SDK',
    Subtitle := 'Data Abstract for Delphi',
    Link := 'http://www.remobjects.com/ro/delphi',
    Category := 'Delphi',
    Description := 'Award-winning cross-platform remoting.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/ro.png');
  Collection.Add(item);

  item := new Item(
    Title := 'RemObjects SDK',
    Subtitle := 'Data Abstract for Java',
    Link := 'http://www.remobjects.com/ro/java',
    Category := 'Java',
    Description := 'Award-winning cross-platform remoting.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/ro.png');
  Collection.Add(item);

  item := new Item(
    Title := 'RemObjects SDK',
    Subtitle := 'Data Abstract for .NET',
    Link := 'http://www.remobjects.com/ro/net',
    Category := '.NET',
    Description := 'Award-winning cross-platform remoting.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/ro.png');
  Collection.Add(item);

  item := new Item(
    Title := 'Oxygene',
    Subtitle := 'Oxygene for .NET',
    Link := 'http://www.remobjects.com/oxygene/net',
    Category := '.NET',
    Description := 'Next Generation Object Pascal for .NET.',
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/oxygene.png');
  Collection.Add(item);

  item := new Item(
    Title := 'Oxygene',
    Subtitle := 'Oxygene for Java',
    Link := 'http://www.remobjects.com/oxygene/java',
    Category := 'Java',
    Description := "This is Not your daddy's Pascal!",
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/oxygene.png');
  Collection.Add(item);

  item := new Item(
    Title := 'Hydra',
    Subtitle := 'Hydra for Delphi and .NET',
    Link := 'http://www.remobjects.com/hydra',
    Category := 'Delphi',
    Description := "Why choose? Mix Delphi & .NET!",
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/hydra.png');
  Collection.Add(item);

  item := new Item(
    Title := 'Oxfuscator',
    Subtitle := 'Oxfuscator for .NET',
    Link := 'http://www.remobjects.com/oxfuscator',
    Category := '.NET',
    Description := "Assembly Obfuscation for .NET",
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/oxfuscator.png');
  Collection.Add(item);

  item := new Item(
    Title := 'Pascal Script',
    Subtitle := 'RemObjects Pascal Script',
    Link := 'http://www.remobjects.com/ps',
    Category := 'Delphi',
    Description := "A Pascal-based scripting language for Delphi.",
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/pascalscript.png');
  Collection.Add(item);

  item := new Item(
    Title := 'RemObjects Script',
    Subtitle := '(ECMAScript) JavaScript',
    Link := 'http://www.remobjects.com/script',
    Category := '.NET',
    Description := "100% native script engine for .NET.",
    Content := LONG_LOREM_IPSUM);
  item.SetImage(_baseUri, 'SampleData/Images/script.png');
  Collection.Add(item);

end;

method DataSource.GetGroupsByCategory: List<GroupInfoList<System.Object>>;
begin
  var groups: List<GroupInfoList<System.Object>> := new List<GroupInfoList<System.Object>>();

  var query :=  from item in Collection 
                order by item.Category asc 
                group item by item.Category into g 
                select new class (GroupName := g.Key, Items := g);

  for each g in query do begin
    var info: GroupInfoList<System.Object> := new GroupInfoList<System.Object>();
    info.Key := g.GroupName;
    for each item in g.Items do begin
      info.Add(item)
    end;
    groups.Add(info)
  end;

  exit groups
end;


method DataSource.GetGroupsByLetter: List<GroupInfoList<System.Object>>;
begin
  var groups: List<GroupInfoList<System.Object>> := new List<GroupInfoList<System.Object>>();

  var query :=  from item in Collection 
                order by item.Title asc 
                group item by item.Title[0] into g 
                select new class (GroupName := g.Key, 
  Items := g
  );
  for each g in query do begin
    var info: GroupInfoList<System.Object> := new GroupInfoList<System.Object>();
    info.Key := g.GroupName;
    for each item in g.Items do begin
      info.Add(item)
    end;
    groups.Add(info)
  end;

  exit groups
end;

method ItemCollection.GetEnumerator: IEnumerator<Item>;
begin
  exit itemCollection.GetEnumerator()
end;

method ItemCollection.GetEnumeratorOld: System.Collections.IEnumerator;
begin
  exit itemCollection.GetEnumerator()
end;

method ItemCollection.&Add(item: Item);
begin
  itemCollection.Add(item)
end;

end.
