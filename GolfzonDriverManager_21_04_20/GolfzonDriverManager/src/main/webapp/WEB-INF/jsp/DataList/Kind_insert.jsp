<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
 %>
 
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.Golfzon.DBManager" %>

<!DOCTYPE html> 
<html> 
<head> 
<meta charset="UTF-8">
 <title> DriverManager </title> 
 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js">  </script>
 
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
	 if ( chekcCode.length > 10 ) {
		 alert("코드명은 10글자 내로 입력해주세요.")
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
 
 var click = true;
 
 // 추가하기 클릭시
 function kind_insert()
 {
	 
	 if( valueChk() ){
		 if (click) {
			 
			 click = !click;
			 
			 var code = document.getElementById('code').value;
			 var name = document.getElementById('name').value;
			 
			 var paramText = "code="+ code
			    + "&name="+ name
			    
			 paramText = encodeURI(paramText);
			 			 
			 $.ajax({
			        url : "/Kind/Kindinsert_sql",
			        data : paramText,
			        type : 'post',
			        success : function(data){
			        	log_insert();
			        	
			        	location.href="/Kind/KindList"; 
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
 
 // log insert
 function log_insert()
 {
	 var log_type = "I";
	 var log_table = "DRV_KIND";
	 var name = document.getElementById('name').value;
	 var log_detail = "\'" + name + "\' 이(가) 신규 생성되었습니다.";	 
	 var code = document.getElementById('code').value;
	 
	 
	 var paramText = "log_type="+ log_type
	    + "&log_table="+ log_table
	    + "&log_detail="+ log_detail
	    + "&log_code="+ code
	    
	    paramText = encodeURI(paramText);
	 
	 $.ajax({
	        url : "/Log/LogInsert_sql",
	        data : paramText,
	        type : 'get',
	        success : function(data){
	        	console,log("LOGINSERT 성공")
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
 <jsp:include page="../Datacontroller/NewtopMenu_sub1.jsp" flush="false"/>
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
  
    try
 {
     Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
     DBManager db = new DBManager();
 	
     Connection con = db.dbConn();
         
     PreparedStatement pstmt=null ; //create statement
		        
     StringBuffer query = new StringBuffer();
     query.append( " select CONCAT('K',LPAD(MAX(substring(k_code, 2, 4)+1),3,0)) AS k_code from DRV_KIND " );        
     
     System.out.println(" 쿼리 확인 : ");
     System.out.println( query.toString() );
     
	 pstmt=con.prepareStatement( query.toString() );		
     
     ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.
     
     // 데이터의 가장 끝으로 보내기
     rs.last();
     
	%>
		<div style="height:auto; margin-top: 20px; text-align: center;" >
			 
			<table style="margin: auto;">
			    <tr>
			    	<td class="EditPageTable">코　드</td>
			    	<td class="EditPageTable">:</td>
			    	<td class="EditPageTable"><input type="text" id="code" value="<%=rs.getString("k_code")%>" disabled></input></td>
			    </tr>
			    <tr>
			    	<td class="EditPageTable">코드명</td>
			    	<td class="EditPageTable">:</td>
			    	<td class="EditPageTable"><input type="text" id="name"></input></td>
			    </tr>
			    <tr>
			    	<td class="EditPageTable"></td>
			    	<td class="EditPageTable"></td>
			    	<td class="EditPageTable"><font size="2px" color="red">※ 코드명은 10글자 내로 입력해주십시오.</font></td>
			    </tr>
			</table>
			
		
	<%	
	 con.close(); //close connection
 }
 catch(Exception e)
 {
     System.out.println(e.toString());
 }

%>


<button type="button" onclick="kind_insert(); "> 입력하기 </button> 
<button type="button" onclick="location.href='/Kind/KindList' "> 뒤로가기 </button> 
</div>
<!-- <a href="javascript:void(0);" onclick="kind_insert();">입력하기</a>
<br><br> 
<a href="/KindList">뒤로가기</a>  -->

</body>
 </html>
 