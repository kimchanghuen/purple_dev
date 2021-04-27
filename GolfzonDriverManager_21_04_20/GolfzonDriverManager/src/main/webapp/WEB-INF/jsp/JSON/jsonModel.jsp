<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.Golfzon.DBManager" %>
<%@ page language="java" 
    contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>

<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

 <c:set var="kind" value="${kind}"/>
 
 <%
 try
 {
	 String strKind =  (String)pageContext.getAttribute("kind");
	 strKind = strKind.trim();
	 	 
     Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
     DBManager db = new DBManager();

     Connection con = db.dbConn();
         
     PreparedStatement pstmt=null ; //create statement
     
     StringBuffer query = new StringBuffer();
     query.append( "SELECT m_code, m_name FROM DRV_MODEL WHERE 1=1 AND m_kind = '" + strKind + "' AND m_enable = '1' ");
     
     pstmt=con.prepareStatement( query.toString() );

     ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.
     
     // ---------------------- kind name 찾기 --------------------------------
     PreparedStatement pstmtSub=null ; //create statement
     
     StringBuffer querySub = new StringBuffer();
     querySub.append( "SELECT k_name  FROM DRV_KIND  WHERE k_code = '" + strKind + "' LIMIT 1  ");
     
     pstmtSub=con.prepareStatement( querySub.toString() );
     
     ResultSet rsSub =pstmtSub.executeQuery(); //execute query and set in resultset object rsSub.
     
     String resultKindName = "";
     while (rsSub.next()){
    	 resultKindName = rsSub.getString("k_name");
     }
     
     // ----------------------------------------------------------------------------

     JSONObject jsonMain=new JSONObject();
     JSONArray jArray=new JSONArray();
     
     int count=0;
            	
     while( rs.next() ){ 
     	
         JSONObject jsonObject=new JSONObject();
         jsonObject.put("code", rs.getString("m_code"));
         jsonObject.put("name", rs.getString("m_name"));

         jArray.add(count, jsonObject);
         count++;	
     	
     }
     
     jsonMain.put("part", "model");
     jsonMain.put("sub", "/driver, /software");
     jsonMain.put("select", strKind);
     jsonMain.put("selectName", resultKindName);
     jsonMain.put("list", jArray);
     
     out.println(jsonMain);
     
     con.close(); //close connection
 }
 catch(Exception e)
 {
     System.out.println(e.toString());
 }
%>
