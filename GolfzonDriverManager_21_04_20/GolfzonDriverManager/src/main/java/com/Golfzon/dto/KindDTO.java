package com.Golfzon.dto;

import java.util.Date;

public class KindDTO {

	private Integer k_idx;
	private String k_code;
	private String k_name; 
	private Date k_date; 
	private Integer k_enable;
	
	public Integer getK_idx() {
		return k_idx;
	}
	public void setK_idx(Integer k_idx) {
		this.k_idx = k_idx;
	}
	public String getK_code() {
		return k_code;
	}
	public void setK_code(String k_code) {
		this.k_code = k_code;
	}
	public String getK_name() {
		return k_name;
	}
	public void setK_name(String k_name) {
		this.k_name = k_name;
	}
	public Date getK_date() {
		return k_date;
	}
	public void setK_date(Date k_date) {
		this.k_date = k_date;
	}
	public Integer getK_enable() {
		return k_enable;
	}
	public void setK_enable(Integer k_enable) {
		this.k_enable = k_enable;
	} 



}

