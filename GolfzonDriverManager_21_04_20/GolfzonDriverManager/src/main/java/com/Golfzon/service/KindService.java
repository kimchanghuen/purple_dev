package com.Golfzon.service;

import java.util.HashMap;
import java.util.List;

import com.Golfzon.dao.KindDAO;
import com.Golfzon.dto.KindDTO;

public class KindService {
	
	KindDAO kinddao = new KindDAO();
	
	//Select
	public List<KindDTO> KindList () {		
		return kinddao.getKindList();
	}
	//Update
	public void KindUpdate_sql (HashMap<String,String>paraMap) {
		kinddao.KindUpdate_sql(paraMap);
	}
	//Insert
	public void Kindinsert_sql (HashMap<String,String>paraMap) {
		kinddao.Kindinsert_sql(paraMap);
	}
	//Delete
	public void KindDelete_sql (HashMap<String,String>paraMap) {
		kinddao.KindDelete_sql(paraMap);
			
	}

}
