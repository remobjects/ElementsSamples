namespace com.example.android.bluetoothchat;

uses android.app, android.os, android.content.pm;

type
  BluetoothPermissions = public static class
  public

    const RequestCode = 4;

    class method requiredPermissions: array of String;
    begin
      if Build.VERSION.SDK_INT ≥ 31 then
        result := ["android.permission.BLUETOOTH_SCAN", "android.permission.BLUETOOTH_CONNECT", "android.permission.BLUETOOTH_ADVERTISE"]
      else
        result := ["android.permission.ACCESS_FINE_LOCATION"];
    end;

    class method hasAll(aActivity: Activity): Boolean;
    begin
      for each lPermission in requiredPermissions do
        if aActivity.checkSelfPermission(lPermission) ≠ PackageManager.PERMISSION_GRANTED then
          exit false;
      result := true;
    end;

    class method requestIfNeeded(aActivity: Activity): Boolean;
    begin
      result := hasAll(aActivity);
      if not result then
        aActivity.requestPermissions(requiredPermissions, RequestCode);
    end;

  end;

end.
