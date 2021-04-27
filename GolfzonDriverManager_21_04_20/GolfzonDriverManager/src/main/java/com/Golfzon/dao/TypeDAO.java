package com.Golfzon.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.Golfzon.DBManager;
import com.Golfzon.dto.PartDTO;
import com.Golfzon.dto.TypeDTO;

public class TypeDAO {


	public List<TypeDTO> TypeList() {


		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			List<TypeDTO> result = new ArrayList<TypeDTO>();

			DBManager db = new DBManager();
			conn  = db.dbConn();

			pstmt = conn.prepareStatement( " SELECT t_idx, t_code, t_name, t_date, t_enable, t_update FROM DRV_TYPE WHERE t_enable < 2 " );        

			rs = pstmt.executeQuery();


			// 데이터의 가장 끝으로 보내기
			rs.last();

			// rs.getRow() : 데이터의 가장 끝 index
			if ( rs.getRow() > 0 ) {

				rs.beforeFirst();

				while( rs.next() ){
					String strTname = rs.getString("t_name");
					strTname = strTname.replace("'", "\\\'"); 

					TypeDTO type = new TypeDTO();
					type.setT_idx(rs.getInt("t_idx"));
					type.setT_code(rs.getString("t_code"));
					type.setT_name(rs.getString("t_name"));
					type.setT_update(rs.getDate("t_update"));
					type.setT_enable(rs.getInt("t_enable"));
					type.setStrTname(strTname);
					result.add(type);
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
	public void TypeUpdate_sql(HashMap<String,String>paraMap) {

		String t_code = paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String t_name = paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String t_enable = paraMap.get("enable");

		String t_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT t_idx FROM DRV_TYPE WHERE t_code = '"+ t_code +"' ");        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			t_idx = rs.getString("t_idx");

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		// ---------------------------------------------------------------------------------
		// update log 넣기 DRV_TYPE
		try
		{
			Connection con = db.dbConn();
			PreparedStatement pstmt=null ; //create statement  
			StringBuffer query = new StringBuffer();
			query.append( "  SELECT * " + "\n" +
					"    FROM DRV_TYPE " + "\n" +
					"  WHERE t_code = '"+ t_code +"' ");        

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			String bdfTname = rs.getString("t_name");
			String bdfTenable = rs.getString("t_enable");

			String logDetail = "코드명 '" + bdfTname + "' 의 ";

			if  ( !bdfTname.equals(t_name) ) {
				logDetail += "코드명이 '" + bdfTname + "' 에서 '" + t_name + "' 으로 " ;
			}

			if  ( !bdfTenable.equals(t_enable) ) {
				if (bdfTenable.equals("1"))
					bdfTenable = "사용";

				if (bdfTenable.equals("0"))
					bdfTenable = "미사용";

				String tmpEnable = t_enable;
				if (tmpEnable.equals("1"))
					tmpEnable = "사용";

				if (tmpEnable.equals("0"))
					tmpEnable = "미사용";

				logDetail += "사용여부가 '" + bdfTenable + "' 에서 '" + tmpEnable + "' 으로 " ;
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
				pstmt2.setString(2, "DRV_TYPE");
				pstmt2.setString(3, logDetail);
				pstmt2.setString(4, t_code);

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
		// --------------------------------------------

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = " UPDATE DRV_TYPE SET t_code = ? " + "\n"
					+ " , t_name = ? "  + "\n"
					+	" , t_update = now() "  + "\n"
					+ " , t_enable = ? "  + "\n"
					+ "  where t_idx = ? "; 

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, t_code);
			pstmt.setString(2, t_name);
			pstmt.setString(3, t_enable);
			pstmt.setString(4, t_idx);

			System.out.println(" DRV_TYPE update 쿼리 확인 : ");
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
	public void TypeInsert_sql(HashMap<String,String>paraMap) throws ClassNotFoundException {

		String t_code=paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String t_name=paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable

		String t_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT max(t_idx)+1 t_idx FROM DRV_TYPE " );        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			t_idx = rs.getString("t_idx");

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		// ------------------ max code 가져오기
		String new_t_code = "";
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( " select CONCAT('T',LPAD(MAX(substring(t_code, 2, 4)+1),3,0)) AS t_code from DRV_TYPE " );        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			new_t_code = rs.getString("t_code");

			con.close(); //close connection
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
			pstmt.setString(2, "DRV_TYPE"); // log_table
			pstmt.setString(3, "'" + t_name + "' 이(가) 신규 생성되었습니다."); // log_detail
			pstmt.setString(4, t_code); // log_code

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


		// -----------------------------------------------------------------

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = "INSERT INTO DRV_TYPE " + "\n"
					+ " ( t_idx, "  + "\n"
					+	"   t_code, "  + "\n"
					+ "   t_name, "  + "\n"
					+ "   t_date, "  + "\n"
					+ "   t_enable) "  + "\n"
					+ "VALUES "  + "\n"
					+ "( ?, "  + "\n" // t_idx 
					+ "  ?, "  + "\n" // new_t_code
					+  " ?, "  + "\n" // t_name
					+  " now(), " + "\n" 
					+ " '1' )";

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, t_idx);
			pstmt.setString(2, new_t_code);
			pstmt.setString(3, t_name);

			System.out.println(" DRV_TYPE insert 쿼리 확인 : ");
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
	public void TypeDelete_sql(HashMap<String,String>paraMap) {

		String t_code = paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String t_name = paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String t_enable = paraMap.get("enable");

		String t_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT t_idx FROM DRV_TYPE WHERE t_code = '"+ t_code +"' ");        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			t_idx = rs.getString("t_idx");

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
			query.append("UPDATE DRV_TYPE SET t_update = now(), t_enable = '2'  where t_idx = '" + t_idx + "'");        

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
			pstmt2.setString(2, "DRV_TYPE");
			pstmt2.setString(3, "코드명 '" + t_name + "' 이(가) 삭제되었습니다.");
			pstmt2.setString(4, t_code);

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
