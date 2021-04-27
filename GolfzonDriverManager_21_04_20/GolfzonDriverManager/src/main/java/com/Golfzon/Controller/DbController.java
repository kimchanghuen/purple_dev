package com.Golfzon.Controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.Golfzon.DBController.DbService;

@Controller
public class DbController {
	
	private static final Logger logger = LoggerFactory.getLogger(DbController.class);

	@Autowired
    DbService dbService;
     
	// 로그인 페이지
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String jsp() throws Exception {
        return "notice";
    }
    
}

