<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
 %>
 
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.Golfzon.dto.KindDTO" %>
<%@page import="com.Golfzon.dao.KindDAO" %>
<%@page import="java.util.List" %>
<%@page import="com.Golfzon.DBManager" %>

<!DOCTYPE html> 
<html> 
<head> 
<meta charset="UTF-8">
 <title> DriverManager </title> 
 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js">  </script>
 
 <script type="text/javascript">  
 
 // 조회 테이블 컬럼명
 var tableHdr = ['코드', '코드명', '수정일자','수정' ]; // 4개 컬럼
 
 // 각 데이터 클릭시
 function pageMove(idx, code, name, enable)
 {
	 
     var f=document.param; //폼 name
	 
	 f.k_idx.value = idx;
	 f.k_code.value = code;
	 f.k_name.value = name;
	 f.k_enable.value = enable;
	 
	 f.action="/KindUpdate";//이동할 페이지
	 f.method="post";//POST방식
	 f.submit();  
 }
 
 // 데이터 조회 function 
 function serchDriver()
 {
    $.ajax({
        url : "/serch_KindData",
        data : "",
        type : 'get',
        success : function(data){
        	$("#titleList").append(data);
        },
        error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
	 
 } 
 </script>
	 <link rel="stylesheet" type="text/css" href="../../../css/style.css">
 </head> 
 <body>
 
  <form name="param">
    <input type="hidden" name="k_idx">
    <input type="hidden" name="k_code">
    <input type="hidden" name="k_name">
    <input type="hidden" name="k_enable">
</form>

     
  <div id="top_header">
  <jsp:include page="../Datacontroller/NewtopMenu.jsp" flush="false"/>
 </div>
 
  <!--  조회 테이블 생성 -->
 <table border = '1' style="text-align:center; border-style:line;" cellpadding=0 cellspacing=0 id="titleList">
  <thead>
  	<script>
  	
  	document.write( '<td width="70" >' + tableHdr[0] + '</td>' );  // code 
  	document.write( '<td width="70" >' + tableHdr[1] + '</td>' ); // name
  	document.write( '<td width="180" >' + tableHdr[2] + '</td>' );  // 수정일자
  	document.write( '<td width="70" >' + tableHdr[3] + '</td>' ); // 수정
  	
  	</script>
  </thead>
  
  
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
        query.append( " SELECT k_idx, k_code, k_name, k_date, k_enable, k_update FROM DRV_KIND " );        
        
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
	        	        	
	        	%>				
	        	  
        		<tr>
		        	<td><%=rs.getString("k_code") %></td>
		        	<td><%=rs.getString("k_name") %></td>
		        	<td><%=rs.getString("k_update") %></td>
		        	<td> <button type="button" onclick="pageMove( '<%=rs.getString("k_idx")%>', '<%=rs.getString("k_code")%>', '<%=rs.getString("k_name")%>'
							                    , '<%=rs.getString("k_enable")%>'  )" >수정</button> </td> 
	        	</tr>
	        	<%
	        } 
        } else {
        	// 데이터가 없을 시
        	%>
        	<tr>
				<td colspan=4> 데이터가 없습니다. </td>
			</tr>
			<%	
        }
        con.close(); //close connection
    }
    catch(Exception e)
    {
        System.out.println(e.toString());
    }

%>      	
		        	
 </table>
 
<br> 
<a href="/Kindinsert">추가하기</a>
<br><br> 

</body>
 </html>
 