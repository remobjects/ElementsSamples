namespace ZipTest;
uses
  Foundation,
  RemObjects.Elements.RTL;

{A class to show the uses of
 NSURL
 NSFileManager
 NSFileCoordinator
 to create a Zipfile from a foldee
}
type
  Zipper = public static class
  private
    method zip(const sourcedir : String; const dest : String ) : NSURL;
    begin
      var zippedURL := new NSURL(dest);
      var SourceUrl := new NSURL(sourcedir);
      var fm := NSFileManager.defaultManager();
      var coord := new NSFileCoordinator();
      var lerror: NSError;

      coord.coordinateReadingItemAtURL(SourceUrl)
             options(NSFileCoordinatorReadingOptions.ForUploading)
             error(var lerror)
             byAccessor(
             method(newURL : NSURL)
             begin
                 if newURL <> nil then
                   fm.copyItemAtURL(newURL) toURL(zippedURL) error(var lerror);
             end
             );
      exit zippedURL;
    end;

  public
    method dozip(const sourcedir : not nullable String; const dest : not nullable String ) : String;
    begin
      {Check if the Sourcedir exist}
      if sourcedir.FolderExists then
      begin
        {IF the dest exists, delete it}
        if dest.FileExists then File.Delete(dest);
        var temp :=  zip(sourcedir, dest);
        result := temp.path;
      end
      else result := 'Sourcefolder does not exist';
    end;
  end;

end.