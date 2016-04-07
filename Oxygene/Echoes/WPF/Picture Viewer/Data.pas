namespace PictureViewer;

interface

uses 
  System.IO,
  System.Windows.Media.Imaging,
  System.Collections.ObjectModel;

type
  
  ImageFile = public class
  private
    fImage: BitmapFrame;
    fUri: Uri;
    fPath: String;
  protected
  public
    constructor (aPath: String); 
    method ToString(): String; override;   
    property Path: String read fPath;
    property Uri: Uri read fUri;
    property Image: BitmapFrame read fImage;
  end;
  
  ImageList = public class(ObservableCollection<ImageFile>)
  private
    
    fDirectory: DirectoryInfo;
    method get_Path: String;
    method SetPath(value: String);
    method SetDirectory(value: DirectoryInfo);
    method Update();
  public
    constructor; 
    constructor(aPath: String); 
    constructor(aDirectory: DirectoryInfo); 
    property Directory: DirectoryInfo read fDirectory write SetDirectory;
    property Path: String read get_Path write SetPath; 
  end; 
  
implementation

constructor ImageFile(aPath: String);
begin
  fPath := aPath;
  fUri := new Uri(fPath);
  fImage := BitmapFrame.Create(fUri);
end;

method ImageFile.ToString(): String;
begin
  exit(Path);
end;

constructor ImageList(); 
begin
  
end;

constructor ImageList(aDirectory: DirectoryInfo); 
begin
  Directory := aDirectory;
end;

constructor ImageList(aPath: String); 
begin
  constructor(new DirectoryInfo(aPath));
end;



method ImageList.SetDirectory(value: DirectoryInfo);
begin
  fDirectory := value;
  Update();
end;

method ImageList.Update();
begin
  for each f: FileInfo in fDirectory.GetFiles('*.jpg') do begin
    &Add(new ImageFile(f.FullName));
  end;
end;

method ImageList.SetPath(value: String);
begin
  fDirectory := new DirectoryInfo(value);
  Update();
end;
  
method ImageList.get_Path: String;
begin
  exit(fDirectory.FullName);
end;

end.