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
 function valueChk(){
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
 
 var click = true;
 
 // 추가하기 클릭시
 function model_insert()
 {

	 if( valueChk() ) {
		 if (click) {
			 
			 click = !click;
		 
			 var code = document.getElementById('code').value;
			 var name = document.getElementById('name').value;
			 var kind = $(".kind").val();
			 
			 var paramText = "code="+ code
			    + "&name="+ name
			    + "&kind="+ kind
			    
		    paramText = encodeURI(paramText);
	
			 $.ajax({
			        url : "/Model/ModelInsert_sql",
			        data : paramText,
			        type : 'get',
			        async:false,
			        success : function(data){
			        	location.href="/Model/ModelList"; 
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
 <jsp:include page="../Datacontroller/NewtopMenu_sub2.jsp" flush="false"/>
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
 
 String m_code =  (String)pageContext.getAttribute("m_code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
 String m_name =  (String)pageContext.getAttribute("m_name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
 String m_kind =  (String)pageContext.getAttribute("m_kind"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
      
 try
 {
     Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
     DBManager db = new DBManager();

     Connection con = db.dbConn();
         
     PreparedStatement pstmt=null ; //create statement
		        
     StringBuffer query = new StringBuffer();
     query.append( "  select LPAD(MAX(substring(m_code, 2, 4)+1),3,0) AS m_code from DRV_MODEL " );        
     
     System.out.println(" 쿼리 확인 : ");
     System.out.println( query.toString() );
     
	 pstmt=con.prepareStatement( query.toString() );		
     
     ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.
     
     // 데이터의 가장 끝으로 보내기
     rs.last();
     
     String strMcode = "";
     strMcode = "M" + rs.getString("m_code");

     
	%>
		<div style="height:auto; text-align: center;" >			
			
            <table style="margin: auto;">
			    <tr>
			    	<td class="EditPageTable">코　드</td>
			    	<td class="EditPageTable">:</td>
			    	<td class="EditPageTable"><input type="text" id="code" value="<%=strMcode%>" disabled></input></td>
			    </tr>
			    <tr>
			    	<td class="EditPageTable">코드명</td>
			    	<td class="EditPageTable">:</td>
			    	<td class="EditPageTable"><input type="text" id="name"></input></td>
			    </tr>
			    <tr>
			    	<td class="EditPageTable"></td>
			    	<td class="EditPageTable"></td>
			    	<td class="EditPageTable"><font size="2px" color="red">※ 코드명은 20글자 내로 입력해주십시오.</font></td>
			    </tr>
			    <tr>
			    	<td class="EditPageTable">분　류</td>
			    	<td class="EditPageTable">:</td>
			    	<td class="EditPageTable">
				    	<select class="kind" id="kind">			 
						    <%
						    try
						    {
						    	Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
						    	DBManager db2 = new DBManager();

						    	Connection con2 = db2.dbConn();
						                
						        PreparedStatement pstmt2=null ; //create statement
						                
						        pstmt2=con2.prepareStatement("SELECT k_idx, k_code, k_name, k_date, k_enable FROM DRV_KIND where k_enable = '1' "); //sql select query
						        ResultSet rs2=pstmt2.executeQuery(); //execute query and set in resultset object rs.
						                
						        while(rs2.next())
						        {
						        %>
						            <option value="<%=rs2.getString("k_code")%>">
						                 <%=rs2.getString("k_name")%>
						            </option>
						        <%
						        }
						           
						        con2.close(); //close connection
						    }
						    catch(Exception e)
						    {
						       out.println(e);
						    }
						    %>
						 </select>
					 </td>
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
<button type="button" onclick="model_insert(); "> 입력하기 </button> 
<button type="button" onclick="location.href='/Model/ModelList' "> 뒤로가기 </button> 

</div>

</body>
 </html>
 