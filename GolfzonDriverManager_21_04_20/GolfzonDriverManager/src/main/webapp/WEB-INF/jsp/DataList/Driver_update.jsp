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
	src="../../../resources/js/jquery-1.11.3.js">  </script>

<script type="text/javascript">  
 //JSON 동적
 function itemChange() {
	 
	 var Jsone = {"type": $('#d_etc_type').val(), "module":$('#d_etc_module').val(),"name":$('#d_etc_name').val(), "uninst":$('#d_etc_uninst').val()};	 
	 console.log(Jsone);
	 
	 var person_str = JSON.stringify(Jsone);
	 
	 console.log(person_str);
	 
	 $('#etc').empty();
	 $('#etc').val(person_str);

}

//입력값 체크
 function valueChk() {
	 
	// 제목
	var d_name = document.getElementById('name').value;
	 
	// 종류 
	var d_part = $(".part").val();
	 
	// 구분 
	var d_type = $(".type").val();
	
	// 버전
	var d_version = document.getElementById('version').value;
	
	// 실행파일
	var d_exec = document.getElementById('exec').value;
	
	// 추가데이터
	var d_etc = document.getElementById('etc').value;
	d_etc = encodeURI(d_etc);
    
	//업로드 파일명
	var file = document.getElementById('fileUp').value;
    file = file.replace('C:\\fakepath\\','');
     
	// 빈칸 체크
	if ( !d_name ) { alert("제목을 입력해주세요")	; return false;	}
	if ( !d_version ) { alert("버전을 입력해주세요");	 return false;	}
	if ( !d_exec ) { alert("실행파일을 입력해주세요");	 return false;	}
	
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
 
 // 각 데이터 클릭시
 function Driver_change()
 {
	// d_idx
	var d_idx = document.getElementById('idx').value;
	 
	// d_code
	var d_code = document.getElementById('code').value;
	 
	// d_name
	var d_name = document.getElementById('name').value;
	
	// d_part 
	var d_part = $(".part").val();
	 
	// d_type 
	var d_type = $(".type").val();
	
	// d_filename
	var d_filename = document.getElementById('filename').value;
	
	// d_version
	var d_version = document.getElementById('version').value;
	
	// d_exec
	var d_exec = document.getElementById('exec').value;
	
	// d_etc
	var d_etc = document.getElementById('etc').value;
	// d_etc = encodeURI(d_etc);
	
	console.log("d_etc : " + d_etc);
	
	// d_enable
	var d_enable = document.getElementById('enable').value;
	
	// 신규 필드 추가 by 김주성 2019.05.07
	// d_etc_type
	var d_etc_type = document.getElementById('d_etc_type').value;
	
	// d_etc_module
	var d_etc_module = document.getElementById('d_etc_module').value;
	
	// d_etc_name
	var d_etc_name = document.getElementById('d_etc_name').value;
	
	// d_etc_uninst
	var d_etc_uninst = document.getElementById('d_etc_uninst').value;
	 
	var paramText = "d_idx="+ d_idx
	    + "&d_code="+ d_code
	    + "&d_name="+ d_name
	    + "&d_part="+ d_part
	    + "&d_type="+ d_type
	    + "&d_filename="+ d_filename
	    + "&d_version="+ d_version
	    + "&d_exec="+ d_exec
	    + "&d_etc="+ d_etc
	    + "&d_enable="+ d_enable
	    + "&d_etc_type="+ d_etc_type
	    + "&d_etc_module="+ d_etc_module
	    + "&d_etc_name="+ d_etc_name
	    + "&d_etc_uninst="+ d_etc_uninst
	    
	    paramText = encodeURI(paramText);
		    
	    $.ajax({
	        url : "/Driver/DriverUpdate_sql",
	        data : paramText,
	        type : 'post',
	        success : function(data){
	        	
	        	var file = document.getElementById('fileUp').value;

	       	    if ( file ) {
	        		fileSubmit();
	       	    } 
	        	
	        	location.href="/Driver/DriverList"; 
	        },
	        error:function(request,status,error){
	            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        }
	    });

 }
 
 // 데이터 삭제 클릭시
 function deleteClick() {
	 
	// 사용 목록
	var strUseResult = document.getElementById('resultList').value;
    
	console.log("strUseResult : " + strUseResult);
    
	if ( strUseResult && strUseResult != 'null'  ){
		var checker = confirm("해당 드라이버는\n" + strUseResult + "\n에 영향을 주고있습니다.\n정말 해당 드라이버를 삭제하시겠습니까?");
		
		if ( checker ) {
			 
			Driver_delete();
			 
		 } else if ( !checker ) {
			 alert("삭제를 취소하셨습니다.");
			 return;
		 } 
	} else {
		var checker = confirm("정말 해당 드라이버를 삭제하시겠습니까?");
		
		if ( checker ) {
			 
		   Driver_delete();
			 
		 } else if (!checker ) {
			 alert("삭제를 취소하셨습니다.");
			 return;
		 }
	}
	
	
 }
 
function Driver_delete() {
	// DB 및 파일 삭제 로직
	
	// d_code
	var d_code = document.getElementById('code').value;
	// d_filename
	var d_filename = document.getElementById('filename').value;
	
	// d_name
	var d_name = document.getElementById('name').value;
	
	console.log(d_code)
	console.log(d_filename)
	console.log(d_name)
	
	var paramText = "d_code="+ d_code
	+ "&d_filename="+ d_filename
	+ "&d_name="+ d_name
	
	paramText = encodeURI(paramText);
	
	$.ajax({
        url : "/Driver/fileDelete",
        data : paramText,
        async : false,
        type : 'post',
        success : function(data){
        	alert("삭제가 완료되었습니다.");   	
        	location.href="/Driver/DriverList"; 
        },
        error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
	
}
	$(document).ready( function()
	  {  part_change();  } );
		  
 // 종류 콤보박스 변경시
 function part_change()
 {
     var part = $(".part").val();
     if( part == "P001" ) {
    	 
    	 $("#type option:eq(0)").prop("selected", true); // 첫번째 인덱스 선택
    	 // 비활성화
    	 document.getElementById('type').disabled = 1;
     } else {
    	 // 활성화
    	 document.getElementById('type').disabled = 0;
     }    
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
		         type : 'post',
		         url : '/Driver/fileCheck/' + file,
		         data : "",
		         processData : false,
		         contentType : false,
		         success : function(html) {
		        	 html = html.trim();
		        	 
		        	 if(html == 'true') {
		        		 var checker = confirm("서버에 파일이 존재합니다.\n덮어씌우시겠습니까?");
		        	
		        		 if (checker) {
		        			 
		        			 Driver_change();
		        			 
		        		 } else if (!checker) {
		        			 alert("파일 올리기를 취소하셨습니다.");
		        			 return;
		        		 }
		        	 } else { 
		        		 Driver_change();
		             } 
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
		 } else {
			 Driver_change();
		 }
	 
	 }
 }
 

 // 파일 업로드 관련
 function fileSubmit() {
     var formData = new FormData($("#fileForm")[0]);
     var d_idx = document.getElementById('idx').value;
     
     console.log("fileSubmit 확인 : " + d_idx);
     $.ajax({
         type : 'post',
         url : '/Driver/fileUpload/' + d_idx,
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
		<jsp:include page="../Datacontroller/NewtopMenu_sub5.jsp"
			flush="false" />
	</div>

	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<c:set var="d_etc" value="${d_etc}" />

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

 
 String d_idx=request.getParameter("d_idx");
 String d_code=request.getParameter("d_code");
 /*
 String d_name=request.getParameter("d_name");
 String d_part=request.getParameter("d_part");
 String d_type=request.getParameter("d_type");
 String d_filename=request.getParameter("d_filename");
 String d_version=request.getParameter("d_version");
 String d_exec=request.getParameter("d_exec");
 String d_etc=request.getParameter("d_etc");
 String d_enable=request.getParameter("d_enable");
 String d_etc_type=request.getParameter("d_etc_type"); 
 String d_etc_module=request.getParameter("d_etc_module"); 
 String d_etc_name=request.getParameter("d_etc_name"); 
 String d_etc_uninst=request.getParameter("d_etc_uninst"); 
 */
 
 String d_name="";
 String d_part="";
 String d_type="";
 String d_filename="temp";
 String d_version="";
 String d_exec="temp";
 String d_etc="temp";
 String d_enable="";
 String d_etc_type=""; 
 String d_etc_module=""; 
 String d_etc_name="null"; 
 String d_etc_uninst="null";
 
 //------------------------------- 데이터 조회 쿼리
 try
 {
     Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
     DBManager db = new DBManager();
     Connection con = db.dbConn();
         
     PreparedStatement pstmt=null ; //create statement
     
     String sql = "SELECT * FROM DRV_DRIVERS" + "\n"
			  	     +  "WHERE d_code = ? ";
     
	 pstmt = con.prepareStatement( sql );
	 pstmt.setString(1, d_code);
     
     System.out.println(" select 쿼리 확인 : ");
     System.out.println( pstmt.toString() );
	 ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

     // 데이터의 가장 끝으로 보내기
     rs.last();
     
     // rs.getRow() : 데이터의 가장 끝 index
     if ( rs.getRow() > 0 ) {
     	
     	// 데이터의 가장 처음으로 보내기
     	rs.beforeFirst();
	        while( rs.next() ){
	        	d_name = rs.getString("d_name");
       			d_part = rs.getString("d_part");
       			d_type = rs.getString("d_type");
       			d_filename = rs.getString("d_filename"); 
       			d_version = rs.getString("d_version");
       			d_exec = rs.getString("d_exec");
       			d_etc = rs.getString("d_etc");
       			
       			d_enable = Integer.toString(rs.getInt("d_enable"));
       			
       			d_etc_type = rs.getString("d_etc_type"); 
       			d_etc_module = rs.getString("d_etc_module");
       			d_etc_name = rs.getString("d_etc_name"); 
       			d_etc_uninst = rs.getString("d_etc_uninst");
	        } 
     } else {
     	// 데이터가 없을 시

     }
     con.close(); //close connection
 } catch(Exception e) {
     System.out.println(e.toString());
 }

 
 if(d_etc_name.equals("null"))
	 d_etc_name = "";

 if(d_etc_uninst.equals("null"))
	 d_etc_uninst = "";
 
 if(d_etc.equals("temp"))
	 d_etc = "";
 
 if(d_filename.equals("temp"))
	 d_filename = "";
 
 if(d_exec.equals("temp"))
	 d_exec = "";
 
 if(d_filename.equals(""))
	 d_filename = "temp";
 
 DBManager db = new DBManager();
 
%>
	<div style="height: auto; text-align: center;">

		<!-- 테이블 폼으로 변경 -->
		<table style="margin: auto;">
			<tr>
				<td class="EditPageTable">코 드</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="code"
					value="<%=d_code %>" disabled></input></td>
			</tr>
			<tr>
				<td class="EditPageTable">제 목</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="name"
					value="<%=d_name %>"></input></td>
			</tr>
			<tr>
				<td class="EditPageTable">사용여부</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><select class="enable" id="enable"
					style="width: 173px">
						<% if ( d_enable.equals("1") ) { %>
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
				<td class="EditPageTable">종 류</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><select class="part" id="part"
					style="width: 173px" onchange="part_change()">
						<%
				    try
				    {
				    	Class.forName("com.mysql.cj.jdbc.Driver"); 
				    	
				    	Connection con = db.dbConn();
				    	
				        PreparedStatement pstmt=null ; 
				                
				        pstmt=con.prepareStatement("SELECT p_code, p_name FROM DRV_PART WHERE p_enable='1' ");
				        ResultSet rs=pstmt.executeQuery(); 
				                
				        while(rs.next())
				        {
				        	if (rs.getString("p_code").equals(d_part)) {
				        		%>
						<option value="<%=rs.getString("p_code")%>" selected>
							<%=rs.getString("p_name")%>
						</option>
						<%
				        	} else {
				        %>
						<option value="<%=rs.getString("p_code")%>">
							<%=rs.getString("p_name")%>
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
				</select></td>
			</tr>
			<tr>
				<td class="EditPageTable">구 분</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><select class="type" id="type"
					style="width: 173px">
						<%
				    try
				    {
				    	Class.forName("com.mysql.cj.jdbc.Driver"); 
				    	
				    	Connection con = db.dbConn();
				    	
				        PreparedStatement pstmt=null ; 
				                
				        pstmt=con.prepareStatement("SELECT t_code, t_name FROM DRV_TYPE WHERE t_enable='1' ");
				        ResultSet rs=pstmt.executeQuery(); 
				        
			        	%>
						<option value=" ">--구분목록--</option>
						<%	        	
				        while(rs.next())
				        {
				        	if (rs.getString("t_code").equals(d_type)) {
				        		%>
						<option value="<%=rs.getString("t_code")%>" selected>
							<%=rs.getString("t_name")%>
						</option>
						<%
				        	} else {
				        %>
						<option value="<%=rs.getString("t_code")%>">
							<%=rs.getString("t_name")%>
						</option>
						<%
				        	}
				        }
				        
				    %>
						<option value="">없음</option>
						<%
				           
				        con.close(); //close connection
				    }
				    catch(Exception e)
				    {
				       out.println(e);
				    }
				    %>
				</select></td>
			</tr>
			<tr>
				<td class="EditPageTable">버 전</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="version"
					value="<%=d_version %>"></input></td>
			</tr>
			<tr>
				<td class="EditPageTable">실행파일</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="exec"
					value="<%=d_exec%>" style="width: 375px;"></input></td>
			</tr>
			<tr>
				<td class="EditPageTable"></td>
				<td class="EditPageTable"></td>
				<td class="EditPageTable"><font size="2px" color="red">※
						실제 설치 파일을 입력합니다. (ex_ setup.exe) </font></td>
			</tr>

			<tr>
				<td class="EditPageTable">설치구분</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><select class="type" id="d_etc_type"
					style="width: 173px" onchange="itemChange()">

						<%		        	
			        	if (d_etc_type.equals("driver")) {
			        		%>
						<option value="driver" selected>driver</option>
						<option value="software">software</option>
						<%
			        	} else {
			        %>
						<option value="software" selected>software</option>
						<option value="driver">driver</option>
						<%
			        	}
			    %>
				</select></td>
			</tr>

			<tr>
				<td class="EditPageTable">설치방식</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><select class="type"
					id="d_etc_module" style="width: 173px" onchange="itemChange()">

						<%		        	
			        	if (d_etc_module.equals("wmi")) {
			        		%>
						<option value="wmi" selected>wmi</option>
						<option value="directx">directx</option>
						<option value="flash">flash</option>
						<%
			        	} else if (d_etc_module.equals("directx")) {
			        %>
						<option value="directx" selected>directx</option>
						<option value="wmi">wmi</option>
						<option value="flash">flash</option>
						<%
			        	} else if (d_etc_module.equals("flash")) {
			        %>
						<option value="flash" selected>flash</option>
						<option value="directx">directx</option>
						<option value="wmi">wmi</option>
						<%
			        	}
			    %>
				</select></td>
			</tr>

			<tr>
				<td class="EditPageTable">설치등록명</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="d_etc_name"
					value="<%=d_etc_name%>" style="width: 373px;"
					onchange="itemChange()"></input></td>
			</tr>

			<tr>
				<td class="EditPageTable">설치제거방식</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable"><input type="text" id="d_etc_uninst"
					value="<%=d_etc_uninst%>" style="width: 373px;"
					onchange="itemChange()"></input></td>
			</tr>

			<!-------------------- 파일 업로드 구현 -------------------->
			<form action="/fileupload" method="post"
				enctype="Multipart/form-data" id="fileForm">
				<tr>
					<td class="EditPageTable">업로드 파일명</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="filename"
						value="<%=d_filename%>" disabled style="width: 250px;"></input> <% 
		    		
		    		d_filename = d_filename.replace("&", "%26");
		    		d_filename = d_filename.replace("+", "%2B");
		    		
		    		String hostURL = request.getRequestURL().toString().replace(request.getRequestURI(),"") ;
		    		
		    		d_filename = URLEncoder.encode(d_filename, "UTF-8");
		    		
		    		
		    		String locationAdress = hostURL + "/filedown?fileName=" + d_filename ; 
		    		
		    		System.out.println(" locationAdress : " + locationAdress);
		    		
		    		%>
						<button type="button"
							onclick="location.href='<%=locationAdress%>' ">다운로드</button> <!--  <input type="button" id="btnFileEdt" onclick="location.href='/FileUploadForm/<%=d_idx%>/<%=d_filename%>'" value="수정"></input>  -->
					</td>
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
				<td class="EditPageTable">추가Data</td>
				<td class="EditPageTable">:</td>
				<td class="EditPageTable">
					<%
						d_etc = d_etc.replace("\"", "&quot;");
					%> <input type="text" id="etc" value="<%=d_etc%>"
					style="width: 373px;"></input>
				</td>
			</tr>
			<tr>
				<td class="EditPageTable"></td>
				<td class="EditPageTable"></td>
				<td class="EditPageTable"><font size="2px" color="red">※
						Json 형식으로 입력합니다. (ex_ {"test":"1", "test2":"2", .. } ) </font></td>
			</tr>
		</table>



		<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");

				Connection con = db.dbConn();

				PreparedStatement pstmt = null;
				pstmt = con.prepareStatement("SELECT GROUP_CONCAT(AA.k_name SEPARATOR '\n' ) AS RESULT "
						+ " FROM ( SELECT CONCAT( (SELECT k_name FROM DRV_KIND WHERE k_code = A.l_kind), ' 의 ' "
						+ " , ( SELECT m_name FROM DRV_MODEL WHERE m_code = A.l_model )) AS k_name "
						+ " FROM DRV_LINK A " + " WHERE A.l_code = '" + d_code + "' "
						+ " AND   A.l_kind NOT IN ('K000') " + " AND   A.l_model NOT IN ('M000')) AA ");
				ResultSet rs = pstmt.executeQuery();

				while (rs.next()) {
		%>
		<input type="hidden" id="resultList" name="resultList"
			value="<%=rs.getString("RESULT")%>">
		<%
			}
				con.close(); //close connection
			} catch (Exception e) {
				out.println(e);
			}
		%>
		<input type="hidden" id="idx" value="<%=d_idx%>"></input> <br>
		<button type="button" onclick="fileChk(); ">수정하기</button>
		<button type="button" onclick="deleteClick(); ">삭제하기</button>
		<button type="button" onclick="location.href='/Driver/DriverList' ">
			뒤로가기</button>

	</div>

	<div class="wrap-loading display-none">
		<div>
			<img src="../../../images/LoadingImage.gif" width="100" height="100" />
		</div>
	</div>

</body>
</html>
