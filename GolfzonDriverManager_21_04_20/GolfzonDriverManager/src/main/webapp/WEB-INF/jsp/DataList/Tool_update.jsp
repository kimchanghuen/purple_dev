<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="com.Golfzon.DBManager"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DriverManager</title>
<script type="text/javascript"
	src="../../../resources/js/jquery-1.11.3.js"> </script>

<script type="text/javascript">   
 
 //입력값 체크
 function valueChk() {
	 
	 var name = document.getElementById('name').value;
	 var version = document.getElementById('version').value;
	 var exec = document.getElementById('exec').value;
     
	//업로드 파일명
	var file = document.getElementById('fileUp').value;
    file = file.replace('C:\\fakepath\\','');
	    
	// 빈칸 체크
	if ( !name ) { alert("제목을 입력해주세요");	 return false;	}
	if ( !version ) { alert("버전을 입력해주세요");	 return false;	}
	if ( !exec ) { alert("실행파일을 입력해주세요");	 return false;	}
	
	if ( file ) { 
		// 파일 용량 체크
		var maxSize = 1024 * 1024 * 850; // 850MB
		var fileSize = 0;
		
		// 브라우저 확인
		var browser=navigator.appName;
		
		// 익스플로러일 경우
		if (browser=="Microsoft Internet Explorer")
		{
			var oas = new ActiveXObject("Scripting.FileSystemObject");
			fileSize = oas.getFile( document.getElementById('fileUp').value ).size;
		}
		// 익스플로러가 아닐경우
		else
		{
			fileSize = document.getElementById('fileUp').files[0].size;
		}	
			
		if(fileSize > maxSize)
	    {
	        alert("첨부파일 사이즈는 850MB 이내로 등록 가능합니다.    ");
	        return false;
	    }	
	}
	/*
	// 업로드 파일명 한글체크
	var korCheck = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
	 if (  korCheck.test(file) ) {
		 alert("파일명은 영어와 숫자로 변경해주세요.")
		 return false;
	 }
	 
	 // 코드명 길이 제한
	 if ( chekcCode.length > 5 ) {
		 alert("코드명은 5글자 내로 입력해주세요.")
		 return false;
	 }
	 */
	 
	 return true;
 }
 
//파일유무 체크
 function fileChk() {
	
	 if ( valueChk() ) {
		 var file = document.getElementById('fileUp').value;
	
		 if ( file ) {
		     file = file.replace('C:\\fakepath\\','');
		     
		     // 한글깨짐 방지처리
		     file = encodeURI(file);
		     
		     $.ajax({
		         type : 'get',
		         url : '/Tool/fileCheck_TOOL/' + file,
		         data : "",
		         processData : false,
		         contentType : false,
		         success : function(html) {
		        	 html = html.trim();     	 
		        	 if(html == 'true') {
		        			 alert("중복파일이있습니다.");
		        			 return;
		        		 
		        	 } else { 
		        		 Tool_change();
		             } 
		         },
		         
		     });
		 } else {
			 Tool_change();
		 }
	 
	 }
 }
 
 
 // 수정 클릭시 
 function Tool_change()
 {
		// tool_idx
		var tool_idx = document.getElementById('idx').value;
		 
		// tool_code
		var tool_code = document.getElementById('code').value;
		 
		// tool_name
		var tool_name = document.getElementById('name').value;
			
		// tool_filename
		var tool_filename = document.getElementById('filename').value;
		
		// tool_version
		var tool_version = document.getElementById('version').value;
		
		// tool_exec
		var tool_exec = document.getElementById('exec').value;
		
		// tool_enable 
		var tool_enable = $(".enable").val();
		 
		var paramText = "tool_idx="+ tool_idx
		   + "&tool_code="+ tool_code
		   + "&tool_name="+ tool_name
		   + "&tool_filename="+ tool_filename
		   + "&tool_version="+ tool_version
		   + "&tool_exec="+ tool_exec
		   + "&tool_enable="+ tool_enable
		   
		   paramText = encodeURI(paramText);
		   
		    
		   $.ajax({
		       url : "/Tool/ToolUpdate_sql",
		       data : paramText,
		       type : 'post',
		       success : function(data){		       		
		       		var file = document.getElementById('fileUp').value;

		       	    if ( file ) {
		        		fileSubmit();
		       	    } 
		       	    
		       	    location.href="/Tool/ToolList"; 
		       },
		       error:function(request,status,error){
		            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		       }
		   });
 }
 
 // 파일 업로드 관련
 function fileSubmit() {
     var formData = new FormData($("#fileForm")[0]);
     var tool_idx = document.getElementById('idx').value;
     
     console.log("fileSubmit 확인 : " + tool_idx);
     $.ajax({
         type : 'post',
         url : '/Tool/FileUploadTool/' + tool_idx,
         data : formData,
         async:false,
         processData : false,
         contentType : false,
         success : function(html) {
        	         	 
         },
         error : function(error) {
             alert("파일 업로드에 실패하였습니다.");
             console.log(error);
             console.log(error.status);
         },
         beforeSend:function(){
        	// 로딩 이미지 호출 
        	$('.wrap-loading').removeClass('display-none');
         },
         complete:function(){
        	// 로딩 이미지 제거 
        	$('.wrap-loading').addClass('display-none');
         },
         error : function(error) {
        	 $('.wrap-loading').addClass('display-none');
             alert("파일 업로드에 실패하였습니다.");
             console.log(error);
             console.log(error.status);
         }
     });   
 } 
 
 // 데이터 삭제 클릭시
 function deleteClick() {

	var checker = confirm("정말 해당 드라이버를 삭제하시겠습니까?");
	
	if ( checker ) {
	   Driver_delete();
	 } else if (!checker ) {
		 alert("삭제를 취소하셨습니다.");
		 return;
	 }

 }
 
 function Driver_delete() {
		// DB 및 파일 삭제 로직
		
		// tool_code
		var tool_code = document.getElementById('code').value;
		// tool_filename
		var tool_filename = document.getElementById('filename').value;
		// tool_name
		var tool_name = document.getElementById('name').value;
		
		var paramText = "tool_code="+ tool_code
		+ "&tool_filename="+ tool_filename
		+ "&tool_name="+ tool_name
		
		paramText = encodeURI(paramText);
		
		$.ajax({
	        url : "/Tool/fileDelete_tool",
	        data : paramText,
	        async : false,
	        type : 'post',
	        success : function(data){        	
	        	alert("삭제가 완료되었습니다.");
	        	location.href="/Tool/ToolList"; 
	        },
	        error:function(request,status,error){
	            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        }
	    });
		
	}
 
 </script>


<style type="text/css">
.wrap-loading { /*화면 전체를 어둡게 합니다.*/
	position: fixed;
	left: 0;
	right: 0;
	top: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0.2); /*not in ie */
	filter: progid:DXImageTransform.Microsoft.Gradient(startColorstr='#20000000',
		endColorstr='#20000000'); /* ie */
}

.wrap-loading div { /*로딩 이미지*/
	position: fixed;
	top: 50%;
	left: 50%;
	margin-left: -21px;
	margin-top: -21px;
}

.display-none { /*감추기*/
	display: none;
}
</style>


</head>
<body>
	<div id="top_header">
		<jsp:include page="../Datacontroller/NewtopMenu.jsp" flush="false" />
	</div>

	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<c:set var="tool_idx" value="${tool_idx}" />

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

 String tool_idx =  request.getParameter("tool_idx");
 String tool_code = request.getParameter("tool_code");
 String tool_name = request.getParameter("tool_name");
 String tool_version = request.getParameter("tool_version");
 String tool_filename = request.getParameter("tool_filename");
 String tool_exec = request.getParameter("tool_exec");
 String tool_enable = request.getParameter("tool_enable");

%>

	<div style="height: auto; text-align: center;">


		<table style="margin: auto;">
			<tr>
				<td class="EditPageTable">코 드</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="code"
					value="<%=tool_code %>" disabled></input></td>
			</tr>
			<tr>
				<td class="EditPageTable">파일명</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="name"
					value="<%=tool_name %>"></input></td>
			</tr>
			<tr>
				<td class="EditPageTable"><label>사용여부</label></td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><select class="enable" id="enable">
						<% if ( tool_enable.equals("사용") ) { %>
						<option value="1" selected>사용</option>
						<option value="0">미사용</option>
						<% }  else {
				   %>
						<option value="1">사용</option>
						<option value="0" selected>미사용</option>
						<%		 
				 } %>
				</select></td>
			</tr>
			<tr>
				<td class="EditPageTable">버 전</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="version"
					value="<%=tool_version %>"></input></td>
			</tr>

			<!-------------------- 파일 업로드 구현 -------------------->
			<form action="/fileupload" method="post"
				enctype="Multipart/form-data" id="fileForm">
				<tr>
					<td class="EditPageTable">업로드 파일명</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="filename"
						value="<%=tool_filename%>" disabled style="width: 250px;"></input>
						<% 
		    		
		    		tool_filename = tool_filename.replace("&", "%26");
		    		tool_filename = tool_filename.replace("+", "%2B");
		    		
		    		String hostURL = request.getRequestURL().toString().replace(request.getRequestURI(),"") ;
		    		
		    		tool_filename = URLEncoder.encode(tool_filename, "UTF-8");
		    		
		    		String locationAdress = hostURL + "/filedown_tool?fileName=" + tool_filename ; 
		    		
		    		System.out.println(" locationAdress : " + locationAdress);
		    		
		    		%>
						<button type="button"
							onclick="location.href='<%=locationAdress%>' ">다운로드</button></td>
				</tr>
				<tr>
					<td class="EditPageTable">변경할 파일명</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="file" id="fileUp"
						name="fileUp" style="bolder: 1px" /></td>
				</tr>
				<tr>
					<td class="EditPageTable"></td>
					<td class="EditPageTable"></td>
					<td class="EditPageTable"><font size="2px" color="red">※
							파일 용량은 850MB를 초과할 수 없습니다. </font></td>
				</tr>
			</form>

			<tr>
				<td class="EditPageTable">실행파일</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="exec"
					value="<%=tool_exec %>"></input></td>
			</tr>

		</table>




		<input type="hidden" id="idx" value="<%=tool_idx %>"></input> <br>
		<button type="button" onclick="fileChk(); ">수정하기</button>
		<button type="button" onclick="deleteClick(); ">삭제하기</button>
		<button type="button" onclick="location.href='/ToolList' ">
			뒤로가기</button>

	</div>

	<div class="wrap-loading display-none">
		<div>
			<img src="../../../images/LoadingImage.gif" width="100" height="100" />
		</div>
	</div>

</body>
</html>
