namespace;

interface

uses
  System,
  System.IO,
  System.Web,
  WindowsLive;

type
  login = public partial class(System.Web.UI.Page)
  protected
    const LoginCookie = 'webauthtoken';
    class var WLL: WindowsLiveLogin := new WindowsLiveLogin(true);
	 class var AppId: String := WLL.AppId;
	 var m_userId: String;	 	 
    method Page_Load(sender: Object; e: EventArgs);
  end;

implementation

method login.Page_Load(sender: Object; e: EventArgs);
begin
	{
		If the user token has been cached in a site cookie, attempt
      to process it and extract the user ID.
	}

	var l_req := HttpContext.Current.Request;
	var l_cookie := l_req.Cookies[LoginCookie];

	if l_cookie <> nil then
	begin
		var l_token := l_cookie.Value;
		
		if (l_token <> nil) and (l_token.Length <> 0) then
		begin
			var l_user := WLL.ProcessToken(l_token);
			
			if l_user <> nil then
			begin
				m_userId := l_user.Id;
			end;
		end;
	end;
end;

end.
