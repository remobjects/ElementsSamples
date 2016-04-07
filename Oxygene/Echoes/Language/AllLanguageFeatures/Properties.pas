namespace AllLanguageFeatures;

interface

type
  ISomeProperties = interface
    property A: string read;
    property B: integer write;
    property C: Object read write;

    property H: string read;
  end;

  Properties = public abstract class(ISomeProperties)
  private
    fB: Int32;
  protected
  public
    property A: string read 'hello'; { inline readers }
    property B: integer write fB;
    property C: Object; { shortcut properties, no visible field }
    
    property D: Int32 read fB write fB; virtual;
    property E: Object read; abstract;
    
    property F: string; readonly; { can only be inited in ctor }
    property G: string := 'hello';

    property H2: string; implements ISomeProperties.H; // Error	1	(PE61) Cannot resolve implements item "ISomeProperties.H (property write)"	R:\Oxygene\Samples\Language\AllLanguageFeatures\AllLanguageFeatures\Properties.pas	29	
    property H: string;
    
    property L: Int32 read A.Length write self.fB; { inline reader and writer}
    property L1: nullable Int32 read A:Length; { can also use colon operator! }

    property L2: Int32 public read A.Length private write fB; { explicit visibility }
    
    { Oxygene only: }
    property M: Int32 read D write B; notify;
    property N: Int32 read D write B; notify 'ENN'; { optional string value as name }
    //property O: String; chord;  { no read-write allowed }
    //property P: Foo; promise; { no read-write allowed }
  end;
  
  Properties2 = assembly class(Properties)
  private
    method SetD(aValue: Int32);
  public
    property D: Int32 write SetD; override;
    property E: Object read C; override;
    property B: Object; reintroduce;
  end;
  
implementation

method Properties2.SetD(aValue: Int32); 
begin
  inherited D := aValue+5;
end;

end.