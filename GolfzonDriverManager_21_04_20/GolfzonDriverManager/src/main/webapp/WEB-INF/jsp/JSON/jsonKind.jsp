<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.Golfzon.DBManager" %>
<%@ page language="java" 
                contentType="application/json; charset=UTF-8" 
                pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>    

 <%
    try
    {
    	// ------- DRV_KIND ----------
        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
        DBManager db = new DBManager();
        
        Connection con  = db.dbConn();
            
        PreparedStatement pstmt=null ; //create statement
        
        StringBuffer query = new StringBuffer();
        query.append( "  SELECT k_code, k_name FROM DRV_KIND WHERE k_enable='1' " );
        
        pstmt=con.prepareStatement( query.toString() );

        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

        JSONObject jsonMain=new JSONObject();
        JSONArray jArray=new JSONArray();
        
        int count=0;
               	
        while( rs.next() ){ 
        	
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("code", rs.getString("k_code"));
            jsonObject.put("name", rs.getString("k_name"));

            jArray.add(count, jsonObject);
            count++;	
        	
        } 
        
        // ---------------------------------------------------------------
        // ----------------------- DRV_NOTICE -----------------------
        
        StringBuffer query2 = new StringBuffer();
        query2.append( "  SELECT n_title, n_body, n_update, n_enable FROM DRV_NOTICE WHERE n_enable = '2' " );
        
        pstmt=con.prepareStatement( query2.toString() );

        ResultSet rs2=pstmt.executeQuery(); //execute query and set in resultset object rs.

        JSONObject jsonMain_Notice=new JSONObject();
        JSONArray jArray_Notice=new JSONArray();
        
        int count_notice = 0;
        
        JSONObject jsonObject_Notice =new JSONObject();
        
        if ( rs2.isBeforeFirst() ) {
        	while( rs2.next() ){ 
            	
                jsonObject_Notice.put("title", rs2.getString("n_title"));
                jsonObject_Notice.put("body", rs2.getString("n_body"));
                
                String Str_n_enable = "";
                if ( rs2.getString("n_enable").equals("1") ) {
                	Str_n_enable = "미공지";
                } else if ( rs2.getString("n_enable").equals("2") ) {
                	Str_n_enable = "공지중";
                }
                
                jsonObject_Notice.put("completed", Str_n_enable );
                jsonObject_Notice.put("time", rs2.getString("n_update") );

                jArray_Notice.add(count_notice, jsonObject_Notice);
                count_notice++;	
            	
            } 
        } else {
        	
            jsonObject_Notice.put("title", "");
            jsonObject_Notice.put("body", "");
            
            String Str_n_enable = "";
            
            jsonObject_Notice.put("completed", Str_n_enable );
            jsonObject_Notice.put("time", "" );

            jArray_Notice.add(count_notice, jsonObject_Notice);
        }

        jsonMain.put("part", "service");
        jsonMain.put("sub", "model");
        jsonMain.put("list", jArray);
        jsonMain.put("notice", jsonObject_Notice);
        
        out.println(jsonMain);
        
        con.close(); //close connection
    }
    catch(Exception e)
    {
        System.out.println(e.toString());
    }

%>