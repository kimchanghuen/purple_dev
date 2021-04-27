package com.Golfzon.service;

import java.util.HashMap;
import java.util.List;

import com.Golfzon.dao.LogDAO;

public class LogService {

	LogDAO logdao = new LogDAO();

	public List<HashMap<String, String>> serch_log(HashMap<String,String> paraMap) {

		return logdao.serch_log(paraMap);

	}
	public void LogInsert_sql(HashMap<String,String> paraMap) {

		 logdao.LogInsert_sql(paraMap);

	}
}
