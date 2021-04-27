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

 // 파일유무 체크
 function fileChk() {
	 
     var file = document.getElementById('fileUp').value;
     
     file = file.replace('C:\\fakepath\\','');
        
     $.ajax({
         type : 'post',
         url : '/fileCheck/' + file,
         data : "",
         processData : false,
         contentType : false,
         success : function(html) {
        	 html = html.trim();
        	 
        	 if(html == 'true') {
        		 var checker = confirm("서버에 파일이 존재합니다.\n덮어씌우시겠습니까?");
       
        		 if (checker ) {
        			 fileSubmit();		 
        		 } else if (!checker) {
        			 alert("파일 올리기를 취소하셨습니다.");
        			 return;
        		 }
        	 } else { 
        		 fileSubmit();
             }
        	 
         },

         beforeSend:function(){
        	// 로딩 이미지 호출 
        	$('.wrap-loading').removeClass('display-none');
         },
         complete:function(){
        	// 로딩 이미지 제거 
        	$('.wrap-loading').addClass('display-none');
         },
         error : function(error) {
             alert("파일 업로드에 실패하였습니다.");
             console.log(error);
             console.log(error.status);
         }
         
     });
 }
 
 function fileSubmit() {
     var formData = new FormData($("#fileForm")[0]);
     var d_idx = document.getElementById('idx').value;
     
     $.ajax({
         type : 'post',
         url : '/fileUpload/' + d_idx,
         data : formData,
         processData : false,
         contentType : false,
         success : function(html) {
        	 location.href="/DriverList"; 
         },
         error : function(error) {
             alert("파일 업로드에 실패하였습니다.");
             console.log(error);
             console.log(error.status);
         }
     });
     
     
 }
 
 </script> 
 
 <style type="text/css" >

	.wrap-loading{ /*화면 전체를 어둡게 합니다.*/
	    position: fixed;
	    left:0;
	    right:0;
	    top:0;
	    bottom:0;
	    background: rgba(0,0,0,0.2); /*not in ie */
	    filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000', endColorstr='#20000000');    /* ie */
	}

    .wrap-loading div{ /*로딩 이미지*/
        position: fixed;
        top:50%;
        left:50%;
        margin-left: -21px;
        margin-top: -21px;
    }
    .display-none{ /*감추기*/
        display:none;
    }

</style>


 </head> 
 <body>

 <%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="d_idx" value="${d_idx}"/>
<c:set var="d_filename" value="${d_filename}"/>

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


 String d_idx =  (String)pageContext.getAttribute("d_idx");
 String d_filename =  (String)pageContext.getAttribute("d_filename"); 

%>
<div style="cursor:pointer; height:auto; margin: 15px 25px 15px 0px; " >

	 <!-------------------- 파일 업로드 구현 -------------------->
	 <form action="/fileupload" method="post" enctype="Multipart/form-data" id="fileForm">
        업로드 파일 : <input type="file" id="fileUp" name="fileUp" />
        <input type="hidden" id="idx" name="idx" value="<%=d_idx%>" />
        <input type="button" value="수정하기" onClick="fileChk();">
    </form>
</div>

<div class="wrap-loading display-none">
    <div><img src="../../../images/LoadingImage.gif" width="100" height="100" /></div>
</div>  
 
 
<br><br> 
<a href="/DriverList">뒤로가기</a>

</body>
 </html>
 