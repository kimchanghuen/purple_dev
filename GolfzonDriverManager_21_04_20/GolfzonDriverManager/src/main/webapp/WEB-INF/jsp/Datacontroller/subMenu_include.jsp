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
 <body>
 
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
 
 
 <div id="top_header" style="line-height:50%;">
 <jsp:include page="../Datacontroller/topMenu_include.jsp" flush="false"/>

 <INPUT type = 'BUTTON' value = ' 분류 ' onclick="location='/KindList' ">   
 <INPUT type = 'BUTTON' value = ' 모델 ' onclick="location='/ModelList' ">   
 <INPUT type = 'BUTTON' value = ' 종류 ' onclick="location='/PartList' ">   
 <INPUT type = 'BUTTON' value = ' 구분 ' onclick="location='/TypeList' ">
 <INPUT type = 'BUTTON' value = ' 드라이버/소프트웨어 ' onclick="location='/DriverList'">
 <br>

 </div>
 <br>
 <div id = "dataField"></div>

 
 </body> 
 </html>

 
 