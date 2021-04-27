<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
 %>
 
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
    


<!DOCTYPE html> 
<html> 
<head> 
<meta charset="UTF-8">
 <title> DriverManager </title> 
 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js"> </script>
 
 <script type="text/javascript">  
 
 function fileSubmit() {
     var formData = new FormData($("#fileForm")[0]);
     var tool_idx = document.getElementById('idx').value;

     
     $.ajax({
         type : 'post',
         url : '/fileUploadTool/' + tool_idx,
         data : formData,
         processData : false,
         contentType : false,
         success : function(html) {
        	         	 
         },
         error : function(error) {
             alert("파일 업로드에 실패하였습니다.");
             console.log(error);
             console.log(error.status);
         }
     });
     
     
 }
 
 </script> 
 </head> 
 <body>

 <%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="tool_idx" value="${tool_idx}"/>
<c:set var="tool_filename" value="${tool_filename}"/>

 <%
 
 // ------------------- 로그인 체크 -------------------
String id = "";

try {
	 // id 체크
	 id = (String)session.getAttribute("id");
	 
	 if (id == null || id.equals("")) {
		 response.sendRedirect("/Login/LoginMain"); 
	  }
} catch (Exception e) {
	  System.out.println("error : " + e.toString());
}
// ------------------------------------------------------

 String tool_idx =  (String)pageContext.getAttribute("tool_idx");
 String tool_filename =  (String)pageContext.getAttribute("tool_filename"); 
  
%>
<div style="cursor:pointer; height:auto; margin: 15px 25px 15px 0px; " >

	 <!-------------------- 파일 업로드 구현 -------------------->
	 <form action="/fileupload" method="post" enctype="Multipart/form-data" id="fileForm">
        업로드 파일 : <input type="file" id="fileUp" name="fileUp" />
        <input type="hidden" id="idx" name="idx" value="<%=tool_idx%>" />
        <input type="button" value="수정하기" onClick="fileSubmit();">
    </form>
</div>

<br><br> 
<a href="/ToolList">뒤로가기</a>

</body>
 </html>
 