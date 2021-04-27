package com.Golfzon.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.Golfzon.DBManager;

public class LogDAO {

	public List<HashMap<String, String>> serch_log(HashMap<String,String> paraMap) {


		
		List<HashMap<String,String>> result = new ArrayList<HashMap<String,String>>();
		
		
		String table_value=paraMap.get("table_value"); 
		String detail=paraMap.get("detail"); 
		String startDate=paraMap.get("startDate"); 
		String endDate=paraMap.get("endDate");
		String type_value=paraMap.get("type_value");

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
			DBManager db = new DBManager();


			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();

			query.append( " SELECT * " + "\n"
					+ "  FROM DRV_LOG " + "\n" 
					+ " WHERE 1=1 " + "\n" 
					+ "     AND substring(log_datetime,1,10) BETWEEN '" +startDate + "' AND '" + endDate + "'" + "\n"          
					);        

			if( ( !detail.equals("") ) ) { // 조회 조건 값 : 상세 내용
				query.append(" AND log_detail like '%" + detail + "%' " + "\n");
			}

			if( ( !table_value.equals("none") ) ) { // 조회 조건 값 : 대상
				query.append(" AND log_table like '%" + table_value + "%' "  + "\n");
			}

			if( ( !type_value.equals("none") ) ) { // 조회 조건 값 : 수정내용
				query.append(" AND log_type like '%" + type_value + "%' "  + "\n");
			}

			query.append(" ORDER BY log_datetime DESC ");

			pstmt=con.prepareStatement( query.toString() );

			System.out.println(" 쿼리 확인 : ");
			System.out.println( pstmt.toString() );

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();


			// rs.getRow() : 데이터의 가장 끝 index
			if ( rs.getRow() > 0 ) {

				// 데이터의 가장 처음으로 보내기
				rs.beforeFirst();
				while( rs.next() ){
					HashMap<String,String> paramMap = new HashMap<String,String>();

					String strTable = "";

					if ( rs.getString("log_table").equals("DRV_NOTICE") ) {
						strTable = "공지사항"; 
					} else if ( rs.getString("log_table").equals("DRV_KIND") ){
						strTable = "분류"; 
					} else if ( rs.getString("log_table").equals("DRV_MODEL") ){
						strTable = "모델"; 
					} else if ( rs.getString("log_table").equals("DRV_PART") ){
						strTable = "종류"; 
					} else if ( rs.getString("log_table").equals("DRV_TYPE") ){
						strTable = "구분"; 
					} else if ( rs.getString("log_table").equals("DRV_DRIVERS") ){
						strTable = "드라이버/소프트웨어"; 
					} else if ( rs.getString("log_table").equals("DRV_LINK") ){
						strTable = "모델별 드라이버"; 
					} else if ( rs.getString("log_table").equals("DRV_TOOLS") ){
						strTable = "툴 버전"; 
					}

					String strType = "";
					if ( rs.getString("log_type").equals("I") ) {
						strType = "신규"; 
					} else if ( rs.getString("log_type").equals("U") ){
						strType = "수정"; 
					} else if ( rs.getString("log_type").equals("D") ){
						strType = "삭제"; 
					}
					
					paramMap.put("strTable", strTable);
					paramMap.put("strType", strType);
					paramMap.put("log_deatail", rs.getString("log_detail"));
					paramMap.put("log_datetime", rs.getString("log_datetime"));
					
					result.add(paramMap);
					
					con.close();
				}
			}
		}catch(Exception e)
		{
			System.out.println(e.toString());
		}
		return result;

	}
	public void LogInsert_sql(HashMap<String,String> paraMap) {
		
		 String log_type=paraMap.get("log_type"); 
	     String log_table=paraMap.get("log_table");
	     String log_detail=paraMap.get("log_detail");
	     String log_code=paraMap.get("log_code");
	     
	     System.out.println("log_type : " + log_type);
	     System.out.println("log_table : " + log_table);
	     System.out.println("log_detail : " + log_detail);
	     System.out.println("log_code : " + log_code);
	         
	    DBManager db = new DBManager();
	        
	    //------------------------------- DRV_LOG 테이블 INSERT
	    try
	    {
	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

	        Connection con = db.dbConn();
	            
	        PreparedStatement pstmt=null ; //create statement
	        
	        String sql = "INSERT INTO DRV_LOG " + "\n"
				  	     + " ( log_idx, "  + "\n"
						 +	"   log_type, "  + "\n"
						 + "   log_table, "  + "\n"
						 + "   log_detail, "  + "\n"
						 + "   log_code, "  + "\n"
						 + "   log_datetime) "  + "\n"
			             + "VALUES "  + "\n"
			             + "( (SELECT log_idx FROM ( SELECT ifnull(max(log_idx)+1, 1) log_idx FROM DRV_LOG ) tmp ) , "  + "\n" // log_idx 
			             + "  ?, "  + "\n" // log_type
			             +  " ?, "  + "\n" // log_table
	       				 +  " ?, "  + "\n" // log_detail
	       				 +  " ?, "  + "\n" // log_code
			             + " now()  )";
	        
			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, log_type);
			pstmt.setString(2, log_table);
			pstmt.setString(3, log_detail);
			pstmt.setString(4, log_code);
	        
	        System.out.println(" insert 쿼리 확인 : ");
	        System.out.println( sql );
	        
			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}
	    }
	    catch(Exception e)
	    {
	        System.out.println(e.toString());
	    }
		
	}
}
