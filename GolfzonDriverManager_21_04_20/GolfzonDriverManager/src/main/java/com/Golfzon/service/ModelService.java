package com.Golfzon.service;

import java.util.HashMap;
import java.util.List;

import com.Golfzon.dao.ModelDAO;
import com.Golfzon.dto.ModelDTO;



public class ModelService {

	ModelDAO modeldao = new ModelDAO();

	//Select
	public List<ModelDTO> ModelList () {		
		return modeldao.ModelList();
	}
    //Update
	public void ModelUpdate_sql (HashMap<String,String>paraMap) {
		modeldao.ModelUpdate_sql(paraMap);
	}
	//Insert
	public void ModelInsert_sql (HashMap<String,String>paraMap) {
		modeldao.ModelInsert_sql(paraMap);
	}
	//Delete
	public void ModelDelete_sql (HashMap<String,String>paraMap) {
		modeldao.ModelDelete_sql(paraMap);
			
	}
}
