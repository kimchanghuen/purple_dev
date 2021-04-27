package com.Golfzon.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.Golfzon.dao.DriverDAO;
import com.Golfzon.dto.DriverDTO;


public class DriverService {

	DriverDAO driverdao = new DriverDAO();
	public List<DriverDTO> DriverList (String type) throws Exception{		

		return driverdao.DriverList(type);
	}
	//Update
	public void DriverUpdate_sql (HashMap<String,String>paraMap)throws Exception {

		driverdao.DriverUpdate_sql(paraMap);
	}
	//Insert
	public void DriverInsert_sql (HashMap<String,String>paraMap) {
		driverdao.DriverInsert_sql(paraMap);
	}
	//FileInsert
	public void FileUpload(HashMap<String,String> paraMap) throws Exception, SQLException {

		driverdao.FileUpload(paraMap);
	}
	//Delete
	public void fileDelete (HashMap<String,String>paraMap) throws Exception {

		driverdao.fileDelete(paraMap);
		return;

	}
	public List<DriverDTO> Driverserch (HashMap<String,String>paraMap) throws Exception {

		return driverdao.Driverserch(paraMap);


	}
}


