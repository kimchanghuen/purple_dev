<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
 
<%@ page import="java.io.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
 
 <!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title> </title>
</head>
<body>

<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="fileName_var" value="${fileName}"/>

<%

	String strFileName =  (String)pageContext.getAttribute("fileName_var");
	strFileName = strFileName.trim();
	
	System.out.println("strFileName : " + strFileName);

    response.setContentType("application/octet-stream");

    
 	//파일이 저장될 경로.
 	// String realPath = "/media/Driver/";
 	String localPath = System.getProperty("user.dir");
	   
	String realPath = localPath + "/drivers/";

 	//파일 이름이 파라미터로 넘어오지 않으면 리다이렉트 시킨다.
 	if ( strFileName==null || "".equals(strFileName) ) {

 		// response.sendRedirect("/redirect.jsp");
 		out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
 		
 		System.out.println("파일이름이 없습니다. " );

 	} else {

 		// 파라미터로 받은 파일 이름.
 		String requestFileNameAndPath = strFileName;
 		// String requestFileNameAndPath = "375.70-desktop-win8-win7-64bit-international-whql.zip";
 		requestFileNameAndPath = requestFileNameAndPath.replace("/", "");
 		System.out.println("파일이름 : " + requestFileNameAndPath);

 		// 서버에서 파일찾기 위해 필요한 파일이름(경로를 포함하고 있음)
 		// 한글 이름의 파일도 찾을 수 있도록 하기 위해서 문자셋 지정해서 한글로 바꾼다.
 		// String UTF8FileNameAndPath = new String(requestFileNameAndPath.getBytes("8859_1"), "UTF-8");
 		String UTF8FileNameAndPath = new String(requestFileNameAndPath.getBytes("ISO-8859-1"), "UTF-8");

 		// 파일이름에서 path는 잘라내고 파일명만 추출한다.
 		String UTF8FileName = UTF8FileNameAndPath.substring(UTF8FileNameAndPath.lastIndexOf("/") + 1)
 				.substring(UTF8FileNameAndPath.lastIndexOf(File.separator) + 1);

 		// 브라우저가 IE인지 확인할 플래그.
 		boolean MSIE = request.getHeader("user-agent").indexOf("MSIE") != -1;
 		
 		System.out.println("MSIE : " + MSIE);

 		// 파일 다운로드 시 받을 때 저장될 파일명
 		String fileNameToSave = "";

 		// IE,FF 각각 다르게 파일이름을 적용해서 구분해주어야 한다.
 		if (MSIE) {
 			// 브라우저가 IE일 경우 저장될 파일 이름
 			// 공백이 '+'로 인코딩된것을 다시 공백으로 바꿔준다.
 			// fileNameToSave = URLEncoder.encode(UTF8FileName, "UTF8").replaceAll("\\+", " ");
 			fileNameToSave = URLEncoder.encode(UTF8FileName, "UTF8").replaceAll("\\+", "%20");
 		} else {
 			// 브라우저가 IE가 아닐 경우 저장될 파일 이름
 			// fileNameToSave = new String(UTF8FileName.getBytes("UTF-8"), "8859_1");
 			fileNameToSave = new String(UTF8FileName.getBytes("UTF-8"), "ISO-8859-1");
 		}
 		// 파일패스 및 파일명을 지정한다.
 		//  String filePathAndName = pageContext.getServletContext().getRealPath("/") + UTF8FileNameAndPath;
 		// String filePathAndName = realPath + UTF8FileNameAndPath;
 		
 		String filePathAndName = realPath + strFileName;
 		
 		System.out.println("파일경로 : " + filePathAndName);
 		
 		File file = new File(filePathAndName);
 		
 		// 버퍼 크기 설정
 		byte bytestream[] = new byte[2048000];

 		// response out에 파일 내용을 출력한다.
 		if (file.isFile() && file.length() > 0) {
 			 			
 			try {
 				
 				out.clear();
 				out = pageContext.pushBody();
 				 				
 				// response.reset();
 				// response.setContentType("application/octet-stream");
 				 				
 				// String Encoding = new String(requestFileNameAndPath.getBytes("UTF-8"), "8859_1");
 				String Encoding = new String(requestFileNameAndPath.getBytes("UTF-8"), "ISO-8859-1");
 				response.setHeader("Content-Disposition", "attachment; filename=\"" + fileNameToSave + "\";");
 				response.setHeader("Content-Length", String.valueOf((int)file.length()));
 				
 				FileInputStream is = new FileInputStream(filePathAndName);
 				System.out.println(" is : " + is) ;
 				ServletOutputStream sos = response.getOutputStream();

 				
 				int numRead;
 				
 				while((numRead = is.read(bytestream,0,bytestream.length)) != -1){
 					sos.write(bytestream,0,numRead);
 				}
 				
 				sos.flush();
 				sos.close();
 				is.close();
 				
 			} catch(Exception e) {
 				System.out.println(" 에러 : " + e.toString());
 			}
 			
 		} else {
 			
 			System.out.println("파일이 없습니다,");
 			
 		}
 	}
 %>
 
 </body>
</html>