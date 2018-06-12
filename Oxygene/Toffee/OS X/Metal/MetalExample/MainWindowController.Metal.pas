namespace MetalExample;

uses
  MetalKit;

type
  MainWindowController = public partial class(NSWindowController)
  private
    const BaseExample = 'Only Background Example running';
    var renderer : MTKViewDelegate;

    method switchApp(const AppId : Integer);
//method MainWindowController.switchApp(const AppId: Integer);
    begin
      var App : MTKViewDelegate := nil;
      case AppId of

        0 : begin
          App := new MetalExample1 InitWithMetalKitView(ViewGL);
          TimeLabel.label := 'Example Triangle running';
        end;

        1 : begin
          App := new MetalExample2 InitWithMetalKitView(ViewGL);
          TimeLabel.label := 'Example Buffers running';
        end;

        2 : begin
          App := new MetalExample3 InitWithMetalKitView(ViewGL);
          TimeLabel.label := 'Example Texture running';
        end;

        3 : begin
          App := new MetalExample4 InitWithMetalKitView(ViewGL);
          TimeLabel.label := 'Example Texture Blend running';
        end
        else
          begin
            App  := new MetalRenderer InitWithMetalKitView(ViewGL);
            TimeLabel.label := BaseExample;
          end;
      end;

// Set the new delegate in the view
      renderer := App;
      renderer.mtkView(ViewGL) drawableSizeWillChange(ViewGL.drawableSize);
      ViewGL.delegate := renderer;

    end;
  end;

end.