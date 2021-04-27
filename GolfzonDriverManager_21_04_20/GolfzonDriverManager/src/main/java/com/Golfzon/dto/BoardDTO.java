package com.Golfzon.dto;

import java.util.Date;

public class BoardDTO {
	
	private Integer sch_idx = 0;
	private Integer model_idx = 0;
	private Integer user_idx = 0;
	private String model_version = "";
	private Date sch_date = new Date();
	private Date sch_update = new Date();
	private String sch_yn = "";
	private String comment = "";
	
	public Integer getSchidx(){
		return sch_idx;
	}
	
	public void setSchidx(Integer schidx){
		this.sch_idx = schidx;
	}
	
	public Integer getModelidx(){
		return model_idx;
	}
	
	public void setModelidx(Integer modelidx){
		this.model_idx = modelidx;
	}
	
	public Integer getUseridx(){
		return sch_idx;
	}
	
	public void setUseridx(Integer useridx){
		this.user_idx = useridx;
	}
	
	public String getModelversion(){
		return model_version;
	}
	
	public void setModelversion(String modelversion){
		this.model_version = modelversion;
	}	
	
    public Date getSchdate() {
        return sch_date;
    }

    public void setSchdate(Date schdate) {
        this.sch_date = schdate;
    }
    
    public Date getSchupdate() {
        return sch_update;
    }

    public void setSchupdate(Date schupdate) {
        this.sch_update = schupdate;
    }
    
	public String getSchyn(){
		return model_version;
	}
	
	public void setSchyn(String schyn){
		this.sch_yn = schyn;
	}
	
	public String getComment(){
		return comment;
	}
	
	public void setComment(String comment){
		this.comment = comment;
	}


}

