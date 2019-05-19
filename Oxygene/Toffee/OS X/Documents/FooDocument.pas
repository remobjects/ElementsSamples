namespace Documents;

interface

uses
  AppKit;

type
  [IBObject]
  FooDocument = public class(NSDocument)
	method loadDocumentFromURL(url: NSURL): Boolean;
	method saveDocumentToURL(url: NSURL): Boolean;
  public
	property data: FooDocumentData read  private write ;

	// NSDocument implementation
	constructor withType(&type: NSString) error(error: ^NSError); override;  // workaround for invalid NSError pointer being passed in, sometimes
	method readFromURL(url: not nullable NSURL) ofType(typeName: not nullable NSString) error(var error: NSError): Boolean; override;
	method writeToURL(url: not nullable NSURL) ofType(typeName: not nullable NSString) forSaveOperation(aveOperation: NSSaveOperationType) originalContentsURL(absoluteOriginalContentsURL: nullable NSURL) error(var error: NSError): Boolean; override;
	method makeWindowControllers; override;
	class property autosavesInPlace: Boolean read true; override;
  end;

  FooDocumentData = public class
  public
	property text: NSString read  write ;
	constructor;
	constructor withURL(url: NSURL);
	method save(url: NSURL);
  end;

implementation

constructor FooDocument withType(&type: NSString) error(error: ^NSError);
begin
  data := new FooDocumentData();
end;

method FooDocument.readFromURL(url: not nullable NSURL) ofType(typeName: not nullable NSString) error(var error: NSError): Boolean;
begin
  result := loadDocumentFromURL(url);
end;

method FooDocument.writeToURL(url: not nullable NSURL) ofType(typeName: not nullable NSString) forSaveOperation(aveOperation: NSSaveOperationType) originalContentsURL(absoluteOriginalContentsURL: nullable NSURL) error(var error: NSError): Boolean;
begin
  result := saveDocumentToURL(url);
end;

method FooDocument.makeWindowControllers;
begin
  addWindowController(new FooDocumentWindowController withDocument(self));
end;

method FooDocument.loadDocumentFromURL(url: NSURL): Boolean;
begin
  data := new FooDocumentData withURL(url);
  exit assigned(data);
end;

method FooDocument.saveDocumentToURL(url: NSURL): Boolean;
begin
  if data = nil then
	exit false;
  data.save(url);
  result := true;
end;

constructor FooDocumentData;
begin
  text := 'New Foo!';
end;

constructor FooDocumentData withURL(url: NSURL);
begin
  if File.Exists(url.path) then
	text := File.ReadText(url.path)
  else
	exit nil;
end;

method FooDocumentData.save(url: NSURL);
begin
  File.WriteText(url.path, text);
end;

end.