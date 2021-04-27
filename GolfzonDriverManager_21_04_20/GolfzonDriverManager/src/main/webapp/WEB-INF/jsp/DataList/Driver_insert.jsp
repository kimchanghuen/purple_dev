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
		file = file.replace('C:\\fakepath\\', '');

		// 빈칸 체크
		if (!d_name) {
			alert("제목을 입력해주세요");
			return false;
		}
		if (!d_version) {
			alert("버전을 입력해주세요");
			return false;
		}
		if (!d_exec) {
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

			$.ajax({
				type : 'post',
				url : '/Driver/fileCheck/' + file,
				processData : false,
				contentType : false,
				success : function(html) {
					html = html.trim();
					console.log(html)

					if (html == 'true') {

						alert("서버에 파일이 존재합니다.");
						return;

					} else {
						Driver_insert();
					}
				},
				beforeSend : function() {
					// 로딩 이미지 호출 
					$('.wrap-loading').removeClass('display-none');
				},
				complete : function() {
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

	}

	// 저장하기 클릭시
	function Driver_insert() {

		console.log("Driver_insert Start");
		// d_code
		var d_code = document.getElementById('code').value;

		// d_name
		var d_name = document.getElementById('name').value;

		// d_part 
		var d_part = $(".part").val();

		// d_type 
		var d_type = $(".type").val();

		// d_version
		var d_version = document.getElementById('version').value;

		// d_exec
		var d_exec = document.getElementById('exec').value;

		// d_etc
		var d_etc = document.getElementById('etc').value;
		// d_etc = encodeURI(d_etc);

		// 신규 필드 추가 by 김주성 2019.05.07
		// d_etc_type
		var d_etc_type = document.getElementById('d_etc_type').value;

		// d_etc_module
		var d_etc_module = document.getElementById('d_etc_module').value;

		// d_etc_name
		var d_etc_name = document.getElementById('d_etc_name').value;

		// d_etc_uninst
		var d_etc_uninst = document.getElementById('d_etc_uninst').value;

		var paramText = "d_code=" + d_code + "&d_name=" + d_name + "&d_part="
				+ d_part + "&d_type=" + d_type + "&d_version=" + d_version
				+ "&d_exec=" + d_exec + "&d_etc=" + d_etc + "&d_etc_type="
				+ d_etc_type + "&d_etc_module=" + d_etc_module + "&d_etc_name="
				+ d_etc_name + "&d_etc_uninst=" + d_etc_uninst

		var formData = new FormData($("#fileForm")[0]);

		console.log('파일 넣는것까지 잘넘어옴')
		$.ajax({
			url : "/Driver/DriverInsert_sql",
			data : formData,
			async : false,
			processData : false,
			contentType : false,
			type : 'post',
			success : function(data) {
				location.href = "/Driver/DriverList";
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	// 파일 업로드 관련
	

	$(document).ready(function() {
		part_change();
	});

	// 종류 콤보박스 변경시
	function part_change() {
		var part = $(".part").val();
		if (part == "P001") {

			$("#type option:eq(0)").prop("selected", true); // 첫번째 인덱스 선택
			// 비활성화
			document.getElementById('type').disabled = 1;
		} else {
			// 활성화
			document.getElementById('type').disabled = 0;
		}

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


	<%
		// ------------------- 로그인 체크 -------------------
		String id = "";

		try {
			// id 체크
			id = (String) session.getAttribute("id");

			if (id == null || id.equals("")) {
				response.sendRedirect("/Login/LoginMain");
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
			query.append(" SELECT LPAD(MAX(substring(d_code, 2, 5)+1),5,0) AS d_code FROM DRV_DRIVERS ");

			System.out.println(" 쿼리 확인 : ");
			System.out.println(query.toString());

			pstmt = con.prepareStatement(query.toString());

			ResultSet result = pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			result.last();

			String strDcode = "";
			strDcode = "D" + result.getString("d_code");
	%>
	<form action="/Driver/DriverInsert_sql" method="post"
		enctype="Multipart/form-data" id="fileForm">
		<div style="height: auto; text-align: center;">

			<!-- 테이블 폼으로 변경 -->
			<table style="margin: auto;">
				<tr>
					<td class="EditPageTable">코 드</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="code"
						name="d_code" value="<%=strDcode%>"></input></td>
				</tr>
				<tr>
					<td class="EditPageTable">제 목</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="name"
						name="d_name" value=""></input></td>
				</tr>
				<tr>
					<td class="EditPageTable">종 류</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><select class="part" id="part"
						name="d_part" style="width: 173px;" onchange="part_change()">
							<%
								try {
										Class.forName("com.mysql.cj.jdbc.Driver");
										DBManager db1 = new DBManager();

										Connection con1 = db1.dbConn();

										PreparedStatement pstmt1 = null;

										pstmt1 = con1.prepareStatement("SELECT p_code, p_name FROM DRV_PART WHERE p_enable='1' ");
										ResultSet rs = pstmt1.executeQuery();

										while (rs.next()) {
							%>
							<option value="<%=rs.getString("p_code")%>">
								<%=rs.getString("p_name")%>
							</option>
							<%
								}

										con1.close(); //close connection
									} catch (Exception e) {
										out.println(e);
									}
							%>
					</select></td>
				</tr>
				<tr>
					<td class="EditPageTable">구 분</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><select class="type" id="type"
						name="d_type" style="width: 173px;">
							<%
								try {
										Class.forName("com.mysql.cj.jdbc.Driver");
										DBManager db2 = new DBManager();

										Connection con2 = db2.dbConn();

										PreparedStatement pstmt2 = null;

										pstmt2 = con2.prepareStatement("SELECT t_code, t_name FROM DRV_TYPE WHERE t_enable='1' ");
										ResultSet rs = pstmt2.executeQuery();
							%>
							<option value=" ">--구분목록--</option>
							<%
								while (rs.next()) {
							%>
							<option value="<%=rs.getString("t_code")%>">
								<%=rs.getString("t_name")%>
							</option>
							<%
								}
							%>
							<option value="">없음</option>
							<%
								con2.close(); //close connection
									} catch (Exception e) {
										out.println(e);
									}
							%>
					</select></td>
				</tr>
				<tr>
					<td class="EditPageTable">버 전</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="version"
						name="d_version" value=""></input></td>
				</tr>

				<tr>
					<td class="EditPageTable">실행파일</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="exec"
						name="d_exec" value="" style="width: 300px;"></input></td>
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
						name="d_etc_type" style="width: 173px" onchange="itemChange()">
							<option value="driver" selected>driver</option>
							<option value="software">software</option>
					</select></td>
				</tr>

				<tr>
					<td class="EditPageTable">설치방식</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><select class="type"
						id="d_etc_module" style="width: 173px" name="d_etc_module" onchange="itemChange()">
							<option value="wmi" selected>wmi</option>
							<option value="directx">directx</option>
							<option value="flash">flash</option>
					</select></td>
				</tr>

				<tr>
					<td class="EditPageTable">설치등록명</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="d_etc_name"
						name="d_etc_name" value="" style="width: 373px;" onchange="itemChange()"></input></td>
				</tr>

				<tr>
					<td class="EditPageTable">설치제거방식</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="d_etc_uninst"
						name="d_etc_uninst" value="" style="width: 373px;" onchange="itemChange()"></input></td>
				</tr>


				<!-------------------- 파일 업로드 구현 -------------------->

				<tr>
					<td class="EditPageTable">업로드 파일명</td>
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


				<tr>
					<td class="EditPageTable">추가Data</td>
					<td class="EditPageTable">:</td>
					<td class="EditPageTable"><input type="text" id="etc" value=""
						name="d_etc" style="width: 299px;"></input></td>
				</tr>
				<tr>
					<td class="EditPageTable"></td>
					<td class="EditPageTable"></td>
					<td class="EditPageTable"><font size="2px" color="red">※
							Json 형식으로 입력합니다. (ex_ {"test":"1", "test2":"2", .. } ) </font></td>
				</tr>
			</table>





			<%
				con.close(); //close connection
				} catch (Exception e) {
					System.out.println(e.toString());
				}
			%>

			<%
				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
					DBManager db3 = new DBManager();

					Connection con3 = db3.dbConn();

					PreparedStatement pstmt3 = null;

					pstmt3 = con3.prepareStatement("SELECT max(d_idx)+1 AS d_idx FROM DRV_DRIVERS ");
					ResultSet rs3 = pstmt3.executeQuery();

					while (rs3.next()) {
						String maxIdx = rs3.getString("d_idx");
			%>
			<input type="hidden" id="idx" name="idx" value="<%=maxIdx%>" />
			<%
				}

					con3.close(); //close connection
				} catch (Exception e) {
					out.println(e);
				}
			%>


			<div class="wrap-loading display-none">
				<div>
					<img src="../../../images/LoadingImage.gif" width="100"
						height="100" />
				</div>
			</div>

			<button type="button" onclick="fileChk(); ">입력하기</button>
			<button type="button" onclick="location.href='/Driver/DriverList' ">
				뒤로가기</button>

		</div>
	</form>


</body>
</html>



