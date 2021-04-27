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
        query.append( " SELECT d_idx, d_kind, d_model, d_part, d_type, d_code, d_name, d_version, d_filename, d_hash, d_filesize, d_exec, d_url, d_datetime, d_enable, d_etc FROM DRV_DRIVER ORDER BY d_idx " );        
                
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
		        	<td width="80">d_idx</td>
		        	<td width="80">d_kind</td>
		        	<td width="80">d_model</td>
		        	<td width="80">d_part</td>
		        	<td width="80">d_type</td>
		        	<td width="80">d_code</td>
		        	<td width="80">d_name</td>
		        	<td width="80">d_version</td>
		        	<td width="180">d_filename</td>
		        	<td width="80">d_hash</td>
		        	<td width="80">d_filesize</td>
		        	<td width="180">d_exec</td>
		        	<td width="250">d_url</td>
		        	<td width="180">d_datetime</td>
		        	<td width="80">d_enable</td>
		        	<td width="80">d_etc</td>
				</tr>
			  </thead>
        	
        	<%
	        while( rs.next() ){
	        	
	        	String JsonText = rs.getString("d_etc");
	        	
	        	if( JsonText != null){
	        		JsonText = JsonText.replaceAll("\"","&quot;" );
	        	} else if ( JsonText == null) {
	        		JsonText = "";
	        	}
	        	
				
	        	
	        	%>
		        	<tbody>
		        		<tr>
				        	<td><%=rs.getString("d_idx") %></td>
				        	<td><input type="text" name="d_kind" value="<%=rs.getString("d_kind") %>" style="width:80px;" ></td>
				        	<td><input type="text" name="d_model" value="<%=rs.getString("d_model") %>" style="width:80px;" ></td>
				        	<td><input type="text" name="d_part" value="<%=rs.getString("d_part") %>" style="width:80px;" ></td>
							<td><input type="text" name="d_type" value="<%=rs.getString("d_type") %>" style="width:80px;" ></td>
							<td><input type="text" name="d_code" value="<%=rs.getString("d_code") %>" style="width:80px;" ></td>
							<td><input type="text" name="d_name" value="<%=rs.getString("d_name") %>" style="width:80px;" ></td>
							<td><input type="text" name="d_version" value="<%=rs.getString("d_version") %>" style="width:80px;" ></td>
							<td><input type="text" name="d_filename" value="<%=rs.getString("d_filename") %>" style="width:180px;" ></td>
							<td><input type="text" name="d_hash" value="<%=rs.getString("d_hash") %>" style="width:80px;" ></td>
							<td><input type="text" name="d_filesize" value="<%=rs.getString("d_filesize") %>" style="width:80px;" ></td>
							<td><input type="text" name="d_exec" value="<%=rs.getString("d_exec") %>" style="width:180px;" ></td>
							<td><input type="text" name="d_url" value="<%=rs.getString("d_url") %>" style="width:250px;" ></td>
							<td width="180"><%=rs.getString("d_datetime") %></td>
							<td><input type="text" name="d_enable" value="<%=rs.getString("d_enable") %>" style="width:80px;" ></td>
							<td><input type="text" name="d_etc " value="<%=JsonText %>" style="width:80px;" ></td>
			        	</tr>
		        	</tbody>
	        	<%
	        } 
        } else {
        	// 데이터가 없을 시
        	%>
        	<tbody>
        		<tr>
        			<td colspan=16> 데이터가 없습니다. </td>
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
