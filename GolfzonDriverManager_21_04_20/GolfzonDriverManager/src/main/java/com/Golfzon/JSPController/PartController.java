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

import com.Golfzon.service.PartService;


@Controller
@Component
@RequestMapping("/Part/*")
public class PartController {

	PartService partservice = new PartService();

	@RequestMapping(value = "/PartList", method = RequestMethod.GET)
	public String PartList(Model model) throws Exception {
		System.out.println("종류");
		
		model.addAttribute("list",partservice.PartList());
		return "DataList/Part_list";
	}
	@RequestMapping(value = "/PartUpdate", method = {RequestMethod.GET, RequestMethod.POST})
	public String PartUpdate() throws Exception {
		return "DataList/Part_update";
	}
	// 종류리스트 update SQL 호출
	@RequestMapping(value = "/PartUpdate_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String PartUpdate_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("enable") String enable ) throws Exception {

		HashMap<String,String> paraMap = new HashMap<String,String>(); 
		paraMap.put("code",code);
		paraMap.put("name",name);
		paraMap.put("enable",enable);
		
		partservice.PartUpdate_sql(paraMap);

		return null;
	}

	// 종류리스트 delete SQL 호출
	@RequestMapping(value = "/PartDelete_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String PartDelete_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("enable") String enable ) throws Exception {

		HashMap<String,String> paraMap = new HashMap<String,String>(); 
		paraMap.put("code",code);
		paraMap.put("name",name);
		paraMap.put("enable",enable);
		partservice.PartDelete_sql(paraMap);

		return null;
	}

	// 종류리스트 Insert 호출
	@RequestMapping(value = "/Partinsert", method = {RequestMethod.GET, RequestMethod.POST})
	public String Partinsert() throws Exception {
		return "DataList/Part_insert";
	}

	// 종류리스트 Insert SQL 호출
	@RequestMapping(value = "/PartInsert_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String PartInsert_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name) throws Exception {

		HashMap<String,String> paraMap = new HashMap<String,String>(); 
		paraMap.put("code",code);
		paraMap.put("name",name);
		
		partservice.PartInsert_sql(paraMap);

		return null;
	}

}
