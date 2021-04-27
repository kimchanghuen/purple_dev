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

 <c:set var="model" value="${modelCode}"/>
 
 <%
 try
 {
	 String strModel =  (String)pageContext.getAttribute("model");
	 strModel = strModel.trim();
	 	 
     Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
     DBManager db = new DBManager();

     Connection con = db.dbConn();
         
     PreparedStatement pstmt=null ; //create statement
     
     StringBuffer query = new StringBuffer();
     
     String subQuery = "( " 
               + " SELECT A.d_idx d_idx"
               + " , B.l_model d_model"
               + " , B.l_kind d_kind"
	           + " , A.d_part"
	           + " , A.d_type"
	           + " , A.d_code" 
               + " , A.d_name"
               + " , A.d_version"
               + " , A.d_filename"
               + " , A.d_hash"
               + " , A.d_filesize"
               + " , A.d_exec"
               + " , A.d_url"
               + " , A.d_datetime"
  		       + " , A.d_enable"
			   + " , A.d_etc"
			   + " , A.d_etc_type"
			   + " , A.d_etc_module"
			   + " , A.d_etc_name"
			   + " , A.d_etc_uninst"
			   + " FROM DRV_DRIVERS A"
			   + " LEFT OUTER JOIN DRV_LINK B"
			   + " ON A.d_code = B.l_code"
			   + " ORDER BY A.d_code "
			   + " )";
    
     query.append( "SELECT A.d_code "
    		                 + " , A.d_type  as  typecode "
				    	     + " , IFNULL(B.t_name,\"\")  as  d_type "
				    	     + " , A.d_version "
				    	     + " , A.d_name "
				    	     + " , A.d_url "
				    	     + " , A.d_filename"
				    	     + " , A.d_filesize "
				    	     + " , A.d_hash "
				    	     + " , A.d_exec "
				    	     + " , A.d_etc "
		    	    		 + " , A.d_etc_type"
		    				 + " , A.d_etc_module"
		    				 + " , A.d_etc_name"
		    				 + " , A.d_etc_uninst"				    	     
				    	     + " FROM " + subQuery + " A "
				    	     + "   LEFT OUTER JOIN DRV_TYPE B "
				    	     + "      ON A.d_type = B.t_code "
				    	     + " WHERE A.d_model = '" + strModel + "'  "
				    	     + " AND A.d_part = 'P001' ORDER BY A.d_type asc ");
     
     pstmt=con.prepareStatement( query.toString() );

     ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.
     
     // ---------------------- model name 찾기 --------------------------------
     PreparedStatement pstmtSub=null ; //create statement
     
     StringBuffer querySub = new StringBuffer();
     querySub.append( "SELECT m_name  FROM DRV_MODEL  WHERE m_code = '" + strModel + "' LIMIT 1  ");
     
     pstmtSub=con.prepareStatement( querySub.toString() );
     
     ResultSet rsSub =pstmtSub.executeQuery(); //execute query and set in resultset object rsSub.
     
     String resultModelName = "";
     while (rsSub.next()){
    	 resultModelName = rsSub.getString("m_name");
     }
     
     // ----------------------------------------------------------------------------
     
     JSONObject jsonMain=new JSONObject();
     JSONArray jArray=new JSONArray();
     
     int count=0;
            	
     while( rs.next() ){ 
     	
    	 String strURL = "http://" + db.getDomain() + rs.getString("d_url");
    	 
         JSONObject jsonObject=new JSONObject();
         jsonObject.put("code", rs.getString("d_code"));
         jsonObject.put("typecode", rs.getString("typecode"));
         jsonObject.put("type", rs.getString("d_type"));
         jsonObject.put("version", rs.getString("d_version"));
         jsonObject.put("name", rs.getString("d_name"));
         jsonObject.put("url",   strURL);
         jsonObject.put("filename", rs.getString("d_filename"));
         jsonObject.put("filesize", rs.getString("d_filesize"));
         jsonObject.put("hash", rs.getString("d_hash"));
         jsonObject.put("exec", rs.getString("d_exec"));
         jsonObject.put("d_etc_type", rs.getString("d_etc_type"));
         jsonObject.put("d_etc_module", rs.getString("d_etc_module"));
         jsonObject.put("d_etc_name", rs.getString("d_etc_name"));
         jsonObject.put("d_etc_uninst", rs.getString("d_etc_uninst"));
         jsonObject.put("model", strModel);
         
         if ( rs.getString("d_etc") != null && !(rs.getString("d_etc").equals("")) ) {
        	 
        	 // 특수문자 replace
        	 String d_etc = "";
        	 d_etc = rs.getString("d_etc");      	 
        	 
        	 d_etc = d_etc.replace("\"", "\"");
        	  
        	 jsonObject.put("etc", d_etc);
        	         	         	 
        	 /* JSON 파싱해서 보여주기
        	 // Stirng to JSON Object
        	 String jsonStr = rs.getString("d_etc");
        	         	 
        	 JSONParser parser = new JSONParser();
        	 Object obj = parser.parse( jsonStr );
        	 
        	 JSONObject jsonObj = (JSONObject) obj;
        	 
        	 // 모든 key 값을 keysItr 에 넣음
        	 Iterator<String> keysItr = jsonObj.keySet().iterator();
        	 
        	 while ( keysItr.hasNext() ) { 
        		 String key = keysItr.next(); 
        		 Object value = jsonObj.get(key); 
        		 // System.out.println("test : " + key + " : " + value); 

        		 jsonObject.put(key, value);
        	}        	 
        	 */
         } else if ( rs.getString("d_etc") != null ) {
        	 jsonObject.put("etc", "");
         } else {
        	 jsonObject.put("etc", "");
         }
         

         jArray.add(count, jsonObject);
         count++;
     	
     }
     
     jsonMain.put("part", "software");
     jsonMain.put("select", strModel);
     jsonMain.put("selectName", resultModelName);
     jsonMain.put("list", jArray);
     
     // out.println(jsonMain.toString().replace("\\", ""));
     out.println(jsonMain.toString());
     
     con.close(); //close connection
 }
 catch(Exception e)
 {
     System.out.println(e.toString());
 }
%>
