namespace org.me.openglapplication;

//Sample app by Brian Long (http://blong.com)

{
  This example demonstrates a number of things:
  - two different OpenGL views, one drawing a spinning coloured square, the
    other drawing a spinning, transparent cube
  - how to get OpenGL to draw on a transparent background so you see the
    previously active view
  - how to pass information to launched activities via Intent
  - how to construct a class from a type name
  - how to implement an About box
  - how to set up an options menu
  - how to use ListActivity, a handy Activity descendant that manages a
    scrolling list of items in conjunction with an adapter
}

interface

uses
  java.util,
  android.os,
  android.app,
  android.content,
  android.util,
  android.view,
  android.widget,
  android.util;

type
  MainActivity = public class(ListActivity)
  private
      //List menu items
    const ID_OPENGL_SQUARE = 0;
    const ID_OPENGL_SQUARE_TRANSLUCENT = 1;
    const ID_OPENGL_CUBE = 2;
    const ID_OPENGL_CUBE_TRANSLUCENT = 3;
    //Options menu items
    const ID_ABOUT = 1;
  public
    method onCreate(savedInstanceState: Bundle); override;
    method onListItemClick(l: ListView; v: View; position: Integer; id: Int64); override;
    method onCreateOptionsMenu(menu: Menu): Boolean; override;
    method onOptionsItemSelected(item: MenuItem): Boolean; override;
    //Misc
    const Tag = "OpenGLApp";
  end;

implementation

method MainActivity.onCreate(savedInstanceState: Bundle);
begin
  inherited;

  var rows := Resources.StringArray[R.array.menu_titles];
  var rowSubtitles := Resources.StringArray[R.array.menu_subtitles];
  if rows.length <> rowSubtitles.length then
    Log.e(Tag, "Menu titles & subtitles have mismatched lengths");
  var listViewContent := new ArrayList<Map<String, Object>>();
  for i: Integer := 0 to rows.length - 1 do
  begin
    var map := new HashMap<String, Object>();
    map.put("heading", rows[i]);
    map.put("subheading", rowSubtitles[i]);
    listViewContent.add(map);
  end;
  //Set up adapter for the ListView using an Android list item template
  //ListAdapter := new SimpleAdapter(Self, listViewContent, Android.R.Layout.simple_expandable_list_item_2,
  //    ["heading", "subheading"], [Android.R.id.text1, Android.R.id.text2]);
  //Set up adapter for the ListView using a custom list item template
  ListAdapter := new SimpleAdapter(Self, listViewContent, R.layout.listitem_twolines,
      ["heading", "subheading"], [Android.R.id.text1, Android.R.id.text2]);
end;

method MainActivity.onListItemClick(l: ListView; v: View; position: Integer; id: Int64);
begin
  var i := new Intent(Self, typeOf(OpenGLActivity));
  case position of
    ID_OPENGL_SQUARE:
      i.putExtra(OpenGLActivity.OpenGLRendererClass, typeOf(GLSquareRenderer).Name);
    ID_OPENGL_SQUARE_TRANSLUCENT:
    begin
      i.putExtra(OpenGLActivity.OpenGLRendererClass, typeOf(GLSquareRenderer).Name);
      i.putExtra(OpenGLActivity.IsTranslucent, True);
    end;
    ID_OPENGL_CUBE:
      i.putExtra(OpenGLActivity.OpenGLRendererClass, typeOf(GLCubeRenderer).Name);
    else
    begin
      i.putExtra(OpenGLActivity.OpenGLRendererClass, typeOf(GLCubeRenderer).Name);
      i.putExtra(OpenGLActivity.IsTranslucent, True);
    end;
  end;
  startActivity(i);
end;

method MainActivity.onCreateOptionsMenu(menu: Menu): Boolean;
begin
  var item := menu.add(0, ID_ABOUT, 0, R.string.about_menu);
  //Options menu items support icons
  item.Icon := Android.R.drawable.ic_menu_info_details;
  Result := True;
end;

method MainActivity.onOptionsItemSelected(item: MenuItem): Boolean;
begin
  if item.ItemId = ID_ABOUT then
  begin
    startActivity(new Intent(Self, typeOf(AboutActivity)));
    exit True
  end;
  exit False;
end;

end.
