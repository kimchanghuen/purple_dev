package com.Golfzon.dto;

import java.util.Date;

public class NoticeDTO {

	private Integer n_idx;
	private String  n_type;
	private String  n_title;
	private String  titleBody;
	private String  resultBody;
	private Date  n_startdate;
	private Date  n_enddate;
	private Date  n_date;
	private Date  n_update;
	private String  n_enable;

	public Integer getN_idx() {
		return n_idx;
	}
	public void setN_idx(Integer n_idx) {
		this.n_idx = n_idx;
	}
	public String getN_type() {
		return n_type;
	}
	public void setN_type(String n_type) {
		this.n_type = n_type;
	}
	public String getN_title() {
		return n_title;
	}
	public void setN_title(String n_title) {
		this.n_title = n_title;
	}
	public String getTitleBody() {
		return titleBody;
	}
	public void setTitleBody(String titleBody) {
		this.titleBody = titleBody;
	}
	public String getResultBody() {
		return resultBody;
	}
	public void setResultBody(String resultBody) {
		this.resultBody = resultBody;
	}
	public Date getN_startdate() {
		return n_startdate;
	}
	public void setN_startdate(Date n_startdate) {
		this.n_startdate = n_startdate;
	}
	public Date getN_enddate() {
		return n_enddate;
	}
	public void setN_enddate(Date n_enddate) {
		this.n_enddate = n_enddate;
	}
	public Date getN_date() {
		return n_date;
	}
	public void setN_date(Date n_date) {
		this.n_date = n_date;
	}
	public Date getN_update() {
		return n_update;
	}
	public void setN_update(Date n_update) {
		this.n_update = n_update;
	}
	public String getN_enable() {
		return n_enable;
	}
	public void setN_enable(String n_enable) {
		this.n_enable = n_enable;
	}



}
