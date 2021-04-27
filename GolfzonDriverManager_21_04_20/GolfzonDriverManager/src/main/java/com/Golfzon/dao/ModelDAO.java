package com.Golfzon.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.Golfzon.DBManager;
import com.Golfzon.dto.ModelDTO;

public class ModelDAO {
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	public List<ModelDTO> ModelList() {
		try{
			List<ModelDTO> result = new ArrayList<ModelDTO>();
			DBManager db = new DBManager();
			conn  = db.dbConn();

			pstmt = conn.prepareStatement("  SELECT A.m_idx " + "\n"
					+ "           , A.m_kind " + "\n"
					+ "           , B.k_name "  + "\n" 
					+ "           , A.m_code"  + "\n"
					+ "           , A.m_name"  + "\n"
					+ "           , A.m_date" + "\n"
					+ "           , A.m_enable"  + "\n"
					+ "           , A.m_update " + "\n"
					+ "   FROM DRV_MODEL A " + "\n"
					+ "           , DRV_KIND B " + "\n"
					+ "  WHERE A.m_enable < 2 " + "\n"
					+ "      AND B.k_enable = 1 "  + "\n" // KIND 사용중인 데이터만 조회 ( 0: 미사용, 1: 사용, 2: 삭제 )
					+ "      AND A.m_kind = B.k_code ");
			rs = pstmt.executeQuery();

			while(rs.next()){

				String strMname = rs.getString("m_name");
				strMname = strMname.replace("'", "\\\'"); 

				String strKname = rs.getString("k_name");
				ModelDTO model = new ModelDTO();


				model.setStrKname(strKname);
				model.setM_idx(rs.getInt("m_idx"));
				model.setM_kind(rs.getString("m_kind"));
				model.setM_code(rs.getString("m_code"));
				model.setM_name(rs.getString("m_name"));
				model.setM_date(rs.getDate("m_update"));
				model.setM_enable(rs.getInt("m_enable"));

				result.add(model);
			}

			return result;

		}catch(Exception e){
			e.printStackTrace();
			return null;
		}finally{
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}
	}

	public void ModelUpdate_sql (HashMap<String,String>paraMap) {


		String m_code=paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String m_name=paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String m_kind=paraMap.get("kind"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String m_enable=paraMap.get("enable"); 

		System.out.println("update sql 파라미터 확인");
		System.out.println("m_code : " + m_code);
		System.out.println("m_name : " + m_name);
		System.out.println("m_kind : " + m_kind);

		String m_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver


			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT m_idx FROM DRV_MODEL WHERE m_code = '"+ m_code +"' ");        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			m_idx = rs.getString("m_idx");
			System.out.println("m_idx 값 확인 : " + m_idx);

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}


		// update log 넣기
		try
		{
			Connection con = db.dbConn();
			PreparedStatement pstmt=null ; //create statement  
			StringBuffer query = new StringBuffer();
			query.append( "  SELECT * " + "\n" +
					"           , (select k_name from DRV_KIND WHERE k_code = m_kind) k_name " + "\n" +
					"           , (select k_name from DRV_KIND WHERE k_code = '" + m_kind + "' ) new_k_name " + "\n" +
					"    FROM DRV_MODEL " + "\n" +
					"  WHERE m_code = '"+ m_code +"' ");        
			System.out.println("쿼리 확인 : \n" + query.toString() );
			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			String bdfMkind = rs.getString("m_kind");
			String bdfMname = rs.getString("m_name");
			String bdfMenable = rs.getString("m_enable");
			String bdfKname = rs.getString("k_name");
			String aftKname = rs.getString("new_k_name");

			String logDetail = "코드명 '" + bdfMname + "' 의 ";

			if  ( !bdfMname.equals(m_name) ) {
				logDetail += "코드명이 '" + bdfMname + "' 에서 '" + m_name + "' 으로 " ;
			}

			if  ( !bdfMkind.equals(m_kind) ) {
				logDetail += "분류가 '" + bdfKname + "' 에서 '" + aftKname + "' 으로 " ;
			}

			if  ( !bdfMenable.equals(m_enable) ) {
				if (bdfMenable.equals("1"))
					bdfMenable = "사용";

				if (bdfMenable.equals("0"))
					bdfMenable = "미사용";

				String tmpEnable = m_enable;
				if (tmpEnable.equals("1"))
					tmpEnable = "사용";

				if (tmpEnable.equals("0"))
					tmpEnable = "미사용";

				logDetail += "사용여부가 '" + bdfMenable + "' 에서 '" + tmpEnable + "' 으로 " ;
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
				pstmt2.setString(2, "DRV_MODEL");
				pstmt2.setString(3, logDetail);
				pstmt2.setString(4, m_code);

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


		//------------------------------- select 하여 k_idx 가져오기
		System.out.println("k_idx 값 확인22 : " + m_idx);
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = " UPDATE DRV_MODEL SET m_code = ?" + "\n"
					+ " , m_name = ? "  + "\n"
					+	" , m_update = now() "  + "\n"
					+ " , m_kind = ? "  + "\n"
					+ " , m_enable = ? "  + "\n"
					+ "  WHERE m_idx = ?" ;

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, m_code);
			pstmt.setString(2, m_name);
			pstmt.setString(3, m_kind);
			pstmt.setString(4, m_enable);
			pstmt.setString(5, m_idx);

			System.out.println(" DRV_MODEL update 쿼리 확인 : ");
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
	public void ModelDelete_sql(HashMap<String,String>paraMap) {

		 String m_code=paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
	     String m_name=paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
	     String m_kind=paraMap.get("kind"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
	     String m_enable=paraMap.get("enable"); 
	         
	     System.out.println("update sql 파라미터 확인");
	     System.out.println("m_code : " + m_code);
	     System.out.println("m_name : " + m_name);
	     System.out.println("m_kind : " + m_kind);
	     
	     String m_idx = "";
	     
	     DBManager db = new DBManager();
	     
	    try
	    {
	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

	        Connection con = db.dbConn();
	            
	        PreparedStatement pstmt=null ; //create statement
			        
	        StringBuffer query = new StringBuffer();
	        query.append( "  SELECT m_idx FROM DRV_MODEL WHERE m_code = '"+ m_code +"' ");        
	        
	        System.out.println(" 쿼리 확인 : ");
	        System.out.println( query.toString() );
	        
			pstmt=con.prepareStatement( query.toString() );		
	        
	        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

	        // 데이터의 가장 끝으로 보내기
	        rs.last();
	        
	        m_idx = rs.getString("m_idx");
	    	System.out.println("m_idx 값 확인 : " + m_idx);
	    	
	        con.close(); //close connection
	    }
	    catch(Exception e)
	    {
	        System.out.println(e.toString());
	    }
	    
	    //------------------------------- select 하여 k_idx 가져오기
	    System.out.println("k_idx 값 확인22 : " + m_idx);
	    try
	    {
	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

	        Connection con = db.dbConn();
	            
	        PreparedStatement pstmt=null ; //create statement
			        
	        StringBuffer query = new StringBuffer();
	        query.append("UPDATE DRV_MODEL SET  m_update = now(), m_enable = '2'  where m_idx = '" + m_idx + "'");        
	        
	        System.out.println(" update 쿼리 확인 : ");
	        System.out.println( query.toString() );
	        
			pstmt=con.prepareStatement( query.toString() );
			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}
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
	   		pstmt2.setString(2, "DRV_MODEL");
	   		pstmt2.setString(3, "코드명 '" + m_name + "' 이(가) 삭제되었습니다.");
	   		pstmt2.setString(4, m_code);
	          
	   		if (pstmt2.executeUpdate() == 1) {
	   			// 정상완료
	   		}
	      }
	      catch(Exception e)
	      {
	          System.out.println(e.toString());
	      }
	}

	public void ModelInsert_sql(HashMap<String,String>paraMap) {

		
		 String m_code=paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
	     String m_name=paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
	     String m_kind=paraMap.get("kind"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
	              
	     String m_idx = "";
	     
	     DBManager db = new DBManager();
	     
	    try
	    {
	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

	        Connection con = db.dbConn();
	            
	        PreparedStatement pstmt=null ; //create statement
			        
	        StringBuffer query = new StringBuffer();
	        query.append( "  SELECT max(m_idx)+1 m_idx FROM DRV_MODEL " );        
	        
	        System.out.println(" 쿼리 확인 : ");
	        System.out.println( query.toString() );
	        
			pstmt=con.prepareStatement( query.toString() );		
	        
	        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

	        // 데이터의 가장 끝으로 보내기
	        rs.last();
	        
	        m_idx = rs.getString("m_idx");
	    	System.out.println("m_idx 값 확인 : " + m_idx);
	    	
	        con.close(); //close connection
	    }
	    catch(Exception e)
	    {
	        System.out.println(e.toString());
	    }

	    // ------------------ max code 가져오기
	    String new_m_code = "";
	    try
	    {
	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

	        Connection con = db.dbConn();
	            
	        PreparedStatement pstmt=null ; //create statement
			        
	        StringBuffer query = new StringBuffer();
	        query.append( " select CONCAT('M',LPAD(MAX(substring(m_code, 2, 4)+1),3,0)) AS m_code from DRV_MODEL " );        
	        
	        System.out.println(" 쿼리 확인 : ");
	        System.out.println( query.toString() );
	        
			pstmt=con.prepareStatement( query.toString() );		
	        
	        ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

	        // 데이터의 가장 끝으로 보내기
	        rs.last();
	        
	        new_m_code = rs.getString("m_code");
	    	
	        con.close(); //close connection
	    }
	    catch(Exception e)
	    {
	        System.out.println(e.toString());
	    }
	    // -----------------------------------------------------------------
	    
	    try
	    {
	        Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

	        Connection con = db.dbConn();
	            
	        PreparedStatement pstmt=null ; //create statement

	        String sql = "INSERT INTO DRV_MODEL " + "\n"
			  	     + " ( m_idx, "  + "\n"
					 +	"   m_kind, "  + "\n"
					 + "   m_code, "  + "\n"
					 + "   m_name, "  + "\n"
					 + "   m_date, "  + "\n"
					 + "   m_enable) "  + "\n"
		             + "VALUES "  + "\n"
		             + "( ?, "  + "\n" // m_idx 
		             + "  ?, "  + "\n" // m_kind
		             +  " ?, "  + "\n" // m_code
		             +  " ?, "  + "\n" // m_name
		             +  " now(), " + "\n" // m_date
		             + " '1' )";
	        
			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, m_idx);
			pstmt.setString(2, m_kind);
			pstmt.setString(3, m_code);
			pstmt.setString(4, m_name);
			
	        System.out.println(" DRV_MODEL insert 쿼리 확인 : ");
	        System.out.println( sql );

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
			pstmt.setString(2, "DRV_MODEL"); // log_table
			pstmt.setString(3, "'" + m_name + "' 이(가) 신규 생성되었습니다."); // log_detail
			pstmt.setString(4, m_code); // log_code
	        
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

