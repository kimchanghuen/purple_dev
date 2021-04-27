package com.Golfzon.JSPController;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Golfzon.service.LogService;


@Controller
@Component
@RequestMapping("/Log/*")
public class LogController {


	LogService logservice = new LogService();

	@RequestMapping(value = "/LogView", method = {RequestMethod.GET, RequestMethod.POST})
	public String LogView() throws Exception {
		return "Log";
	}
	@ResponseBody
	@RequestMapping(value = "/serch_log", method = {RequestMethod.GET, RequestMethod.POST})
	public List<HashMap<String, String>> serch_log(
			@RequestParam("table_value") String table_value
			, @RequestParam("detail") String detail
			, @RequestParam("startDate") String startDate
			, @RequestParam("endDate") String endDate
			, @RequestParam("type_value") String type_value

			) throws Exception {


		System.out.println("===LOG컨트롤러===");
		System.out.println(table_value);
		System.out.println(detail);
		System.out.println(startDate);
		System.out.println(endDate);
		System.out.println(type_value);
		System.out.println("============");

		HashMap<String,String> paraMap = new HashMap<String,String>();

		paraMap.put("table_value", table_value);
		paraMap.put("detail", detail);
		paraMap.put("startDate", startDate);
		paraMap.put("endDate", endDate);
		paraMap.put("type_value", type_value);

		//		logservice.serch_log(paraMap);


		return logservice.serch_log(paraMap);
	}

	// ---------------------------------------------------
	// LOG Insert SQL 호출
	@RequestMapping(value = "/LogInsert_sql", method = {RequestMethod.GET, RequestMethod.POST})
	public String Loginsert(ModelMap model
			, @RequestParam("log_type") String log_type
			, @RequestParam("log_table") String log_table
			, @RequestParam("log_code") String log_code
			, @RequestParam("log_detail") String log_detail) throws Exception {

		HashMap<String,String> paraMap = new HashMap<String,String>();

		paraMap.put("log_type", log_type);
		paraMap.put("log_table", log_table);
		paraMap.put("log_code", log_code);
		paraMap.put("log_detail", log_detail);
		
		logservice.LogInsert_sql(paraMap);
		

		return null;
	}
}
