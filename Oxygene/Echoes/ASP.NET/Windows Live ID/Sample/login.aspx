<%@ Page Language="Oxygene" AutoEventWireup="true" CodeFile="login.aspx.pas" Inherits="login" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>Oxygene Windows Live Login</title>
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />
    <style type="text/css">
		body {
			font-family: verdana;
         font-size: 10pt;
         color: black;
         background-color: white;
      }
      h1 {
         font-family: verdana;
         font-size: 10pt;
         font-weight: bold;
         color: #0070C0;			
		}
    </style>
</head>
<body>
	<div style="width:320px">
    <h1>Welcome to the RemObjects Oxygene Sample for the Windows Live&trade; ID Web
    Authentication SDK</h1>

    <p>The text of the link below indicates whether you are signed in
    or not. If the link invites you to <b>Sign in</b>, you are not
    signed in yet. If it says <b>Sign out</b>, you are already signed
    in.</p>

    <iframe 
       id="WebAuthControl" 
       name="WebAuthControl"
       src="http://login.live.com/controls/WebAuth.htm?appid=<%=AppId%>&style=font-size%3A+10pt%3B+font-family%3A+verdana%3B+background%3A+white%3B"
       width="80px"
       height="20px"
       marginwidth="0"
       marginheight="0"
       align="middle"
       frameborder="0"
       scrolling="no">
   </iframe>	
	<p>
	<% if (m_userId = nil) then begin %>
      This application does not know who you are! Click the <b>Sign in</b> link above.
	<%  end else begin %>
      Now this application knows that you are the user with ID = "<b><%= m_userId.ToString %></b>".
	<% end; %>
</p>
	</div>	    
</body>
</html>
