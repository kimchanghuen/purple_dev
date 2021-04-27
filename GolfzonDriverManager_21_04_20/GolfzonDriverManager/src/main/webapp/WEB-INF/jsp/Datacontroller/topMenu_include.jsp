<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8;"
         pageEncoding="UTF-8"
 %>
 
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<!DOCTYPE html> 
<html> 
<head> 
<meta charset="UTF-8">
 <title> DriverManager </title> 
 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js">  </script>
 
 </head> 
 <body bgcolor="#EFEFEF">
 <%
 
 // ------------------- 로그인 체크 -------------------
 String id = "";

	try {
		 // id 체크
		 id = (String)session.getAttribute("id");
		 
		 if (id == null || id.equals("")) {
			 response.sendRedirect("/LoginMain"); 
		  }
	} catch (Exception e) {
		  System.out.println("error : " + e.toString());
	}
// ------------------------------------------------------
 
 %>

 <div>
 <INPUT type = 'BUTTON' value = ' 코드관리 ' onclick="location='/subMenu_include' ">   
 <INPUT type = 'BUTTON' value = ' 모델별 드라이버 관리 ' onclick="location='/LinkList' ">
 <INPUT type = 'BUTTON' value = ' 툴 버전 관리 ' onclick="location='/ToolList' ">   
 <INPUT type = 'BUTTON' value = ' 메인으로 ' onclick="location='/DriverManager' ">      
 <br>

 </div>
 <br>
 <div id = "dataField"></div>

 
 </body> 
 </html>

 
 