package com.Golfzon.JSPController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Golfzon.DBController.DbService;
import com.Golfzon.dto.NoticeDTO;
import com.Golfzon.service.NoticeService;
import com.Golfzon.service.ToolService;

@Controller
public class JspController {

	@Autowired
	DbService dbService;
	NoticeService noticeservice;

	// main.jsp 호출    
	@RequestMapping(value = "/DriverManager", method = {RequestMethod.GET, RequestMethod.POST})
	public String jsp(HttpServletRequest request 
			,Model model

			) throws Exception {


		return "notice";
	}
	

	// 드라이버 목록 호출 (드라이버 상세)
	@RequestMapping(value = "/serchInDriverPage", method = RequestMethod.GET)
	public String serchInDriverPage() throws Exception {
		return "Search/serchDriver_InPage";
	}

	// 링크 목록 호출
	@RequestMapping(value = "/serch_LinkData", method = RequestMethod.GET)
	public String serchLinkData() throws Exception {
		return "Search/serchLink";
	}

	// 링크 목록 호출
	@RequestMapping(value = "/serch_SubLinkData", method = {RequestMethod.GET, RequestMethod.POST})
	public String serchSubLinkData() throws Exception {
		return "DataList/sub_Link_list";
	}   

	// 링크 목록 호출
	@RequestMapping(value = "/serch_KindData", method = RequestMethod.GET)
	public String serchKindData() throws Exception {
		return "Search/serchKind";
	}


	// json 호출 
	@RequestMapping(value = "/kind", method = {RequestMethod.GET, RequestMethod.POST})
	public String serchJsonKind() throws Exception {
		return "JSON/jsonKind";
	}

	@RequestMapping(value = "/model/{kind}", method = {RequestMethod.GET, RequestMethod.POST})
	public String serchJsonModel(@PathVariable String kind, Model model) {
		String strKind = kind;
		model.addAttribute("kind", strKind);
		return "JSON/jsonModel";
	}

	@RequestMapping(value = "/driver/{modelCode}", method = {RequestMethod.GET, RequestMethod.POST})
	public String serchJsonDevice(@PathVariable String modelCode, Model model) {
		String strModelCode = modelCode;
		model.addAttribute("modelCode", strModelCode);
		return "JSON/jsonDriver";
	}

	@RequestMapping(value = "/software/{modelCode}", method = {RequestMethod.GET, RequestMethod.POST})
	public String serchJsonDevice_software(@PathVariable String modelCode, Model model) {
		String strModelCode = modelCode;
		model.addAttribute("modelCode", strModelCode);
		return "JSON/jsonSoftware";
	}

	@RequestMapping(value = "/Tools", method = {RequestMethod.GET, RequestMethod.POST})
	public String serchJsonDevice_Tooversion() {
		return "JSON/jsonToolversion";
	}

	// 파일 다운로드 jsp 호출
	@RequestMapping(value = "/filedown",  produces = "application/text; charset=utf8", method = {RequestMethod.GET, RequestMethod.POST})
	public String filedown(ModelMap model, @RequestParam("fileName") String fileName) throws Exception {
		fileName = fileName.replace("%26", "%");
		fileName = fileName.replace("%2B", "+");
		fileName = fileName.replace("/", "");
		fileName = fileName.replace("../", "");    	
		System.out.println(" fileName in filedown : " + fileName);
		model.addAttribute("fileName", fileName);
		return "fileDown";
	}

	// 파일 다운로드 jsp 호출
	@RequestMapping(value = "/filedown_tool",  produces = "application/text; charset=utf8", method = {RequestMethod.GET, RequestMethod.POST})
	public String filedown_tool(ModelMap model, @RequestParam("fileName") String fileName) throws Exception {
		fileName = fileName.replace("%26", "%");
		fileName = fileName.replace("%2B", "+");
		fileName = fileName.replace("/", "");
		fileName = fileName.replace("../", "");
		System.out.println(" fileName in filedown : " + fileName);
		model.addAttribute("fileName", fileName);
		return "fileDown_tool";
	}    

	// 파일 다운로드 url 호출
	@RequestMapping(value = "/drivers/{modelName}/{fileName}",  produces = "application/text; charset=utf8", method = {RequestMethod.GET, RequestMethod.POST})
	public String filedown_url(ModelMap model, @PathVariable String modelName, @PathVariable String fileName) throws Exception {
		System.out.println("filedown_url : " + fileName);
		String strFileName = fileName;
		model.addAttribute("fileName", strFileName);
		model.addAttribute("modelName", modelName);
		return "fileDown_url";
	}

	// 파일 다운로드 url 호출
	@RequestMapping(value = "/drivers/{fileName}",  produces = "application/text; charset=utf8", method = {RequestMethod.GET, RequestMethod.POST})
	public String filedown_url_2(ModelMap model, @PathVariable String fileName) throws Exception {

		fileName = fileName.replace("/", "");
		fileName = fileName.replace("../", "");

		System.out.println("filedown_url : " + fileName);
		String strFileName = fileName;
		model.addAttribute("fileName", strFileName);
		return "fileDown_url";
	}

	// 툴 다운로드 url 호출
	@RequestMapping(value = "/Tools/{fileName}",  produces = "application/text; charset=utf8", method = {RequestMethod.GET, RequestMethod.POST})
	public String filedown_url_tool(ModelMap model, @PathVariable String fileName) throws Exception {
		System.out.println("filedown_url : " + fileName);
		String strFileName = fileName;
		model.addAttribute("fileName", strFileName);
		return "fileDown_url_tool";
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

}

