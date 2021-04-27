package com.Golfzon.service;

import java.util.HashMap;
import java.util.List;

import com.Golfzon.dao.LinkDAO;
import com.Golfzon.dto.LinkDTO;

public class LinkService {


	LinkDAO linkdao = new LinkDAO();

	public List<LinkDTO> LinkList (HashMap<String,String> paraMap){

		return linkdao.LinkList(paraMap);
	}

	public void LinkDelete (String l_idx) throws ClassNotFoundException{

		linkdao.LinkDelete(l_idx);
	}
	public List<HashMap<String, String>> serch_SubLinkData (String kind_value,String model_value){

		return linkdao.serch_SubLinkData(kind_value,model_value);

	}
	public void insert_LinkData (HashMap<String,String> paraMap) throws ClassNotFoundException{

		 linkdao.insert_LinkData(paraMap);

	}
}
