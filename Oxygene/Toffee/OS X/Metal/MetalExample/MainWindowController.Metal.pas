namespace MetalExample;

uses
  MetalKit;

type
  MainWindowController = public partial class(NSWindowController)
  private
    const BaseExample = 'Devices and Commands';
    var renderer : MTKViewDelegate;

    method switchApp(const AppId : Integer);
//method MainWindowController.switchApp(const AppId: Integer);
    begin
      var App : MetalBaseDelegate := nil;
      case AppId of

        0 : begin
          App := new MetalExample1 InitWithMetalKitView(ViewGL);
          TimeLabel.label := '"Hello Triangle" running';
        end;

        1 : begin
          App := new MetalExample2 InitWithMetalKitView(ViewGL);
          TimeLabel.label := '"Basic Buffers" running';
        end;

        2 : begin
          App := new MetalExample3 InitWithMetalKitView(ViewGL);
          TimeLabel.label := '"Basic Texturing" running';
        end;
        3 : begin
          App := new MetalExample4 InitWithMetalKitView(ViewGL);
          TimeLabel.label := '"Basic Texturing" with Blend running';
        end;

        4 : begin
          App := new MetalExample5 InitWithMetalKitView(ViewGL);
          TimeLabel.label := '"Draw a Cube" running';
        end
        else
          begin
            App  := new MetalRenderer InitWithMetalKitView(ViewGL);
            TimeLabel.label := BaseExample;
          end;
      end;
      // Fallback in case of error
      if App = nil then
      begin
        NSLog("Fallback to default");
        App  := new MetalRenderer InitWithMetalKitView(ViewGL);
        TimeLabel.label := BaseExample;
      end;
// Set the new delegate in the view
      renderer := App;
      renderer.mtkView(ViewGL) drawableSizeWillChange(ViewGL.drawableSize);
      ViewGL.delegate := renderer;
      ViewGL.MouseDelegate := App;
    end;
  end;

end.