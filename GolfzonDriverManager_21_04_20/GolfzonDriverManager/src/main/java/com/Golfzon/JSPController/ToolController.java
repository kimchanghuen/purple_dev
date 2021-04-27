package com.Golfzon.JSPController;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.zip.CRC32;
import java.util.zip.Checksum;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.Golfzon.service.ToolService;

@Controller
@Component
@RequestMapping("/Tool/*")
public class ToolController {

	//리스트 부분  넣는부분 따로 만들고 엡데이트 부분 다만들어야함 
	ToolService toolservice;

	@RequestMapping(value = "/ToolList", method = {RequestMethod.GET, RequestMethod.POST})
	public String ToolList(Model model) throws Exception {

		toolservice =  new ToolService();
		model.addAttribute("list",toolservice.ToolList());

		return "DataList/Tool_List";
	}


	@RequestMapping(value = "/Toolinsert", method = {RequestMethod.GET, RequestMethod.POST})
	public String Toolinsert() throws Exception {

		return "DataList/Tool_insert";
	}


	@RequestMapping(value = "/fileCheck_TOOL/{file}", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String fileCheck_TOOL(ModelMap model
			, @PathVariable String file) {
		System.out.println("filename : " + file);

		//		String fileName = (String)pageContext.getAttribute("fileName");
		// fileName = "/media/Tools/"+fileName;
		String localPath = System.getProperty("user.dir");

		String path = localPath + "/Tools/";

		file = path+file;

		System.out.println("in ----- fileName : " + file);

		File fileChk = new File(file);
		System.out.println(fileChk);

		if (fileChk.exists()) {
			return "true";
		}else {
			return "false";
		}
	}


	@RequestMapping(value = "/ToolInsert_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public String ToolInsert_sql(	
			HttpServletRequest request
			,MultipartHttpServletRequest multi) throws Exception {

		System.out.println("==========");
		toolservice =  new ToolService();
		HashMap<String,String> paraMap = new HashMap<String,String>();

		System.out.println(multi.getFileNames());
		System.out.println("사용여부 : " + multi.getParameter("tool_code"));
		System.out.println("사용여부 : " + multi.getParameter("name"));
		System.out.println("사용여부 : " + multi.getParameter("enable"));
		System.out.println("사용여부 : " + multi.getParameter("version"));
		System.out.println("사용여부 : " + multi.getParameter("exec"));
		System.out.println("사용여부 : " + multi.getParameter("idx"));


		toolservice = new ToolService();


		paraMap.put("code", multi.getParameter("tool_code"));
		paraMap.put("name",multi.getParameter("name"));
		paraMap.put("version",multi.getParameter("version"));
		paraMap.put("enable",multi.getParameter("enable"));
		paraMap.put("exec", multi.getParameter("exec"));


		toolservice.ToolInsert_sql(paraMap);


		String tool_idx = multi.getParameter("idx");

		System.out.println("업로드 시작" + tool_idx);

		String localPath = System.getProperty("user.dir");

		String path = localPath + "/Tools/";

		String newFileName = ""; // 업로드 되는 파일명
		String strCRC32 = ""; // CRC32코드 
		String strNewFile = ""; // 새로 생성되는 경로+파일명

		File dir = new File(path);
		if(!dir.isDirectory()){
			dir.mkdir();
		}



		Iterator<String> files = multi.getFileNames();

		while(files.hasNext()){
			String uploadFile = files.next();

			MultipartFile mFile = multi.getFile(uploadFile);
			String fileName = mFile.getOriginalFilename();
			System.out.println("실제 파일 이름 : " +fileName);

			newFileName = fileName;

			try {
				mFile.transferTo(new File(path+newFileName));

				// CRC32 코드 가져오기
				strCRC32 = String.format("%08X", getCRC32Value(path+newFileName) );


				// 파일 사이즈 확인
				strNewFile = path+newFileName;

				File fileSize = new File(strNewFile);
				long size = fileSize.length();
				String strSize = Long.toString(size);


				//수정부분
				System.out.println("idx : " + tool_idx + " / crc32 : " + strCRC32 + " / size : " + strSize + " / fileName : " + newFileName);

				//para data 넘기기
				HashMap<String,String> paraMaps = new HashMap<String,String>();
				paraMaps.put("tool_idx",tool_idx);
				paraMaps.put("strCRC32",strCRC32);
				paraMaps.put("strSize",strSize);
				paraMaps.put("newFileName",newFileName);

				toolservice.FileUploadTool(paraMaps);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("업로드 실패 : " + e.toString());
				return "false";
			}
		}




		return "DataList/Tool_List";
	}
	@RequestMapping(value = "/FileUploadTool/{tool_idx}", method = {RequestMethod.GET, RequestMethod.POST})
	public String ToolfileUp(MultipartHttpServletRequest multi
			, @PathVariable String tool_idx 	                    
			) {
		System.out.println("업로드 시작" + tool_idx);
		toolservice =  new ToolService();



		// 저장 경로 설정
		// String root = multi.getSession().getServletContext().getRealPath("/");
		// root : C:\workspace\GolfzonDriverManager\src\main\webapp\
		// String path = root+"WEB-CONNTENT/uploadFile/";

		// 파일이 저장될 경로.
		// String path = "/media/Tools/";
		String localPath = System.getProperty("user.dir");

		String path = localPath + "/Tools/";

		String newFileName = ""; // 업로드 되는 파일명
		String strCRC32 = ""; // CRC32코드 
		String strNewFile = ""; // 새로 생성되는 경로+파일명

		File dir = new File(path);
		if(!dir.isDirectory()){
			dir.mkdir();
		}



		Iterator<String> files = multi.getFileNames();

		while(files.hasNext()){
			String uploadFile = files.next();

			MultipartFile mFile = multi.getFile(uploadFile);
			String fileName = mFile.getOriginalFilename();
			System.out.println("실제 파일 이름 : " +fileName);

			newFileName = fileName;

			try {
				mFile.transferTo(new File(path+newFileName));

				// CRC32 코드 가져오기
				strCRC32 = String.format("%08X", getCRC32Value(path+newFileName) );


				// 파일 사이즈 확인
				strNewFile = path+newFileName;

				File fileSize = new File(strNewFile);
				long size = fileSize.length();
				String strSize = Long.toString(size);


				//수정부분
				System.out.println("idx : " + tool_idx + " / crc32 : " + strCRC32 + " / size : " + strSize + " / fileName : " + newFileName);

				//para data 넘기기
				HashMap<String,String> paraMap = new HashMap<String,String>();
				paraMap.put("tool_idx",tool_idx);
				paraMap.put("strCRC32",strCRC32);
				paraMap.put("strSize",strSize);
				paraMap.put("newFileName",newFileName);

				toolservice.FileUploadTool(paraMap);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("업로드 실패 : " + e.toString());
				return "false";
			}
		}

		return "DataList/Tool_List";
	}

	@RequestMapping(value = "/ToolUpdate", method = {RequestMethod.GET, RequestMethod.POST})
	public String LinkUpdate() throws Exception {	   
		return "DataList/Tool_update";
	}
	@RequestMapping(value = "/ToolUpdate_sql", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String ToolUpdate_sql(ModelMap model
			, @RequestParam("tool_idx") String tool_idx
			, @RequestParam("tool_code") String tool_code
			, @RequestParam("tool_name") String tool_name
			, @RequestParam("tool_filename") String tool_filename
			, @RequestParam("tool_version") String tool_version
			, @RequestParam("tool_exec") String tool_exec
			, @RequestParam("tool_enable") String tool_enable
			) throws Exception {

		HashMap<String,String> paraMap = new HashMap<String,String>();
		toolservice =  new ToolService();
		paraMap.put("tool_idx",tool_idx);
		paraMap.put("tool_code",tool_code);
		paraMap.put("tool_name",tool_name);
		paraMap.put("tool_filename",tool_filename);
		paraMap.put("tool_version",tool_version);
		paraMap.put("tool_exec",tool_exec);
		paraMap.put("tool_enable",tool_enable);

		toolservice.ToolUpdate_sql(paraMap);


		System.out.println("tool_enable 이 안넘어오나 ? : " + tool_enable);

		return "DataList/Tool_List";
	}
	@RequestMapping(value = "/fileDelete_tool", method = {RequestMethod.GET, RequestMethod.POST})
	public String fileDelete_tool(ModelMap model
			, @RequestParam("tool_code") String tool_code
			, @RequestParam("tool_name") String tool_name 
			, @RequestParam("tool_filename") String tool_filename) throws Exception {

		System.out.println("파일제거 시작");

		// 파일 경로.
		// String path = "/media/Driver/";
		HashMap<String,String> paraMap = new HashMap<String,String>();

		paraMap.put("tool_code",tool_code);
		paraMap.put("tool_name",tool_name);



		String localPath = System.getProperty("user.dir");

		String path = localPath + "/Tools/";

		File dir = new File(path + tool_filename);

		System.out.print("삭제 타겟 파일 : ??후" + dir);

		if( dir.exists()){
			if (dir.delete()) {
				toolservice.fileDelete_tool(paraMap);
			} 
		}
		return "DataList/Tool_List";
	}

	//============================================================================================

	public static long getCRC32Value(String filename) {
		Checksum crc = new CRC32();

		try {

			BufferedInputStream in = new BufferedInputStream(new FileInputStream(filename));
			byte buffer[] = new byte[32768];
			int length = 0;

			while ((length = in.read(buffer)) >= 0)
				crc.update(buffer, 0, length);

			in.close();

		} catch (IOException e) {
			System.err.println(e);
			System.exit(2);
		}   

		return crc.getValue();
	}



}
