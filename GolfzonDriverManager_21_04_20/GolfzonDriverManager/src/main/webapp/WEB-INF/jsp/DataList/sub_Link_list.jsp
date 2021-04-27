<%@ page language="java" contentType="text/html; charset=UTF-8;"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.sql.*"%>
<%@page import="com.Golfzon.DBManager"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title></title>

<script type="text/javascript"
	src="../../../resources/js/jquery-1.11.3.js"> </script>

<script type="text/javascript">

var click = true;

window.onload = function () {
	
}

function reloadPop(){
	location.reload();
}

// 데이터 추가 function 
function insertBtnClink(Linkd_code)
{
	 if (click) {
		 
		 click = !click;
		 
		 var kind = opener.document.getElementById('Linkkind');
		 var kind_value = kind.options[kind.selectedIndex].value; // 분류 코드값
		 
		 if (kind_value == 'none') {
			 alert("선택한 분류코드를 다시 확인해주세요.");
			 return;
		 }
			 
		 var model = opener.document.getElementById('Linkmodel');
		 var model_value = model.options[model.selectedIndex].value; // 모델 코드값
		 
		 if (model_value == 'none') {
			 alert("선택한 모델코드를 다시 확인해주세요.");
			 return;
		 }
		 
		 var driver_value = Linkd_code;
		 	 
		 if ( driver_value != 'none' ) { // driver_value 가 null이 아닐 시
		    var paramText = "kind_value="+ kind_value
		    + "&model_value="+ model_value
		    + "&driver_value="+ driver_value
		
		    $.ajax({
		        url : "/Link/insert_LinkData",
		        data : paramText,
		        async : false,
		        type : 'post',
		        success : function(data){
		        	opener.Linkserch();
		        	window.close();
		        },
		        error:function(request,status,error){
		            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		            return;
		        }
		    });
		 } else {
			 alert("추가할 드라이버가 없습니다.\n선택한 드라이버를 확인하여 주십시오.");
			 return;
		 }
		 
		 setTimeout(function(){
			 	click = true;
			 	}, 2000)
	  }
}


function closeClick()
{
	self.close();	// 자기자신 창닫기
}



//테이블 헤더 클릭시 자동정렬
var sortOrder = true;

function SortTable( table, n )
{
	  // 헤더 span 초기화
	  for (var hdrnum=0; hdrnum<4; ++hdrnum ){
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
} );


</script>

<link rel="stylesheet" type="text/css" href="../../../css/style.css">

</head>
<body bgcolor="#EFEFEF" style="text-align: left;">

	<br>
	<b><font size="5" color="gray">추가 드라이버</font></b>
	<br>

	<button type='BUTTON' onclick='closeClick()'
		style="width: 70px; margin-left: 460px;">창닫기</button>
	<br>

	<div id="dataField" style="max-height: 200px; text-align: center;">

		<!--  조회 테이블 생성 -->
		<table border='1'
			style="text-align: center; border-style: line; width: 530px;"
			cellpadding=0 cellspacing=0 id="titleList">
			<thead>
				<th width="70px">코드 <span id="sort_0"></span>
				</th>
				<th>NAME <span id="sort_1"></span>
				</th>
				<th width="100px">구분 <span id="sort_2"></span>
				</th>
				<th width="60px">추가 <span id="sort_3"></span>
				</th>
			</thead>

			<tbody>
				<c:forEach items="${list}" var="subLinklist">
					<tr>
						<td><c:out value="${subLinklist.d_code}" /></td>
						<td><c:out value="${subLinklist.d_name}" /></td>
						<td><c:out value="${subLinklist.t_name}" /></td>
						<td> <button type="button" onclick="insertBtnClink('${subLinklist.d_code}')">추가</button></td>
	
					</tr>
				</c:forEach>
			</tbody>


		</table>

	</div>
	<br>
	<button type='BUTTON' onclick='closeClick()'
		style="width: 70px; margin-left: 460px;">창닫기</button>

</body>
</html>