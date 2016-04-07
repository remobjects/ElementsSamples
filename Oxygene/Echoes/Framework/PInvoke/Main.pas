namespace CallingWin32DLL;

interface

uses
  System.Windows.Forms,
  System.Drawing,
  System.Runtime.InteropServices;  // this namespace contains the DllImport attribute needed for importing Win32 DLLs.

type
  
  MainForm = partial class(System.Windows.Forms.Form)
  private
    method btnSoundRenamed_Click(sender: System.Object; e: System.EventArgs);
    method btnSoundStandard_Click(sender: System.Object; e: System.EventArgs);
  protected
    method Dispose(aDisposing: boolean); override;
  public
    constructor;
  end;
  
  Win32Methods = class
  public
    [DllImport('kernel32.dll')]  //this attribute indentifies the DLL that is used for identifying the origing of the method after the attribute.
    class method Beep(Tone, Length: UInt32): Boolean; external;  
    [DllImport('kernel32.dll', EntryPoint := 'Beep')]  //same as previous attribute but here the method name is different from the one in the DLL.
    class method BeepFromKernel(Tone, Length: UInt32): Boolean; external; //same method as 'Beep' but renamed to 'BeepFromKernel' 
  end;

implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
  InitializeComponent();
end;

method MainForm.Dispose(aDisposing: boolean);
begin
  if aDisposing then begin
    if assigned(components) then
      components.Dispose();
  end;
  inherited Dispose(aDisposing);
end;
{$ENDREGION}

method MainForm.btnSoundStandard_Click(sender: System.Object; e: System.EventArgs);
begin
  //call the standard imported Beep method imported from kernel32.dll
  Win32Methods.Beep(tbFrequency.Value, 1000);  // this method will make a sound through the PC-Speaker of your PC.
end;

method MainForm.btnSoundRenamed_Click(sender: System.Object; e: System.EventArgs);
begin
  //call the renamed imported Beep method imported from kernel32.dll
  Win32Methods.BeepFromKernel(tbFrequency.Value, 1000);    
end;

end.