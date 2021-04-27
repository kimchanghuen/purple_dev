<%@page import="java.sql.*" %>
<%@page import="com.Golfzon.DBManager" %>

<%
if(request.getParameter("kind_value")!=null) 
{
    String kind_value=request.getParameter("kind_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
    String model_value=request.getParameter("model_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
    String driver_value=request.getParameter("driver_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
    
    System.out.println("파라미터 확인 : " + kind_value + " / " + model_value + " / " + driver_value);

    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
        DBManager db = new DBManager();

        Connection con = db.dbConn();
        
        PreparedStatement pstmt=null ; //create statement
                
        pstmt=con.prepareStatement(   "SELECT A.d_code"
        	     + " , A.d_name " 
        	     + " FROM DRV_DRIVERS A " 
        	     + " WHERE A.d_enable = '1' " 
        	     + " and A.d_code NOT IN ( SELECT B.l_code " 
        	     + " FROM DRV_LINK B " 
        	   	 +	" WHERE B.l_kind  = '"+ kind_value +"' "	
        	   	 + " AND B.l_model = '" + model_value  + "' )  "); //sql select query
        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.
        
        System.out.println("쿼리 확인 : " + pstmt.toString());

        
        %>        
            <option selected="selected" value="none" >-- 드라이버 --</option>
        <%    
        while(rs.next())
        {
        %>        
            <option value="<%=rs.getString("d_code")%>">
                <%=rs.getString("d_name")%>
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