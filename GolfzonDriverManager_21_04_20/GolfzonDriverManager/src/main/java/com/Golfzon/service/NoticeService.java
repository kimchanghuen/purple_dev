package com.Golfzon.service;

import java.util.HashMap;
import java.util.List;

import com.Golfzon.dao.NoticeDAO;
import com.Golfzon.dto.NoticeDTO;

public class NoticeService {


	NoticeDAO noticedao;

    //Select
	public List<NoticeDTO> serchNotice(HashMap<String,String> paraMap) {
		noticedao = new NoticeDAO();
		return noticedao.serchNotice(paraMap);
	}
	//Insert 
	public void NoticeInsert_sql(HashMap<String,String> paraMap) {
		noticedao = new NoticeDAO();
		noticedao.NoticeInsert_sql(paraMap);

	}
	//Delete
	public void NoticeDelete_sql(String n_idx) {
		noticedao = new NoticeDAO();
		noticedao.NoticeDelete_sql(n_idx);

	}
	//Update
	public void NoticeUpdate_sql(HashMap<String,String> paraMap) {
		noticedao = new NoticeDAO();
		noticedao.NoticeUpdate_sql(paraMap);

	}

}
