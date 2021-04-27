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
 <title> ETC Edit </title>
 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js"> </script>

  <script type="text/javascript">
  // 파일수정 클릭시
 function saveClick(){
	  	  	 
	var etcData = document.getElementById('d_etc').value; 
	var idxData = document.getElementById('idx').value;
	 
	// etcData = encodeURI(etcData);
	 
 	var paramText = "etcData="+ etcData + "&idxData=" + idxData
 	 
 	paramText = encodeURI(paramText); 
	
 	$.ajax({
        url :  "${pageContext.request.contextPath}/editETCsave",
        data : paramText,
        type : 'get',
        success : function(data){
        	
        	// 메인 화면으로 이동
        	location.href="DriverView"; 
        	
        },
        error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });	  
 	
 	
 	
 } 
  
  </script>

<link rel="stylesheet" type="text/css" href="../../css/style.css">      
      
 </head> 
 <body>
 
<div id="top_header">
<jsp:include page="../Datacontroller/NewtopMenu.jsp" flush="false"/>
</div>
 
 
 <%
if(request.getParameter("d_idx")!=null) 
{
    String idx=request.getParameter("d_idx"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
        
    System.out.println("파라미터 확인");
    System.out.println("idx : " + idx);    
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
        DBManager db = new DBManager();
        
       Connection con = db.dbConn();
            
        PreparedStatement pstmt=null ; //create statement
		        
        StringBuffer query = new StringBuffer();
        query.append( "  select d_idx, d_etc from DRV_DRIVERS where d_idx = "+ idx );        
        
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

	        	String JsonText = "";
	        	
	        	if (rs.getString("d_etc") == null ) {
	        		
	        	} else {
	        		JsonText = rs.getString("d_etc");
	        	}	        	
	        	/*
	        	JsonText = JsonText.replaceAll("\"","&quot;" );
	        	
	        	System.out.println("치환 값 확인 : " + JsonText);
	        	*/
	        	%>
	        	<div id="dataField" style="width: 500px; margin:auto; text-align:center;">
       	
		         <label style="margin-right: 390px; font-weight: bold; font-size:15px;"> ETC : </label> <br>
		         
		         <textarea name="d_etc" id="d_etc" cols=50 rows=10 ><%=JsonText %></textarea>
		         
		         <input type="hidden" id="idx" value="<%=idx %>" />

	     	<%
        		} 
	        } else {
	        	// 데이터가 없을 시
	        	System.out.println("데이터가 없습니다.");
        	
        } 
        con.close(); //close connection
    }
    catch(Exception e)
    {
        System.out.println(e.toString());
    }
}else{
	System.out.println("no param");
}
%>
<br>
<button type="button" onclick="saveClick()" style="margin-left: 370px; width: 50px;" > 저장 </button>
</div>

</body>
</html>