package com.Golfzon.JSPController;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.zip.CRC32;
import java.util.zip.Checksum;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.Golfzon.DBManager;
import com.Golfzon.DBController.DbService;
import com.Golfzon.dto.ToolDTO;
import com.Golfzon.service.ToolService;

@Controller
@Component
public class JspController_editTable {

	@Autowired
	DbService dbService;



	
	// data insert JSP 호출
	@RequestMapping(value = "/datainsert", method = RequestMethod.GET)
	public String insertData() throws Exception {
		return "Datacontroller/topMenu_include";
	}

	// data insert JSP 호출
	@RequestMapping(value = "/subMenu_include", method = RequestMethod.GET)
	public String subMenu_include() throws Exception {
		return "Datacontroller/subMenu_include";
	}   




}

