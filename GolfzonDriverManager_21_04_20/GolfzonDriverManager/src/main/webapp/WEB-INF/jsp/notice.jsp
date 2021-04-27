<%@ page language="java" contentType="text/html; charset=UTF-8;"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DriverManager</title>
<script type="text/javascript" src="../../resources/js/jquery-1.11.3.js">
	
</script>

<script type="text/javascript">
	var tableHdr = [ '제목', '내용', '공지 여부', '입력시간', '수정시간', '수정' ]; // 6개 컬럼
	// 로그인 체크 함수
	function loginChk() {

		$.ajax({
			type : "GET",
			url : "/Login/loginChk_javascript",
			data : "",
			cache : false,
			success : function(response) {

				var loginChker = response;

				if (loginChker == 'null')
					location.href = "/Login/LoginMain";

			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}

	function pageMove(idx, title, body, enable, startdate, enddate, memo) {
		
		console.log('버튼 클릭')
		console.log(idx)
		console.log(title)
		var f = document.param; //폼 name

		f.n_idx.value = idx;
		f.n_title.value = title;
		f.n_body.value = body;
		f.n_enable.value = enable;
		f.n_startdate.value = startdate;
		f.n_enddate.value = enddate;
		f.n_memo.value = memo;

		f.action = "/Notice/NoticeUpdate";//이동할 페이지
		f.method = "post";//POST방식
		f.submit();
	}

	// 엔터 입력시
	function Enter_Check() {
		// 엔터키의 코드는 13입니다.
		if (event.keyCode == 13) {
			serchBtnClick(); // 실행할 이벤트
		}
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

		serchNotice();
		tableOrderSetting();
	});

	function tableOrderSetting() {
		// 모든 table 헤더에 클릭 이벤트를 설정한다.
		var tables = document.getElementsByTagName("table");

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
	function serchBtnClick() {

		console.log("조회버튼 클릭");
		loginChk();

		// 테이블 초기화
		$("#titleList>tbody").remove();

		serchNotice();
	}
	function serchNotice() {
		// 테이블 초기화

		var type = document.getElementById('type');
		var type_value = type.options[type.selectedIndex].value; // 구분 코드값 1:제목 2:내용
		var value = document.getElementById('value').value; // 제목 / 내용 검색 내용

		var paramText = "type_value=" + type_value + "&value=" + value

		paramText = encodeURI(paramText);

		$
				.ajax({
					url : "/Notice/serchNotice",
					data : paramText,
					type : 'post',
					async : false,
					success : function(data) {
						console.log('조회버튼 클릭s')

						var datas = "";
						for (var i = 0; i < data.length; i++) {

							
							datas += "<tr style='height:29px';>";
							datas += "<td>" + data[i]['n_title'] + "</td>";
							datas += "<td style='text-align: left; text-overflow: ellipsis; overflow: hidden;'" + "title="+"'"+data[i]['titleBody']+"'><nobr>"
									+ data[i]['resultBody'] + "</nobr></td>";
							datas += "<td>" + data[i]['n_date'] + "</td>";
							datas += "<td>" + data[i]['n_update'] + "</td>";
							datas += "<td>" + data[i]['n_enable'] + "</td>";
							datas += '<td width="60"><button type="button" onclick="pageMove('+data[i]['n_idx']
							        +",'"+data[i]['n_title']+"'"
									+",'"+data[i]['resultBody']+"'"
									+",'"+data[i]['n_enanble']+"'"
									+",'"+data[i]['n_startdate']+"'"
									+",'"+data[i]['n_enddate']+"'"
									+')">수정</button></td>';
							datas += "</tr>"

						}
						
						$('#titleList').append(datas);
					},
					error : function(request, status, error) {
						alert("code:" + request.status + "\n" + "message:"
								+ request.responseText + "\n" + "error:"
								+ error);
					}
				});
	}
</script>

<link rel="stylesheet" type="text/css" href="../../css/style.css">

</head>

<body bgcolor="#EFEFEF">

	<%
		//------------------- 로그인 체크 -------------------	

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
	%>
	<!-- 로고이미지 -->
	<div id="top_header">
		<jsp:include page="../jsp/Datacontroller/NewtopMenu.jsp" flush="false" />
	</div>

	<div style='display: -webkit-inline-box; text-align: center;'>
		<form name='serch' action='/DriverManager' method="post">
			<select class="type" id="type" onchange=""
				style="width: 80px; height: 20px;" name='type'>
				<option value="1">제목</option>
				<option value="2">내용</option>
			</select> <input type="text" id="value" value="" name='value'
				style="width: 220px;" />

			<button type="button" style="width: 70px; margin-left: 15px;"
				onclick="serchBtnClick()">조회</button>
			<button type="button" onclick="location.href='/Notice/Noticeinsert' "
				style="width: 70px;">추가</button>

		</form>
	</div>

	<form name="param">
		<input type="hidden" name="n_idx"> <input type="hidden"
			name="n_title"> <input type="hidden" name="n_body"> <input
			type="hidden" name="n_enable"> <input type="hidden"
			name="n_startdate"> <input type="hidden" name="n_enddate">
		<input type="hidden" name="n_memo">
	</form>

	<!-- 줄바꿈 -->
	<br>

	<div id="dataField">
		<!--  조회 테이블 생성 -->
		<table border='1'
			style="text-align: center; border-style: line; width: 1000px; table-layout: fixed;"
			cellpadding=0 cellspacing=0 id="titleList" name="titleList">
			<thead>

				<script>
					document.write('<th width="180" >' + tableHdr[0]
							+ ' <span id="sort_0"></span> </th>'); // 제목
					document.write('<th width="500" >' + tableHdr[1]
							+ ' <span id="sort_1"></span> </th>'); // 내용
					document.write('<th width="90" >' + tableHdr[2]
							+ ' <span id="sort_2"></span> </th>'); // 공지 완료 여부
					document.write('<th width="160" >' + tableHdr[3]
							+ ' <span id="sort_3"></span> </th>'); // 입력시간
					document.write('<th width="150" >' + tableHdr[4]
							+ ' <span id="sort_4"></span> </th>'); // 수정시간
					document.write('<th width="60" >' + tableHdr[5]
							+ ' <span id="sort_5"></span> </th>'); // 수정
				</script>
			</thead>
			<tbody>

			</tbody>

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

