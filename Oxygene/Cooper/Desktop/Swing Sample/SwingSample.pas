namespace swingsample;

//Sample app by Brian Long (http://blong.com)

{
  This example demonstrates using Java Swing
  See:
   - http://download.oracle.com/javase/1.4.2/docs/api/javax/swing/package-frame.html
   - http://www.java2s.com/Code/JavaAPI/javax.swing/Catalogjavax.swing.htm
}

interface

uses
  java.util,
  javax.swing,
  java.awt,
  java.awt.event;

type
  SwingSample = class(JFrame)
  private
    var label3: JLabel;
    method actionPerformed(e: ActionEvent);
  public
    constructor;
    class method Main(args: array of String);
  end;

implementation

//App entry point
class method SwingSample.Main(args: array of String);
begin
  new SwingSample();
end;

constructor SwingSample();
begin
  //Ensure app closes when you click the close button
  DefaultCloseOperation := JFrame.EXIT_ON_CLOSE;
  //Set window caption and size
  Title := "Oxygene and Java Swing";
  Size := new Dimension(500, 150);
  //We will have a horizontal row of vertical control sets
  var hBox := Box.createHorizontalBox;
  //Ensure there is a little gap at the top of the window
  hBox.add(Box.createHorizontalStrut(20));

  //1st vertical control set
  var vBox1 := Box.createVerticalBox;
  var label1 := new JLabel("Trivial example");
  vBox1.add(label1);
  //A gap between the label and the button
  vBox1.add(Box.createVerticalStrut(10));
  var button1 := new JButton("Update label");
  //Handler added via inline interface implementation using an anonymous method
  button1.addActionListener(new interface ActionListener(actionPerformed :=
    method(e: ActionEvent) begin 
      label1.Text := "Clicked the button!" 
    end));
  vBox1.add(button1);
  hBox.add(vBox1);

  //2nd vertical control set
  var vBox2 := Box.createVerticalBox;
  var label2 := new JLabel("Message Box");
  vBox2.add(label2);
  //A gap between the label and the button
  vBox2.add(Box.createVerticalStrut(10));
  var button2 := new JButton("Show message box");
  //Handler added via inline interface implementation using a lambda expression
  button2.addActionListener(new interface ActionListener(actionPerformed :=
    (e) -> begin
             JOptionPane.showMessageDialog(self,
               'There is no news...', 'News', JOptionPane.INFORMATION_MESSAGE);
             JButton(e.Source).Text := 'Click again!'
           end));
  vBox2.add(button2);
  hBox.add(vBox2);

  //3rd vertical control set
  var vBox3 := Box.createVerticalBox;
  // the other way:
  label3 := new JLabel("Confirmation Box");
  vBox3.add(label3);
  //A gap between the label and the button
  vBox3.add(Box.createVerticalStrut(10));
  var button3 := new JButton("Show confirmation box");
  //Handler added via inline interface implementation using a regular method
  button3.addActionListener(new interface ActionListener(
    actionPerformed := @actionPerformed));
  vBox3.add(button3);
  hBox.add(vBox3);

  //Add the controls to the frame and show it
  add(hBox);
  Visible := true;
end;

method SwingSample.actionPerformed(e: ActionEvent);
begin
  label3.Text := case JOptionPane.showConfirmDialog(self,
      'Happy?', 'Mood test', JOptionPane.YES_NO_CANCEL_OPTION) of
    JOptionPane.YES_OPTION: ':o)';
    JOptionPane.NO_OPTION:  ':o(';
    else                    ':o|';
  end;
end;

end.