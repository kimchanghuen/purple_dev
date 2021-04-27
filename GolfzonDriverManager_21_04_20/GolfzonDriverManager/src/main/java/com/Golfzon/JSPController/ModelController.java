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

import com.Golfzon.service.ModelService;


@Controller
@Component
@RequestMapping("/Model/*")
public class ModelController {

	ModelService modelservice = new ModelService();

	@RequestMapping(value = "/ModelList", method = RequestMethod.GET)
	public String ModelList(Model model) throws Exception {

		model.addAttribute("list",modelservice.ModelList());

		return "DataList/Model_list";
	}
	@RequestMapping(value = "/ModelUpdate", method = {RequestMethod.GET, RequestMethod.POST})
	public String ModelUpdate() throws Exception {

		return "DataList/Model_update";
	}

	// 모델리스트 update SQL 호출
	@RequestMapping(value = "/ModelUpdate_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String  ModelUpdate_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("kind") String kind
			, @RequestParam("enable") String enable ) throws Exception {

		HashMap<String,String> paraMap = new HashMap<String,String>(); 

		paraMap.put("code",code);
		paraMap.put("name",name);
		paraMap.put("kind",kind);
		paraMap.put("enable",enable);
		modelservice.ModelUpdate_sql(paraMap);



		return null;
	}

	// 모델리스트 delete SQL 호출
	@RequestMapping(value = "/ModelDelete_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String ModelDelete_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("kind") String kind
			, @RequestParam("enable") String enable ) throws Exception {
		HashMap<String,String> paraMap = new HashMap<String,String>(); 
		paraMap.put("code",code);
		paraMap.put("name",name);
		paraMap.put("kind",kind);
		paraMap.put("enable",enable);
		
		modelservice.ModelDelete_sql(paraMap);
		return null;
	}  

	// 모델리스트 Insert 호출
	@RequestMapping(value = "/Modelinsert", method = {RequestMethod.GET, RequestMethod.POST})
	public String Modelinsert() throws Exception {
		return "DataList/Model_insert";
	}

	// 모델리스트 Insert SQL 호출
	@RequestMapping(value = "/ModelInsert_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String ModelInsert_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("kind") String kind) throws Exception {
		HashMap<String,String> paraMap = new HashMap<String,String>(); 

		paraMap.put("code",code);
		paraMap.put("name",name);
		paraMap.put("kind",kind);
		modelservice.ModelInsert_sql(paraMap);

		return null;
	} 

}
