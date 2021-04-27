<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
 %>
 
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.Golfzon.DBManager" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html> 
<html> 
<head> 
<meta charset="UTF-8">
 <title> DriverManager </title> 
 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js"> </script>
 
 <script type="text/javascript">  

//입력값 체크
 function NoticeUpdate() {
	 
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
 
 // 수정하기 클릭시
 function Noticechange()
 {
	 if ( NoticeUpdate() ) {
			// 제목
			var n_title = document.getElementById('n_title').value;
			 
			// 내용 
			var n_body = document.getElementById('n_body').value;
			
			n_body = n_body.replace(/(?:\r\n|\r|\n)/g, '\\r\\n'); 
			
			// n_body = encodeURI(n_body);
			
			console.log(n_body);
			// 완료여부
			var n_enable = $(".enable").val();
			
			// idx
			var n_idx = document.getElementById('idx').value;
			
			var paramText = "n_title="+ n_title
			    + "&n_body="+ n_body
			    + "&n_enable="+ n_enable
			    + "&n_idx="+ n_idx
			
			    paramText = encodeURI(paramText);
			    
			    $.ajax({
			        url : "/Notice/NoticeUpdate_sql",
			        data : paramText,
			        type : 'get',
			        success : function(data){			        	
			        	location.href="/DriverManager";
			        },
			        error:function(request,status,error){
			            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			        }
			    });
	 }
	
 }
 
 // 데이터 삭제 클릭시
 function deleteClick() {
	// 완료여부
	var n_enable = $(".enable").val();
	
	if ( n_enable == '1' ) {
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
        	console.log('성공')
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
  
 <%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

 <c:set var="n_idx" value="${n_idx}"/>
 
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

 
 String n_idx=request.getParameter("n_idx");
 String n_title=request.getParameter("n_title");
 String n_body=request.getParameter("n_body");
 String n_enable=request.getParameter("n_enable");
 String n_startdate=request.getParameter("n_startdate");
 String n_enddate=request.getParameter("n_enddate");
 String n_mome=request.getParameter("n_mome");
  
 
 try
 {
     Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
     DBManager db = new DBManager();

     Connection con = db.dbConn();
         
     PreparedStatement pstmt=null ; //create statement
		        
     StringBuffer query = new StringBuffer();
     query.append( " SELECT n_body FROM DRV_NOTICE WHERE n_idx = '" + n_idx + "' LIMIT 1 " );        
     
     System.out.println(" 쿼리 확인 : ");
     System.out.println( query.toString() );
     
		pstmt=con.prepareStatement( query.toString() );		
     
     ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

     // 데이터의 가장 끝으로 보내기
     rs.last();
     
     // rs.getRow() : 데이터의 가장 끝 index
     if ( rs.getRow() > 0 ) {
     	
     	// 데이터의 가장 처음으로 보내기
     	rs.beforeFirst();
     	        	
	        while( rs.next() ){
	        	  n_body = rs.getString("n_body");
	        	  
	        	  if ( n_body.contains("\\r\\n") ) {
	        		  n_body = n_body.replace("\\r\\n", "&#10;");
	        	  }
	        	  
	        } 
     } else {
    	 n_body = "입력한 사항이 없습니다.";
     }
     con.close(); //close connection
 }
 catch(Exception e)
 {
     System.out.println(e.toString());
 } 
%>
<div style="height:auto; text-align:center;" >

<!-- 테이블 폼으로 변경 -->
    <table style="margin:auto;">
	    <tr>
	    	<td class="EditPageTable">제　　목</td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable"><input type="text" id="n_title" value="<%=n_title %>"></input></td>
	    </tr>
	    <tr>
	    	<td class="EditPageTable">완료여부</td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable">
		    	<select class="enable" id="enable" style="width:173px">
					 <% if ( n_enable.equals("1") ) { %> 
					     <option value="1" selected>미공지</option>
						 <option value="2">공지중</option>
					  <% }  else {
					   %>
						 <option value="2" selected >공지중</option>
				  		 <option value="1" >미공지</option>
					 <%		 
					 } %>
				 </select>
	    	</td>
	    </tr>
	    <tr>
	    	<td class="EditPageTable">내　　용</td>
	    	<td class="EditPageTable">:</td>
	    	<td class="EditPageTable"><textarea name=n_body id="n_body" cols=50 rows=10 ><%=n_body %></textarea></td>
	    </tr>
	</table>
    


<input type="hidden" id="idx" value="<%=n_idx %>"></input>

<br>
<button type="button" onclick="Noticechange(); "> 수정하기 </button>
<button type="button" onclick="deleteClick(); "> 삭제하기 </button>  
<button type="button" onclick="location.href='/DriverManager' "> 뒤로가기 </button>

</div>

<div class="wrap-loading display-none">
    <div><img src="../../../images/LoadingImage.gif" width="100" height="100" /></div>
</div>  

</body>
 </html>
 