package com.Golfzon.DBController;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Golfzon.dto.BoardDTO;
import com.Golfzon.dto.KindDTO;


@Service
public class DbService {
 
    // @Autowired
    DbMapper dbMapper;
 
    /* select dual */
    public String getDual() throws Exception{
    	return dbMapper.getDual();
    }
    
    /* select db */
    public String getTest() throws Exception{
        return dbMapper.getTest();
    }
    
    /* select db 다건 조회 */
    public List<BoardDTO> getData() throws Exception{
        return dbMapper.getData();
    }
    
    /* DRV_KIND 조회 */
    public List<KindDTO> getKind() throws Exception{
        return dbMapper.getKind();
    }
 
}
