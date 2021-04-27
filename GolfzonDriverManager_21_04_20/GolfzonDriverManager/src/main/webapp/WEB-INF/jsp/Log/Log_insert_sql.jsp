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

 </script> 
 </head> 
 <body>
   
    
 <%
     String log_type=request.getParameter("log_type"); 
     String log_table=request.getParameter("log_table");
     String log_detail=request.getParameter("log_detail");
     String log_code=request.getParameter("log_code");
     
     System.out.println("log_type : " + log_type);
     System.out.println("log_table : " + log_table);
     System.out.println("log_detail : " + log_detail);
     System.out.println("log_code : " + log_code);
         
    DBManager db = new DBManager();
        
    //------------------------------- DRV_LOG 테이블 INSERT
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

        Connection con = db.dbConn();
            
        PreparedStatement pstmt=null ; //create statement
        
        String sql = "INSERT INTO DRV_LOG " + "\n"
			  	     + " ( log_idx, "  + "\n"
					 +	"   log_type, "  + "\n"
					 + "   log_table, "  + "\n"
					 + "   log_detail, "  + "\n"
					 + "   log_code, "  + "\n"
					 + "   log_datetime) "  + "\n"
		             + "VALUES "  + "\n"
		             + "( (SELECT log_idx FROM ( SELECT ifnull(max(log_idx)+1, 1) log_idx FROM DRV_LOG ) tmp ) , "  + "\n" // log_idx 
		             + "  ?, "  + "\n" // log_type
		             +  " ?, "  + "\n" // log_table
       				 +  " ?, "  + "\n" // log_detail
       				 +  " ?, "  + "\n" // log_code
		             + " now()  )";
        
		pstmt = con.prepareStatement( sql );
		pstmt.setString(1, log_type);
		pstmt.setString(2, log_table);
		pstmt.setString(3, log_detail);
		pstmt.setString(4, log_code);
        
        System.out.println(" insert 쿼리 확인 : ");
        System.out.println( sql );
        
		if (pstmt.executeUpdate() == 1) {
			// 정상완료
		}
    }
    catch(Exception e)
    {
        System.out.println(e.toString());
    }

%>

</body>
 </html>
 