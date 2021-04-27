package com.Golfzon.service;

import java.util.HashMap;

import com.Golfzon.dao.LoginDAO;

public class LoginService {

	LoginDAO logindao;

	public Long LoginCheck(HashMap<String,String> paraMap) {
		logindao = new LoginDAO();	
		
		return logindao.LoginCheck(paraMap);
		

	}

}
