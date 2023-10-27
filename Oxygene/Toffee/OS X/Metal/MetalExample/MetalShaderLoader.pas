namespace MetalExample;

interface
uses
  Metal,
  MetalKit;

// Helper Class for load a Shader from Resources and setup the vertex and fragment functions

type
  shaderLoader = class
  private
    _vertexfunc  :MTLFunction;
    _fragmentfunc  :MTLFunction;
  public
    constructor(const device: MTLDevice) Shadername(const shadername: String) Vertexname(const vertexname: String) Fragmentname(const fragmentname: String);

    property VertexFunc : MTLFunction read _vertexfunc;
    property FragmentFunc : MTLFunction read _fragmentfunc;
  end;

implementation

constructor shaderLoader(const device: MTLDevice) Shadername(const shadername: String) Vertexname(const vertexname: String) Fragmentname(const fragmentname: String);
begin
  var lError : Error;
  var SourceShader := Asset.getFullname(shadername); readonly;

  // Try to Load  the Shader Lib
  var  defaultLibrary  : MTLLibrary := device.newLibraryWithFile(SourceShader) error(var lError);
   // Load all the shader files with a .metal file extension in the project
  // Will not work at moment in element because there is no precompile for the shaders like in xcode
 // var  defaultLibrary  : MTLLibrary := _device.newDefaultLibrary;
  if defaultLibrary = nil then
  begin
    NSLog("Shaderlib, error %@", SourceShader);
    NSLog("Failed to load the Shaderlib, error %@", lError);
    exit nil;
  end
  else
  begin
    _vertexfunc   := defaultLibrary.newFunctionWithName(vertexname);
    if _vertexfunc = nil then
    begin
      NSLog("Failed to get the Vertex Function , error %@", lError);
      exit nil;
    end;
    // Load the fragment function from the library
    _fragmentfunc  := defaultLibrary.newFunctionWithName(fragmentname);
    if _fragmentfunc = nil then
    begin
      NSLog("Failed to get the Fragment Function , error %@", lError);
      exit nil;
    end;
  end;


end;



end.