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
 <title> ETC Edit </title>
 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js">  </script>

  <script type="text/javascript">
  // 파일수정 클릭시
 function saveClick(){
	 
	 var etcData = document.getElementById('d_etc').value; 
	 
	 etcData = encodeURI(etcData);
	 
 	 var paramText = "etcData="+ etcData
	
 	$.ajax({
        url :  "${pageContext.request.contextPath}/editETCsaveAll",
        data : paramText,
        type : 'get',
        success : function(data){
        	
        	// 메인 화면으로 이동
        	location.href="DriverManager"; 
        	
        },
        error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });	  
 	
 	
 	
 } 
  
  </script>
           
 </head> 
 <body>
 
 <label> 일괄 추가할 json : </label> <br>
 
 <textarea name="d_etc" id="d_etc" cols=50 rows=10 ></textarea>

<br>
값을 JSON 형식으로 넣어주세요 <br>
예시 : {"test":"123", "test2":"456789"}
<br><br>
<INPUT type = 'BUTTON' value = ' 저장 ' onclick="saveClick()">


</body>
</html>