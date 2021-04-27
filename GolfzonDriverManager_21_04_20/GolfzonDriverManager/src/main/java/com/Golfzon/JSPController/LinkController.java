package com.Golfzon.JSPController;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Golfzon.dto.LinkDTO;
import com.Golfzon.service.LinkService;

@Controller
@Component
@RequestMapping("/Link/*")
public class LinkController {


	LinkService linkservice = new LinkService();

	@RequestMapping(value = "/LinkList", method = {RequestMethod.GET ,RequestMethod.POST})
	public String DriverList(HttpServletRequest request,Model model			
			) throws Exception {


		return "DataList/Link_list";
	}

	@ResponseBody
	@RequestMapping(value = "/serch_LinkData", method = {RequestMethod.GET ,RequestMethod.POST})
	public List<LinkDTO> serch_LinkData(HttpServletRequest request,Model model
			,@RequestParam("kind_value") String kind_value
			,@RequestParam("model_value") String model_value
			,@RequestParam("type_value") String type_value
			,@RequestParam("driver_value") String driver_value


			) throws Exception {

		System.out.println("=====================");      
		System.out.println(kind_value);
		System.out.println(model_value);
		System.out.println(type_value);
		System.out.println(driver_value);
		System.out.println("=====================");


		HashMap<String,String> paraMap = new HashMap<String,String>(); 


		paraMap.put("Linkkind",kind_value);
		paraMap.put("Linkmodel",model_value);
		paraMap.put("type",type_value);
		paraMap.put("Linkdriver",driver_value);


		return linkservice.LinkList(paraMap);
	}	




	@RequestMapping(value = "/combomodel", method = RequestMethod.GET)
	public String combomodel() throws Exception {
		return "model";
	}


	@ResponseBody
	@RequestMapping(value = "/LinkDelete", method = {RequestMethod.GET, RequestMethod.POST})
	public String LinkDelete(HttpServletRequest request) throws Exception {

	   String l_idx = request.getParameter("l_idx");
		
		linkservice.LinkDelete(l_idx);
		return null;
	}

	// 링크 목록 호출
	@RequestMapping(value = "/serch_SubLinkData", method = {RequestMethod.GET, RequestMethod.POST})
	public String serchSubLinkData(
			HttpServletRequest request
			,Model model
			) throws Exception {
		String kind_value = request.getParameter("kind");
		String model_value = request.getParameter("model");
		
		System.out.println("===Link==");
		System.out.println(kind_value);
		System.out.println(model_value);
		System.out.println("========");
		model.addAttribute("list",linkservice.serch_SubLinkData(kind_value, model_value));
		
		
		return "DataList/sub_Link_list";
	}   

	@ResponseBody
	@RequestMapping(value = "/insert_LinkData", method = {RequestMethod.GET, RequestMethod.POST})
	public String insert_LinkData(
			HttpServletRequest request
			) throws Exception {
		HashMap<String,String> paraMap = new HashMap<String,String>(); 
		
		
		
		System.out.println("====Linkinsert===");
		
		
		System.out.println(request.getParameter("kind_value"));
		System.out.println(request.getParameter("model_value"));
		System.out.println(request.getParameter("driver_value"));
		
		System.out.println("====Linkinsert===");
		paraMap.put("kind_value",request.getParameter("kind_value"));
		paraMap.put("model_value",request.getParameter("model_value"));
		paraMap.put("driver_value",request.getParameter("driver_value"));
		linkservice.insert_LinkData(paraMap);
		return null;
	}	   



}
