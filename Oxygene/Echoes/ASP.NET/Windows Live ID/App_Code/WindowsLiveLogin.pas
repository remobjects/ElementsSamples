namespace WindowsLive;

interface

uses
  System,
  System.Collections,
  System.Collections.Generic,
  System.Collections.Specialized,
  System.IO,
  System.Net,
  System.Reflection,
  System.Security.Cryptography,
  System.Text,
  System.Text.RegularExpressions, 
  System.Web,
  System.Web.Configuration,
  System.Xml;

type
 
  WindowsLiveLogin = public class
  private
	  m_AppId: String;
	  m_SecurityAlgorithm: String;
	  m_cyrptKey: Array of Byte;
	  m_signKey: Array of Byte;
	  m_BaseUrl: String;
	  m_SecureUrl: String;
	  method GetAppId: String;
	  method SetAppId(AValue: String);
	  method SetSecret(AValue: String);
	  method GetSecurityAlgorithm: String;
	  method GetBaseUrl: String;
	  method GetSecureUrl: String;
	  class method debug(AMsg: string);
	  class method parseSettings(ASettingsFile: String): NameValueCollection;
	  class method derive(ASecret: String; APrefix: String): Array of Byte;
	  class method getTimeStamp: String;
	  class method e64(Ab: array of Byte): String;
	  class method u64(AStr: String): Array of Byte;
	  class method fetch(AUrl: String): String;
  public
    constructor(AAppId: String; ASecret: String);
    constructor(AAppId: String; ASecret: String; ASecurityAlgorithm: String);
    constructor(ALoadAppSettings: Boolean);
	 constructor(ASettingsFile: String);
  public
	  method ProcessLogin(AQuery: NameValueCollection): User;
	  method GetLoginUrl: String;
	  method GetLoginUrl(AContext: String): String;
	  method GetLogoutUrl: String;
	  method ProcessToken(AToken: String): User;
	  method ProcessToken(AToken: String; AContext: String): User;
	  method GetClearCookieResponse(out AType: String;
		 out AContent: Array of Byte);
	  method DecodeToken(AToken: String): String;
	  method SignToken(AToken: String): Array of Byte;
	  method ValidateToken(AToken: String): String;
	  method GetAppVerifier: String;
	  method GetAppVerifier(AIp: String): String;
	  method GetAppLoginUrl: String;
	  method GetAppLoginUrl(ASiteId: String): String;
	  method GetAppLoginUrl(ASiteId: String; AIp: String): String;
	  method GetAppLoginUrl(ASiteId: String; AIp: String; AJs: Boolean): String;
	  method GetAppSecurityToken: String;
	  method GetAppSecurityToken(ASiteId: String): String;
	  method GetAppSecurityToken(ASiteId: String; AIp: String): String;
	  method GetAppRetCode: String;
	  method GetTrustedParams(AUser: String): NameValueCollection;
	  method GetTrustedParams(AUser: String; ARetCode: String): NameValueCollection;
	  method GetTrustedToken(AUser: String): String;
	  method GetTrustedLoginUrl: String;
	  method GetTrustedLogoutUrl: String;	  
  public
	 property AppId: String read GetAppId write SetAppId;
	 property Secret: String write SetSecret;
	 property SecurityAlgorithm: String
	 		read GetSecurityAlgorithm
			write m_SecurityAlgorithm;
	 property BaseUrl: String read GetBaseUrl write m_BaseUrl;
	 property SecureUrl: String read GetSecureUrl write m_SecureUrl;	 
  end;

	/// <summary>
	/// Holds the user information after a successful login.
	/// </summary>
	User nested in WindowsLiveLogin = public class
	private
	  m_id: String;
	 	m_timestamp: DateTime;
		method setId(AId: String);
	  method setTimestamp(ATimestamp: String);
	method setFlags(AFlags: String);
	public	  
	  constructor(ATimestamp: String; AId: String; AFlags: String;
	     AContext: String; AToken: String);
	  property Token: String;
	  property Context: String;	  
	  property UsePersistentCookie: Boolean;	  
	  property Id: String read m_id write setId;
	  property Timestamp: DateTime read m_timestamp;
  end;

implementation

/// <summary>
/// Initialize the WindowsLiveLogin module with the
/// application ID and secret key.
///
/// We recommend that you employ strong measures to protect
/// the secret key. The secret key should never be
/// exposed to the Web or other users.
/// </summary>
constructor WindowsLiveLogin(AAppId: String; ASecret: String);
begin
	constructor(AAppId, ASecret, nil);
end;

/// <summary>
/// Initialize the WindowsLiveLogin module with the
/// application ID, secret key, and security algorithm to use.
///
/// We recommend that you employ strong measures to protect
/// the secret key. The secret key should never be
/// exposed to the Web or other users.
/// </summary>
constructor WindowsLiveLogin(AAppId: String; ASecret: String; ASecurityAlgorithm: String); 
begin
	AppId := AAppId;
   Secret := ASecret;
   SecurityAlgorithm := ASecurityAlgorithm;
end;

/// <summary>
/// Initialize the WindowsLiveLogin module from the
/// web.config file if loadAppSettings is true. Otherwise,
/// you will have to manually set the AppId, Secret and
/// SecurityAlgorithm properties.
/// </summary>
constructor WindowsLiveLogin(ALoadAppSettings : Boolean); 
begin
	if not ALoadAppSettings then
		exit;
	
	var l_appSettings := WebConfigurationManager.AppSettings;
	if l_appSettings = nil then
	begin
		raise new IOException('Error: WindowsLiveLogin: Failed to load the Web '
		                      + 'application settings.');	
	end;		
	
	AppId := l_appSettings['wll_appid'];
	Secret := l_appSettings['wll_secret'];
	SecurityAlgorithm := l_appSettings['wll_securityalgorithm'];
	BaseUrl := l_appSettings['wll_baseurl'];
	SecureUrl := l_appSettings['wll_secureurl'];
end;


/// <summary>
/// Stub implementation for logging debug output. You can run
/// a tool such as 'dbmon' to see the output.
/// </summary>
class method WindowsLiveLogin.debug(AMsg: string); 
begin
	System.Diagnostics.Debug.WriteLine(AMsg);
	System.Diagnostics.Debug.Flush;
end;

/// <summary><![CDATA[
/// Initialize the WindowsLiveLogin module from a settings file. 
/// 
/// 'settingsFile' specifies the location of the XML settings
/// file containing the application ID, secret key, and an optional
/// security algorithm.  The file is of the following format:
/// 
/// <windowslivelogin>
///   <appid>APPID</appid>
///   <secret>SECRET</secret>
///   <securityalgorithm>wsignin1.0</securityalgorithm>
/// </windowslivelogin>
/// 
/// We recommend that you store the Windows Live Login settings file
/// in an area on your server that cannot be accessed through
/// the Internet. This file contains important confidential
/// information.      
/// ]]></summary>
constructor WindowsLiveLogin(ASettingsFile: String); 
begin
	var l_settings := parseSettings(ASettingsFile);
	
	AppId := l_settings['appid'];
	Secret := l_settings['secret'];
	SecurityAlgorithm := l_settings['securityalgorithm'];
	BaseUrl := l_settings['baseurl'];
	SecureUrl := l_settings['secureurl'];	
end;

method WindowsLiveLogin.GetAppId: String; 
begin
	if (m_AppId = nil) or (m_AppId.Length = 0) then
	begin
		raise new InvalidOperationException('Error: AppId: Application ID was '
		  + 'not set. Aborting.');
	end;
	
	result := m_AppId;
end;

method WindowsLiveLogin.SetAppId(AValue: String); 
begin
	if (AValue = nil) or (AValue.Length = 0) then
	begin
		raise new ArgumentNullException('AValue');
	end;
	
	var l_re: Regex := new Regex('^\w+$');
	
	if not l_re.IsMatch(AValue) then
	begin
		raise new ArgumentException('Error: AppId: Application ID must be '
		  + 'alphanumeric: "' + AValue + '"');
	end;
	
	m_AppId := AValue;
end;

method WindowsLiveLogin.SetSecret(AValue: String); 
begin
	if (AValue = nil) or (AValue.Length = 0) then
	begin
		raise new ArgumentNullException('AValue');
	end;
	
	if AValue.Length < 16 then
	begin
		raise new ArgumentException('Error: Secret: Secret key is expected '
		  + 'to be longer than 16 characters: "' + AValue.Length + '"');
	end;
	
	m_cyrptKey := derive(AValue, 'ENCRYPTION');
	m_signKey := derive(AValue, 'SIGNATURE');
end;

method WindowsLiveLogin.GetSecurityAlgorithm: String; 
begin
	if (m_SecurityAlgorithm = nil) or (m_SecurityAlgorithm.Length = 0) then
	begin
		result := 'wsignin1.0';
		exit;
	end;
	
	result := m_SecurityAlgorithm;
end;

method WindowsLiveLogin.GetBaseUrl: String; 
begin
	if (m_BaseUrl = nil) or (m_BaseUrl.Length = 0) then
	begin
		result := 'http://login.live.com/';
		exit;
	end;
	
	result := m_BaseUrl;
end;

method WindowsLiveLogin.GetSecureUrl: String; 
begin
	if (m_SecureUrl = nil) or (m_SecureUrl.Length = 0) then
	begin
		result := 'https://login.live.com/';
		exit;
	end;
	
	result := m_SecureUrl;
end;

class method WindowsLiveLogin.parseSettings(ASettingsFile: String): NameValueCollection;
begin
	if ASettingsFile = nil then
	begin
		raise new ArgumentNullException('ASettingsFile');
	end;
	
	result := new NameValueCollection;
	
	//*** Throws an exception on any failure
	var xd := new XmlDocument;
	xd.Load(ASettingsFile);
	
	// application id
	var appIdNode := xd.SelectSingleNode('//windowslivelogin/appid');	
	var l_appId := appIdNode:InnerText;
	if (l_appId = nil) or (l_appId.Length = 0) then
	begin
		raise new XmlException('Error: parseSettings: Could not read '
		  + '"appid" node in settings file: "' + ASettingsFile + "'");
	end;
	result['appid'] := l_appId;
	
	// secret
	var secretNode := xd.SelectSingleNode('//windowslivelogin/secret');	
	var l_secret := secretNode:InnerText;
	if (l_secret = nil) or (l_secret.Length = 0) then
	begin
		raise new XmlException('Error: parseSettings: Could not read '
		  + '"secret" node in settings file: "' + ASettingsFile + "'");
	end;
	result['secret'] := l_secret;
	
	// security algorithm
	var secalgoNode := xd.SelectSingleNode('//windowslivelogin/securityalgorithm');
	result['securityalgorithm'] := secalgoNode:InnerText;

	// base url
	var baseurlNode := xd.SelectSingleNode('//windowslivelogin/baseurl');
	result['baseurl'] := baseurlNode:InnerText;

	// secure url
	var securlNode := xd.SelectSingleNode('//windowslivelogin/secureurl');
	result['secureurl'] := securlNode:InnerText;
end;

/// <summary>
/// Processes the login response from the Windows Live Login server.
/// </summary>
///
/// <param name="query">Contains the preprocessed POST query
/// such as that returned by HttpRequest.Form</param>
/// 
/// <returns>The method returns a User object on successful
/// sign-in; otherwise null.</returns>
method WindowsLiveLogin.ProcessLogin(AQuery: NameValueCollection): User; 
begin
	result := nil;
	
	if (AQuery = nil) then
	begin
		debug('Error: ProcessLogin: Invalid Query');
		exit;
	end;
	
	var l_action := AQuery['action'];
	if l_action <> 'login' then
	begin
		debug('Warning: ProcessLogin: query action ignored: "' + l_action + '"');		
		exit;
	end;
	
	var l_token := AQuery['stoken'];
	var l_context := AQuery['appctx'];
	
	if (l_context <> nil) then
	begin
		l_context := HttpUtility.UrlDecode(l_context);
	end;
	
	result := ProcessToken(l_token, l_context);
end;


/// <summary>
/// Returns the sign-in URL to use for the Windows Live Login server.
/// We recommend that you use the Sign In control instead.
/// </summary>
/// <returns>Sign-in URL</returns>
method WindowsLiveLogin.GetLoginUrl: String; 
begin
	result := GetLoginUrl(nil);
end;

/// <summary>
/// Returns the sign-in URL to use for the Windows Live Login server.
/// We recommend that you use the Sign In control instead.
/// </summary>
/// <param name="context">If you specify it, <paramref
/// name="context"/> will be returned as-is in the login
/// response for site-specific use.</param>
/// <returns>Sign-in URL</returns>
method WindowsLiveLogin.GetLoginUrl(AContext: String): String; 
begin
	var l_algPart := '&alg=' + SecurityAlgorithm;
	var l_contextPart :=
 	   iif(AContext = nil, String.Empty, '&appctx=' + HttpUtility.UrlEncode(AContext));
	
	result := BaseUrl + 'wlogin.srf?appid=' + AppId + l_algPart + l_contextPart;
end;


/// <summary>
/// Returns the sign-out URL to use for the Windows Live Login server.
/// We recommend that you use the Sign In control instead.
/// </summary>
/// <returns>Sign-out URL</returns>
method WindowsLiveLogin.GetLogoutUrl: String;
begin
   result := BaseUrl + 'logout.srf?appid=' + AppId;
end;


/// <summary>
/// Decodes and validates a Web Authentication token. Returns a User
/// object on success.
/// </summary>
method WindowsLiveLogin.ProcessToken(AToken: String): User;
begin
	result := ProcessToken(AToken, nil);
end;


/// <summary>
/// Decodes and validates a Web Authentication token. Returns a User
/// object on success. If a context is passed in, it will be
/// returned as the context field in the User object.
/// </summary>
method WindowsLiveLogin.ProcessToken(AToken: String; AContext: String): User; 
begin
	result := nil;
	
	if (AToken = nil) or (AToken.Length = 0) then
	begin
		debug('Error: ProcessToken: Invalid token');
		exit;
	end;
	
	var l_token := DecodeToken(AToken);
	if (l_token = nil) or (l_token.Length = 0) then
	begin
		debug('Error: ProcessToken: Failed to decode token: "' + AToken + '"');
		exit;
	end;
	
	l_token := ValidateToken(l_token);
	if (l_token = nil) or (l_token.Length = 0) then
	begin
		debug('Error: ProcessToken: Failed to validate token: "' + AToken + '"');
	end;
	
	var l_parsedToken := HttpUtility.ParseQueryString(l_token);
	if (l_parsedToken = nil) or (l_parsedToken.Count < 3) then
	begin
		debug('Error: ProcessToken: Failed to parse token after decoding: "'
		    + AToken + '"');
      exit;
	end;
	
	var l_user: User := nil;	
	
	try
		l_user := new User(l_parsedToken['ts'], l_parsedToken['uid'],
						       l_parsedToken['flags'], AContext, AToken);
	except
		on E: Exception do
		begin
			debug('Error: ProcessToken: Contents of Token considered '
			   + 'innvalid: "' + E + '"');
		end;
	end;
	
	result := l_user;
end;

/// <summary>
/// When a user signs out of Windows Live or a Windows Live
/// application, a best-effort attempt is made to sign the user out
/// from all other Windows Live applications the user might be signed
/// in to. This is done by calling the handler page for each
/// application with 'action' parameter set to 'clearcookie' in the query
/// string. The application handler is then responsible for clearing
/// any cookies or data associated with the login. After successfully
/// signing the user out, the handler should return a GIF (any
/// GIF) as response to the action=clearcookie query.
///
/// This function returns an appropriate content type and body
/// response that the application handler can return to
/// signify a successful sign-out from the application.
/// </summary>
method WindowsLiveLogin.GetClearCookieResponse(out AType: String;
		 out AContent: Array of Byte);
const cGif = 'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAEALAAAAAABAAEAAAIBTAA7';
begin   
   AType := 'image/gif';
   AContent := Convert.FromBase64String(cGif);
end;


/// <summary>
/// Decode the given token. Returns null on failure.
/// </summary>
///
/// <list type="number">
/// <item>First, the string is URL unescaped and base64
/// decoded.</item>
/// <item>Second, the IV is extracted from the first 16 bytes
/// of the string.</item>
/// <item>Finally, the string is decrypted by using the
/// encryption key.</item> 
/// </list>
method WindowsLiveLogin.DecodeToken(AToken: String): String; 
begin
	result := nil;
	
	if (m_cyrptKey = nil) or (m_cyrptKey.Length = 0) then
	begin
		raise new InvalidOperationException('Error: DecodeToken: Secret key '
				+ 'was not set. Aborting');
	end;
	
	var l_ivLength := 16;
	var l_ivAndEncryptedValue: array of Byte := u64(AToken);
	
	if (l_ivAndEncryptedValue = nil) or
		(l_ivAndEncryptedValue.Length <= l_ivLength) or
		((l_ivAndEncryptedValue.Length mod l_ivLength) <> 0) then
	begin
		debug('Error: DecodeToken: Attempted to decode invalid token');
		exit;
	end;
	
	var l_aesAlg: Rijndael := nil;
	var l_memStream: MemoryStream := nil;
	var l_cStream: CryptoStream := nil;
	var l_sReader: StreamReader := nil;
	var l_decodedValue: String := nil;
	
	try
		l_aesAlg := new RijndaelManaged;
		l_aesAlg.KeySize := 128;
		l_aesAlg.Key := m_cyrptKey;
		l_aesAlg.Padding := PaddingMode.PKCS7;
		
		l_memStream := new MemoryStream(l_ivAndEncryptedValue);
		var l_iv := new array of Byte(l_ivLength);
		l_memStream.Read(l_iv, 0, l_ivLength);
		l_aesAlg.IV := l_iv;
		
		l_cStream := new CryptoStream(l_memStream,
		     l_aesAlg.CreateDecryptor, CryptoStreamMode.Read);
	   l_sReader := new StreamReader(l_cStream, Encoding.ASCII);
		l_decodedValue := l_sReader.ReadToEnd;
	except
		on E: Exception do
		begin
		   debug('Error: DecodeToken: Decryption failed: "' + E + '"');
		end;
	finally
		try
			if not (l_sReader = nil) then l_sReader.Close;
			if not (l_cStream = nil) then l_cStream.Close;
			if not (l_memStream = nil) then l_memStream.Close;
			if not (l_aesAlg = nil) then l_aesAlg.Clear;
		except
		   on E: Exception do
		   begin
		      debug('Error: DecodeToken: Failure during resource cleanup: "' + E + '"');
		   end;
		end;
	end;
	
	result := l_decodedValue;
end;

/// <summary>
/// Creates a signature for the given string by using the
/// signature key.
/// </summary>
method WindowsLiveLogin.SignToken(AToken: String): Array of Byte; 
begin
	result := nil;
	
	if (m_signKey = nil) or (m_signKey.Length = 0) then
	begin
		raise new InvalidOperationException('Error: SignToken: Secret key was '
		  + 'not set. Aborting');
	end;
	
   if (AToken = nil) or (AToken.Length = 0) then
   begin
	   debug('Attempted to sign null token.');
      exit;
   end;
	
	using lhashAlg := new HMACSHA256(m_signKey) do
	begin
		var l_data := Encoding.Default.GetBytes(AToken);
		var l_hash := lhashAlg.ComputeHash(l_data);
		result := l_hash;
	end;
end;


/// <summary>
/// Extracts the signature from the token and validates it.
/// </summary>
method WindowsLiveLogin.ValidateToken(AToken: String): String; 
begin
	result := nil;
	
	if (AToken = nil) or (AToken.Length = 0) then
	begin
		debug('Error: Validate Token: Invalid token.');
		exit;
	end;
	
	var s: Array of String := [ '&sig=' ];
	var l_bodyAndSig: Array of String := AToken.Split(s, StringSplitOptions.None);	
	if (l_bodyAndSig.Length <> 2) then
	begin
		debug('Error: ValidateToken: Invalid token: "' + AToken + '"');
		exit;
	end;
	
	var l_sig: Array of Byte := u64(l_bodyAndSig[1]);
	if (l_sig = nil) then
	begin
		debug('Error: ValidateToken: Could not extract the signature '
	      + 'from the token');
		exit;
	end;
	
	var l_sig2: Array of Byte := SignToken(l_bodyAndSig[0]);
	if (l_sig2 = nil) then
	begin
		debug('Error: ValidateToken: Could not generate a signature '
	      + 'from the token');
		exit;
	end;
	
	if (l_sig.Length = l_sig2.Length) then
	begin
		for each c in l_sig index i do
		begin
			if l_sig2[i] <> c then
			begin
				debug('Error: ValidateToken: Signature did not match.');
				exit;
			end;
		end;
		
		result := AToken;
	end;
end;

/// <summary>
/// Generates an Application Verifier token.
/// </summary>
method WindowsLiveLogin.GetAppVerifier: String; 
begin
	result := GetAppVerifier(nil);
end;

/// <summary>
/// Generates an Application Verifier token. An IP address
/// can be included in the token.
/// </summary>
method WindowsLiveLogin.GetAppVerifier(AIp: String): String; 
begin
	result := nil;

	var l_ipPart := iif(AIp = nil, String.Empty, '&ip=' + AIp);
	var l_token := 'appid=' + AppId + '&ts=' + getTimeStamp + l_ipPart;
 	var l_sig := e64(SignToken(l_token));

	if (l_sig = nil) then
	begin
 		debug('Error: GetAppVerifier: Failed to sign the token.');
	 	exit;
	end;
 	
   l_token := l_token + '&sig=' + l_sig;
	result := HttpUtility.UrlEncode(l_token);
end;

/// <summary>
/// Returns the URL needed to retrieve the application
/// security token. The application security token
/// will be generated for the Windows Live site.
///
/// JavaScript Output Notation (JSON) output is returned:
///
/// {"token":"&lt;value&gt;"}
/// </summary>
method WindowsLiveLogin.GetAppLoginUrl: String; 
begin
	result := GetAppLoginUrl(nil, nil, false);
end;

/// <summary>
/// Returns the URL needed to retrieve the application
/// security token.
///
/// By default, the application security token will be
/// generated for the Windows Live site; a specific Site ID
/// can optionally be specified in 'siteId'.
///
/// JSON output is returned:
///
/// {"token":"&lt;value&gt;"}
/// </summary>
method WindowsLiveLogin.GetAppLoginUrl(ASiteId: String): String; 
begin
	result := GetAppLoginUrl(ASiteId, nil, false);
end;

method WindowsLiveLogin.GetAppLoginUrl(ASiteId: String; AIp: String): String; 
begin
	result := GetAppLoginUrl(ASiteId, AIp, false);
end;

/// <summary>
/// Returns the URL needed to retrieve the application
/// security token.
///
/// By default, the application security token will be
/// generated for the Windows Live site; a specific Site ID
/// can optionally be specified in 'siteId'. The IP address
/// can also optionally be included in 'ip'.
///
/// JSON output is returned:
///
/// {"token":"&lt;value&gt;"}
/// </summary>
method WindowsLiveLogin.GetAppLoginUrl(ASiteId: String;
	AIp: String; AJs: Boolean): String; 
begin
	var l_algPart := '&alg=' + SecurityAlgorithm;
 	var l_sitePart := iif(ASiteId = nil, String.Empty, '&id=' + ASiteId);
   var l_jsPart := iif(not AJs, String.Empty, '&js=1');
	
 	result := SecureUrl + 'wapplogin.srf?app=' +
 		GetAppVerifier(AIp) + l_algPart + l_sitePart + l_jsPart;	 
end;

/// <summary>
/// Retrieves the application security token for application
/// verification from the application login URL. The
/// application security token will be generated for the
/// Windows Live site.
/// </summary>
method WindowsLiveLogin.GetAppSecurityToken: String; 
begin
	result := GetAppSecurityToken(nil, nil);
end;

/// <summary>
/// Retrieves the application security token for application
/// verification from the application login URL.
///
/// By default, the application security token will be
/// generated for the Windows Live site; a specific Site ID
/// can optionally be specified in 'siteId'.
/// </summary>
method WindowsLiveLogin.GetAppSecurityToken(ASiteId: String): String; 
begin
	result := GetAppSecurityToken(ASiteId, nil);
end;

/// <summary>
/// Retrieves the application security token for application
/// verification from the application login URL.
///
/// By default, the application security token will be
/// generated for the Windows Live site; a specific Site ID
/// can optionally be specified in 'siteId'. The IP address
/// can also optionally be included in 'ip'.
///
/// Implementation note: The application security token is
/// downloaded from the application login URL in JSON format
/// {"token":"&lt;value&gt;"}, so we need to extract
/// &lt;value&gt; from the string and return it as seen here.
/// </summary>
method WindowsLiveLogin.GetAppSecurityToken(ASiteId: String; AIp: String): String; 
begin
	result := nil;
	
	var l_url := GetAppLoginUrl(ASiteId, AIp);
	var l_body := fetch(l_url);

	if (l_body = nil) then
	begin
		debug('Error: GetAppSecurityToken: Failed to download token.');
		exit;
	end;
	
	var l_re: Regex := new Regex('{"token":"(.*)"}');
	var l_gc: GroupCollection := l_re.Match(l_body).Groups;
	
	if (l_gc.Count <> 2) then
	begin
		debug('Error: GetAppSecurityToken: Failed to extract token: "' + l_body + '"');
		exit;
	end;
	
	var l_cc: CaptureCollection := l_gc[1].Captures;
	
	if (l_cc.Count <> 1) then
	begin
		debug('Error: GetAppSecurityToken: Failed to extract token: "' + l_body + '"');
		exit;	
	end;
	
	result := l_cc[0].ToString;
end;

/// <summary>
/// Returns a string that can be passed to the GetTrustedParams
/// function as the 'retcode' parameter. If this is specified as
/// the 'retcode', then the app will be used as return URL
/// after it finishes trusted login.  
/// </summary>
method WindowsLiveLogin.GetAppRetCode: String; 
begin
	result := 'appid=' + AppId;
end;

/// <summary>
/// Returns a table of key-value pairs that must be posted to
/// the login URL for trusted login. Use HTTP POST to do
/// this. Be aware that the values in the table are neither
/// URL nor HTML escaped and may have to be escaped if you are
/// inserting them in code such as an HTML form.
/// 
/// The user to be trusted on the local site is passed in as
/// string 'user'.
/// </summary>
method WindowsLiveLogin.GetTrustedParams(AUser: String): NameValueCollection; 
begin
	result := GetTrustedParams(AUser, nil);
end;

/// <summary>
/// Returns a table of key-value pairs that must be posted to
/// the login URL for trusted login. Use HTTP POST to do
/// this. Be aware that the values in the table are neither
/// URL nor HTML escaped and may have to be escaped if you are
/// inserting them in code such as an HTML form.
/// 
/// The user to be trusted on the local site is passed in as
/// string 'user'.
/// 
/// Optionally, 'retcode' specifies the resource to which
/// successful login is redirected, such as Windows Live Mail,
/// and is typically a string in the format 'id=2000'. If you
/// pass in the value from GetAppRetCode instead, login will
/// be redirected to the application. Otherwise, an HTTP 200
/// response is returned.
/// </summary>
method WindowsLiveLogin.GetTrustedParams(AUser: String; ARetCode: String): NameValueCollection; 
begin
	result := nil;
	
	var l_token := GetTrustedToken(AUser);
	if (l_token = nil) then
		exit;
		
	l_token := '<wst:RequestSecurityTokenResponse '
	   + 'xmlns:wst="http://schemas.xmlsoap.org/ws/2005/02/trust">'
		+ '<wst:RequestedSecurityToken>'
		+ '<wsse:BinarySecurityToken '
		+ 'xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-'
		+ 'wssecurity-secext-1.0.xsd">'
		+ l_token
		+ '</wsse:BinarySecurityToken>'
		+ '</wst:RequestedSecurityToken>'
		+ '<wsp:AppliesTo '
		+ 'xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy">'
		+ '<wsa:EndpointReference'
		+ 'xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing">'
		+ '<wsa:Address>uri:WindowsLiveID</wsa:Address>'
		+ '</wsa:EndpointReference>'
		+ '</wsp:AppliesTo>'
		+ '</wst:RequestSecurityTokenResponse>';
		
	result := new NameValueCollection(3);
	
	result['wa'] := SecurityAlgorithm;
	result['wresult'] := l_token;
	if (ARetCode <> nil) then
	begin
		result['wctx'] := ARetCode;
	end;
end;

/// <summary>
/// Returns the trusted login token in the format needed by the
/// trusted login gadget.
///
/// User to be trusted on the local site is passed in as string
/// 'user'.
/// </summary>
method WindowsLiveLogin.GetTrustedToken(AUser: String): String; 
begin
	result := nil;
	
	if (AUser = nil) or (AUser.Length = 0) then
	begin
		debug('Error: GetTrustedToken: Invalid user specified.');
		exit;
	end;
	
	var l_token := 'appid=' + AppId + '&uid='
	  + HttpUtility.UrlEncode(AUser) + '&ts=' + getTimeStamp;
	var l_sig := e64(SignToken(l_token));
	
	if (l_sig = nil) then
	begin
	   debug('Error: GetTrustedToken: Failed to sign the token.');
		exit;
	end;
	
	l_token := l_token + '&sig=' + l_sig;
	result := HttpUtility.UrlEncode(l_token);
end;

/// <summary>
/// Returns the trusted sign-in URL to use for the Windows Live
/// Login server. 
/// </summary>
method WindowsLiveLogin.GetTrustedLoginUrl: String; 
begin
	result := SecureUrl + 'wlogin.srf';
end;

/// <summary>
/// Returns the trusted sign-out URL to use for the Windows Live
/// Login server. 
/// </summary>
method WindowsLiveLogin.GetTrustedLogoutUrl: String; 
begin
	result := SecureUrl + 'logout.srf?appid=' + AppId;
end;

/// <summary>
/// Derives the signature or encryption key, given the secret key 
/// and prefix as described in the SDK documentation.
/// </summary>
class method WindowsLiveLogin.derive(ASecret: String; APrefix: String): Array of Byte; 
const cKeyLength = 16;
begin
	using l_hashAlg := HashAlgorithm.Create('SHA256') do
	begin
		var l_data: Array of Byte := Encoding.Default.GetBytes(APrefix + ASecret);
		var l_hashoutput: Array of Byte := l_hashAlg.ComputeHash(l_data);
		var l_byteKey: Array of Byte := new Array of Byte(cKeyLength);
		Array.Copy(l_hashoutput, l_byteKey, cKeyLength);
		result := l_byteKey;
	end;
end;

/// <summary>
/// Generates a timestamp suitable for the application
/// verifier token.
/// </summary>
class method WindowsLiveLogin.getTimeStamp: String; 
begin
	var l_refTime := new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
	var l_ts := DateTime.UtcNow - l_refTime;
	result := UInt32(l_ts.TotalSeconds).ToString();
end;

/// <summary>
/// Base64-encode and URL-escape a byte array.
/// </summary>
class method WindowsLiveLogin.e64(Ab: array of Byte): String; 
begin
	result := nil;
	
	if (Ab = nil) then
		exit;
	
	try
		result := Convert.ToBase64String(Ab);
		result := HttpUtility.UrlEncode(result);
	except
		on E: Exception do
		begin
			debug('Error: e64: Base64 conversion error: "' + E + '"');
		end;
	end;
end;

/// <summary>
/// URL-unescape and Base64-decode a string.
/// </summary>
class method WindowsLiveLogin.u64(AStr: String): Array of Byte; 
begin
	result := nil;
	
	if (AStr = nil) then
		exit;
		
	AStr := HttpUtility.UrlDecode(AStr);
	
	try
		result := Convert.FromBase64String(AStr);
	except
		on E: Exception do
		begin
			debug('Error: u64: Base64 conversion error: "' + AStr + '", "' + E + '"');
		end;
	end;
end;

/// <summary>
/// Fetch the contents given a URL.
/// </summary>
class method WindowsLiveLogin.fetch(AUrl: String): String; 
begin
	result := nil;
	
	try
		var l_req := HttpWebRequest.Create(AUrl);
		l_req.Method := 'GET';
		var l_res := l_req.GetResponse;
		
		using l_sr := new StreamReader(l_res.GetResponseStream, Encoding.UTF8) do
		begin
			result := l_sr.ReadToEnd;
		end;
	except
		on E: Exception do
		begin
			debug('Error: fetch: Failed to get the document: "' + AUrl
			   + '", "' + E + '"');
		end;
	end;
end;

method WindowsLiveLogin.User.setId(AId: String); 
begin
	if (AId = nil) then
	begin
		raise new ArgumentNullException('Error: User: Null id in token.');
	end;
	
	var l_re := new Regex('^\w+$');
	if not l_re.IsMatch(AId) then
	begin
		raise new ArgumentException('Error: User: Invalid id: "' + AId + '"');
	end;
	
	m_id := AId;
end;

method WindowsLiveLogin.User.setTimestamp(ATimestamp: String); 
begin
	if (ATimestamp = nil) then
	begin
		raise new ArgumentNullException('Error: User: Null Timestamp in token.');
	end;
	
	var l_timestampInt: Integer;
	
	try
		l_timestampInt := Convert.ToInt32(ATimestamp);
	except
		raise new ArgumentException('Error: User: Invalid Timestamp: "'
		   + ATimestamp + '"');
	end;
	
	var l_refTime := new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
	m_timestamp := l_refTime.AddSeconds(l_timestampInt);
end;

method WindowsLiveLogin.User.setFlags(AFlags: String); 
begin
	UsePersistentCookie := false;
	
	if (AFlags = nil) or (AFlags <> '') then
	begin
		try
			UsePersistentCookie := ((Convert.ToInt32(AFlags) mod 2) = 1);
		except
			raise new ArgumentException('Error: User: Invalid flags: "' + AFlags + '"');
		end;
	end;
end;

constructor WindowsLiveLogin.User(ATimestamp: String; AId: String; AFlags: String;
	     AContext: String; AToken: String); 
begin
	setTimestamp(ATimestamp);
	setId(AId);
	setFlags(AFlags);
	Context := AContext;
	Token := AToken;
end;

end.