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
	var tableHdr = [ '대상', '수정내용', '상세내용', '실행시간' ]; // 4개 컬럼

	// 로그인 체크 함수
	function loginChk() {

		$.ajax({
			type : "post",
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

	// 찾기버튼 클릭시
	function serchBtnClick() {
		

		loginChk();

		serchLog();
	}

	// 데이터 조회 function 
	function serchLog() {
		// 대상 
		
		$("#titleList>tbody").remove();
		var table = document.getElementById('table');
		var table_value = table.options[table.selectedIndex].value;

		// 수정내용 
		var type = document.getElementById('type');
		var type_value = type.options[type.selectedIndex].value;

		// 내용
		var detail = document.getElementById('detail').value;

		// 조회시작일자
		var startDate = document.getElementById('startdate').value;

		// 조회종료일자
		var endDate = document.getElementById('enddate').value;

		// 날짜체크
		if (startDate > endDate) {
			alert("입력하신 날짜를 확인해주세요.");
			return false;
		}
		var paramText = "table_value=" + table_value + "&detail=" + detail
				+ "&startDate=" + startDate + "&endDate=" + endDate
				+ "&type_value=" + type_value

		paramText = encodeURI(paramText);

		$
				.ajax({
					url : "/Log/serch_log",
					data : paramText,
					type : 'post',
					async : false,
					success : function(data) {

						console.log(data.length)

						//HashMap 으로 넘겨봤음
						console.log("데이터 전송 성공")
						var datas = "";
						for (var i = 0; i < data.length; i++) {

							datas += "<tr style='height:30px';>";
							datas += "<td>" + data[i]['strTable'] + "</td>";
							datas += "<td>" + data[i]['strType'] + "</td>";
							datas += "<td style='text-align: left; text-overflow: ellipsis; overflow: hidden;'>"
									+ data[i]['log_deatail'] + "</td>";
							datas += "<td>" + data[i]['log_datetime'] + "</td>";
							datas += "</tr>"
							

						}

						$("#titleList").append(datas);

					},
					error : function(request, status, error) {
						alert("code:" + request.status + "\n" + "message:"
								+ request.responseText + "\n" + "error:"
								+ error);
					}
				});

	}

	// 열리자마자 조회
	$(document).ready(function() {
		serchLog();
	});

	function logout() {
		location.href = "/logOut";
	}

	// 엔터 입력시
	function Enter_Check() {
		// 엔터키의 코드는 13입니다.
		if (event.keyCode == 13) {
			serchBtnClick(); // 실행할 이벤트
		}
	}

	/* 헤더 클릭시 sort 주석처리
	//테이블 헤더 클릭시 자동정렬
	var sortOrder = true;
	
	function SortTable( table, n )
	{
	  // 헤더 span 초기화
	  for (var hdrnum=0; hdrnum<tableHdr.length; ++hdrnum ){
	    	document.getElementById('sort_'+hdrnum).innerHTML = "";
	  }
	  if ( sortOrder ) { // 오름차순 
		  document.getElementById('sort_'+n).innerHTML = "▲";
	  } else { // 내림차순
		  document.getElementById('sort_'+n).innerHTML = "▼";
	  } 
	  
	  // table 에 tbody tag 가 반드시 존재한다고 가정한다.
	   var tbody = table.tBodies[0];
	   var rows = tbody.getElementsByTagName( "tr" );
	
	   // 배열로 생성한 후, 배열로 정렬한다.
	   rows = Array.prototype.slice.call( rows, 0 );
	
	   rows.sort( function( row1, row2 )
	   {
		    var cell1 = row1.getElementsByTagName("td")[n];
		    var cell2 = row2.getElementsByTagName("td")[n];
		    var value1 = cell1.textContent || cell1.innerText;
		    var value2 = cell2.textContent || cell2.innerText;
		    
		    if ( sortOrder ) { // 오름차순
			    if( value1 < value2 ) return -1;
			    if( value1 > value2 ) return 1;
		    } else { // 내림차순
		    	if( value1 < value2 ) return 1;
			    if( value1 > value2 ) return -1;
		    } 
		    
		    return 0;
	   });

	   // 정렬된 배열로 row 를 다시 저장한다. 문서에 이미 존재하는 node 는 삽입하면 해당 node 는 자동으로 제거되고 새 위치에 저장된다.
	   for( var i = 0; i < rows.length; ++i )
	   {
	      tbody.appendChild( rows[i] );
	   }
	}

	$(document).ready( function()
	{
	  tableOrderSetting();
	} );
	
	function tableOrderSetting() {
	  console.log("테이블 헤더 세팅");
	  
	  // 모든 table 헤더에 클릭 이벤트를 설정한다.
	   var tables = document.getElementsByTagName("table");
	   
	   console.log(tables);
	   
	   for( var i = 0; i < tables.length; ++i )
	   {
		    var headers = tables[i].getElementsByTagName("th");
		    for( var j = 0; j < headers.length; ++j )
		    {
		     // 지역 유효범위에 생성할 중첩 함수
		     ( function(table,n)
		     {
		        headers[j].onclick = function() {
		        	sortOrder = !sortOrder;
		       		SortTable( table, n )
		        };
		     } ( tables[i], j) );
	    }
	   }
	}

	 */
</script>

<link rel="stylesheet" type="text/css" href="../../css/style.css">

</head>

<body bgcolor="#EFEFEF">

	<div id="top_header">
		<jsp:include page="../jsp/Datacontroller/NewtopMenu.jsp" flush="false" />
	</div>

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
	%>


	<div
		style='display: -webkit-inline-box; margin-bottom: 3px; text-align: center;'>
		<label>대상 : </label> <select class="table" onchange="" id="table">
			<option selected="selected" value="none">-- 대상 --</option>
			<option value="DRV_NOTICE">공지사항</option>
			<option value="DRV_KIND">분류</option>
			<option value="DRV_MODEL">모델</option>
			<option value="DRV_PART">종류</option>
			<option value="DRV_TYPE">구분</option>
			<option value="DRV_DRIVERS">드라이버/소프트웨어</option>
			<option value="DRV_LINK">모델별 드라이버</option>
			<option value="DRV_TOOLS">툴 버전</option>
		</select> <label>수정내용 : </label> <select class="type" onchange="" id="type">
			<option selected="selected" value="none">-- 수정내용 --</option>
			<option value="I">신규</option>
			<option value="U">수정</option>
			<option value="D">삭제</option>
		</select> <label style="margin-left: 20px;">상세내용 : </label> <input type="text"
			id="detail" value=""
			style="width: 180px; vertical-align: text-bottom;"
			onkeydown="JavaScript:Enter_Check();"></input> <label
			style="margin-left: 20px;">검색일자 :</label> <input type='date'
			id='startdate' /> <label> ~ </label> <input type='date' id='enddate' />

		<script>
			// 최초 날짜 세팅
			var loadDt = new Date();
			document.getElementById('startdate').value = new Date(Date
					.parse(loadDt)
					- 7 * 1000 * 60 * 60 * 24).toISOString().substring(0, 10); // 일주일 전

			document.getElementById('enddate').value = new Date().toISOString()
					.substring(0, 10);
		</script>

		<button type="button" onclick="serchBtnClick()"
			style="margin-left: 30px; width: 70px;">조회</button>


	</div>


	<!-- 줄바꿈 -->
	<br>

	<div id="dataField">
		<!--  조회 테이블 생성 -->
		<table border='1'
			style="text-align: center; border-style: line; width: 1000px; table-layout: fixed;"
			cellpadding=0 cellspacing=0 id="titleList" name="titleList">
			<thead>
				<script>
					document.write('<th width="150" >' + tableHdr[0]
							+ ' <span id="sort_0"></span> </th>'); // 대상
					document.write('<th width="80" >' + tableHdr[1]
							+ ' <span id="sort_1"></span> </th>'); // 수정내용
					document.write('<th width="700" >' + tableHdr[2]
							+ ' <span id="sort_2"></span> </th>'); // 상세내용
					document.write('<th width="200" >' + tableHdr[3]
							+ ' <span id="sort_3"></span> </th>'); // 시간
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


