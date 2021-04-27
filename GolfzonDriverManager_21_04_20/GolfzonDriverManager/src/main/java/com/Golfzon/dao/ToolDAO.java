package com.Golfzon.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.Golfzon.DBManager;
import com.Golfzon.dto.ToolDTO;

public class ToolDAO {

	public List<ToolDTO> ToolList() {
		List<ToolDTO> list = new ArrayList<ToolDTO>();

		try {

			Class.forName("com.mysql.cj.jdbc.Driver");
			DBManager db = new DBManager();
			Connection conn = null;
			ResultSet rs = null;
			PreparedStatement pstmt = null;

			conn = db.dbConn();

			// BINARY : 대소문자 구분
			String sql = " SELECT tool_idx"
					+ " , tool_code"
					+ " , tool_name"
					+ " , tool_version"
					+ " , tool_filename"
					+ " , tool_exec"
					+ " , tool_url"
					+ " , tool_enable"
					+ " , tool_datetime"
					+  " FROM DRV_TOOLS ";


			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();


			while(rs.next()) {	

				ToolDTO tooldto = new ToolDTO();
				tooldto.setTool_idx(rs.getInt("tool_idx"));
				tooldto.setTool_name(rs.getString("tool_name"));
				tooldto.setTool_code(rs.getString("tool_code"));
				tooldto.setTool_version(rs.getString("tool_version"));
				tooldto.setTool_filename(rs.getString("tool_filename"));
				tooldto.setTool_exec(rs.getString("tool_exec"));
				tooldto.setTool_url(rs.getString("tool_url"));
				tooldto.setTool_datetime(rs.getDate("tool_datetime"));
				String strUse = "";

				if(rs.getString("tool_enable").equals("1")) {
					strUse = "사용";
				}else {
					strUse = "미사용";
				}
				tooldto.setTool_enable(strUse);
				list.add(tooldto);
			}


		}catch(Exception e) {
			System.out.println("error : " + e.toString());

		}

		return list;
	}

	public void ToolInsert_sql(HashMap<String,String> paraMap) throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
		DBManager db = new DBManager();

		String enable = paraMap.get("enable");

		if(enable.equals("1")) {

			Connection con = db.dbConn();
			PreparedStatement pstmt=null ;
			String sql = "UPDATE DRV_TOOLS SET tool_enable = 0"
					+ ", tool_updatetime = now()"
					+ " where 1=1 " ; 
			pstmt = con.prepareStatement( sql );
			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}
		}
		String new_t_code = "";
		try
		{
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( " SELECT CONCAT('T',LPAD(MAX(substring(tool_code, 2, 6)+1),5,0)) AS tool_code, MAX(tool_idx)+1 tool_idx  FROM DRV_TOOLS " );        

			System.out.println(" 쿼리 확인 : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			new_t_code = rs.getString("tool_code");

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
		try
		{
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = "INSERT INTO DRV_TOOLS " + "\n"
					+ " ( tool_idx, "  + "\n"
					+	"   tool_code, "  + "\n"
					+ "   tool_name, "  + "\n"
					+ "   tool_version, "  + "\n"
					+ "   tool_exec, "  + "\n"
					+ "   tool_datetime, "  + "\n"
					+ "   tool_enable) "  + "\n"
					+ "VALUES "  + "\n"
					+ "( (SELECT tool_idx FROM ( SELECT MAX(tool_idx)+1 tool_idx FROM DRV_TOOLS ) tmp ) , "  + "\n" // tool_idx 
					+ "  ?, "  + "\n" // new_t_code
					+  " ?, "  + "\n" // name
					+  " ?, " + "\n" // version
					+  " ?, " + "\n" // tool_exec
					+  " now(), " + "\n" // tool_datetime
					+  " ? ) ";// tool_enable

			System.out.println( " tool insert 쿼리 확인 : " + sql);
			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, new_t_code);
			pstmt.setString(2, paraMap.get("name"));
			pstmt.setString(3, paraMap.get("version"));
			pstmt.setString(4, paraMap.get("exec"));
			pstmt.setString(5, enable);


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
		try
		{
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
			pstmt.setString(2, "DRV_TOOLS"); // log_table

			String strEnable = "";

			if ( enable.equals("1") ) {
				strEnable = "사용";
			} else if ( enable.equals("0") ) {
				strEnable = "미사용";
			}

			pstmt.setString(3, "사용여부가 '" + strEnable + "' 인 '" + paraMap.get("name") + "' 이(가) 신규 생성되었습니다."); // log_detail
			pstmt.setString(4, new_t_code); // log_code

			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}
			System.out.println("insert 완료");
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
	public void FileUploadTool(HashMap<String,String> paraMap) throws ClassNotFoundException {


		String tool_idx = paraMap.get("tool_idx");
		String tool_hash = paraMap.get("strCRC32");
		String tool_filesize = paraMap.get("strSize");
		String tool_filename = paraMap.get("newFileName");

		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
		DBManager db = new DBManager();

		String tool_code = "";

		// ---------------------------------------------------------------------------------
		// update log 넣기 DRV_MODEL
		try
		{
			Connection con = db.dbConn();
			PreparedStatement pstmt=null ; //create statement  
			StringBuffer query = new StringBuffer();
			query.append( "  SELECT * " + "\n" +
					"    FROM DRV_TOOLS " + "\n" +
					"  WHERE tool_idx = '"+ tool_idx +"' ");        
			System.out.println("file upload 관련 쿼리 : " + query.toString() );
			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			tool_code = rs.getString("tool_code");
			String befToolname = rs.getString("tool_name");

			String logDetail = "'" + befToolname + "' 의 ";


			// 해쉬코드
			String befToolhash = rs.getString("tool_hash");
			if  ( !befToolhash.equals(tool_hash) ) {
				// logDetail += "해쉬코드가 '" + bdfDhash + "' 에서 '" + d_hash + "' 으로 " ;
			}

			// 파일용량
			String befToolsize = rs.getString("tool_filesize");
			if  ( !befToolsize.equals(tool_filesize) ) {
				// logDetail += "파일용량이 '" + bdfDsize + "' 에서 '" + d_filesize + "' 으로 " ;
			}

			// 파일이름
			String befToolfilename = rs.getString("tool_filename");
			if  ( !befToolfilename.equals(tool_filename) ) {
				logDetail += "파일이 '" + befToolfilename + "' 에서 '" + tool_filename + "' 으로 " ;
			}
			// url
			String strUrl_log = "/Tools/" + tool_filename ;
			String befToolurl = rs.getString("tool_url");
			if  ( !befToolfilename.equals(tool_filename) ) {
				// logDetail += "url이 '" + befToolurl + "' 에서 '" + strUrl_log + "' 으로 " ;
			}

			logDetail += "변경되었습니다. ";

			if ( !logDetail.equals("'" + befToolname + "' 의 변경되었습니다. ") ) {

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
					pstmt2.setString(2, "DRV_TOOLS");
					pstmt2.setString(3, logDetail);
					pstmt2.setString(4, tool_code);

					if (pstmt2.executeUpdate() == 1) {
						// 정상완료
					}
				}
				catch(Exception e)
				{
					System.out.println(e.toString());
				}
			}

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
		// ----------------------------------------------------------	   

		try
		{
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			// String strUrl = "/version/" + tool_filename ;
			String strUrl = "/Tools/" + tool_filename ;

			String sql = " UPDATE DRV_TOOLS SET tool_hash = ? " + "\n"
					+ "  , tool_filesize = ? "  + "\n"
					+	"  , tool_filename =  ? "  + "\n"
					+ "  , tool_updatetime = now()"  + "\n"
					+ "  , tool_url = ? "  + "\n"
					+ " WHERE tool_idx = ? " ;

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, tool_hash);
			pstmt.setString(2, tool_filesize);
			pstmt.setString(3, tool_filename);
			pstmt.setString(4, strUrl);
			pstmt.setString(5, tool_idx);

			System.out.println(" update 쿼리 확인하자 : ");
			System.out.println( "file"+sql );

			if (pstmt.executeUpdate() == 1) {
				// 정상완료
			}

		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

	}
	public void ToolUpdate_sql(HashMap<String,String> paraMap) throws ClassNotFoundException {


		String tool_idx= paraMap.get("tool_idx"); 
		String tool_code= paraMap.get("tool_code");
		String tool_name= paraMap.get("tool_name");
		String tool_version= paraMap.get("tool_version");
		String tool_exec= paraMap.get("tool_exec");
		String tool_enable= paraMap.get("tool_enable");

		DBManager db = new DBManager();
		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

		if ( tool_enable.equals("1") ) { // 완료여부가 '공지완료' 상태일 시, 다른 데이터들은 모두 '미공지' 상태로 변경
			try
			{
				Connection con = db.dbConn();

				PreparedStatement pstmt=null ; //create statement

				String sql = "UPDATE DRV_TOOLS SET tool_enable = 0"
						+ ", tool_updatetime = now()"
						+ " where tool_idx != ?" ;

				pstmt = con.prepareStatement( sql );
				pstmt.setString(1, tool_idx);

				System.out.println("다른데이터 update 쿼리 확인 : " + pstmt.toString());

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
			Connection con = db.dbConn();
			PreparedStatement pstmt=null ; //create statement  
			StringBuffer query = new StringBuffer();
			query.append( "  SELECT * " + "\n" +
					"    FROM DRV_TOOLS " + "\n" +
					"  WHERE tool_code = '"+ tool_code +"' ");        

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			// 제목
			String befToolname = rs.getString("tool_name");

			String logDetail = "'" + befToolname + "' 의 ";

			if  ( !befToolname.equals(tool_name) ) {
				logDetail += "제목이 '" + befToolname + "' 에서 '" + tool_name + "' 으로 " ;
			}

			// 사용여부
			String befToolenable = rs.getString("tool_enable");

			if  ( !befToolenable.equals(tool_enable) ) {
				if (befToolenable.equals("1"))
					befToolenable = "사용";

				if (befToolenable.equals("0"))
					befToolenable = "미사용";

				String tmpEnable = tool_enable;
				if (tmpEnable.equals("1"))
					tmpEnable = "사용";

				if (tmpEnable.equals("0"))
					tmpEnable = "미사용";

				logDetail += "사용여부가 '" + befToolenable + "' 에서 '" + tmpEnable + "' 으로 " ;
			}

			// 버전
			String befVersion = rs.getString("tool_version");
			if  ( !befVersion.equals(tool_version) ) {
				logDetail += "버전이 '" + befVersion + "' 에서 '" + tool_version + "' 으로 " ;
			}

			// 실행파일
			String befToolexec = rs.getString("tool_exec");
			if  ( !befToolexec.equals(tool_exec) ) {
				logDetail += "실행파일이 '" + befToolexec + "' 에서 '" + tool_exec + "' 으로 " ;
			}                            

			logDetail += "변경되었습니다. ";

			if ( !logDetail.equals("'" + befToolname + "' 의 변경되었습니다. ") ) {
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
					pstmt2.setString(2, "DRV_TOOLS");
					pstmt2.setString(3, logDetail);
					pstmt2.setString(4, tool_code);

					if (pstmt2.executeUpdate() == 1) {
						// 정상완료
					}
				}
				catch(Exception e)
				{
					System.out.println(e.toString());
				}

			}
			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		// ------------------------------------------------------------------

		try
		{
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = "UPDATE DRV_TOOLS SET tool_name = ?"
					+ ", tool_updatetime = now()"
					+ ", tool_version =?"
					+ ", tool_exec =?"
					+ ", tool_enable =?"
					+ " where tool_idx = ?" ;

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, tool_name);
			pstmt.setString(2, tool_version);
			pstmt.setString(3, tool_exec);
			pstmt.setString(4, tool_enable);
			pstmt.setString(5, tool_idx);

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
	public void fileDelete_tool(HashMap<String,String> paraMap) throws ClassNotFoundException {

		
	 System.out.println("삭제넘어옴?");
		String tool_code= paraMap.get("tool_code");
		String tool_name= paraMap.get("tool_name");

		System.out.println(" DELETE SQL in tool_code : " + tool_code);

		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
		DBManager db = new DBManager();

		// ------------------------------------------------------------------------------------
		//------------------------------- DRV_LOG 테이블 INSERT
		try {

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
			pstmt2.setString(2, "DRV_TOOLS");
			pstmt2.setString(3, "툴 '" + tool_name + "' 이(가) 삭제되었습니다.");
			pstmt2.setString(4, tool_code);

			if (pstmt2.executeUpdate() == 1) {
				// 정상완료
			}
		} catch(Exception e) {
			System.out.println(e.toString());
		}

		try
		{
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = "DELETE FROM DRV_TOOLS WHERE tool_code = '"+tool_code+"' ";

			pstmt = con.prepareStatement( sql );
			// pstmt.setString(1, d_code);

			System.out.println("delete 쿼리 확인 : " + pstmt.toString());

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
