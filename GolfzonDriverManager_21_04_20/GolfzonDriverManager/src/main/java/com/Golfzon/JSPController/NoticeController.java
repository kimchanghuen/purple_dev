package com.Golfzon.JSPController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Golfzon.dto.NoticeDTO;
import com.Golfzon.service.NoticeService;

@Controller
@Component
@RequestMapping("/Notice/*")

public class NoticeController {

	NoticeService noticeservice;

	@ResponseBody
	@RequestMapping(value="/serchNotice" , method = {RequestMethod.GET, RequestMethod.POST})
	public List<NoticeDTO> serchNotice(
			@RequestParam("type_value") String type_value
			, @RequestParam("value") String value
			,Model model) {

		if(type_value == null) {  
			type_value = "1";
			value = "";
		}
		System.out.println(type_value+":"+value);


		HashMap<String,String> paraMap = new HashMap<String, String>();
		noticeservice =  new NoticeService();


	

		paraMap.put("type",type_value);
		paraMap.put("value",value);




		return noticeservice.serchNotice(paraMap);

	}

	@RequestMapping(value="/Noticeinsert" , method = {RequestMethod.GET, RequestMethod.POST})
	public String Noticeinsert() {
		return "DataList/Notice_insert";	
	}

	@RequestMapping(value="/NoticeInsert_sql" , method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String  NoticeInsert_sql(
			@RequestParam("n_title") String n_title
			,@RequestParam("n_body") String n_body
			,@RequestParam("n_enable") String n_enable
			) {
		System.out.println(n_title +":"+n_body+":"+n_enable);

		noticeservice = new NoticeService();
		HashMap<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("n_title", n_title);
		paraMap.put("n_body", n_body);
		paraMap.put("n_enable", n_enable);
		noticeservice.NoticeInsert_sql(paraMap);
		return null;	
	}
	@RequestMapping(value="/NoticeUpdate" , method = {RequestMethod.GET, RequestMethod.POST})
	public  String NoticeUpdate() {
		return "DataList/Notice_update";	
	}
	@RequestMapping(value="/NoticeUpdate_sql" , method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String NoticeUpdate_sql(
			@RequestParam("n_idx") String n_idx
			,@RequestParam("n_title") String n_title
			,@RequestParam("n_body") String n_body
			,@RequestParam("n_enable") String n_enable
			) {
		noticeservice = new NoticeService();
		HashMap<String,String> paraMap = new HashMap<String, String>();
		paraMap.put("n_idx", n_idx);
		paraMap.put("n_title", n_title);
		paraMap.put("n_body", n_body);
		paraMap.put("n_enable", n_enable);
		noticeservice.NoticeUpdate_sql(paraMap);

		return null;	
	}
	@RequestMapping(value = "/NoticeDelete_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String NoticeDelete_sql(
			@RequestParam("n_idx") String n_idx
			) throws Exception {
		noticeservice = new NoticeService();
		noticeservice.NoticeDelete_sql(n_idx);
		return null;
	}
}
