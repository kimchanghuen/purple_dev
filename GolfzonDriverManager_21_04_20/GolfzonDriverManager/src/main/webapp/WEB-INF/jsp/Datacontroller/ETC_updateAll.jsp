<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
 %>
 
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.Golfzon.DBManager" %>
    
 <%
if(request.getParameter("etcData")!=null) 
{
    String etcData=request.getParameter("etcData"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
        
    System.out.println("파라미터 확인");
    System.out.println("etcData : " + etcData);
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
        DBManager db = new DBManager();
        
        Connection con = db.dbConn();
        
        PreparedStatement pstmt=null ; //create statement
		
        StringBuffer query = new StringBuffer();
        query.append("UPDATE DRV_DRIVERS SET d_etc='" + etcData);        
        
        System.out.println(" update 쿼리 확인 : ");
        System.out.println( query.toString() );
        
		pstmt=con.prepareStatement( query.toString() );
		if (pstmt.executeUpdate() == 1) {
			// 정상완료
		}
    }
    catch(Exception e)
    {
        System.out.println(e.toString());
    }
}else{
	System.out.println("no param");
}
%>
<br><br>

