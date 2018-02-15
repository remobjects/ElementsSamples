namespace GlHelper;
{ Helper Class for read *.Shape Files
  These Files are from a internal Software with a own Format
  These internal Software is based on OpenCascade and not public
}
{$IF  TOFFEE OR ISLAND}
interface
uses
    RemObjects.Elements.RTL;

type
    ShapeReader = public class
    private
        stream : FileHandle;
        method ReadBuff(Buffer: ^Void; Count: LongInt): LongInt;
        method ReadInteger : Integer;
        method ReadVec3Array : array of TVector3;
        method ReadIntArray: array of Int32;

    public
        constructor ();

        method load(const aFilename: String) : Shape;

    end;
implementation

constructor ShapeReader();
begin
    inherited ();
end;

method ShapeReader.load(const aFilename: String): Shape;
begin
    result := nil;
    if aFilename.FileExists then
    begin

    {Open the File}
        stream := new FileHandle(aFilename, FileOpenMode.ReadOnly);
     {Read the Version must be 1 at these point }
        try
            if ReadInteger = 1 then
            begin
                var Faces : Integer := ReadInteger;
                result := new Shape(Faces);

      // Start Points of Faces

                for i:Integer := 0 to Faces-1 do
                    begin
                    var temp  := ReadVec3Array;
                    if temp <> nil then
                        result.addFaceVecs(i, temp);
                end;

     // Start Normals
                Faces := ReadInteger;
                for  i: Integer := 0 to Faces-1 do
                    begin
                    var temp  := ReadVec3Array;
                    if temp <> nil then
                        result.addNormales(i, temp);
                end;

   // Start Indexes

                Faces := ReadInteger;

                for  i : Integer := 0 to Faces-1 do
                    begin
                    var temp  := ReadIntArray;
                    if temp <> nil then
                        result.addIndexes(i, temp);
                end;

            end;
        finally
            stream.Close;
        end;
    end;
end;

method ShapeReader.ReadBuff(Buffer: ^Void; Count: LongInt): LongInt;
begin
    var lBuf := new Byte[Count];
    result := stream.&Read(lBuf, 0, Count);
 {$IF ISLAND}
  {$IF WINDOWS}ExternalCalls.memcpy(Buffer, @lBuf[0], Count){$ELSEIF POSIX}rtl.memcpy(Buffer, @lBuf[0], Count){$ENDIF};
  {$ELSEIF TOFFEE}
  memcpy(Buffer, @lBuf[0], Count);
  {$ENDIF}
end;

method ShapeReader.ReadInteger: Integer;
begin
    ReadBuff(var result, 4);
end;

method ShapeReader.ReadVec3Array: array of TVector3;
begin
    result := nil;
    Var fCountVecs : Integer := ReadInteger;
    if fCountVecs > 0 then
    begin
        result := new  TVector3[fCountVecs];
        ReadBuff(var result[0], 12*fCountVecs);
    end;
end;


method ShapeReader.ReadIntArray: array of Int32;
begin
    result := nil;
    Var fCount : Integer := ReadInteger;
    if fCount > 0 then
    begin
        result := new  Int32[fCount];
        ReadBuff(var result[0], 4*fCount);
    end;
end;

{$ENDIF}
end.