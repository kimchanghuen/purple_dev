<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>




<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
</head>
<script type="text/javascript" src="../../resources/js/jquery-1.11.3.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.0.0/crypto-js.min.js"></script>


<style type="text/css">
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin: auto;
}

#center {
	position: absolute;
	top: 50%;
	left: 50%;
	width: 500px;
	height: auto;
	overflow: hidden;
	margin-top: -250px;
	margin-left: -250px;
	width: auto;
	height: auto;
}

button {
	margin: 3px;
	color: #333333;
	border: 1px solid #aaaaaa;
	border-radius: 3px;
	box-shadow: 1px 1px #888888;
	cursor: pointer;
}
</style>
<script>
	function getCookies(cookiename) {
		var a;

		var paramData = "cookiename=" + cookiename
		paramData = encodeURI(paramData);

		$.ajax({
			method : 'post',
			data : paramData,
			url : 'LoginCookieGet',
			async : false,
			success : function(data) {
				a = data["value"]
			},
			error : function(error) {
				return;
			}
		});

		return a;

	}

	function setCookie(value, cookieName) {

		var paramData = "user=" + value + "&cookieName=" + cookieName
		paramData = encodeURI(paramData);
		$.ajax({
			method : 'post',
			url : 'LoginCookie',
			data : paramData,
			success : function(data) {
			},
			error : function(error) {
				alert("실패")
				return;
			}
		});

	}

	function deleteCookie(cookieName) {
		var expireDate = new Date();
		expireDate.setDate(expireDate.getDate() + 1); //어제날짜를 쿠키 소멸날짜로 설정
		document.cookie = cookieName + "= " + "; expires="
				+ expireDate.toGMTString();
	}

	$(document).ready(function() {

		var userInputId = getCookies("userInputId");
		var userInputPw = getCookies("userInputPw");

		$("input[name='id']").val(userInputId);
		$("input[name='pw']").val(userInputPw);

		if ($("input[name='pw']").val() != "") {
			$("#remember").attr("checked", true);
		}
		if ($("input[name='id']").val() != "") {
			$("#remember").attr("checked", true);
		}

		$("#remember").change(function() {
			if ($("#remember").is(":checked")) {

				var userInputId = $("input[name='id']").val();
				var userInputPw = $("input[name='pw']").val();

				setCookie(userInputId, 'userInputId');
				setCookie(userInputPw, 'userInputPw');

			} else {
				deleteCookie("userInputId");
				deleteCookie("userInputPw");

			}
		});

		$("input[name='id']").keyup(function() {
			if ($("#remember").is(":checked")) {
				var userInputId = $("input[name='id']").val();
				setCookie(userInputId, 'userInputId');
			}
		});

		$("input[name='pw']").keyup(function() {
			if ($("#remember").is(":checked")) {
				var userInputPw = $("input[name='pw']").val();
				setCookie(userInputPw, 'userInputPw');
			}
		});
	});
</script>

<body bgcolor="#EFEFEF">
	<div id="center">
		<%
			String ip = request.getHeader("X-Forwarded-For");
			System.out.println("ip : " + ip);
			if (ip == null) {
				ip = request.getHeader("Proxy-Client-IP");
				System.out.println(" >>>> Proxy-Client-IP : " + ip);
			}
			if (ip == null) {
				ip = request.getHeader("WL-Proxy-Client-IP"); // 웹로직
				System.out.println(" >>>> WL-Proxy-Client-IP : " + ip);
			}
			if (ip == null) {
				ip = request.getHeader("HTTP_CLIENT_IP");
				System.out.println(" >>>> HTTP_CLIENT_IP : " + ip);
			}
			if (ip == null) {
				ip = request.getHeader("HTTP_X_FORWARDED_FOR");
				System.out.println(" >>>> HTTP_X_FORWARDED_FOR : " + ip);
			}
			if (ip == null) {
				ip = request.getRemoteAddr();
				System.out.println(" ip null : " + ip);
			}

			String clientIP = ip;

			// clientIP = "115.92.104.5";

			String ip1 = "112.222.251.204";
			String ip2 = "115.92.104";
			String ip3 = "172.20.50.9";
			String ip4 = "112.222.251.117";
			String ip5 = "112.222.251.240";
			String ip6 = "112.222.251.201";

			System.out.println("ip : " + clientIP);

			// ip주소 115.92.104.x 체크
			if (clientIP.contains("115")) {
				//   	String[] tmpIP = clientIP.split("\\.");
				// 	if ( tmpIP[0].contains("115") && tmpIP[1].contains("92") && tmpIP[2].contains("104") ) {

				//	} else {
				// blank 로 이동
				//	response.sendRedirect("/blank");
				//return;
				//}
			}
			// ip주소가 115.92.104.x / 112.222.251.204 / 172.20.50.9 가 아니면 api/kind로 가도록 하기
			else if (clientIP.matches(ip1)) {
				// ip1 = "112.222.251.204";
			} else if (clientIP.matches(ip3)) {
				// ip3 = "172.20.50.9";
			} else if (clientIP.matches(ip4)) {
				// ip4 = "112.222.251.117";
			} else if (clientIP.matches(ip5)) {
				// ip5 = "112.222.251.240";
			} else if (clientIP.matches(ip6)) {
				// ip5 = "112.222.251.201";
				//   }else {
				// 	response.sendRedirect("/blank");
				//	return;
			}

			request.setCharacterEncoding("utf-8");

			if (request.getParameter("error") == null) {
		%>
		<div>
			<img src="../../../images/login.png" width="auto" height="auto" />
		</div>
		<%
			} else {
		%>
		<script>
			alert("아이디와 비밀번호를 다시 확인해주세요.");
		</script>
		<div>
			<img src="../../../images/login.png" width="auto" height="auto" />
		</div>
		<%
			}
		%>
		<form action="/Login/loginCheck" method="post"
			style="margin: auto; width: 556px;" class="login=form">

			<table style="margin: auto; text-align: center; width: 150px;">
				<tr>
					<td><input name="id" type="text" Placeholder="  아이디" id="ids"
						style="width: 250px; height: 30px; font-size: 14px"></td>
				</tr>
				<tr>
					<td><input name="pw" type="password" Placeholder="  패스워드"
						style="width: 250px; height: 30px; font-size: 14px"></td>
				</tr>
				<tr>

					<td><input id="remember" type="checkbox"
						style="float: left; margin-top: 8px;">
						<div style="float: left; margin-top: 4px;">자동 로그인</div> <input
						type="submit" value="로그인"
						style="width: 65px; height: 30px; font-size: 14px; float: right;">
					</td>
				</tr>

			</table>

		</form>

	</div>
</body>
</html>