<%@ page 
         language="java" 
         contentType="text/html; charset=UTF-8;"
         pageEncoding="UTF-8"
 %>
 
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "javax.servlet.http.HttpServletRequest" %>


 <script type="text/javascript" src="../../../resources/js/jquery-1.11.3.js"> </script>
 
 <script type="text/javascript"> 
   
  function logout() {
	  location.href="/Login/logOut"; 
  }  
  
 </script>
 
 	<link rel="stylesheet" type="text/css" href="../../css/style.css">
  

 
 <!-- 로고이미지 -->
  <div id="TopHeader" style='display: inline-grid; width: 100%'>
 
	<div id="Logo" style="text-align: center"> 
	    <a href="javascript:void(0);" onclick="location='/DriverManager' "><img src="../../../images/top_logo.png" /></a> 
	</div>
	<br>
	
	<div id="MenuBar" style="background-color: #2D2D2D; width: 100%; text-align: -webkit-center; height:30px;">
	<%	
		 // ------------------- 로그인 체크 -------------------	
		 
		 String id = "";
	
	    try {
	   	 // id 체크
	   	 id = (String)session.getAttribute("id");
	   	
	   	 System.out.println("로그인 확인 : " + id);
	   	 
	   	 if (id == null || id.equals("")) {
	   		 response.sendRedirect("/Login/LoginMain"); 
	   	  }
	    } catch (Exception e) {
	   	  System.out.println("error : " + e.toString());
	    }
	    
	    // ------------------------------------------------------
	    %>
	　
	 <nav id="topMenu" style="margin: -15px auto; ">
	 <ul> 
	      <li class="topMenuLi"> <a class="menuLink" href="javascript:void(0);" onclick="location='/DriverManager' ">공지사항 관리</a></li> 
	   <li>|</li> 
	   <li class="topMenuLi"> <a class="menuLink" href="#">코드관리</a> 
		    <ul class="submenu">
			  <li><a href="javascript:void(0);" class="submenuLink longLink" onclick="location='/Kind/KindList' ">분류</a></li>
			  <li><a href="javascript:void(0);" class="submenuLink longLink" onclick="location='/Model/ModelList' " >모델</a></li> 
			  <li><a href="javascript:void(0);" class="submenuLink longLink" onclick="location='/Part/PartList' " >종류</a></li> 
	          <li><a href="javascript:void(0);" class="submenuLink longLink" onclick="location='/Type/TypeList' ">구분</a></li> 
			  <li><a href="javascript:void(0);" class="submenuLink longLink" onclick="location='/Driver/DriverList'">드라이버/소프트웨어</a></li> 
	        </ul> 
	   </li> 
	   <li>|</li> 
	   <li class="topMenuLi"> <a class="menuLink" href="javascript:void(0);" onclick="location='/Link/LinkList' ">모델별 드라이버 관리</a> </li> 
	   <li>|</li> 
	   <li class="topMenuLi"> <a class="menuLink" href="javascript:void(0);" onclick="location='/Tool/ToolList' ">툴 버전 관리</a></li> 
	   <li>|</li> 
	   <li class="topMenuLi"> <a class="menuLink" href="javascript:void(0);" onclick="location='/Driver/DriverView' ">드라이버 조회</a></li>
	   <li>|</li> 
	   <li class="topMenuLi"> <a class="menuLink" href="javascript:void(0);" onclick="location='/Log/LogView' ">로그 조회</a></li>  
	   <li>|</li> 
	   <li class="topMenuLi"> <a class="menuLink" href="javascript:void(0);" onclick="logout();">로그아웃</a></li> 
	  </ul>
	</nav>
	
	 </div>
 
 </div>
 <!-- 줄바꿈 -->
<br><br>
<br>



 