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

import com.Golfzon.dao.TypeDAO;
import com.Golfzon.service.TypeService;

@Controller
@Component
@RequestMapping("/Type/*")
public class TypeController {


	TypeService typeservive = new TypeService();


	@RequestMapping(value = "/TypeList", method = RequestMethod.GET)
	public String TypeList(Model model) throws Exception {

		model.addAttribute("list",typeservive.TypeList());


		return "DataList/Type_list";
	}
	// 구분리스트 update 호출
	@RequestMapping(value = "/TypeUpdate", method = {RequestMethod.GET, RequestMethod.POST})
	public String TypeUpdate() throws Exception {
		return "DataList/Type_update";
	}    

	// 구분리스트 update SQL 호출
	@RequestMapping(value = "/TypeUpdate_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String TypeUpdate_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("enable") String enable ) throws Exception {
		HashMap<String,String> paraMap = new HashMap<String,String>(); 

		paraMap.put("code",code);
		paraMap.put("name",name);
		paraMap.put("enable",enable);

		typeservive.TypeUpdate_sql(paraMap);


		return "EditSQL/Type_update_sql";
	}

	// 구분리스트 delete SQL 호출
	@RequestMapping(value = "/TypeDelete_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String TypeDelete_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name
			, @RequestParam("enable") String enable ) throws Exception {

		
		System.out.println("뭔대");
		HashMap<String,String> paraMap = new HashMap<String,String>();
		paraMap.put("code",code);
		paraMap.put("name",name);
		paraMap.put("enable",enable);
		typeservive.TypeDelete_sql(paraMap);

		return null;
	}

	// 구분리스트 Insert 호출
	@RequestMapping(value = "/Typeinsert", method = {RequestMethod.GET, RequestMethod.POST})
	public String Typeinsert() throws Exception {
		return "DataList/Type_insert";
	}

	// 구분리스트 Insert SQL 호출
	@RequestMapping(value = "/TypeInsert_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public @ResponseBody String TypeInsert_sql(ModelMap model
			, @RequestParam("code") String code
			, @RequestParam("name") String name) throws Exception {
		HashMap<String,String> paraMap = new HashMap<String,String>(); 
	

		paraMap.put("code",code);
		paraMap.put("name",name);
		typeservive.TypeInsert_sql(paraMap);

		return null;
	} 

}
