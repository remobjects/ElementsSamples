namespace ;

interface

uses
  System,
  System.IO,
  System.Collections.Generic,
  System.Linq,
  System.Text,
  System.Threading.Tasks,
  Windows.Storage,
  Windows.Storage.Streams,
  System.Runtime.Serialization,
  Windows.ApplicationModel;

  type
    SuspensionManager = class
    private
      class var   sessionState_: Dictionary<System.String, System.Object> := new Dictionary<System.String, System.Object>();
      class var   knownTypes_: List<&Type> := new List<&Type>();
      const       filename: System.String = '_sessionState.xml';

    public
      // Provides access to the currect session state
      class property SessionState: Dictionary<System.String, System.Object> read sessionState_;

      // Allows custom types to be added to the list of types that can be serialized
      class property KnownTypes: List<&Type> read knownTypes_;

      // Save the current session state
      class method SaveAsync: Task;

      // Restore the saved sesison state
      class method RestoreAsync: Task;
    end;


implementation


class method SuspensionManager.SaveAsync: Task;
begin
  // Get the output stream for the SessionState file.
  var file: StorageFile := await ApplicationData.Current.LocalFolder.CreateFileAsync(filename, CreationCollisionOption.ReplaceExisting);
  ApplicationData.Current.LocalFolder.CreateFileAsync(filename, CreationCollisionOption.ReplaceExisting);
  var raStream := await file.OpenAsync(FileAccessMode.ReadWrite);
  file.OpenAsync(FileAccessMode.ReadWrite);
  using outStream: IOutputStream := raStream.GetOutputStreamAt(0) do begin
  // Serialize the Session State.
    var serializer: DataContractSerializer := new DataContractSerializer(typeOf(Dictionary<System.String, System.Object>), knownTypes_);
    serializer.WriteObject(outStream.AsStreamForWrite(), sessionState_);
    await outStream.FlushAsync();
  end
end;

class method SuspensionManager.RestoreAsync: Task;
begin
  // Get the input stream for the SessionState file.
  try
    var file: StorageFile := await ApplicationData.Current.LocalFolder.GetFileAsync(filename);
    ApplicationData.Current.LocalFolder.GetFileAsync(filename);
    if file = nil then      exit;
    var inStream: IInputStream := await file.OpenSequentialReadAsync();
    file.OpenSequentialReadAsync();

    // Deserialize the Session State.
    var serializer: DataContractSerializer := new DataContractSerializer(typeOf(Dictionary<System.String, System.Object>), knownTypes_);
    sessionState_ := Dictionary<System.String, System.Object>(serializer.ReadObject(inStream.AsStreamForRead()))
  except
    on Exception do 
      // Restoring state is best-effort.  If it fails, the app will just come up with a new session.
    end
end;

end.
