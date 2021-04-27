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
import com.Golfzon.dto.KindDTO;


public class KindDAO {
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	// Kind 리스트 조회
	public List<KindDTO> getKindList() {
		try{
			List<KindDTO> result = new ArrayList<KindDTO>();
			DBManager db = new DBManager();
			conn  = db.dbConn();
			pstmt = conn.prepareStatement("SELECT k_idx, k_code, k_name, k_date, k_enable FROM DRV_KIND WHERE k_enable < 2");
			rs = pstmt.executeQuery();

			while(rs.next()){
				KindDTO kind = new KindDTO();
				kind.setK_idx(rs.getInt("k_idx"));
				kind.setK_code(rs.getString("k_code"));
				kind.setK_name(rs.getString("k_name"));
				kind.setK_date(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(rs.getString("k_date")));
				kind.setK_enable(rs.getInt("k_enable"));
				result.add(kind);
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

	// KIND insert시 신규 코드 생성
	public String getLastKcode(){
		try {
			DBManager db = new DBManager();
			conn = db.dbConn();
			pstmt = conn.prepareStatement( "select LPAD(MAX(substring(k_code, 2, 4)+1),3,0) AS k_code from DRV_KIND");
			rs = pstmt.executeQuery();

			String strKcode = "";
			if( rs.next() ) {
				strKcode = rs.getString("k_code");
			}

			return strKcode;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	// KIND INSERT
	public boolean addKcode(KindDTO kind){
		try {
			DBManager db = new DBManager();
			conn = db.dbConn();
			pstmt = conn.prepareStatement( 
					"INSERT INTO DRV_KIND "
							+ " (k_idx, k_code, k_name, k_date, k_enable) "
							+ "VALUES ( (SELECT k_idx FROM (SELECT max(k_idx)+1 k_idx FROM DRV_KIND ) TEMP) ,?,?, now(), '1')"  );

			System.out.println("code : " + kind.getK_code());
			System.out.println("name : " + kind.getK_name());
			pstmt.setString(1, kind.getK_code()); // k_code
			pstmt.setString(2, kind.getK_name()); // k_name			

			if(pstmt.executeUpdate() == 1){
				return true;
			}

			return false;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}finally{
			if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
			if (conn != null) try { conn.close(); } catch(SQLException ex) {}
		}

	}

	public void KindUpdate_sql(HashMap<String,String>paraMap){

		String k_code= paraMap.get("code"); 
		String k_name= paraMap.get("name"); 
		String k_enable= paraMap.get("enable"); 

		System.out.println("update sql 파라미터 확인");
		System.out.println("k_code : " + k_code);
		System.out.println("k_name : " + k_name);
		System.out.println("k_enable : " + k_enable);

		String k_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT k_idx FROM DRV_KIND WHERE k_code = '"+ k_code +"' ");        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			k_idx = rs.getString("k_idx");
			System.out.println("k_idx 값 확인 : " + k_idx);

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
			query.append( "  SELECT * FROM DRV_KIND WHERE k_code = '"+ k_code +"' ");        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			String bdfKname = rs.getString("k_name");
			String bdfKenable = rs.getString("k_enable");

			String logDetail = "코드명 '" + bdfKname + "' 의 ";

			if  ( !bdfKname.equals(k_name) ) {
				logDetail += "코드명이 '" + bdfKname + "' 에서 '" + k_name + "' 으로 " ;
			}

			if  ( !bdfKenable.equals(k_enable) ) {
				if (bdfKenable.equals("1"))
					bdfKenable = "사용";

				if (bdfKenable.equals("0"))
					bdfKenable = "미사용";

				String tmpEnable = k_enable;
				if (tmpEnable.equals("1"))
					tmpEnable = "사용";

				if (tmpEnable.equals("0"))
					tmpEnable = "미사용";

				logDetail += "사용여부가 '" + bdfKenable + "' 에서 '" + tmpEnable + "' 으로 " ;
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
				pstmt2.setString(2, "DRV_KIND");
				pstmt2.setString(3, logDetail);
				pstmt2.setString(4, k_code);

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

		//------------------------------- DRV_KIND UPDATE
		System.out.println("k_idx 값 확인22 : " + k_idx);
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = "UPDATE DRV_KIND SET" + "\n"
					+ " k_code = ?, "  + "\n"
					+	" k_name = ?, "  + "\n"
					+ " k_enable = ?, "  + "\n"
					+ " k_update = now() "  + "\n"
					+ " WHERE k_idx = ? " ;

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, k_code);
			pstmt.setString(2, k_name);
			pstmt.setString(3, k_enable);
			pstmt.setString(4, k_idx);

			System.out.println(" update 쿼리 확인 : ");
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

	public void Kindinsert_sql(HashMap<String,String>paraMap) {

		String k_code=paraMap.get("code"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String k_name=paraMap.get("name"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable

		System.out.println("k_code : " + k_code);
		System.out.println("k_name : " + k_name);

		String k_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT max(k_idx)+1 k_idx FROM DRV_KIND " );        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			k_idx = rs.getString("k_idx");
			System.out.println("k_idx 값 확인 : " + k_idx);

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		String new_k_code = "";
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( " select CONCAT('K',LPAD(MAX(substring(k_code, 2, 4)+1),3,0)) AS k_code from DRV_KIND " );        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			new_k_code = rs.getString("k_code");

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		//------------------------------- DRV_KIND 테이블 INSERT
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = "INSERT INTO DRV_KIND " + "\n"
					+ " ( k_idx, "  + "\n"
					+	"   k_code, "  + "\n"
					+ "   k_name, "  + "\n"
					+ "   k_date, "  + "\n"
					+ "   k_enable) "  + "\n"
					+ "VALUES "  + "\n"
					+ "( ?, "  + "\n" // k_idx 
					+ "  ?, "  + "\n" // k_code
					+  " ?, "  + "\n" // k_name
					+  " now(), " + "\n" 
					+ " '1' )";

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, k_idx);
			pstmt.setString(2, new_k_code);
			pstmt.setString(3, k_name);

			System.out.println(" update 쿼리 확인 : ");
			System.out.println( pstmt.toString() );

			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
	public void KindDelete_sql(HashMap<String,String>paraMap) {

		String k_code=paraMap.get("code"); 
		String k_name=paraMap.get("name"); 
		String k_enable=paraMap.get("enable"); 

		System.out.println("update sql 파라미터 확인");
		System.out.println("k_code : " + k_code);
		System.out.println("k_name : " + k_name);
		System.out.println("k_enable : " + k_enable);

		String k_idx = "";

		DBManager db = new DBManager();

		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( "  SELECT k_idx FROM DRV_KIND WHERE k_code = '"+ k_code +"' ");        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			k_idx = rs.getString("k_idx");
			System.out.println("k_idx 값 확인 : " + k_idx);

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}


		//------------------------------- select 하여 k_idx 가져오기
		System.out.println("k_idx 값 확인22 : " + k_idx);
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append("UPDATE DRV_KIND SET k_update = now(), k_enable = '2'  where k_idx = '" + k_idx + "'");        
			
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
			pstmt2.setString(2, "DRV_KIND");
			pstmt2.setString(3, "코드명 '" + k_name + "' 이(가) 삭제되었습니다.");
			pstmt2.setString(4, k_code);

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
