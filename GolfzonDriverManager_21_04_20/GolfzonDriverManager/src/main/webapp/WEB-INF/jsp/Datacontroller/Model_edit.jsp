<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
 %>
 
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.Golfzon.DBManager" %>

 <%
if(request.getParameter("kind_id")!=null) 
{
    String kind=request.getParameter("kind_id"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
        
    System.out.println("파라미터 확인");
    System.out.println("kind : " + kind);    
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
        DBManager db = new DBManager();
        
        Connection con = db.dbConn();
            
        PreparedStatement pstmt=null ; //create statement
		        
        StringBuffer query = new StringBuffer();
        query.append( " SELECT A.m_idx, A.m_kind, A.m_code, A.m_name, A.m_date, A.m_enable FROM DRV_MODEL A " );        
                
		pstmt=con.prepareStatement( query.toString() );		
        
        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

        // 데이터의 가장 끝으로 보내기
        rs.last();
        
        // rs.getRow() : 데이터의 가장 끝 index
        if ( rs.getRow() > 0 ) {
        	
        	// 데이터의 가장 처음으로 보내기
        	rs.beforeFirst();
        	%>
        	
        	 <table border = '1' style="text-align:center; border-style:line;" cellpadding=0 cellspacing=0 id="resultTable">
        	   <thead>
        	     <tr>
		        	<td width="80">m_idx</td>
		        	<td width="80">m_kind</td>
		        	<td width="80">m_code</td>
		        	<td width="80">m_name</td>
		        	<td width="180">m_date</td>
		        	<td width="80">m_enable</td>
				</tr>
			  </thead>
        	
        	<%
	        while( rs.next() ){
	        	%>
		        	<tbody>
		        		<tr>
				        	<td><%=rs.getString("m_idx") %></td>
				        	<td><input type="text" name="m_kind" value="<%=rs.getString("m_kind") %>" style="width:80px;" ></td>
				        	<td><input type="text" name="m_code" value="<%=rs.getString("m_code") %>" style="width:80px;" ></td>
				        	<td><input type="text" name="m_name" value="<%=rs.getString("m_name") %>" style="width:150px;" ></td>
				        	<td><%=rs.getString("m_date") %></td>
				        	<td><input type="text" name="m_enable" value="<%=rs.getString("m_enable") %>" style="width:80px;" ></td>
			        	</tr>
		        	</tbody>
	        	<%
	        } 
        } else {
        	// 데이터가 없을 시
        	%>
        	<tbody>
        		<tr>
        			<td colspan=6> 데이터가 없습니다. </td>
			 	</tr>
		     </tbody>
        	<%	
        }
        
        %>
        
        </table>
        <%
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
