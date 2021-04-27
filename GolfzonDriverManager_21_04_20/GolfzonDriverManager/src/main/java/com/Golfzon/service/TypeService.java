package com.Golfzon.service;

import java.util.HashMap;
import java.util.List;

import com.Golfzon.dao.TypeDAO;
import com.Golfzon.dto.PartDTO;
import com.Golfzon.dto.TypeDTO;

public class TypeService {

	TypeDAO typedao = new TypeDAO();
	
	public List<TypeDTO> TypeList () {		
		return typedao.TypeList();
	}
	//Update
	public void TypeUpdate_sql (HashMap<String,String>paraMap) {

		typedao.TypeUpdate_sql(paraMap);
	}
	//Insert
	public void TypeInsert_sql (HashMap<String,String>paraMap) throws ClassNotFoundException {
		typedao.TypeInsert_sql(paraMap);
	}
	//Delete
	public void TypeDelete_sql (HashMap<String,String>paraMap) {
		typedao.TypeDelete_sql(paraMap);

	}
}
