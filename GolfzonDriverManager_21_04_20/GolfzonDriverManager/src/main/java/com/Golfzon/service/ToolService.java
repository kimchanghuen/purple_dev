package com.Golfzon.service;



import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.Golfzon.DBController.DbService;
import com.Golfzon.dao.ToolDAO;
import com.Golfzon.dto.ToolDTO;


public class ToolService {

	ToolDAO tooldao = new ToolDAO();
    //Select
	public List<ToolDTO> ToolList() throws Exception{	
		return tooldao.ToolList();
	}
	//Insert
	public void ToolInsert_sql(HashMap<String,String> paraMap) throws Exception{	
		tooldao.ToolInsert_sql(paraMap);
		return;
	}
	//FileInsert
	public void FileUploadTool(HashMap<String,String> paraMap) throws ClassNotFoundException, SQLException {

		tooldao.FileUploadTool(paraMap);
		return;
	}
	//Update
	public void ToolUpdate_sql(HashMap<String,String> paraMap) throws Exception{

		tooldao.ToolUpdate_sql(paraMap);
		return;
	}
	//Delete
	public void fileDelete_tool(HashMap<String,String> paraMap) throws Exception{

	System.out.println("오냐?");
		tooldao.fileDelete_tool(paraMap);
		return;
	}

}
