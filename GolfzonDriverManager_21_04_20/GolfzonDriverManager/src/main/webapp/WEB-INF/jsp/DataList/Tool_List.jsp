<%@ page language="java" contentType="text/html; charset=UTF-8;"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DriverManager</title>
<script type="text/javascript"
	src="../../../resources/js/jquery-1.11.3.js">
	
</script>

<script type="text/javascript">
	// 찾기버튼 클릭시
	var tableHdr = [ '파일이름', '버전', '설치파일', '등록일자', 'url', '사용여부', '수정' ]; // 6개 컬럼
	function serchBtnClick() {

		// 테이블 초기화
		$("#titleListTool>tbody").remove();

		serchTool();
	}

	// 데이터 조회 function 

	// 데이터 추가 function 
	function insertBtnClink() {
		location.href = "/Tool/Toolinsert";
	}

	//테이블 헤더 클릭시 자동정렬

	// 각 데이터 클릭시
	function pageMove(idx, code, name, version, filename, exec, enable) {

		console.log(idx + " / " + code + " / " + name + " / " + version + " / "
				+ filename + " / " + exec + " / " + enable);

		var f = document.param; //폼 name

		f.tool_idx.value = idx;
		f.tool_code.value = code;
		f.tool_name.value = name;
		f.tool_version.value = version;
		f.tool_filename.value = filename;
		f.tool_exec.value = exec;
		f.tool_enable.value = enable;

		f.action = "/Tool/ToolUpdate";//이동할 페이지
		f.method = "post";//POST방식
		f.submit();
	}

	var sortOrder = true;

	function SortTable(table, n) {
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
	});
</script>
</head>
<body>

	<form name="param">
		<input type="hidden" name="tool_idx"> <input type="hidden"
			name="tool_code"> <input type="hidden" name="tool_name">
		<input type="hidden" name="tool_version"> <input type="hidden"
			name="tool_filename"> <input type="hidden" name="tool_exec">
		<input type="hidden" name="tool_enable">
	</form>

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
	%>

	<div id="top_header">
		<jsp:include page="../Datacontroller/NewtopMenu.jsp" flush="false" />
	</div>

	<div id="buttonDiv" style="text-align: center;">
		<BUTTON type='BUTTON' value=' 추가 ' onclick='insertBtnClink()'
			style="margin-left: 1100px; width: 70pt;">추가</button>
	</div>

	<!-- 줄바꿈 -->
	<br>
	<br>

	<div id="dataField"
		style="width: auto; margin: auto; text-align: center;">
		<!--  조회 테이블 생성 -->
		<table border='1'
			style="text-align: center; border-style: line; width: 1200px; margin: auto;"
			cellpadding=0 cellspacing=0 id="titleListTool">
			<thead>

				<script>
					document.write('<th width="90" >' + tableHdr[0]
							+ ' <span id="sort_0"></span> </th>'); // 파일이름
					document.write('<th width="90" >' + tableHdr[1]
							+ ' <span id="sort_1"></span> </th>'); // 버전
					document.write('<th width="170" >' + tableHdr[2]
							+ ' <span id="sort_2"></span> </th>'); // 설치파일
					document.write('<th width="170" >' + tableHdr[3]
							+ ' <span id="sort_3"></span> </th>'); // 등록일자
					document.write('<th width="90" >' + tableHdr[4]
							+ ' <span id="sort_4"></span> </th>'); // url
					document.write('<th width="85" >' + tableHdr[5]
							+ ' <span id="sort_5"></span> </th>'); // 사용여부
					document.write('<th width="85" >' + tableHdr[6]
							+ ' <span id="sort_6"></span> </th>'); // 수정
				</script>
			</thead>

			<tbody>
				<c:forEach items="${list}" var="ToolList">
					<tr>
						<td><c:out value="${ToolList.tool_name}" /></td>
						<td><c:out value="${ToolList.tool_version}" /></td>
						<td><c:out value="${ToolList.tool_filename}" /></td>
						<td><fmt:formatDate value="${ToolList.tool_datetime}"
								pattern="yyyy-MM-dd" /></td>
						<td><c:out value="${ToolList.tool_url}" /></td>
						<td><c:out value="${ToolList.tool_enable}" /></td>
						<td>
							<button type="button"
								onclick="pageMove('${ToolList.tool_idx}'
								,'${ToolList.tool_code}'
								,'${ToolList.tool_name}'
								,'${ToolList.tool_version}'
								,'${ToolList.tool_filename}'
								,'${ToolList.tool_exec}'
								,'${ToolList.tool_enable}') ">수정</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>




		</table>


	</div>


</body>
</html>
