package com.Golfzon.JSPController;

import java.util.HashMap;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Golfzon.service.KindService;

@Controller
@Component
@RequestMapping("/Kind/*")
public class KindController {

	KindService kindservice = new KindService();;	


	@RequestMapping(value="/KindList", method = {RequestMethod.GET, RequestMethod.POST})
	public String KindList(Model model) throws Exception  {
		model.addAttribute("list",kindservice.KindList());
		return "DataList/Kind_list";
	}
	@RequestMapping(value="/KindUpdate", method = {RequestMethod.GET, RequestMethod.POST})
	public String KindUpdate(Model model) throws Exception  {

		return "DataList/Kind_update";
	}
	@RequestMapping(value="/KindUpdate_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public  @ResponseBody String KindUpdate_sql(
			@RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("enable") String enable
			) throws Exception  {
		HashMap<String,String> paraMap = new HashMap<String,String>(); 

		paraMap.put("code", code);
		paraMap.put("name", name);
		paraMap.put("enable", enable);

		kindservice.KindUpdate_sql(paraMap);

		return null;
	}
	@RequestMapping(value="/Kindinsert", method = {RequestMethod.GET, RequestMethod.POST})
	public String Kindinsert() throws Exception  {

		return "DataList/Kind_insert";
	}
	@RequestMapping(value="/Kindinsert_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public  @ResponseBody String Kindinsert_sql(
			@RequestParam("code") String code
			, @RequestParam("name") String name
			) throws Exception  {
		HashMap<String,String> paraMap = new HashMap<String,String>(); 

		paraMap.put("code", code);
		paraMap.put("name", name);

		kindservice.Kindinsert_sql(paraMap);

		return null;
	}
	@RequestMapping(value = "/KindDelete_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String KindDelete_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("enable") String enable ) throws Exception {
		System.out.println("KindUpdate_sql 파라미터 확인 code : " + code + " / name : " + name + " / enable : " + enable);
		HashMap<String,String> paraMap = new HashMap<String,String>(); 
		paraMap.put("code",code);
		paraMap.put("name",name);
		paraMap.put("enable",enable);
		kindservice.KindDelete_sql(paraMap);
		
		
		return null;
	}





}
