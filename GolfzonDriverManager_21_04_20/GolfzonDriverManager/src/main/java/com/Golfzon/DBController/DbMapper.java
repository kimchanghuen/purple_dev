package com.Golfzon.DBController;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.Golfzon.dto.BoardDTO;
import com.Golfzon.dto.KindDTO;


// @MapperScan("com.developer.project.mapper")
@Repository
public interface DbMapper {
    /* DB Select  */
    public String getDual() throws Exception;
    
    public String getTest() throws Exception;
    
    public List<BoardDTO> getData() throws Exception;
    
    // DRV_KIND 조회
    public List<KindDTO> getKind() throws Exception;

}