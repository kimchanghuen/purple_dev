<%@ page language="java" contentType="text/html; charset=UTF-8;"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
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
	// 로그인 체크 함수
	function deleteLink(l_idx, obj) {

		var checker = confirm("정말 해당 코드를 삭제하시겠습니까?");

		if (checker) {

			var link_idx = l_idx;

			var paramText = "l_idx=" + link_idx

			$.ajax({
				url : "/Link/LinkDelete",
				data : paramText,
				async : false,
				type : 'post',
				success : function(data) {

					Linkserch();

					alert("삭제가 완료되었습니다.");
				},
				error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:"
							+ request.responseText + "\n" + "error:" + error);
				}
			});

		} else if (!checker) {
			alert("삭제를 취소하셨습니다.");
			return;
		}

	}

	// 다중팝업 만들기 위한 변수
	var newName, n = 0;

	function newWindow(value) {
		// n = n + 1;
		n = Math.floor(Math.random() * 99999999) + 1; // 난수 발생
		newName = value + n;
	}

	// function pageMove(idx, code, name, part, type, filename, version, exec, etc, enable, d_etc_type, d_etc_module, d_etc_name, d_etc_uninst) {
	function pageMove(idx, code) {

		// paramSet();	 

		var form = document.createElement("form");

		form.setAttribute("charset", "UTF-8");
		form.setAttribute("method", "Post"); // Get 또는 Post 입력
		form.setAttribute("action", "/Driver/DriverUpdate");

		var hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_idx");
		hiddenField.setAttribute("value", idx);
		form.appendChild(hiddenField);

		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_code");
		hiddenField.setAttribute("value", code);
		form.appendChild(hiddenField);

		/*
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_name");
		hiddenField.setAttribute("value", name);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_part");
		hiddenField.setAttribute("value", part);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_type");
		hiddenField.setAttribute("value", type);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_filename");
		hiddenField.setAttribute("value", filename);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_version");
		hiddenField.setAttribute("value", version);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_exec");
		hiddenField.setAttribute("value", exec);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_etc");
		hiddenField.setAttribute("value", etc);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_enable");
		hiddenField.setAttribute("value", enable);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_etc_type");
		hiddenField.setAttribute("value", d_etc_type);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_etc_module");
		hiddenField.setAttribute("value", d_etc_module);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_etc_name");
		hiddenField.setAttribute("value", d_etc_name);	 
		form.appendChild(hiddenField);
		
		hiddenField = document.createElement("input");
		hiddenField.setAttribute("type", "hidden");
		hiddenField.setAttribute("name", "d_etc_uninst");
		hiddenField.setAttribute("value", d_etc_uninst);	 
		form.appendChild(hiddenField);
		
		 */
		// window open => a herf 로 변경하기
		// var title = "param";
		// var status = "width=600, height=600"; // 설정시 팝업
		newWindow("param");

		window.open("about:blank", newName);
		// form.target = title;
		form.target = newName;

		document.body.appendChild(form);

		form.submit();

	}

	function loginChkLink() {

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

	// 팝업창
	var winPop

	// 분류 콤보박스 변경시 
	function Linkkind_change() {
		loginChkLink();
		$("#titleListLink>tbody").remove();

		var kind = $(".Linkkind").val();

		console.log("kind 확인 : " + kind);

		// 테이블 초기화

		$("#type option:eq(0)").prop("selected", true); // 구분 콤보박스 첫번째 인덱스 선택

		$.ajax({
			type : "GET",
			url : "/Link/combomodel",
			data : "kind_id=" + kind,
			cache : false,
			success : function(response) {
				$(".Linkmodel").html(response);
				Linkserch();
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});

	}

	// 찾기버튼 클릭시
	function LinkserchBtnClick() {

		// 테이블 초기화

		Linkserch();
	}

	// 데이터 조회 function 
	function Linkserch() {

		$("#titleListLink>tbody").remove();
		var kind = document.getElementById('Linkkind');
		var kind_value = kind.options[kind.selectedIndex].value; // 분류 코드값

		var model = document.getElementById('Linkmodel');
		var model_value = model.options[model.selectedIndex].value; // 모델 코드값

		var type = document.getElementById('type');
		var type_value = type.options[type.selectedIndex].value; // 구분 코드값

		var driver = document.getElementById('Linkdriver');
		var driver_value = driver.options[driver.selectedIndex].value; // 드라이버 코드값

		console.log("머다냐")
		var paramText = "kind_value=" + kind_value + "&model_value="
				+ model_value + "&type_value=" + type_value + "&driver_value="
				+ driver_value

		$
				.ajax({
					url : "/Link/serch_LinkData",
					data : paramText,
					type : 'post',
					cache : false,
					success : function(data) {

						console.log('조회버튼 클릭s')

						var datas = "";
						for (var i = 0; i < data.length; i++) {

							datas += "<tr style='height:29px';>";
							datas += "<td>" + data[i]['l_kind'] + "</td>";
							datas += "<td>" + data[i]['l_model'] + "</td>";
							datas += "<td>" + data[i]['l_driver'] + "</td>";
							datas += "<td>" + data[i]['l_type'] + "</td>";
							datas += "<td>" + data[i]['l_update'] + "</td>";
							datas += '<td width="60"><button type="button" onclick="pageMove('
									+ data[i]['d_idx']
									+ ",'"
									+ data[i]['d_code']
									+ "'"
									+ ')">수정</button></td>';

							datas += '<td width="60"><button type="button" onclick="deleteLink('
									+ data[i]['l_idx'] + ')">삭제</button></td>';
							datas += "</tr>"

						}

						$("#titleListLink").append(datas);
					},
					error : function(request, status, error) {
						alert("code:" + request.status + "\n" + "message:"
								+ request.responseText + "\n" + "error:"
								+ error);
					}
				});

	}

	// 다중팝업 만들기 위한 변수
	var newName, n = 0;

	function newWindow(value) {
		n = n + 1;
		newName = value + n;
	}

	// 다중팝업 만들기 위한 변수
	var newName, n = 0;

	function newWindow(value) {
		// n = n + 1;
		n = Math.floor(Math.random() * 99999999) + 1; // 난수 발생
		newName = value + n;
	}

	// 자식창 팜업조회
	function LinkserchDriverPop() {
		loginChkLink();

		var kind = document.getElementById('Linkkind');
		var kind_value = kind.options[kind.selectedIndex].value; // 분류 코드값

		if (kind_value == 'none') {
			alert("선택한 분류코드를 다시 확인해주세요.");
			return;
		}

		var model = document.getElementById('Linkmodel');
		var model_value = model.options[model.selectedIndex].value; // 모델 코드값

		if (model_value == 'none') {
			alert("선택한 모델코드를 다시 확인해주세요.");
			return;
		}

		var f = document.param;

		newWindow("SubLinkPop");

		winPop = window.open("", newName,
				"width=570, height=350, resizable = no, scrollbars = no");

		console.log("kind_value : " + kind_value + " &model_value : "
				+ model_value);

		f.kind.value = kind_value;
		f.model.value = model_value;

		f.action = "/Link/serch_SubLinkData";//이동할 페이지
		// f.target = newName; //window,open()의 두번째 인수와 같아야 하며 필수다.
		f.target = newName; //window,open()의 두번째 인수와 같아야 하며 필수다.
		f.method = "post";//POST방식
		f.submit();

	}

	//테이블 헤더 클릭시 자동정렬
	var sortOrder = true;

	function SortTable(table, n) {
		for (var hdrnum = 0; hdrnum < 7; ++hdrnum) {
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
		Linkserch();
	});
</script>
</head>
<body>

	<!-- 팝업창에게 파라미터를 넘겨주기 위한 form -->
	<form name="param">
		<input type="hidden" name="kind"> <input type="hidden"
			name="model">
	</form>

	<div id="top_header">
		<jsp:include page="../Datacontroller/NewtopMenu.jsp" flush="false" />
	</div>


	<div id="dataField"
		style="width: auto; text-align: center; margin: auto;">


		<label>분류 : </label> <select class="Linkkind"
			onchange="Linkkind_change()" id="Linkkind" name="kind_value">
			<option selected="selected" value="none">-- 분류 --</option>

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
		</select> <label>모델 :</label> <select class="Linkmodel" id="Linkmodel"
			name="model_value" onchange="LinkserchBtnClick()">
			<option selected="selected" value="none">-- 모델 --</option>
		</select>

		<!-- 구분 콤보박스 추가 -->
		<label>구분 :</label> <select class="type" id="type"
			onchange="LinkserchBtnClick()">
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

		</select> <label style="display: none">드라이버 :</label> <select
			class="Linkdriver" id="Linkdriver" onchange="LinkserchBtnClick()"
			style="display: none" disabled>
			<option selected="selected" value="none">-- 드라이버 --</option>
			<%
				try {
					Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

					Connection con = db.dbConn();

					PreparedStatement pstmt = null; //create statement

					pstmt = con.prepareStatement("SELECT d_code, d_name FROM DRV_DRIVERS WHERE d_enable = '1' "); //sql select query
					ResultSet rs = pstmt.executeQuery(); //execute query and set in resultset object rs.

					while (rs.next()) {
			%>
			<option value="<%=rs.getString("d_code")%>">
				<%=rs.getString("d_name")%>
			</option>
			<%
				}

					con.close(); //close connection
				} catch (Exception e) {
					out.println(e);
				}
			%>

		</select>



		<button type='BUTTON' value=' 조회 ' onclick='LinkserchBtnClick()'
			style="margin-left: 400px; width: 70px;">조회</button>
		<button type='BUTTON' value=' 추가 ' onclick='LinkserchDriverPop()'
			style="width: 70px;">추가</button>

		<!-- 줄바꿈 -->
		<br> <br>


		<!--  조회 테이블 생성 -->
		<table border='1'
			style="text-align: center; border-style: line; margin: auto;"
			cellpadding=0 cellspacing=0 id="titleListLink" name="titleListLink">
			<thead>
				<th width="70">분류 <span id="sort_0"></span>
				</th>
				<th width="170">모델 <span id="sort_1"></span>
				</th>
				<th width="230">드라이버 <span id="sort_2"></span>
				</th>
				<th width="140">구분 <span id="sort_3"></span>
				</th>
				<th width="180">수정일자 <span id="sort_4"></span>
				</th>
				<th width="180">드라이버 정보보기 <span id="sort_5"></span>
				</th>
				<th width="70">삭제 <span id="sort_6"></span>
				</th>
			</thead>
			<tbody>
			</tbody>
		</table>


	</div>

</body>
</html>
