<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.Golfzon.DBManager" %>
<%@page language="java"
    contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

 <%
 try
 {	 	 
     Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
     DBManager db = new DBManager();

     Connection con = db.dbConn();
         
     PreparedStatement pstmt=null ; //create statement
     
     StringBuffer query = new StringBuffer();     
     
     query.append( "SELECT tool_idx, tool_code, tool_name, tool_filename, tool_version, tool_hash, tool_filesize, tool_exec, tool_url, tool_datetime, tool_enable, tool_etc FROM DRV_TOOLS WHERE tool_enable = '1' ORDER BY tool_idx DESC LIMIT 1; " );
     
     pstmt=con.prepareStatement( query.toString() );

     ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.
     // ----------------------------------------------------------------------------
     
     JSONObject jsonMain=new JSONObject();
     JSONArray jArray=new JSONArray();
     
     int count=0;
            	
     while( rs.next() ){ 
         // JSONObject jsonObject=new JSONObject();
         // jsonObject.put("version", rs.getString("tool_version"));
         
         jsonMain.put("version", rs.getString("tool_version"));
         String strUrl = "http://" + db.getDomain() + rs.getString("tool_url");
         
         jsonMain.put("url", strUrl);
         jsonMain.put("name", rs.getString("tool_filename"));
         
         // jArray.add(count, jsonObject);
         count++;
     }
     
     System.out.println("jsonMain : " + jsonMain.size() );
     
     if ( jsonMain.size() < 1 ){ // row 가 없을 시
    	 
         jsonMain.put("version", "1.0.0.0");
         // String strUrl = "http://" + db.getDomain() + rs.getString("tool_url");
         
         jsonMain.put("url", " ");
         jsonMain.put("name", " ");
    	 
     }
     
     /*
     jsonMain.put("version", "ToolVersion");
     jsonMain.put("select", strModel);
     jsonMain.put("selectName", resultModelName);
     */
     // jsonMain.put("list", jArray);
     
     
     // out.println(jsonMain.toString().replace("\\", ""));
     out.println(jsonMain.toString());
     
     con.close(); //close connection
 }
 catch(Exception e)
 {
     System.out.println(e.toString());
 } 
%>
