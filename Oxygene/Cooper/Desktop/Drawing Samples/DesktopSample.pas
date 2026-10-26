// Positive sample guard: host the former applet drawings and input handlers in a standalone Swing window.
namespace drawingsamples;

uses
  java.awt,
  javax.swing;

type
  DesktopSample = public class(Panel)
  private
    var fStatus: JLabel;
  public
    method init; virtual; empty;
    method start; virtual; empty;
    method stop; virtual; empty;

    method showStatus(aText: String);
    begin
      fStatus:Text := aText;
    end;

    class method Show(aSample: DesktopSample; aTitle: String);
    begin
      SwingUtilities.invokeLater(new interface Runnable(run := method begin
        var lWindow := new JFrame(aTitle);
        lWindow.DefaultCloseOperation := JFrame.EXIT_ON_CLOSE;
        aSample.PreferredSize := new Dimension(300, 300);
        lWindow.ContentPane.add(aSample, BorderLayout.CENTER);
        aSample.fStatus := new JLabel(' ');
        lWindow.ContentPane.add(aSample.fStatus, BorderLayout.SOUTH);
        lWindow.pack;
        lWindow.Resizable := false;
        aSample.Focusable := true;
        aSample.init;
        lWindow.Visible := true;
        aSample.start;
        aSample.requestFocusInWindow;
      end));
    end;
  end;
end.
