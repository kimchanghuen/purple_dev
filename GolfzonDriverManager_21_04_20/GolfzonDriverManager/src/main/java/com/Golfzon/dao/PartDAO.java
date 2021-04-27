package com.Golfzon.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.Golfzon.DBManager;

import com.Golfzon.dto.PartDTO;

public class PartDAO {

	public List<PartDTO> PartList() {

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			List<PartDTO> result = new ArrayList<PartDTO>();

			DBManager db = new DBManager();
			conn  = db.dbConn();

			pstmt = conn.prepareStatement( " SELECT p_idx, p_code, p_name, p_date, p_enable, p_update FROM DRV_PART WHERE p_enable < 2" );        

			rs = pstmt.executeQuery();


			// 데이터의 가장 끝으로 보내기
			rs.last();

			// rs.getRow() : 데이터의 가장 끝 index
			if ( rs.getRow() > 0 ) {

				rs.beforeFirst();

				while( rs.next() ){
					String strPname = rs.getString("p_name");
					strPname = strPname.replace("'", "\\\'"); 

					PartDTO part = new PartDTO();
					part.setP_idx(rs.getInt("p_idx"));
					part.setP_code(rs.getString("p_code"));
					part.setP_name(rs.getString("p_name"));
					part.setP_update(rs.getDate("p_update"));
					part.setP_enable(rs.getInt("p_enable"));
					part.setStrPname(strPname);
					result.add(part);
				}
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

	public void PartUpdate_sql(HashMap<String,String>paraMap) {


		String p_code = paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String p_name = paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String p_enable = paraMap.get("enable");

		String p_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT p_idx FROM DRV_PART WHERE p_code = '"+ p_code +"' ");        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			p_idx = rs.getString("p_idx");
			System.out.println("k_idx 값 확인 : " + p_idx);

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		// -----------------------------------------------
		// update log 넣기
		try
		{
			Connection con = db.dbConn();
			PreparedStatement pstmt=null ; //create statement  
			StringBuffer query = new StringBuffer();
			query.append( "  SELECT * " + "\n" +
					"    FROM DRV_PART " + "\n" +
					"  WHERE p_code = '"+ p_code +"' ");        

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			String bdfPname = rs.getString("p_name");
			String bdfPenable = rs.getString("p_enable");

			String logDetail = "코드명 '" + bdfPname + "' 의 ";

			if  ( !bdfPname.equals(p_name) ) {
				logDetail += "코드명이 '" + bdfPname + "' 에서 '" + p_name + "' 으로 " ;
			}

			if  ( !bdfPenable.equals(p_enable) ) {
				if (bdfPenable.equals("1"))
					bdfPenable = "사용";

				if (bdfPenable.equals("0"))
					bdfPenable = "미사용";

				String tmpEnable = p_enable;
				if (tmpEnable.equals("1"))
					tmpEnable = "사용";

				if (tmpEnable.equals("0"))
					tmpEnable = "미사용";

				logDetail += "사용여부가 '" + bdfPenable + "' 에서 '" + tmpEnable + "' 으로 " ;
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
				pstmt2.setString(2, "DRV_PART");
				pstmt2.setString(3, logDetail);
				pstmt2.setString(4, p_code);

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

		//------------------------------------------------------------ 

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = " UPDATE DRV_PART SET p_code = ? " + "\n"
					+ "  , p_name = ? "  + "\n"
					+	"  , p_update = now() "  + "\n"
					+ " , p_enable = ? "  + "\n"
					+ "  where p_idx = ? "  ; 

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, p_code);
			pstmt.setString(2, p_name);
			pstmt.setString(3, p_enable);
			pstmt.setString(4, p_idx);

			System.out.println(" DRV_PART update 쿼리 확인 : ");
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

	public void PartInsert_sql (HashMap<String,String>paraMap) {


		String p_code=paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String p_name=paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable

		String p_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT max(p_idx)+1 p_idx FROM DRV_PART " );        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			p_idx = rs.getString("p_idx");

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		// ------------------ max code 가져오기
		String new_p_code = "";
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( " select CONCAT('P',LPAD(MAX(substring(p_code, 2, 4)+1),3,0)) AS p_code from DRV_PART " );        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			new_p_code = rs.getString("p_code");

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

			String sql = "INSERT INTO DRV_PART " + "\n"
					+ " ( p_idx, "  + "\n"
					+	"   p_code, "  + "\n"
					+ "   p_name, "  + "\n"
					+ "   p_date, "  + "\n"
					+ "   p_enable) "  + "\n"
					+ "VALUES "  + "\n"
					+ "( ?, "  + "\n" // p_idx 
					+ "  ?, "  + "\n" // new_p_code
					+  " ?, "  + "\n" // p_name
					+  " now(), " + "\n" 
					+ " '1' )";

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, p_idx);
			pstmt.setString(2, new_p_code);
			pstmt.setString(3, p_name);

			System.out.println(" DRV_PART insert 쿼리 확인 : ");
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
			pstmt.setString(2, "DRV_PART"); // log_table
			pstmt.setString(3, "'" + p_name + "' 이(가) 신규 생성되었습니다."); // log_detail
			pstmt.setString(4, p_code); // log_code

			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

	}
	public void PartDelete_sql (HashMap<String,String>paraMap) {


		String p_code = paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String p_name = paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String p_enable = paraMap.get("enable");

		String p_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT p_idx FROM DRV_PART WHERE p_code = '"+ p_code +"' ");        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			p_idx = rs.getString("p_idx");
			System.out.println("k_idx 값 확인 : " + p_idx);

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

			StringBuffer query = new StringBuffer();
			query.append("UPDATE DRV_PART SET p_update = now(), p_enable = '2'  where p_idx = '" + p_idx + "'");        

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
			pstmt2.setString(2, "DRV_PART");
			pstmt2.setString(3, "코드명 '" + p_name + "' 이(가) 삭제되었습니다.");
			pstmt2.setString(4, p_code);

			if (pstmt2.executeUpdate() == 1) {
				// 정상완료
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
}
