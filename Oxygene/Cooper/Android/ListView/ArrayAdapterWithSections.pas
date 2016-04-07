namespace org.me.listviewapp;

interface

uses
  java.util,
  android.app,
  android.os,
  android.content,
  android.view,
  android.widget,
  android.util;

type
  ArrayAdapterWithSections<T> = class(ArrayAdapter<T>, SectionIndexer)
  private
    elements: array of String;
    alphaIndex: TreeMap<String, Integer>;
    sections: array of String;
    javaSections: array of Object;
    const Tag = 'ArrayAdapterWithSections';
  public
    constructor (ctx: Context; resource, textViewResourceId: Integer; objects: array of T);
    method GetPositionForSection(section: Integer): Integer;
    method GetSectionForPosition(position: Integer): Integer;
    method GetSections: array of Object;
  end;

implementation

constructor ArrayAdapterWithSections<T>(ctx: Context; resource, textViewResourceId: Integer; objects: array of T);
begin
  inherited;
  elements := new String[objects.length];
  for i: Integer := 0 to objects.length - 1 do
    elements[i] := objects[i].toString;
  //Make a map holding location of 1st occurrence of each alphabet letter
  alphaIndex := new TreeMap<String, Integer>();
  //Start from the end and work backwards finding location of 1st item for each letter
  for i: Integer := 0 to elements.length - 1 do
  begin
    var newKey := elements[i].substring(0, 1);
    if not alphaIndex.containsKey(newKey) then
      alphaIndex.put(newKey, i);
  end;
  sections := alphaIndex.keySet.toArray(new String[alphaIndex.keySet.size]);
  //Now set up the Java Object sections that we need to return
  javaSections := new Object[sections.length];
  for i: Integer := 0 to sections.length - 1 do
    javaSections[i] := sections[i];
end;

method ArrayAdapterWithSections<T>.GetPositionForSection(section: Integer): Integer;
begin
  Result := -1;
  if alphaIndex.containsKey(sections[section]) then
    Result := alphaIndex[sections[section]];
end;

method ArrayAdapterWithSections<T>.GetSectionForPosition(position: Integer): Integer;
begin
  exit 0 //Not called
end;

method ArrayAdapterWithSections<T>.GetSections: array of Object;
begin
  exit javaSections
end;

end.