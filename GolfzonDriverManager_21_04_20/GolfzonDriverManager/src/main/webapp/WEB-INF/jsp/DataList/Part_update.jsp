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
 
 // 입력값 체크
 function valueChk() {
	 // 코드명 체크
	 var chekcCode = document.getElementById('name').value;
	 
	 // 코드명 null
	 if ( !chekcCode ) {
		 alert("코드명을 입력해주세요")
		 return false;
	 }
	 
	 // 코드명 길이 제한
	 if ( chekcCode.length > 20 ) {
		 alert("코드명은 20글자 내로 입력해주세요.")
		 return false;
	 }
	 
	 /*	 
	 // 코드명 한글 제한
	 var korCheck = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
	 if (  korCheck.test(chekcCode) ) {
		 alert("코드명에 한글은 불가능합니다.")
		 return false;
	 }
	 */
	 
	 return true;
 }
 
 // 수정하기 클릭시
 function part_change()
 {
	 if ( valueChk() ) {
		 var code = document.getElementById('code').value;
		 var name = document.getElementById('name').value;
		 var enable = $(".enable").val();
		 
		 var paramText = "code="+ code
		    + "&name="+ name
		    + "&enable="+ enable	 
		
	     paramText = encodeURI(paramText);
		 
		 $.ajax({
		        url : "/Part/PartUpdate_sql",
		        data : paramText,
		        type : 'get',
		        success : function(data){
		        	location.href="/Part/PartList"; 
		        },
		        error:function(request,status,error){
		            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		        }
		    });
	 }
 }
 
 function deleteCheck() {
	 var checker = confirm("정말 해당 코드를 삭제하시겠습니까?");
		
		if ( checker ) {
			 
			part_delete();
			 
		 } else if ( !checker ) {
			 alert("삭제를 취소하셨습니다.");
			 return;
		 } 
 }
 
 // 삭제하기
  function part_delete()
 {
	 var code = document.getElementById('code').value;
	 var name = document.getElementById('name').value;
	 var enable = $(".enable").val();
	 
	 var paramText = "code="+ code
	    + "&name="+ name
	    + "&enable="+ enable	 
	    
    paramText = encodeURI(paramText);

	 $.ajax({
	        url : "/Part/PartDelete_sql",
	        data : paramText,
	        type : 'get',
	        success : function(data){
	        	location.href="/Part/PartList"; 
	        },
	        error:function(request,status,error){
	            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        }
	    });
 }
 
 
 </script> 
 </head> 
 <body>

 <div id="header">
 <jsp:include page="../Datacontroller/NewtopMenu_sub3.jsp" flush="false"/>
 </div>
 
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

 
 String p_code =  request.getParameter("p_code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
 String p_name =  request.getParameter("p_name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
 String p_enable =  request.getParameter("p_enable");
     
 System.out.println("update 파라미터 확인");
 System.out.println("p_code : " + p_code + " / p_name : " + p_name + " / p_enable : " + p_enable);
 
%>
<div style="height:auto; text-align:center;" >
	 
	 <table style="margin:auto;">
	    <tr>
	    	<td class="EditPageTable">코　드</td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable"><input type="text" id="code" value="<%=p_code %>" disabled></input></td>
	    </tr>
	    <tr>
	    	<td class="EditPageTable">코드명</td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable"><input type="text" id="name" value="<%=p_name %>"></input></td>
	    </tr>
	    <tr>
	    	<td class="EditPageTable"></td>
	    	<td class="EditPageTable"></td>
	    	<td class="EditPageTable"><font size="2px" color="red">※ 코드명은 20글자 내로 입력해주십시오.</font></td>
	    </tr>
	    <tr>
	    	<td class="EditPageTable"><label>사용여부</label></td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable"> 
	    		 <select class="enable" id="enable">
					 <% if ( p_enable.equals("1") ) { %> 
					     <option value="1" selected>사용</option>
						 <option value="0">미사용</option>
					  <% }  else {
					   %>
						 <option value="1" >사용</option>
				  		 <option value="0"selected >미사용</option>
					 <%		 
					 } %>
				 </select>	 
	    	</td>
	    </tr>
	</table>
	 

					
	
<br> 
<button type="button" onclick="part_change(); "> 수정하기 </button> 
<button type="button" onclick="deleteCheck(); "> 삭제하기 </button>  
<button type="button" onclick="location.href='/Part/PartList' "> 뒤로가기 </button>

</div>
</body>
 </html>
 