<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="com.Golfzon.DBManager"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DriverManager</title>
<script type="text/javascript"
	src="../../../resources/js/jquery-1.11.3.js">
	
</script>

<script type="text/javascript">
	//입력값 체크
	function valueChk() {

		var name = document.getElementById('name').value;
		var version = document.getElementById('version').value;
		var exec = document.getElementById('exec').value;

		//업로드 파일명
		var file = document.getElementById('fileUp').value;
		file = file.replace('C:\\fakepath\\', '');

		// 빈칸 체크
		if (!name) {
			alert("제목을 입력해주세요");
			return false;
		}
		if (!version) {
			alert("버전을 입력해주세요");
			return false;
		}
		if (!exec) {
			alert("실행파일을 입력해주세요");
			return false;
		}
		if (!file) {
			alert("업로드 파일을 입력해주세요");
			return false;
		}

		// 파일 용량 체크
		var maxSize = 1024 * 1024 * 850; // 850MB
		var fileSize = 0;

		// 브라우저 확인
		var browser = navigator.appName;

		// 익스플로러일 경우
		if (browser == "Microsoft Internet Explorer") {
			var oas = new ActiveXObject("Scripting.FileSystemObject");
			fileSize = oas.getFile(document.getElementById('fileUp').value).size;
		}
		// 익스플로러가 아닐경우
		else {
			fileSize = document.getElementById('fileUp').files[0].size;
		}

		if (fileSize > maxSize) {
			alert("첨부파일 사이즈는 850MB 이내로 등록 가능합니다.    ");
			return false;
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

	// 파일유무 체크
	function fileChk() {

		if (valueChk()) {
			var file = document.getElementById('fileUp').value;

			file = file.replace('C:\\fakepath\\', '');

			// 한글깨짐 방지처리
			file = encodeURI(file);

			console.log("file : " + file);
			$.ajax({
				method : 'get',
				url : '/Tool/fileCheck_TOOL/' + file,
				processData : false,
				contentType : false,
				async : false,
				success : function(html) {
					console.log(html);
					if (html == 'true') {
						alert("중복파일이있습니다.");
						return;
					} else {
						tool_insert();
					}
				},
				error : function(error) {
					alert("파일 업로드에 실패하였습니다.");
					console.log(error);
					console.log(error.status);
					return;
				}
			});
		}
	}

	// 파일 추가하기
	function tool_insert() {
		console.log("tool_insert Start!!");
		

		var formData = new FormData($("#fileForm")[0]);


		$.ajax({
			url : "/Tool/ToolInsert_sql",
			data : formData,
			type : 'post',
			async : false,
			processData : false,
			contentType : false,
			success : function() {
				location.href = "/Tool/ToolList";
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	// 파일 업로드 관련  업로드하고 인설트 부분 한번에 묶는걸로 수정
	// 파일 폼에다가 데이터 저장해야함 
	
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

	<%
		// ------------------- 로그인 체크 -------------------
		String id = "";

		try {
			// id 체크
			id = (String) session.getAttribute("id");

			if (id == null || id.equals("")) {
				response.sendRedirect("/LoginMain");
			}
		} catch (Exception e) {
			System.out.println("error : " + e.toString());
		}
		// ------------------------------------------------------

		try {
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
			DBManager db = new DBManager();

			Connection con = db.dbConn();

			PreparedStatement pstmt = null; //create statement

			StringBuffer query = new StringBuffer();
			query.append(
					"  SELECT CONCAT('T',LPAD(MAX(substring(tool_code, 2, 6)+1),5,0)) AS tool_code, MAX(tool_idx)+1 tool_idx  FROM DRV_TOOLS ");

			System.out.println(" 쿼리 확인 : ");
			System.out.println(query.toString());

			pstmt = con.prepareStatement(query.toString());

			ResultSet rs = pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();
	%>
	<form name='serch 'action="/Tool/ToolInsert_sql" method="post"
	enctype="Multipart/form-data" id="fileForm">
		<div style="height: auto; text-align: center;">
			<!-- 테이블 폼으로 변경 -->
			<table style="margin: auto;">
				<tr>
					<td class="EditPageTable">코 드</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="code" name="tool_code"
						value="<%=rs.getString("tool_code")%>"></input></td>
						
				</tr>
				<tr>
					<td class="EditPageTable">파일명</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="name" name="name"></input></td>
				</tr>

				<tr>
					<td class="EditPageTable">사용여부</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><select class="enable" id="enable" name="enable"
						style="width: 173px">
							<option value="1" selected>사용</option>
							<option value="0">미사용</option>
					</select></td>
				</tr>

				<tr>
					<td class="EditPageTable">버 전</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="version" name="version"
						style="width: 169px;"></input></td>
				</tr>


				<!-------------------- 파일 업로드 구현 -------------------->

				<tr>
					<td class="EditPageTable">업로드 파일명</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="file" id="fileUp"
						name="fileUp" /></td>
				</tr>
				<tr>
					<td class="EditPageTable"></td>
					<td class="EditPageTable"></td>
					<td class="EditPageTable"><font size="2px" color="red">※
							파일 용량은 850MB를 초과할 수 없습니다. </font></td>
				</tr>

				<tr>
					<td class="EditPageTable">실행파일</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="exec"
						style="width: 350px;" name="exec"></input></td>
				</tr>

			</table>

			<input type="hidden" id="idx" name="idx"
				value="<%=rs.getString("tool_idx")%>" />


			<%
				con.close(); //close connection
				} catch (Exception e) {
					System.out.println(e.toString());
				}
			%>

			<div class="wrap-loading display-none">
				<div>
					<img src="../../../images/LoadingImage.gif" width="100"
						height="100" />
				</div>
			</div>

			<br>
			<button type="button" onclick="fileChk()" >입력하기</button>
			<button type="button" onclick="location.href='/Tool/ToolList' ">
				뒤로가기</button>

		</div>
	</form>

</body>
</html>
