package com.Golfzon.JSPController;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
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

import com.Golfzon.dto.DriverDTO;
import com.Golfzon.service.DriverService;


@Controller
@Component
@RequestMapping("/Driver/*")
public class DriverController {

	DriverService driverservice = new DriverService();

	@RequestMapping(value = "/DriverList", method = {RequestMethod.GET ,RequestMethod.POST})
	public String DriverList(HttpServletRequest request,Model model) throws Exception {

		//		String type;
		//
		//		System.out.println(request.getParameter("sum") + "왔나?");
		//		type = request.getParameter("sum");
		//
		//		if(type == null) {
		//			type = "none";
		//		}
		//
		//		model.addAttribute("list",driverservice.DriverList(type));

		return "DataList/Driver_list";
	}
	@ResponseBody
	@RequestMapping(value = "/serchInDriverPage", method = {RequestMethod.GET ,RequestMethod.POST})
	public List<DriverDTO> serchInDriverPage(HttpServletRequest request,Model model,
			@RequestParam("type_value") String type_value
			) throws Exception {


		System.out.println(type_value + "왔나?");


		if(type_value == null) {
			type_value = "none";
		}


		return driverservice.DriverList(type_value);
	}


	@RequestMapping(value = "/fileCheck/{file}", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String fileCheck_TOOL(ModelMap model
			, @PathVariable String file) {
		System.out.println("filename : " + file);

		//		String fileName = (String)pageContext.getAttribute("fileName");
		// fileName = "/media/Tools/"+fileName;
		String localPath = System.getProperty("user.dir");

		String path = localPath + "/drivers/";

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
	@RequestMapping(value = "/DriverUpdate", method = {RequestMethod.GET, RequestMethod.POST})
	public String DriverUpdate() throws Exception {
		System.out.println("????");
		return "DataList/Driver_update";
	}  
	@RequestMapping(value = "/DriverUpdate_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String DriverUpdate_sql(ModelMap model
			, @RequestParam("d_idx") String d_idx
			, @RequestParam("d_code") String d_code
			, @RequestParam("d_name") String d_name
			, @RequestParam("d_part") String d_part
			, @RequestParam("d_type") String d_type
			, @RequestParam("d_filename") String d_filename
			, @RequestParam("d_version") String d_version
			, @RequestParam("d_exec") String d_exec
			, @RequestParam("d_etc") String d_etc
			, @RequestParam("d_enable") String d_enable
			, @RequestParam("d_etc_type") String d_etc_type
			, @RequestParam("d_etc_module") String d_etc_module
			, @RequestParam("d_etc_name") String d_etc_name
			, @RequestParam("d_etc_uninst") String d_etc_uninst
			
			) throws Exception {

		HashMap<String,String> paraMap = new HashMap<String,String>(); 
		paraMap.put("d_idx",d_idx);
		paraMap.put("d_code",d_code);
		paraMap.put("d_name",d_name);
		paraMap.put("d_part",d_part);
		if(d_part == null) {
			d_part = "";
		}
		paraMap.put("d_type",d_type);
		paraMap.put("d_filename",d_filename);
		paraMap.put("d_version",d_version);
		paraMap.put("d_exec",d_exec);
		paraMap.put("d_etc",d_etc);
		paraMap.put("d_enable",d_enable);
		paraMap.put("d_etc_type",d_etc_type);
		paraMap.put("d_etc_module",d_etc_module);
		paraMap.put("d_etc_name",d_etc_name);
		paraMap.put("d_etc_uninst",d_etc_uninst);
		driverservice.DriverUpdate_sql(paraMap);

		return null;
	}
	@RequestMapping(value = "/fileUpload/{d_idx}", method = {RequestMethod.GET, RequestMethod.POST})
	public String fileUp(MultipartHttpServletRequest multi
			, @PathVariable String d_idx ) {
		System.out.println("업로드 시작");

		// 저장 경로 설정
		// String root = multi.getSession().getServletContext().getRealPath("/");
		// root : C:\workspace\GolfzonDriverManager\src\main\webapp\
		// String path = root+"WEB-CONNTENT/uploadFile/";

		// 파일이 저장될 경로.
		// String path = "/media/Driver/";


		String localPath = System.getProperty("user.dir");

		String path = localPath + "/drivers/";

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


			newFileName = fileName;           

			System.out.println("실제 파일 경로 + 이름 : " +path+newFileName);

			try {
				mFile.transferTo(new File(path+newFileName));

				// CRC32 코드 가져오기
				strCRC32 = String.format("%08X", getCRC32Value(path+newFileName) );

				// 파일 사이즈 확인
				strNewFile = path+newFileName;

				File fileSize = new File(strNewFile);
				long size = fileSize.length();
				String strSize = Long.toString(size);

				System.out.println("idx : " + d_idx + " / crc32 : " + strCRC32 + " / size : " + strSize + " / fileName : " + newFileName);


				HashMap<String,String> paraMaps = new HashMap<String,String>();
				paraMaps.put("tool_idx",d_idx);
				paraMaps.put("strCRC32",strCRC32);
				paraMaps.put("strSize",strSize);
				paraMaps.put("newFileName",newFileName);

				driverservice.FileUpload(paraMaps);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("업로드 실패 : " + e.toString());
				return "false";
			}
		}

		return "DataList/Driver_list";
	}

	@RequestMapping(value = "/Driverinsert", method = {RequestMethod.GET, RequestMethod.POST})
	public String Driverinsert() throws Exception {
		return "DataList/Driver_insert";
	}
	@RequestMapping(value = "/DriverInsert_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String DriverInsert_sql(ModelMap model , MultipartHttpServletRequest multi

			) throws Exception {
		HashMap<String,String> paraMap = new HashMap<String,String>(); 
		System.out.println("## DriverInsert_sql Start!!");

		String d_part;
		String tool_idx = multi.getParameter("idx");

		if(multi.getParameter("d_part") == null) {

			d_part="";
		}else {
			d_part =multi.getParameter("d_part");
		}

		System.out.println("=================");

		paraMap.put("d_code",multi.getParameter("d_code"));
		paraMap.put("d_name",multi.getParameter("d_name"));
		paraMap.put("d_part",d_part);
		paraMap.put("d_type",multi.getParameter("d_type"));
		paraMap.put("d_version",multi.getParameter("d_version"));
		paraMap.put("d_exec",multi.getParameter("d_exec"));
		paraMap.put("d_etc",multi.getParameter("d_etc"));
		paraMap.put("d_etc_type",multi.getParameter("d_etc_type"));
		paraMap.put("d_etc_module",multi.getParameter("d_etc_module"));
		paraMap.put("d_etc_name",multi.getParameter("d_etc_name"));
		paraMap.put("d_etc_uninst",multi.getParameter("d_etc_uninst"));


		System.out.println("넘어오는값 :" + multi.getParameter("d_code"));
		System.out.println("넘어오는값 :" + multi.getParameter("d_name"));
		System.out.println("넘어오는값 :" + multi.getParameter("d_part"));
		System.out.println("넘어오는값 :" + multi.getParameter("d_type"));
		System.out.println("넘어오는값 :" + multi.getParameter("d_exec"));
		System.out.println("넘어오는값 :" + multi.getParameter("d_etc"));
		System.out.println("넘어오는값 :" + multi.getParameter("d_etc_type"));
		System.out.println("넘어오는값 :" + multi.getParameter("d_etc_module"));
		System.out.println("넘어오는값 :" + multi.getParameter("d_etc_name"));				
		System.out.println("넘어오는값 :" +multi.getParameter("d_version"));
		System.out.println("넘어오는값 :" +multi.getParameter("d_etc_uninst"));
		System.out.println("넘어오는값 :" +tool_idx);

		System.out.println("=================");


		driverservice.DriverInsert_sql(paraMap);

		System.out.println("업로드 시작" + tool_idx);

		String localPath = System.getProperty("user.dir");

		String path = localPath + "/drivers/";

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

				driverservice.FileUpload(paraMaps);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("업로드 실패 : " + e.toString());
				return "false";
			}
		}





		return null;
	} 

	@RequestMapping(value = "/fileDelete", method = {RequestMethod.GET, RequestMethod.POST})
	public String fileDelete(ModelMap model
			, @RequestParam("d_code") String d_code
			, @RequestParam("d_name") String d_name 
			, @RequestParam("d_filename") String d_filename) throws Exception {

		System.out.println("파일제거 시작");


		HashMap<String,String> paraMap = new HashMap<String,String>();
		paraMap.put("d_code", d_code);
		paraMap.put("d_name", d_name);
		paraMap.put("d_filename", d_filename);


		// 파일 경로.
		// String path = "/media/Driver/";
		String localPath = System.getProperty("user.dir");

		String path = localPath + "/drivers/";

		File dir = new File(path + d_filename);

		System.out.print("삭제 타겟 파일 : 잘오는건가? " + dir);

		if( dir.exists()){
			if (dir.delete()) {
				driverservice.fileDelete(paraMap);
			}
		}
		return "DataList/Driver_list";
	}
	@RequestMapping(value = "/DriverView", method =  {RequestMethod.GET, RequestMethod.POST})
	public String Notice() throws Exception {
		return "main";
	}

	@ResponseBody
	@RequestMapping(value = "/Driverserch", method =  {RequestMethod.GET, RequestMethod.POST})
	public List<DriverDTO> Driverserch(HttpServletRequest request
			, @RequestParam("kind_value") String kind_value
			, @RequestParam("model_value") String model_value 
			, @RequestParam("part_value") String part_value 
			, @RequestParam("type_value") String type_value) throws Exception {

		HashMap<String,String> paraMap = new HashMap<String,String>();

		paraMap.put("kind_value", kind_value);
		paraMap.put("model_value", model_value);
		paraMap.put("part_value", part_value);
		paraMap.put("type_value", type_value);

		List<DriverDTO> result = driverservice.Driverserch(paraMap);

		for(int i =0; i<result.size(); i++) {

			String strFileName = result.get(i).getD_filename();



			strFileName = strFileName.replace("&", "%26");
			strFileName = strFileName.replace("+", "%2B");
			strFileName = strFileName.replace("/", "");
			strFileName = strFileName.replace("../", "");


			// System.out.println("strFileName : " + strFileName);

			String hostURL = request.getRequestURL().toString().replace(request.getRequestURI(),"") ;

			strFileName = URLEncoder.encode(strFileName, "UTF-8");

			String locationAdress = hostURL + "/filedown?fileName="+strFileName;

			result.get(i).setD_filename(locationAdress);
		}



		return result;
	}
	// etc data edit JSP 호출
	@RequestMapping(value = "/etcEdit", method = RequestMethod.GET)
	public String editEtcData(ModelMap model, @RequestParam("d_idx") String d_idx) throws Exception {
		System.out.println("d_idx 확인 : " + d_idx);
		model.addAttribute("d_idx",d_idx);

		return "Datacontroller/ETC_edit";
	}

	// etc data edit JSP 호출
	@RequestMapping(value = "/etcEditAll", method = RequestMethod.GET)
	public String editEtcDataAll() throws Exception {	   
		return "Datacontroller/ETC_editAll";
	}

	// etc data edit 저장 JSP 호출
	@RequestMapping(value = "/editETCsave", method = RequestMethod.GET)
	public String editETCsave(ModelMap model
			, @RequestParam("etcData") String etcData 
			, @RequestParam("idxData") String idxData  ) throws Exception {

		System.out.println("파라미터 확인 etcData : " + etcData + " / idxData : " + idxData);
		model.addAttribute("etcData",etcData);
		model.addAttribute("idxData",idxData);

		return "Datacontroller/ETC_update";
	}  

	// etc data edit 저장 JSP 호출
	@RequestMapping(value = "/editETCsaveAll", method = RequestMethod.GET)
	public String editETCsaveAll(ModelMap model
			, @RequestParam("etcData") String etcData   ) throws Exception {

		System.out.println("파라미터 확인 etcData : " + etcData);
		model.addAttribute("etcData",etcData);	   
		return "Datacontroller/ETC_updateAll";
	}    



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
