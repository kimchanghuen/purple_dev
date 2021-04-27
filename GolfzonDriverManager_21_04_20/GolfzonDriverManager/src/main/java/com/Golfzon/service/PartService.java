package com.Golfzon.service;

import java.util.HashMap;
import java.util.List;

import com.Golfzon.dao.PartDAO;
import com.Golfzon.dto.PartDTO;

public class PartService {


	PartDAO partdto = new PartDAO();
	//Select
	public List<PartDTO> PartList () {		
		return partdto.PartList();
	}
	//Update
	public void PartUpdate_sql (HashMap<String,String>paraMap) {

		partdto.PartUpdate_sql(paraMap);
	}
	//Insert
	public void PartInsert_sql (HashMap<String,String>paraMap) {
		partdto.PartInsert_sql(paraMap);
	}
	//Delete
	public void PartDelete_sql (HashMap<String,String>paraMap) {
		partdto.PartDelete_sql(paraMap);

	}
}
