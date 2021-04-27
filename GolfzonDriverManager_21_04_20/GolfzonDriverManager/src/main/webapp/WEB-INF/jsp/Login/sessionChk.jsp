<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         trimDirectiveWhitespaces="true"
 %>

<%
 	 String id = "";
 
     try {
    	 // id 체크
    	 id = (String)session.getAttribute("id");
    	 if (id == null || id.equals("")) {
    		 
    		 // response.sendRedirect("/LoginMain");
    		 %>null<%
    		 
    	 }
     } catch (Exception e) {
    	 System.out.println("error : " + e.toString());
     }
 %>
