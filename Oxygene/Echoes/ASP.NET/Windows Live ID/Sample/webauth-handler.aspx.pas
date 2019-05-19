namespace;

interface

uses
  System,
  System.IO,
  System.Web,
  WindowsLive;

type
  WindowsLiveAuthHandler = public partial class(System.Web.UI.Page)
  const
    LoginPage = 'login.aspx';
	 LogoutPage = LoginPage;
	 LoginCookie = 'webauthtoken';
  class var ExpireCookie: DateTime := DateTime.Now.AddYears(-10);
  class var PersistCookie: DateTime := DateTime.Now.AddYears(10);
  class var WLL: WindowsLiveLogin := new WindowsLiveLogin(true);  
  protected
    method Page_Load(sender: Object; e: EventArgs);
  end;

implementation

method WindowsLiveAuthHandler.Page_Load(sender: Object; e: EventArgs);
begin
	var l_req := HttpContext.Current.Request;
	var l_res := HttpContext.Current.Response;
	
	var l_action := l_req.QueryString.Get('action');

	{
		If action is 'logout', clear the login cookie and redirect
		to the logout page.

		If action is 'clearcookie', clear the login cookie and
		return a GIF as response to signify success.

		By default, try to process a login. If login was
		successful, cache the user token in a cookie and redirect
		to the site's main page.  If login failed, clear the cookie
		and redirect to the main page.
   }
	case l_action of
   	'logout': begin
         var l_cookie := new HttpCookie(LoginCookie);
			l_cookie.Expires := ExpireCookie;
			l_res.Cookies.Add(l_cookie);
			l_res.Redirect(LogoutPage);
			l_res.End;
		end;
		  
		'clearcookie': begin
         var l_cookie := new HttpCookie(LoginCookie);
			l_cookie.Expires := ExpireCookie;
			l_res.Cookies.Add(l_cookie);
			
			var l_type: String;
			var l_content: Array of Byte;
			WLL.GetClearCookieResponse(out l_type, out l_content);
			l_res.ContentType := l_type;
			l_res.OutputStream.Write(l_content, 0, l_content.Length);
			
			l_res.End;		 
		end;
		  
		else begin
		   var l_user := WLL.ProcessLogin(l_req.Form);
			
         var l_cookie := new HttpCookie(LoginCookie);

			if (l_user <> nil) then
			begin
				l_cookie.Value := l_user.Token;
				if l_user.UsePersistentCookie then
				begin
					l_cookie.Expires := PersistCookie;
				end;
			end
			else
			begin
			   l_cookie.Expires := ExpireCookie;	
			end;
			
			l_res.Cookies.Add(l_cookie);
			l_res.Redirect(LogoutPage);
			l_res.End;			
		end;
	end;
end;

end.
