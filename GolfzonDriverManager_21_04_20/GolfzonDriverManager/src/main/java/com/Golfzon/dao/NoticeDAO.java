package com.Golfzon.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.Golfzon.DBManager;
import com.Golfzon.dto.NoticeDTO;
import com.Golfzon.dto.ToolDTO;

public class NoticeDAO {

	NoticeDTO noticedto;

	public List<NoticeDTO> serchNotice(HashMap<String,String> paraMap) {


		List<NoticeDTO> list = new ArrayList<NoticeDTO>();
		String type = paraMap.get("type");
		String value = paraMap.get("value");

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
			DBManager db = new DBManager();

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();

			query.append( " SELECT n_idx " + "\n"
					+ "           , n_type "  + "\n"
					+ "           , n_title "  + "\n"
					+ "           , n_body "  + "\n"
					+ "           , n_startdate "  + "\n"
					+ "           , n_enddate "  + "\n"
					+ "           , n_date "  + "\n"
					+ "           , n_update "  + "\n"
					+ "           , n_enable "  + "\n"
					+ "           , n_memo "  + "\n"
					+ "  FROM DRV_NOTICE " + "\n" 
					+ " WHERE 1=1 " + "\n"
					+ " AND     n_enable < '3' ");        

			if( type.equals("1") && ( !value.equals("") ) ) { // 조회 조건 값 : 제목
				query.append(" AND n_title like '%" + value + "%' ");
			}

			if( type.equals("2") && ( !value.equals("") )  )  { // 조회 조건 값 : 내용
				query.append(" AND n_body like '%" + value + "%' ");
				// params.add(model);
			}

			query.append(" ORDER BY n_idx ");

			pstmt=con.prepareStatement( query.toString() );
			/*
				for (int i= 0; i<params.size(); i++) {
					pstmt.setString(i+1, params.get(i).toString() );
				}
			 */

			System.out.println(" notice select 쿼리 확인 : ");
			System.out.println( pstmt.toString() );

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			// rs.getRow() : 데이터의 가장 끝 index
			if ( rs.getRow() > 0 ) {

				// 데이터의 가장 처음으로 보내기
				rs.beforeFirst();

				while( rs.next() ){

					noticedto = new NoticeDTO();
					String result = "";
					if ( rs.getString("n_enable").equals("1") ) {
						result = "미공지";
					} else if ( rs.getString("n_enable").equals("2") ) {
						result = "공지중";
					}

					String resultBody = rs.getString("n_body"); // 실제 핸들링 할 데이터
					String titleBody = rs.getString("n_body");

					// if ( rs.getString("n_body").contains("\\r\\n")) {
					if ( resultBody.contains("\\r\\n")) {

						titleBody = titleBody.replace("\\r\\n", "&#13;");
						resultBody = resultBody.replace("\\r\\n", " ");
						resultBody = resultBody.replace("'", "\\\'"); 	        		
					} 


					noticedto.setN_title(rs.getString("n_title"));
					noticedto.setTitleBody(titleBody);
					noticedto.setResultBody(resultBody);
					noticedto.setN_enable(result);
					noticedto.setN_date(rs.getDate("n_date"));
					noticedto.setN_update(rs.getDate("n_update"));
					noticedto.setN_idx(rs.getInt("n_idx"));
					noticedto.setN_startdate(rs.getDate("n_startdate"));
					noticedto.setN_enddate(rs.getDate("n_enddate"));

					list.add(noticedto);
				} 
			} else {
				// 데이터가 없을 시

			}



			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
		return list;


	}
	public void NoticeInsert_sql(HashMap<String,String> paraMap) {


		System.out.println("2");
		String n_title = paraMap.get("n_title");
		String n_body = paraMap.get("n_body");
		String n_enable = paraMap.get("n_enable");
		String n_idx = "";

		DBManager db = new DBManager();

		if ( n_enable.equals("2") ) { // 완료여부가 '공지완료' 상태일 시, 다른 데이터들은 모두 '미공지' 상태로 변경
			try
			{
				Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

				Connection con = db.dbConn();

				PreparedStatement pstmt=null ; //create statement

				String sql = "UPDATE DRV_NOTICE SET n_enable = 1"
						+ ", n_update = now()"
						+ " where 1=1 " 
						+ " AND   n_enable != '3' "; // 삭제된 데이터

				pstmt = con.prepareStatement( sql );

				if (pstmt.executeUpdate() == 1) {
					// 정상완료
				}
			}
			catch(Exception e)
			{
				System.out.println(e.toString());
			}

		}


		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT ifnull(max(n_idx)+1, '0') n_idx FROM DRV_NOTICE " );        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			n_idx = rs.getString("n_idx");
			System.out.println("n_idx 값 확인 : " + n_idx);

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		//------------------------------- select 하여 n_idx 가져오기
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = "INSERT INTO DRV_NOTICE " + "\n"
					+ " ( n_idx, "  + "\n"
					+	"   n_title, "  + "\n"
					+ "   n_body, "  + "\n"
					+ "   n_date, "  + "\n"
					+ "   n_enddate, "  + "\n"
					+ "   n_update, "  + "\n"
					+ "   n_startdate, "  + "\n"
					+ "   n_enable, "  + "\n"
					+ "   n_type, "  + "\n"
					+ "   n_memo) "  + "\n"
					+ "VALUES "  + "\n"
					+ "( ?, "  + "\n" // n_idx 
					+ "  ?, "  + "\n" // n_title
					+  " ?, "  + "\n" // n_body
					+  " now(), " + "\n" // n_date
					+  " now(), " + "\n" // n_enddate
					+  " now(), " + "\n" // n_update
					+  " now(), " + "\n" // n_startdate
					+  " ?, "  + "\n" // n_enable
					+  " 'N000', "  + "\n" // n_type
					+  " '' ) ";// n_memo

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, n_idx);
			pstmt.setString(2, n_title);
			pstmt.setString(3, n_body);
			pstmt.setString(4, n_enable);

			System.out.println(" insert 쿼리 확인 : ");
			System.out.println( sql );

			System.out.println("n_body in sql : " + n_body);

			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}


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
			pstmt.setString(1, "I"); // log_type
			pstmt.setString(2, "DRV_NOTICE"); // log_table
			pstmt.setString(3, "'" + n_title + "' 이(가) 신규 생성되었습니다."); // log_detail
			pstmt.setString(4, n_idx); // log_code

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
	public void NoticeDelete_sql(String n_idx) {
		
		
		
		 
	     System.out.println(" DELETE SQL in d_code : " + n_idx);

	     DBManager db = new DBManager();
	     
	    try
	    {
	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

	        Connection con = db.dbConn();
	            
	        PreparedStatement pstmt=null ; //create statement
			
	        String sql = "UPDATE DRV_NOTICE SET "
	                + "n_update = now()"
	                + ", n_enable ='3' "
	                + " where n_idx = ?" ;
	        
			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, n_idx);

			System.out.println("delete 쿼리 확인 : " + pstmt.toString());

			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}
			
	    }
	    catch(Exception e)
	    {
	        System.out.println(e.toString());
	    }
	    
	    String bdfNtitle = "";
	    try
	    {
	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

	        Connection con = db.dbConn();
	            
	        PreparedStatement pstmt=null ; //create statement
			
	        StringBuffer query = new StringBuffer();
	        query.append( "  SELECT * FROM DRV_NOTICE WHERE n_idx = '"+ n_idx +"' ");        
	                
			pstmt=con.prepareStatement( query.toString() );		
	        
	        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

	        // 데이터의 가장 끝으로 보내기
	        rs.last();
	        
	        // 제목
	        bdfNtitle = rs.getString("n_title");        
			
			
	    }
	    catch(Exception e)
	    {
	        System.out.println(e.toString());
	    }
	    
	    
	    // ------------------------------------------------------------------------------------
	    //------------------------------- DRV_LOG 테이블 INSERT
	    try
	      {
	          Connection con2 = db.dbConn();
	              
	          PreparedStatement pstmt2=null ; //create statement
	          
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
	          
	   		pstmt2 = con2.prepareStatement( sql );
	   		pstmt2.setString(1, "D");
	   		pstmt2.setString(2, "DRV_NOTICE");
	   		pstmt2.setString(3, "제목 '" + bdfNtitle + "' 이(가) 삭제되었습니다.");
	   		pstmt2.setString(4, n_idx);
	          
	   		if (pstmt2.executeUpdate() == 1) {
	   			// 정상완료
	   		}
	      }
	      catch(Exception e)
	      {
	          System.out.println(e.toString());
	      }
		
		
	}
	public void NoticeUpdate_sql(HashMap<String,String> paraMap) {
		
		
		  String n_idx= paraMap.get("n_idx");
		     String n_title= paraMap.get("n_title");
		     String n_body= paraMap.get("n_body");
		     String n_enable= paraMap.get("n_enable");
		     
		     DBManager db = new DBManager();
		     
		     if ( n_enable.equals("2") ) { // 완료여부가 '공지완료' 상태일 시, 다른 데이터들은 모두 '미공지' 상태로 변경
		    	 try
		    	    {
		    	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

		    	        Connection con = db.dbConn();
		    	            
		    	        PreparedStatement pstmt=null ; //create statement
		    			
		    	        String sql = "UPDATE DRV_NOTICE SET n_enable = 1"
		    	                + ", n_update = now()"
		    	                + " where n_idx != ?" 
		    	                + " AND   n_enable != '3' "; // 삭제된 데이터
		    	        
		    			pstmt = con.prepareStatement( sql );
		    			pstmt.setString(1, n_idx);
		    			
		    			if (pstmt.executeUpdate() == 1) {
		    				// 정상완료
		    			}
		    	    }
		    	    catch(Exception e)
		    	    {
		    	        System.out.println(e.toString());
		    	    }
		    	 
		     }
		    
		     // ---------------------------------------------------------------------------------------
		     // update log 넣기 DRV_NOTICE
		    try
		    {
		        Connection con = db.dbConn();
		        PreparedStatement pstmt=null ; //create statement  
		        StringBuffer query = new StringBuffer();
		        query.append( "  SELECT * FROM DRV_NOTICE WHERE n_idx = '"+ n_idx +"' ");        
		                
				pstmt=con.prepareStatement( query.toString() );		
		        
		        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

		        // 데이터의 가장 끝으로 보내기
		        rs.last();
		        
		        // 제목
		        String bdfNtitle = rs.getString("n_title");
		        
		        // 내용
		        String bdfNbody = rs.getString("n_body");
		        
		        // 완료여부
		        String bdfNenable = rs.getString("n_enable");
		        
		        String logDetail = "제목 '" + bdfNtitle + "' 의 ";
		        if  ( !bdfNtitle.equals(n_title) ) {
		        	logDetail += "제목이 '" + bdfNtitle + "' 에서 '" + n_title + "' 으로 " ;
		        }
		        
		        if  ( !bdfNbody.equals(n_body) ) {
		        	logDetail += "내용이 (변경전 '" + bdfNbody + "' ) " ;
		        }
		        
		        if  ( !bdfNenable.equals(n_enable) ) {
		        	if (bdfNenable.equals("1"))
		        		bdfNenable = "미공지";
		        	
		        	if (bdfNenable.equals("2"))
		        		bdfNenable = "공지중";
		        	
		        	String tmpEnable = n_enable;
		        	if (tmpEnable.equals("1"))
		        		tmpEnable = "미공지";
		        	
		        	if (tmpEnable.equals("2"))
		        		tmpEnable = "공지중";
		        	
		        	logDetail += "사용여부가 '" + bdfNenable + "' 에서 '" + tmpEnable + "' 으로 " ;
		        }
		        logDetail += "변경되었습니다. ";
		        
		        
		        //------------------------------- DRV_LOG 테이블 INSERT
		        try
		        {

		            Connection con2 = db.dbConn();
		                
		            PreparedStatement pstmt2=null ; //create statement
		            
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
		            
		    		pstmt2 = con2.prepareStatement( sql );
		    		pstmt2.setString(1, "U");
		    		pstmt2.setString(2, "DRV_NOTICE");
		    		pstmt2.setString(3, logDetail);
		    		pstmt2.setString(4, n_idx);
		            
		    		if (pstmt2.executeUpdate() == 1) {
		    			// 정상완료
		    		}
		        }
		        catch(Exception e)
		        {
		            System.out.println(e.toString());
		        }
		        
		        
		        con.close(); //close connection
		    }
		    catch(Exception e)
		    {
		        System.out.println(e.toString());
		    }
		  
		     
		    try
		    {
		        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

		        Connection con = db.dbConn();
		            
		        PreparedStatement pstmt=null ; //create statement
				
		        String sql = "UPDATE DRV_NOTICE SET n_title = ?"
		                + ", n_update = now()"
		                + ", n_body =?"
		                + ", n_enable =?"
		                + " where n_idx = ?" ;
		        
				pstmt = con.prepareStatement( sql );
				pstmt.setString(1, n_title);
				pstmt.setString(2, n_body);
				pstmt.setString(3, n_enable);
				pstmt.setString(4, n_idx);
				
				System.out.println("update 쿼리 확인 : " + pstmt.toString());

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
