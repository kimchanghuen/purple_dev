<%@ page language="java" contentType="text/html; charset=UTF-8;"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@page import="com.Golfzon.DBManager"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DriverManager</title>
<script type="text/javascript" src="../../resources/js/jquery-1.11.3.js">
	
</script>

<script type="text/javascript">
	// 조회 테이블 컬럼명
	var tableHdr = [ '분류', '모델', '종류', '구분', '버전', 'NAME', 'DOWN', 'ETC' ]; // 7개 컬럼

	// 로그인 체크 함수
	function loginChk() {

		$.ajax({
			type : "GET",
			url : "/Login/loginChk_javascript",
			data : "",
			cache : false,
			success : function(response) {

				var loginChker = response;
				console.log(loginChker);

				if (loginChker == 'null')
					location.href = "/Login/LoginMain";

			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	// 분류 콤보박스 변경시
	function kind_change() {
		loginChk();

		// 테이블 초기화
		$("#titleList>tbody").remove();

		$("#part option:eq(0)").prop("selected", true); // 종류 콤보박스 첫번째 인덱스 선택
		$("#type option:eq(0)").prop("selected", true); // 구분 콤보박스 첫번째 인덱스 선택

		var kind = $(".kind").val();

		$.ajax({
			type : "GET",
			url : "/Link/combomodel",
			data : "kind_id=" + kind,
			cache : false,
			success : function(response) {
				$(".model").html(response);
				serchBtnClick();
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	// 모델 콤보박스 변경시
	function model_change() {
		// 테이블 초기화
		$("#titleList>tbody").remove();

		$("# option:eq(0)").prop("selected", true); // 종류 콤보박스 첫번째 인덱스 선택
		$("#type option:eq(0)").prop("selected", true); // 구분 콤보박스 첫번째 인덱스 선택
		serchBtnClick();
	}
	// 종류 콤보박스 변경시
	function part_change() {
		loginChk();

		$("#type option:eq(0)").prop("selected", true); // 첫번째 인덱스 선택

		var part = $(".part").val();
		if (part == "P001") {
			// 비활성화
			document.getElementById('type').disabled = 1;
		} else {
			// 활성화
			document.getElementById('type').disabled = 0;
		}

		serchBtnClick();

	}
	// 찾기버튼 클릭시
	function serchBtnClick() {

		loginChk();

		// 테이블 초기화
		

		serchDriver();
	}

	// 데이터 조회 function 
	function serchDriver() {
		$("#titleList>tbody").remove();
		var kind = document.getElementById('kind');
		var kind_value = kind.options[kind.selectedIndex].value; // 분류 코드값

		var model = document.getElementById('model');
		var model_value = model.options[model.selectedIndex].value; // 모델 코드값

		var part = document.getElementById('part');
		var part_value = part.options[part.selectedIndex].value; // 종류 코드값

		var type = document.getElementById('type');
		var type_value = type.options[type.selectedIndex].value; // 구분 코드값

		var paramText = "kind_value=" + kind_value + "&model_value="
				+ model_value + "&part_value=" + part_value + "&type_value="
				+ type_value

		$
				.ajax({
					url : "/Driver/Driverserch",
					data : paramText,
					type : 'post',
					async : false,
					success : function(data) {

						console.log("성공 함")
						console.log(data[0]['d_kind'])
						var datas = "";
						for (var i = 0; i < data.length; i++) {
							
							var d_idx = data[i]['d_idx'];

							datas += "<tr style='height:29px';>";
							datas += "<td>" + data[i]['d_kind'] + "</td>";
							datas += "<td>" + data[i]['d_model'] + "</td>";
							datas += "<td>" + data[i]['d_part'] + "</td>";
							datas += "<td>" + data[i]['d_type'] + "</td>";
							datas += "<td>" + data[i]['d_version'] + "</td>";
							datas += "<td>" + data[i]['d_name'] + "</td>";
							datas += '<td width="80"><button type="button" onclick="location.href='+"'"+data[i]['d_filename']				
					    	+"'"+'">다운로드</button></td>';
							datas += '<td style="text-align: left; text-overflow: ellipsis; overflow: hidden;">'+data[i]['d_etc']+'</td>';
							datas += '<td width="60"><button type="button" onclick="location='+"'etcEdit?d_idx="+d_idx+"'"+'">수정</button></td>';
							datas += "</tr>"

						}

						$("#titleList").append(datas);
						tableOrderSetting();
					},
					error : function(request, status, error) {
						alert("code:" + request.status + "\n" + "message:"
								+ request.responseText + "\n" + "error:"
								+ error);
					}
				});
	}

	/* 화면 열자마자 조회 주석 by 2018.04.12 
	$(document).ready( function() {
	 console.log( "파라미터 확인 : " + $("#openParam").value );
	 
	 var signal = openParam.value;
	 if ( signal ) {
	     
	 } else {
		 serchDriver();
	 }
	});
	 */

	function logout() {
		location.href = "/logOut";
	}

	//테이블 헤더 클릭시 자동정렬
	var sortOrder = true;

	function SortTable(table, n) {
		// 헤더 span 초기화
		for (var hdrnum = 0; hdrnum < tableHdr.length; ++hdrnum) {
			document.getElementById('sort_' + hdrnum).innerHTML = "";
		}
		if (sortOrder) { // 오름차순 
			document.getElementById('sort_' + n).innerHTML = "▲";
		} else { // 내림차순
			document.getElementById('sort_' + n).innerHTML = "▼";
		}

		// table 에 tbody tag 가 반드시 존재한다고 가정한다.
		var tbody = table.tBodies[0];
		var rows = tbody.getElementsByTagName("tr");

		// 배열로 생성한 후, 배열로 정렬한다.
		rows = Array.prototype.slice.call(rows, 0);

		rows.sort(function(row1, row2) {
			var cell1 = row1.getElementsByTagName("td")[n];
			var cell2 = row2.getElementsByTagName("td")[n];
			var value1 = cell1.textContent || cell1.innerText;
			var value2 = cell2.textContent || cell2.innerText;

			if (sortOrder) { // 오름차순
				if (value1 < value2)
					return -1;
				if (value1 > value2)
					return 1;
			} else { // 내림차순
				if (value1 < value2)
					return 1;
				if (value1 > value2)
					return -1;
			}

			return 0;
		});

		// 정렬된 배열로 row 를 다시 저장한다. 문서에 이미 존재하는 node 는 삽입하면 해당 node 는 자동으로 제거되고 새 위치에 저장된다.
		for (var i = 0; i < rows.length; ++i) {
			tbody.appendChild(rows[i]);
		}
	}

	$(document).ready(function() {
		tableOrderSetting();
		serchBtnClick();
	});

	function tableOrderSetting() {
		console.log("테이블 헤더 세팅");

		// 모든 table 헤더에 클릭 이벤트를 설정한다.
		var tables = document.getElementsByTagName("table");

		console.log(tables);

		for (var i = 0; i < tables.length; ++i) {
			var headers = tables[i].getElementsByTagName("th");
			for (var j = 0; j < headers.length; ++j) {
				// 지역 유효범위에 생성할 중첩 함수
				(function(table, n) {
					headers[j].onclick = function() {
						sortOrder = !sortOrder;
						SortTable(table, n)
					};
				}(tables[i], j));
			}
		}
	}
</script>

<link rel="stylesheet" type="text/css" href="../../css/style.css">

</head>

<body bgcolor="#EFEFEF">

	<div id="top_header">
		<jsp:include page="../jsp/Datacontroller/NewtopMenu.jsp" flush="false" />
	</div>

	<div style='display: -webkit-inline-box; text-align: center;'>
		<label>분류 : </label> <select class="kind" onchange="kind_change()"
			id="kind">
			<option selected="selected" value="none">-- 분류 --</option>

			<%
				// ------------------- 로그인 체크 -------------------	

				String id = "";

				try {
					// id 체크
					id = (String) session.getAttribute("id");

					System.out.println("로그인 확인 : " + id);

					if (id == null || id.equals("")) {
						response.sendRedirect("/Login/LoginMain");
					}
				} catch (Exception e) {
					System.out.println("error : " + e.toString());
				}

				// ------------------------------------------------------

				DBManager db = new DBManager();

				try {
					Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

					Connection con = db.dbConn();

					PreparedStatement pstmt = null; //create statement

					pstmt = con.prepareStatement(
							"SELECT k_idx, k_code, k_name, k_date, k_enable FROM DRV_KIND where k_enable = '1' "); //sql select query
					ResultSet rs = pstmt.executeQuery(); //execute query and set in resultset object rs.

					while (rs.next()) {
			%>
			<option value="<%=rs.getString("k_code")%>">
				<%=rs.getString("k_name")%>
			</option>
			<%
				}

					con.close(); //close connection
				} catch (Exception e) {
					out.println(e);
				}
			%>
		</select> <label>모델 :</label> <select class="model" id="model"
			onchange="serchBtnClick()">
			<option selected="selected" value="none">-- 모델 --</option>
		</select> <label>종류 :</label> <select class="part" onchange="part_change()"
			id="part">
			<option selected="selected" value="none">-- 종류 --</option>
			<%
				try {
					Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

					Connection con = db.dbConn();

					PreparedStatement pstmt = null; //create statement

					pstmt = con.prepareStatement(
							"SELECT p_idx, p_code, p_name, p_date, p_enable FROM DRV_PART where p_enable = '1' "); //sql select query
					ResultSet rs = pstmt.executeQuery(); //execute query and set in resultset object rs.

					while (rs.next()) {
			%>
			<option value="<%=rs.getString("p_code")%>">
				<%=rs.getString("p_name")%>
			</option>
			<%
				}

					con.close(); //close connection
				} catch (Exception e) {
					out.println(e);
				}
			%>

		</select> <label>구분 :</label> <select class="type" id="type"
			onchange="serchBtnClick()">
			<option selected="selected" value="none">-- 구분 --</option>
			<%
				try {
					Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

					Connection con = db.dbConn();

					PreparedStatement pstmt = null; //create statement

					pstmt = con.prepareStatement(
							"SELECT t_idx, t_code, t_name, t_date, t_enable FROM DRV_TYPE where t_enable = '1' "); //sql select query
					ResultSet rs = pstmt.executeQuery(); //execute query and set in resultset object rs.

					while (rs.next()) {
			%>
			<option value="<%=rs.getString("t_code")%>">
				<%=rs.getString("t_name")%>
			</option>
			<%
				}

					con.close(); //close connection
				} catch (Exception e) {
					out.println(e);
				}
			%>

		</select>

		<button type="button" onclick="serchBtnClick()"
			style="margin-left: 150px; width: 70px;">조회</button>


	</div>


	<!-- 줄바꿈 -->
	<br>

	<div id="dataField">
		<!--  조회 테이블 생성 -->
		<table border='1'
			style="text-align: center; border-style: line; width: 1500px; table-layout: fixed;"
			cellpadding=0 cellspacing=0 id="titleList" name="titleList">
			<thead>
				<script>
					document.write('<th width="80" >' + tableHdr[0]
							+ ' <span id="sort_0"></span> </th>'); // 분류
					document.write('<th width="150" >' + tableHdr[1]
							+ ' <span id="sort_1"></span> </th>'); // 모델
					document.write('<th width="90" >' + tableHdr[2]
							+ ' <span id="sort_2"></span> </th>'); // 종류
					document.write('<th width="160" >' + tableHdr[3]
							+ ' <span id="sort_3"></span> </th>'); // 구분
					document.write('<th width="150" >' + tableHdr[4]
							+ ' <span id="sort_4"></span> </th>'); // 버전
					document.write('<th width="150" >' + tableHdr[5]
							+ ' <span id="sort_5"></span> </th>'); // name
					document.write('<th width="80" >' + tableHdr[6]
							+ ' <span id="sort_6"></span> </th>'); // down
					document.write('<th width="450" colspan=2>' + tableHdr[7]
							+ ' <span id="sort_7"></span> </th>'); // ETC
				</script>
			</thead>
		</table>

		<%
			String param = "";
			if (request.getParameter("signal") == null) {
			} else {
				param = request.getParameter("signal");
			}
		%>
	</div>

</body>
</html>

