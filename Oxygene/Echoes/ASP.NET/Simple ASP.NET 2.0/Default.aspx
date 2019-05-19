<%@ Page Language="Oxygene" AutoEventWireup="true"  CodeFile="Default.aspx.pas" Inherits="DefaultPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
	    <title>ASP.NET Sample</title>
		<style type="text/css"> 
		BODY 
		{ 
		    FONT-SIZE: 10pt; 
		    MARGIN: 15px; 
		    FONT-FAMILY: Tahoma, Verdana, sans-serif; 
		    BACKGROUND-COLOR: #f7f7f7 
		} 
		TABLE 
		{ 
		    FONT-SIZE: 10pt; 
		    MARGIN: 15px; 
		    FONT-FAMILY: Tahoma, Verdana, sans-serif; 
		    BACKGROUND-COLOR: #f7f7f7 
		} 
		TR 
		{ 
		    FONT-SIZE: 10pt; 
		    MARGIN: 15px; 
		    FONT-FAMILY: Tahoma, Verdana, sans-serif; 
		    BACKGROUND-COLOR: #f7f7f7 
		} 
		TD 
		{ 
		    FONT-SIZE: 10pt; 
		    MARGIN: 15px; 
		    FONT-FAMILY: Tahoma, Verdana, sans-serif; 
		    BACKGROUND-COLOR: #f7f7f7 
		} 
		P 
		{ 
		    MARGIN-TOP: 0px; 
		    MARGIN-BOTTOM: 0.75em 
		} 
		P.h1 
		{ 
		    MARGIN-TOP: 1em; 
		    MARGIN-BOTTOM: 0px; 
		    PADDING-BOTTOM: 0px 
		} 
		P.h2 
		{ 
		    MARGIN-TOP: 1em; 
		    MARGIN-BOTTOM: 0px; 
		    PADDING-BOTTOM: 0px 
	    } 
	    P.h3 
	    {
	        MARGIN-TOP: 1em; 
	        MARGIN-BOTTOM: 0px; 
	        PADDING-BOTTOM: 0px 
	    } 
	    A 
	    { 
	        TEXT-DECORATION: none 
	    } 
	    .h1 
	    { 
	        FONT-WEIGHT: bold; 
	        FONT-SIZE: 13pt 
	    } 
	    .h2 
	    { 
	        FONT-WEIGHT: bold; 
	        FONT-SIZE: 11pt 
	    } 
	    .h3 
	    { 
	        FONT-WEIGHT: bold; 
	        FONT-SIZE: 10pt 
	    } 
	    UL 
	    { 
	        MARGIN-TOP: 0px; 
	        MARGIN-BOTTOM: 0.75em 
	    } 
	    OL 
	    { 
	        MARGIN-TOP: 0px; 
	        MARGIN-BOTTOM: 0.75em 
	    } 
	    PRE 
	    { 
	        MARGIN: 0px 
	    } 
	    .spaced 
	    { 
	        COLOR: #000060; 
	        LETTER-SPACING: 1px 
	    } 
	    </style>
	</head>
	<body>
		<form id="Form1" runat="server">
			<img src="Elements.png" style="PADDING-BOTTOM: 15px" alt=""/>
			<p class="h1">ASP.NET Sample</p>
			<table border="0">
				<tr>
					<td><b>Input:</b></td>
					<td>
						<asp:TextBox id="edInput" runat="server"></asp:TextBox>
					</td>
					<td><asp:LinkButton id="btnRefresh" accessKey="R" runat="server" OnClick="btnRefresh_Click">Refresh</asp:LinkButton></td>
				</tr>
			</table>
			<table border="0">
				<tr>
					<td>&nbsp;</td>
					<td><b>From Celsius</b></td>
					<td><b>From Fahrenheit</b></td>
					<td><b>From Kelvin</b></td>
				</tr>
				<tr>
					<td><b>To Celsius</b></td>
					<td><asp:TextBox id="edCtoC" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
					<td><asp:TextBox id="edFtoC" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
					<td><asp:TextBox id="edKtoC" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
				</tr>
				<tr>
					<td><b>To Fahrenheit</b></td>
					<td><asp:TextBox id="edCtoF" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
					<td><asp:TextBox id="edFtoF" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
					<td><asp:TextBox id="edKtoF" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
				</tr>
				<tr>
					<td><b>To Kelvin</b></td>
					<td><asp:TextBox id="edCtoK" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
					<td><asp:TextBox id="edFtoK" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
					<td><asp:TextBox id="edKtoK" runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td><b>KM to Miles:</b></td>
					<td><asp:TextBox ID="edKMtoMI" Runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td><b>Miles to KM:</b></td>
					<td><asp:TextBox ID="edMItoKM" Runat="server" BackColor="LightGray" ReadOnly="True"></asp:TextBox></td>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</form>
	</body>
</html>
