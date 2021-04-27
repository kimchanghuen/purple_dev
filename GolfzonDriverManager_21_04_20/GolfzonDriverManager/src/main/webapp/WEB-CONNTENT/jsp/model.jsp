<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8;"
         pageEncoding="UTF-8"
 %>
 
<%@page import="java.sql.*" %>
<%@page import="com.Golfzon.DBManager" %>


<%

if(request.getParameter("kind_id")!=null) 
{
    String id=request.getParameter("kind_id"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
     
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
        DBManager db = new DBManager();

        Connection con = db.dbConn();
            
        PreparedStatement pstmt=null ; //create statement
                
        pstmt=con.prepareStatement(   " SELECT * "
								                + "   FROM DRV_MODEL "
								                + " WHERE 1=1 "
								                + "     and  m_kind like '%" + id +"%' "
								                + "     and  m_enable = 1 "); //sql select query
        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.
        %>        
            <option selected="selected">-- 모델 --</option>
        <%    
        while(rs.next())
        {
        %>        
            <option value="<%=rs.getString("m_code")%>">
                <%=rs.getString("m_name")%>
            </option>
        <%
        }
  
        con.close(); //close connection
    }
    catch(Exception e)
    {
        out.println(e);
    }
}
%>