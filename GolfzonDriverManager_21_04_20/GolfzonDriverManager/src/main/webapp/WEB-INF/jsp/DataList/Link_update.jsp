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

 // 수정하기 클릭시
 function link_change()
 {
	 var idx = document.getElementById('idx').value;
	 var kind = $(".kind").val();
	 var model = $(".model").val();
	 var driver = $(".driver").val();
	 var enable = $(".enable").val();
	 
	 
	 var paramText = "l_kind="+ kind
	    + "&l_model="+ model
	    + "&l_driver="+ driver
	    + "&l_enable="+ enable
	    + "&l_idx="+ idx

	 $.ajax({
	        url : "/LinkUpdate_sql",
	        data : paramText,
	        type : 'get',
	        success : function(data){
	        	location.href="/LinkList"; 
	        },
	        error:function(request,status,error){
	            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        }
	    });

 } 
 </script> 
 </head> 
 <body>

 <div id="header">
  <jsp:include page="../Datacontroller/NewtopMenu.jsp" flush="false"/>
 </div>
 
 <%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="l_idx" value="${l_idx}"/>
<c:set var="l_kind" value="${l_kind}"/>
<c:set var="l_model" value="${l_model}"/>
<c:set var="l_code" value="${l_code}"/>
<c:set var="l_enable" value="${l_enable}"/>

 <%
 
 // ------------------- 로그인 체크 -------------------
String id = "";

try {
	 // id 체크
	 id = (String)session.getAttribute("id");
	 
	 if (id == null || id.equals("")) {
		 response.sendRedirect("/Login/LoginMain"); 
	  }
} catch (Exception e) {
	  System.out.println("error : " + e.toString());
}
// ------------------------------------------------------

 
 String l_idx =  (String)pageContext.getAttribute("l_idx"); 
 String l_kind =  (String)pageContext.getAttribute("l_kind"); 
 String l_model =  (String)pageContext.getAttribute("l_model");
 String l_code =  (String)pageContext.getAttribute("l_code");
 String l_enable =  (String)pageContext.getAttribute("l_enable");
     
 System.out.println("update 파라미터 확인");
 System.out.println("l_kind : " + l_kind + " / l_model : " + l_model + " / l_code : " + l_code);
 
 DBManager db = new DBManager();
 
%>
<div style="cursor:pointer; height:auto;" >
	
	<!---------------------------- kind code -------------------------------->
	<label> 분류　　 : </label>
	<select class="kind" id="kind" style="width:173px" disabled>	 
	   <%
	   try
	   {
	   	   Class.forName("com.mysql.cj.jdbc.Driver"); 
 		
	   	   Connection con = db.dbConn();
	   	
	       PreparedStatement pstmt=null ; 
	                
	       pstmt=con.prepareStatement("SELECT k_code, k_name FROM DRV_KIND WHERE k_enable = '1' ");
	       ResultSet rs=pstmt.executeQuery(); 
	       
           %>
           <option value=" ">--분류목록--</option>	        	
           <%	        	
	       while(rs.next())
	       {
	           if (rs.getString("k_code").equals(l_kind)) {
	        %>
	        	<option value="<%=rs.getString("k_code")%>" selected>
		                <%=rs.getString("k_name")%>
		           </option>
	        	<%
	        } else {
	        %>
	            <option value="<%=rs.getString("k_code")%>">
	                 <%=rs.getString("k_name")%>
	            </option>
	        <%
	        	}
	        }	           
	        con.close(); //close connection
	    }
	    catch(Exception e)
	    {
	       out.println(e);
	    }
	    %>
	 </select>
	 <br>
	
	 <!---------------------------- model code -------------------------------->
	 <label> 모델　　 : </label>
	 <select class="model" id="model" style="width:173px" disabled>	 
	    <%
	    try
	    {
	    	Class.forName("com.mysql.cj.jdbc.Driver"); 
	    	
	    	Connection con = db.dbConn();
	    	
	        PreparedStatement pstmt=null ; 
	                
	        pstmt=con.prepareStatement("SELECT m_code, m_name FROM DRV_MODEL WHERE m_enable = '1' ");
	        ResultSet rs=pstmt.executeQuery(); 
	        
        	%>
        	<option value=" ">--모델목록--</option>	        	
        	<%	        	
	        while(rs.next())
	        {
	        	if (rs.getString("m_code").equals(l_model)) {
	        		%>
	        		<option value="<%=rs.getString("m_code")%>" selected>
		                 <%=rs.getString("m_name")%>
		            </option>
	        		<%
	        	} else {
	        %>
	            <option value="<%=rs.getString("m_code")%>">
	                 <%=rs.getString("m_name")%>
	            </option>
	        <%
	        	}
	        }	           
	        con.close(); //close connection
	    }
	    catch(Exception e)
	    {
	       out.println(e);
	    }
	    %>
	 </select>
	 <br>
	
	 <!---------------------------- driver code -------------------------------->
	 <label> 드라이버 : </label>
	 <select class="driver" id="driver" style="width:173px">	 
	    <%
	    try
	    {
	    	Class.forName("com.mysql.cj.jdbc.Driver"); 
	    	
	    	Connection con = db.dbConn();
	    	
	        PreparedStatement pstmt=null ; 
	                
	        pstmt=con.prepareStatement("SELECT d_code, d_name FROM DRV_DRIVERS WHERE d_enable = '1' ");
	        ResultSet rs=pstmt.executeQuery(); 
	        
        	%>
        	<option value=" ">--드라이버목록--</option>	        	
        	<%	        	
	        while(rs.next())
	        {
	        	if (rs.getString("d_code").equals(l_code)) {
	        		%>
	        		<option value="<%=rs.getString("d_code")%>" selected>
		                 <%=rs.getString("d_name")%>
		            </option>
	        		<%
	        	} else {
	        %>
	            <option value="<%=rs.getString("d_code")%>">
	                 <%=rs.getString("d_name")%>
	            </option>
	        <%
	        	}
	        }	           
	        con.close(); //close connection
	    }
	    catch(Exception e)
	    {
	       out.println(e);
	    }
	    %>
	 </select>
	<br>
	
	<label>사용여부 : </label>
	 <select class="enable" id="enable">
	 <% if ( l_enable.equals("1") ) { %> 
	     <option value="1" selected>사용</option>
		 <option value="0">미사용</option>
	  <% }  else {
	   %>
		 <option value="1" >사용</option>
  		 <option value="0"selected >미사용</option>
	 <%		 
	 } %>
	 </select>
	 
	 <input type="hidden" id="idx" value="<%=l_idx %>" />
	 
</div>
					
	
<br> 
<a href="javascript:void(0);" onclick="link_change();">수정하기</a>
<br><br> 
<a href="/LinkList">뒤로가기</a>

</body>
 </html>
 