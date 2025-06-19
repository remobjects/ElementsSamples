namespace Documents;

interface

uses
  AppKit;

type
  [IBObject]
  FooDocumentWindowController = public class(NSWindowController)
  private
	var _document: FooDocument;
  public
	property data: nullable FooDocumentData read _document.data;
	constructor withDocument(document: FooDocument);
	method windowDidLoad; override;
  end;

implementation

constructor FooDocumentWindowController withDocument(document: FooDocument);
begin
  inherited constructor withWindowNibName('FooDocumentWindow');
  _document := document;
end;

method FooDocumentWindowController.windowDidLoad;
begin
  inherited windowDidLoad();
  //  Implement this method to handle any initialization after your window controller's
  //  window has been loaded from its nib file.
end;

end.