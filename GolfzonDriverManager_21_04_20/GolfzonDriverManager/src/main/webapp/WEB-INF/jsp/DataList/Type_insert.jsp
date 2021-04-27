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
 
 // 각 데이터 클릭시
 function type_insert()
 {
	 if ( valueChk() ) {
		if (click) {
			 
			 click = !click;
		 
			 var code = document.getElementById('code').value;
			 var name = document.getElementById('name').value;
			 
			 var paramText = "code="+ code
			    + "&name="+ name
			    
		     paramText = encodeURI(paramText);
	
			 $.ajax({
			        url : "/Type/TypeInsert_sql",
			        data : paramText,
			        type : 'get',
			        async:false,
			        success : function(data){
			        	location.href="/Type/TypeList"; 
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
 </script> 
 </head> 
 <body>
 <div id="header">
 <jsp:include page="../Datacontroller/NewtopMenu_sub4.jsp" flush="false"/>
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

 String t_code =  (String)pageContext.getAttribute("p_code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
 String t_name =  (String)pageContext.getAttribute("p_name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable  
 
 try
 {
     Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
     DBManager db = new DBManager();

     Connection con = db.dbConn();
         
     PreparedStatement pstmt=null ; //create statement
		        
     StringBuffer query = new StringBuffer();
     query.append( "  select LPAD(MAX(substring(t_code, 2, 4)+1),3,0) AS t_code from DRV_TYPE " );        
     
     System.out.println(" 쿼리 확인 : ");
     System.out.println( query.toString() );
     
	 pstmt=con.prepareStatement( query.toString() );		
     
     ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.
     
     // 데이터의 가장 끝으로 보내기
     rs.last();
     
     String strTcode = "";
     strTcode = "T" + rs.getString("t_code");

     
	%>
		<div style="height:auto; text-align: center; " >
		
			<table style="margin:auto">
			    <tr>
			    	<td class="EditPageTable">코　드</td>
			    	<td class="EditPageTable">:</td>
			    	<td class="EditPageTable"><input type="text" id="code" value="<%=strTcode%>" disabled></input></td>
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

<br> 
<button type="button" onclick="type_insert(); "> 입력하기 </button> 
<button type="button" onclick="location.href='/Type/TypeList' "> 뒤로가기 </button> 

</div>

</body>
 </html>
 