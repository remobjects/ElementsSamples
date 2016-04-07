namespace LinqToXML;

interface

uses
  System.Drawing,
  System.Collections,
  System.Collections.Generic,
  System.Linq,
  System.Xml,
  System.Xml.Linq,
  System.Windows.Forms,
  System.ComponentModel;

type
  /// <summary>
  /// Summary description for MainForm.
  /// </summary>
  MainForm = partial class(System.Windows.Forms.Form)
  private
   method button1_Click(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(disposing: Boolean); override;
  public
    constructor;
  end;

implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  //
  // Required for Windows Form Designer support
  //
  InitializeComponent();

  //
  // TODO: Add any constructor code after InitializeComponent call
  //
end;

method MainForm.Dispose(disposing: Boolean);
begin
  if disposing then begin
    if assigned(components) then
      components.Dispose();

    //
    // TODO: Add custom disposition code here
    //
  end;
  inherited Dispose(disposing);
end;
{$ENDREGION}

method MainForm.button1_Click(sender: System.Object; e: System.EventArgs);
var
  books : Array of Books := [ new Books('Programming and Problem Solving with Delphi', 'Mitchell C. Kerman', 2008),
                              new Books('Delphi 2009', 'Marco Cantu', 2008),
                              new Books('Learn Object Pascal with Delphi', 'Rachele, Warren', 2008),
                              new Books('RSS and Atom in Action', 'Manning', 2006)];
  xml : XElement;
begin
  xml := new XElement('books', from book in books
                                 where book.Year = 2008
                                 select new XElement( 'book',
                                       new XAttribute('title',book.Title),
                                       new XAttribute('publisher', book.Publisher) ) );

  tbXML.Text := xml.ToString
  
end;

end.