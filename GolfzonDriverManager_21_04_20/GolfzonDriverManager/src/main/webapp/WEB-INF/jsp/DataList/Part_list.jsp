<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
var tableHdr = ['코드', '코드명', '수정일자','수정' ]; // 4개 컬럼 
	// 각 데이터 클릭시
	function part_change(code, name, enable) {

		var f = document.param; //폼 name

		f.p_code.value = code;
		f.p_name.value = name;
		f.p_enable.value = enable;

		f.action = "/Part/PartUpdate";//이동할 페이지
		f.method = "post";//POST방식
		f.submit();
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
	<div id="header">
		<jsp:include page="../Datacontroller/NewtopMenu_sub3.jsp"
			flush="false" />
	</div>

	<form name="param">
		<input type="hidden" name="p_idx"> <input type="hidden"
			name="p_code"> <input type="hidden" name="p_name"> <input
			type="hidden" name="p_enable">
	</form>

	<div id="dataField"
		style="width: 870px; text-align: center; margin: auto;">

		<button type="button" onclick="location.href='/Part/Partinsert' "
			style="margin-left: 785px;">추가하기</button>
		<br>

		<!--  조회 테이블 생성 -->
		<table border='1'
			style="text-align: center; border-style: line; width: 850px;"
			cellpadding=0 cellspacing=0 id="titleList">
			<thead>
				<script>
  	
  	document.write( '<th width="70" >' + tableHdr[0] + ' <span id="sort_0"></span> </th>' );  // code 
  	document.write( '<th width="100" >' + tableHdr[1] + ' <span id="sort_1"></span> </th>' ); // name
  	document.write( '<th width="180" >' + tableHdr[2] + ' <span id="sort_2"></span> </th>' );  // 수정일자
  	document.write( '<th width="70" >' + tableHdr[3] + ' <span id="sort_3"></span> </th>' ); // 수정
  	
  	</script>
			</thead>

			<tbody>
				<c:forEach items="${list}" var="PartList">
					<tr>

						<td><c:out value="${PartList.p_code}" /></td>
						<td><c:out value="${PartList.p_name}" /></td>
						<td><fmt:formatDate value="${PartList.p_update}"
								pattern="yyyy-MM-dd" /></td>

						<td width="70">
							<button type="button"
								onclick="part_change('${PartList.p_code}'
								,'${PartList.strPname}'
								,'${PartList.p_enable}'
								) ">수정</button>
						</td>
					</tr>
				</c:forEach>

			</tbody>


		</table>


		<br>
		<button type="button" onclick="location.href='/Part/Partinsert' "
			style="margin-left: 785px;">추가하기</button>
		<br> <br>
	</div>

</body>
</html>
