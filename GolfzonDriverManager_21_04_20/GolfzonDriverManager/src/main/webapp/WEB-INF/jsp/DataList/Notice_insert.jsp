<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
 %>
 
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html> 
<html> 
<head> 
<meta charset="UTF-8">
 <title> DriverManager </title> 
 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js"> </script>
 
 <script type="text/javascript">  

//입력값 체크
 function ValueCheck() {
	 
	// 제목
	var n_title = document.getElementById('n_title').value;
	 
	// 내용 
	var n_body = document.getElementById('n_body').value;
	
	// 완료여부
	var n_enable = $(".enable").val();
	
	// 빈칸 체크
	if ( !n_title ) { alert("제목을 입력해주세요")	; return false;	}
	if ( !n_body ) { alert("내용을 입력해주세요");	 return false;	}
	
	/*
	// 업로드 파일명 한글체크
	var korCheck = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
	 if (  korCheck.test(file) ) {
		 alert("파일명은 영어와 숫자로 변경해주세요.")
		 return false;
	 }
	 
	 // 코드명 길이 제한
	 if ( chekcCode.length > 5 ) {
		 alert("코드명은 5글자 내로 입력해주세요.")
		 return false;
	 }
	 */
	 
	 return true;
 }
 
 var click = true;
 
 // 추가하기 클릭시
 function NoticeInsert()
 {
	 if (click) {
		 
		 click = !click;
		 
		 if ( ValueCheck() ) {
				// 제목
				var n_title = document.getElementById('n_title').value;
				 
				console.log("title : " + n_title);
				// 내용 
				var n_body = document.getElementById('n_body').value;
				console.log("변환전 : " + n_body);
				n_body = n_body.replace(/(?:\r\n|\r|\n)/g, '\\r\\n'); 
				
				console.log("변환후 : " + n_body);
				
				// n_body = encodeURI(n_body);
				
				
				// 완료여부
				var n_enable = $(".enable").val();
				
				var paramText = "n_title="+ n_title
				    + "&n_body="+ n_body
				    + "&n_enable="+ n_enable
				    
				    paramText = encodeURI(paramText);
				    console.log("paramText : " + paramText);
				    
				    $.ajax({
				        url : "/Notice/NoticeInsert_sql",
				        data : paramText,
				        type : 'post',
				        success : function(data){	
				        	console.log('성공')
				        	location.href="/DriverManager";
				        },
				        error:function(request,status,error){
				            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				        }
				    });
				
				setTimeout(function(){
				 	click = true;
				 	}, 3000)
				 	
				 	
		 }
	 }
	
 }
 
 // 데이터 삭제 클릭시
 function deleteClick() {
	// 완료여부
	var n_enable = $(".enable").val();
	
	if ( n_enable = '1' ) {
		var checker = confirm("해당 공지사항은 미공지한 내용입니다.\n정말 해당 공지사항을 삭제하시겠습니까?");
	
		if ( checker ) {
			 
			Notice_delete();
			 
		 } else if ( !checker ) {
			 alert("삭제를 취소하셨습니다.");
			 return;
		 } 
	} else {
		var checker = confirm("정말 해당 공지사항을 삭제하시겠습니까?");
		
		if ( checker ) {
			 
			Notice_delete();
			 
		 } else if ( !checker ) {
			 alert("삭제를 취소하셨습니다.");
			 return;
		 }
	}
	 
 }
 
 function Notice_delete() {
	// idx 정보
	var n_idx = document.getElementById('idx').value;
	
	var paramText = "n_idx="+ n_idx	
	    
    $.ajax({
        url : "/Notice/NoticeDelete_sql",
        data : paramText,
        type : 'post',
        success : function(data){		
        	console.log('삭제성공')
        	location.href="/DriverManager";
        },
        error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
 }
 
 
 </script> 

 </head> 
 <body>
 <div id="top_header">
  <jsp:include page="../Datacontroller/NewtopMenu.jsp" flush="false"/>
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

%>
<div style="height:auto;" >

<!-- 테이블 폼으로 변경 -->
    <table style="margin:auto;">
	    <tr>
	    	<td class="EditPageTable">제　　목</td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable"><input type="text" id="n_title" value=""></input></td>
	    </tr>
	    <tr>
	    	<td class="EditPageTable">완료여부</td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable">
		    	<select class="enable" id="enable" style="width:173px">
					     <option value="1" selected>미공지</option>
						 <option value="2">공지중</option>
				 </select>
	    	</td>
	    </tr>
	    <tr>
	    	<td class="EditPageTable">내　　용</td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable"><textarea name=n_body id="n_body" cols=50 rows=10 ></textarea></td>
	    </tr>
	</table>
    
</div>

<br>
  <div id = "buttonDiv" style="text-align:center;">
	<button type="button" onclick="NoticeInsert(); "> 추가하기 </button>  
	<button type="button" onclick="location.href='/DriverManager' "> 뒤로가기 </button>
  </div>   

<div class="wrap-loading display-none">
    <div><img src="../../../images/LoadingImage.gif" width="100" height="100" /></div>
</div>  

</body>
 </html>
 