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
	// 조회 테이블 컬럼명
	var tableHdr = [ '코드', '코드명', '버전', '구분', '수정일자', '수정' ]; // 4개 컬럼

	// function pageMove(idx, code, name, part, type, filename, version, exec, etc, enable, d_etc_type, d_etc_module, d_etc_name, d_etc_uninst )
	function pageMove(idx, code) {
		var f = document.param; //폼 name

		f.d_idx.value = idx;
		f.d_code.value = code;
		/*
		f.d_name.value = name;
		f.d_part.value = part;
		f.d_type.value = type;
		f.d_filename.value = filename;
		f.d_version.value = version;
		f.d_exec.value = exec;
		f.d_etc.value = etc;
		f.d_enable.value = enable;
		f.d_etc_type.value = d_etc_type;
		f.d_etc_module.value = d_etc_module;
		f.d_etc_name.value = d_etc_name;
		f.d_etc_uninst.value = d_etc_uninst;
		 */
		f.action = "/Driver/DriverUpdate";
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

		serchBtnClick();

	});

	// 데이터 조회 function 
	function serchBtnClick() {
		var type = document.getElementById('type');
		var type_value = type.options[type.selectedIndex].value; // 구분 코드값

		var paramText = "type_value=" + type_value

		$.ajax({
			url : "/Driver/serchInDriverPage",
			data : paramText,
			type : 'post',
			async : false,
			success : function(data) {

				$("#titleList>tbody").remove();

				var datas = "";
				for (var i = 0; i < data.length; i++) {
			
					datas += "<tr style='height:29px';>";
					datas += "<td>" + data[i]['d_code'] + "</td>";
					datas += "<td>" + data[i]['d_name'] + "</td>";
					datas += "<td>" + data[i]['d_version'] + "</td>";
					datas += "<td>" + data[i]['t_name'] + "</td>";
					datas += "<td>" + data[i]['d_update'] + "</td>";
					datas += '<td width="60"><button type="button" onclick="pageMove('+data[i]['d_idx']
					        +",'"+data[i]['d_code']+"'"
							+",'"+data[i]['d_name']+"'"
							+",'"+data[i]['d_part']+"'"
							+",'"+data[i]['d_type']+"'"
							+",'"+data[i]['d_filename']+"'"
							+",'"+data[i]['d_version']+"'"
							+",'"+data[i]['d_exec']+"'"
							+",'"+data[i]['d_etc']+"'"
							+",'"+data[i]['d_enable']+"'"
							+",'"+data[i]['d_etc_uninst']+"'"
							+')">수정</button></td>';
					datas += "</tr>"

				}
				
				$('#titleList').append(datas);
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});
	}
</script>
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
				response.sendRedirect("/LoginMain");
			}
		} catch (Exception e) {
			System.out.println("error : " + e.toString());
		}
		// ------------------------------------------------------
	%>
	<form name="param">
		<input type="hidden" name="d_idx"> <input type="hidden"
			name="d_code"> <input type="hidden" name="d_name"> <input
			type="hidden" name="d_part"> <input type="hidden"
			name="d_type"> <input type="hidden" name="d_filename">
		<input type="hidden" name="d_version"> <input type="hidden"
			name="d_exec"> <input type="hidden" name="d_etc"> <input
			type="hidden" name="d_enable"> <input type="hidden"
			name="d_etc_type"> <input type="hidden" name="d_etc_module">
		<input type="hidden" name="d_etc_name"> <input type="hidden"
			name="d_etc_uninst">
	</form>

	<div id="dataField"
		style="width: 870px; text-align: center; margin: auto;">

		<!-- 구분 콤보박스 추가 -->
		<label>구분 :</label> <select class="type" id="type"
			onchange="serchBtnClick()">
			<option selected="selected" value="none">-- 구분 --</option>
			<%
				try {
					Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
					DBManager db = new DBManager();

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

		<button type="button" onclick="location.href='/Driver/Driverinsert' "
			style="margin-left: 590px;">추가하기</button>
		<br>


		<!--  조회 테이블 생성 -->
		<table border='1'
			style="text-align: center; border-style: line; width: 850px;"
			cellpadding=0 cellspacing=0 id="titleList">
			<thead>
				<script>
					document.write('<th width="70" >' + tableHdr[0]
							+ ' <span id="sort_0"></span> </th>'); // code 
					document.write('<th width="230" >' + tableHdr[1]
							+ ' <span id="sort_1"></span> </th>'); // name
					document.write('<th width="90" >' + tableHdr[2]
							+ ' <span id="sort_2"></span> </th>'); // VERSION
					document.write('<th width="90" >' + tableHdr[3]
							+ ' <span id="sort_3"></span> </th>'); // TYPE
					document.write('<th width="180" >' + tableHdr[4]
							+ ' <span id="sort_4"></span> </th>'); // 수정일자
					document.write('<th width="70" >' + tableHdr[5]
							+ ' <span id="sort_5"></span> </th>'); // 수정
				</script>
			</thead>

		</table>


		<br>
		<button type="button" onclick="location.href='/Driver/Driverinsert' "
			style="margin-left: 755px;">추가하기</button>

	</div>

</body>
</html>
