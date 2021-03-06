package com.Golfzon.dao;

import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.Golfzon.DBManager;
import com.Golfzon.dto.DriverDTO;
import com.Golfzon.dto.TypeDTO;

public class DriverDAO {

	public List<DriverDTO> DriverList(String type){
		PreparedStatement pstmt=null ; //create statement
		Connection conn = null;
		try
		{
			List<DriverDTO> result = new ArrayList<DriverDTO>();
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
			DBManager db = new DBManager();

			Connection con = db.dbConn();



			StringBuffer query = new StringBuffer();
			if ( type.equals("none") ) {
				query.append( " SELECT d_idx " + "\n"
						+ " , d_part" + "\n"
						+ " , d_type" + "\n"
						+ " , d_code" + "\n"
						+ " , d_name" + "\n"
						+ " , d_version " + "\n"       		
						+ " , d_filename" + "\n"
						+ " , d_hash" + "\n"
						+ " , d_filesize" + "\n"
						+ " , d_exec" + "\n"
						+ " , d_url" + "\n"
						+ " , d_datetime" + "\n"
						+ " , d_enable" + "\n"
						+ " , d_etc" + "\n"
						+ " , d_update" + "\n"
						+ " , d_etc_type" + "\n"
						+ " , d_etc_module" + "\n"
						+ " , d_etc_name" + "\n"
						+ " , d_etc_uninst" + "\n"
						+ " , ifnull( (SELECT B.t_name FROM DRV_TYPE B WHERE A.d_type = B.t_code),'SOFTWARE') t_name" + "\n"
						+ " FROM DRV_DRIVERS A " + "\n"
						+ " ORDER BY A.d_type" );
			} else {
				query.append( " SELECT d_idx " + "\n"
						+ " , d_part" + "\n"
						+ " , d_type" + "\n"
						+ " , d_code" + "\n"
						+ " , d_name" + "\n"
						+ " , d_version " + "\n"       		
						+ " , d_filename" + "\n"
						+ " , d_hash" + "\n"
						+ " , d_filesize" + "\n"
						+ " , d_exec" + "\n"
						+ " , d_url" + "\n"
						+ " , d_datetime" + "\n"
						+ " , d_enable" + "\n"
						+ " , d_etc" + "\n"
						+ " , d_update" + "\n"
						+ " , d_etc_type" + "\n"
						+ " , d_etc_module" + "\n"
						+ " , d_etc_name" + "\n"
						+ " , d_etc_uninst" + "\n"
						+ " , ifnull( (SELECT B.t_name FROM DRV_TYPE B WHERE A.d_type = B.t_code),'-') t_name" + "\n"
						+ " FROM DRV_DRIVERS A " + "\n"
						+ " WHERE A.d_type = '" + type + "'" + "\n"
						+ " ORDER BY A.d_type" );
			}
			System.out.println(" ?????? ?????? : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		
			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			rs.last();

			if ( rs.getRow() > 0 ) {

				// ???????????? ?????? ???????????? ?????????
				rs.beforeFirst();

				while( rs.next() ){

					DriverDTO driverdto = new DriverDTO();
					String d_type = "temp";

					if ( rs.getString("d_type") != null && !(rs.getString("d_type").equals(""))) {
						d_type = rs.getString("d_type");
					}

					String d_etc = "temp";

					if ( rs.getString("d_etc") != null && !(rs.getString("d_etc").equals(""))) {
						d_etc = rs.getString("d_etc");

						d_etc = d_etc.replaceAll("\"", "&quot;");

						// System.out.println("?????? ??? ?????? : " + d_etc);
					}

					String d_filename= "temp";

					if ( rs.getString("d_filename") != null && !(rs.getString("d_filename").equals(""))) {
						d_filename = rs.getString("d_filename");
					}

					String d_exec = "temp";

					if ( rs.getString("d_exec") != null && !(rs.getString("d_exec").equals(""))) {
						d_exec = rs.getString("d_exec");
						d_exec = d_exec.replace("'", "\\\'");
					}

					String DriverList = "";

					if ( rs.getString("d_enable").equals("1") ){
						DriverList = rs.getString("d_code") + " || " +  rs.getString("d_name") ;
					} else {
						DriverList = rs.getString("d_code") + " || " +  rs.getString("d_name") + " (?????????)" ;
					}

					String strDname = rs.getString("d_name");
					strDname = strDname.replace("'", "\\\'");

					String strTname = rs.getString("t_name");
					strTname = strTname.replace("'", "\\\'");


					driverdto.setD_code(rs.getString("d_code"));
					driverdto.setD_name(rs.getString("d_name"));
					driverdto.setD_version(rs.getString("d_version"));
					driverdto.setT_name(rs.getString("t_name"));
					driverdto.setD_update(rs.getDate("d_update"));

					driverdto.setD_idx(rs.getInt("d_idx"));
					driverdto.setD_part(rs.getString("d_part"));
					driverdto.setD_filename(d_filename);
					driverdto.setD_enable(rs.getInt("d_enable"));
					driverdto.setD_type(rs.getString("d_etc_type"));
					driverdto.setD_etc_module(rs.getString("d_etc_module"));
					driverdto.setD_etc_name(rs.getString("d_etc_name"));
					driverdto.setD_etc_uninst(rs.getString("d_etc_uninst"));

					result.add(driverdto);




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
	public void DriverUpdate_sql(HashMap<String,String>paraMap) throws ClassNotFoundException {

		String d_idx=paraMap.get("d_idx"); 
		String d_code=paraMap.get("d_code");
		String d_name=paraMap.get("d_name");
		String d_part=paraMap.get("d_part");
		String d_type=paraMap.get("d_type");
		String d_filename=paraMap.get("d_filename"); // -> ?????? ??????????????? ????????????
		String d_version=paraMap.get("d_version");
		String d_exec=paraMap.get("d_exec");
		String d_etc=paraMap.get("d_etc");
		String d_enable=paraMap.get("d_enable");
		String d_etc_type=paraMap.get("d_etc_type");
		String d_etc_module=paraMap.get("d_etc_module");
		String d_etc_name=paraMap.get("d_etc_name");
		String d_etc_uninst=paraMap.get("d_etc_uninst");

		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
		DBManager db = new DBManager();

		// ---------------------------------------------------------------------------------
		// update log ?????? DRV_MODEL
		try
		{
			Connection con = db.dbConn();
			PreparedStatement pstmt=null ; //create statement  
			StringBuffer query = new StringBuffer();
			query.append( "  SELECT * " + "\n" +
					"            , (select p_name from DRV_PART WHERE p_code = d_part) p_name " + "\n" +
					"            , (select p_name from DRV_PART WHERE p_code = '" + d_part + "' ) new_p_name " + "\n" +
					"            , (select t_name from DRV_TYPE WHERE t_code = d_type) t_name " + "\n" +
					"            , (select t_name from DRV_TYPE WHERE t_code = '" + d_type + "' ) new_t_name " + "\n" +
					"    FROM DRV_DRIVERS " + "\n" +
					"  WHERE d_code = '"+ d_code +"' ");        

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// ???????????? ?????? ????????? ?????????
			rs.last();

			// ??????
			String bdfDname = rs.getString("d_name");

			String logDetail = "'" + bdfDname + "' ??? ";

			if  ( !bdfDname.equals(d_name) ) {
				logDetail += "????????? '" + bdfDname + "' ?????? '" + d_name + "' ?????? " ;
			}

			// ????????????
			String bdfDenable = rs.getString("d_enable");

			if  ( !bdfDenable.equals(d_enable) ) {
				if (bdfDenable.equals("1"))
					bdfDenable = "??????";

				if (bdfDenable.equals("0"))
					bdfDenable = "?????????";

				String tmpEnable = d_enable;
				if (tmpEnable.equals("1"))
					tmpEnable = "??????";

				if (tmpEnable.equals("0"))
					tmpEnable = "?????????";

				logDetail += "??????????????? '" + bdfDenable + "' ?????? '" + tmpEnable + "' ?????? " ;
			}


			// ??????
			String bdfPcode = rs.getString("d_part");
			String bdfPname = rs.getString("p_name");
			String aftPname = rs.getString("new_p_name");

			if  ( !bdfPcode.equals(d_part) ) {
				logDetail += "????????? '" + bdfPname + "' ?????? '" + aftPname + "' ?????? " ;
			}

			// ??????
			String bdfTcode = rs.getString("d_type");
			String bdfTpart = rs.getString("t_name");
			String aftTname = rs.getString("new_t_name");

			if  ( !bdfTcode.equals(d_type) ) {
				logDetail += "????????? '" + bdfTpart + "' ?????? '" + aftTname + "' ?????? " ;
			}


			// ??????
			String bdfVersion = rs.getString("d_version");
			if  ( !bdfVersion.equals(d_version) ) {
				logDetail += "????????? '" + bdfVersion + "' ?????? '" + d_version + "' ?????? " ;
			}

			// ????????????
			String bdfDexec = rs.getString("d_exec");
			if  ( !bdfDexec.equals(d_exec) ) {
				logDetail += "??????????????? '" + bdfDexec + "' ?????? '" + d_exec + "' ?????? " ;
			}

			// ????????????
			String bdfEtcType = rs.getString("d_etc_type");
			if  ( !bdfEtcType.equals(d_etc_type) ) {
				logDetail += "??????????????? '" + bdfEtcType + "' ?????? '" + d_etc_type + "' ?????? " ;
			}

			// ????????????
			String bdfEtcModule = rs.getString("d_etc_module");
			if  ( !bdfEtcModule.equals(d_etc_module) ) {
				logDetail += "??????????????? '" + bdfEtcModule + "' ?????? '" + d_etc_module + "' ?????? " ;
			}

			// ???????????????
			String bdfEtcName = rs.getString("d_etc_name");
			if  ( !bdfEtcName.equals(d_etc_name) ) {
				logDetail += "?????????????????? '" + bdfEtcName + "' ?????? '" + d_etc_name + "' ?????? " ;
			}

			// ??????????????????
			String bdfEtcUninst = rs.getString("d_etc_uninst");
			if  ( !bdfEtcUninst.equals(d_etc_uninst) ) {
				logDetail += "????????????????????? '" + bdfEtcUninst + "' ?????? '" + d_etc_uninst + "' ?????? " ;
			}

			// ??????Data
			String bdfEtc = rs.getString("d_etc");
			if  ( !bdfEtc.equals(d_etc) ) {
				logDetail += "?????????????????? '" + bdfEtc + "' ?????? '" + d_etc + "' ?????? " ;
			}


			logDetail += "?????????????????????. ";

			if ( !logDetail.equals("'" + bdfDname + "' ??? ?????????????????????. ") ) {
				//------------------------------- DRV_LOG ????????? INSERT
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
					pstmt2.setString(2, "DRV_DRIVERS");
					pstmt2.setString(3, logDetail);
					pstmt2.setString(4, d_code);

					if (pstmt2.executeUpdate() == 1) {
						// ????????????
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

			String sql = "UPDATE DRV_DRIVERS SET d_name = ?"
					+ ", d_update = now()"
					+ ", d_part =?"
					+ ", d_type =?"
					+ ", d_version =?"
					+ ", d_exec =?"
					+ ", d_etc =?"
					+ ", d_enable =? "
					+ ", d_etc_type =? "
					+ ", d_etc_module =? "
					+ ", d_etc_name =? "
					+ ", d_etc_uninst =? "
					+ " where d_idx = ?" ;

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, d_name);
			pstmt.setString(2, d_part);
			pstmt.setString(3, d_type);
			pstmt.setString(4, d_version);
			pstmt.setString(5, d_exec);
			pstmt.setString(6, d_etc);
			pstmt.setString(7, d_enable);
			pstmt.setString(8, d_etc_type);
			pstmt.setString(9, d_etc_module);
			pstmt.setString(10, d_etc_name);
			pstmt.setString(11, d_etc_uninst);
			pstmt.setString(12, d_idx);

			System.out.println("update ?????? ?????? : " + pstmt.toString());

			if (pstmt.executeUpdate() == 1) {
				// ????????????
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
	public void DriverInsert_sql(HashMap<String,String>paraMap) {

		String d_code=paraMap.get("d_code");
		String d_name=paraMap.get("d_name");
		String d_part=paraMap.get("d_part");
		String d_type=paraMap.get("d_type");
		String d_version=paraMap.get("d_version");
		String d_exec=paraMap.get("d_exec");
		String d_etc=paraMap.get("d_etc");
		String d_etc_type=paraMap.get("d_etc_type");
		String d_etc_module=paraMap.get("d_etc_module");
		String d_etc_name=paraMap.get("d_etc_name");
		String d_etc_uninst=paraMap.get("d_etc_uninst");

		System.out.println("Driver Sql Insert Start ???????????????!!");

		DBManager db = new DBManager();

		// ------------------ max d_code ????????????
		String new_d_code = "";
		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();
			query.append( " SELECT CONCAT('D',LPAD(MAX(substring(d_code, 2, 5)+1),5,0)) AS d_code FROM DRV_DRIVERS " );        

			System.out.println(" ?????? ?????? : ");
			System.out.println( query.toString() );

			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// ???????????? ?????? ????????? ?????????
			rs.last();

			new_d_code = rs.getString("d_code");

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
			String sql = "INSERT INTO DRV_DRIVERS"
					+	"(   d_idx "
					+ " , d_code"
					+ " , d_name"
					+ " , d_part"
					+ " , d_type"
					+ " , d_version"
					+ " , d_exec"
					+ " , d_etc"
					+ " , d_etc_type"
					+ " , d_etc_module"
					+ " , d_etc_name"
					+ " , d_etc_uninst"
					+ " , d_datetime"
					+ " , d_enable )"
					+ " VALUES"
					+ " ( (SELECT d_idx FROM ( SELECT MAX(d_idx)+1 d_idx FROM DRV_DRIVERS ) tmp ) "
					+ " , ?" // d_code
					+ " , ?" // d_name
					+ " , ?" // d_part
					+ " , ?" // d_type
					+ " , ?" // d_version
					+ " , ?" // d_exec
					+ " , ?" // d_etc
					+ " , ?" // d_etc_type
					+ " , ?" // d_etc_module
					+ " , ?" // d_etc_name
					+ " , ?" // d_etc_uninst
					+ " , now()"
					+ " , '1'  ) ";

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, new_d_code);
			pstmt.setString(2, d_name);
			pstmt.setString(3, d_part);
			pstmt.setString(4, d_type);
			pstmt.setString(5, d_version);
			pstmt.setString(6, d_exec);
			pstmt.setString(7, d_etc);
			pstmt.setString(8, d_etc_type);
			pstmt.setString(9, d_etc_module);
			pstmt.setString(10, d_etc_name);
			pstmt.setString(11, d_etc_uninst);

			if(pstmt.executeUpdate() == 1){
				// ????????????
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

		//------------------------------- DRV_LOG ????????? INSERT
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
			pstmt.setString(2, "DRV_DRIVERS"); // log_table
			pstmt.setString(3, "'" + d_name + "' ???(???) ?????? ?????????????????????."); // log_detail
			pstmt.setString(4, d_code); // log_code

			System.out.println(" insert ?????? ?????? : ");
			System.out.println( sql );

			if (pstmt.executeUpdate() == 1) {
				// ????????????
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}


	}
	public void FileUpload (HashMap<String,String> paraMap) throws ClassNotFoundException {



		String d_idx = paraMap.get("tool_idx");
		String d_hash = paraMap.get("strCRC32");
		String d_filesize = paraMap.get("strSize");
		String d_filename = paraMap.get("newFileName");

		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
		DBManager db = new DBManager();

		String strUrl = "/drivers/";


		String d_code = "";

		// ---------------------------------------------------------------------------------
		// update log ?????? DRV_MODEL
		try
		{
			Connection con = db.dbConn();
			PreparedStatement pstmt=null ; //create statement  
			StringBuffer query = new StringBuffer();
			query.append( "  SELECT * " + "\n" +
					"    FROM DRV_DRIVERS " + "\n" +
					"  WHERE d_idx = '"+ d_idx +"' ");        
			System.out.println("file upload ?????? ?????? : " + query.toString() );
			pstmt=con.prepareStatement( query.toString() );		

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// ???????????? ?????? ????????? ?????????
			rs.last();

			d_code = rs.getString("d_code");
			String bdfDname = rs.getString("d_name");

			String logDetail = "'" + bdfDname + "' ??? ";


			// ????????????
			String bdfDhash = rs.getString("d_hash");
			if  ( !bdfDhash.equals(d_hash) ) {
				// logDetail += "??????????????? '" + bdfDhash + "' ?????? '" + d_hash + "' ?????? " ;
			}

			// ????????????
			String bdfDsize = rs.getString("d_filesize");
			if  ( !bdfDsize.equals(d_filesize) ) {
				// logDetail += "??????????????? '" + bdfDsize + "' ?????? '" + d_filesize + "' ?????? " ;
			}

			// ????????????
			String bdfDfilename = rs.getString("d_filename");
			if  ( !bdfDfilename.equals(d_filename) ) {
				logDetail += "????????? '" + bdfDfilename + "' ?????? '" + d_filename + "' ?????? " ;
			}
			// url
			String bdfDurl = rs.getString("d_url");
			if  ( !bdfDfilename.equals(d_filename) ) {
				// logDetail += "url??? '" + bdfDurl + "' ?????? '" + strUrl + d_filename + "' ?????? " ;
			}

			logDetail += "?????????????????????. ";

			if ( !logDetail.equals("'" + bdfDname + "' ??? ?????????????????????. ") ) {

				//------------------------------- DRV_LOG ????????? INSERT
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
					pstmt2.setString(2, "DRV_DRIVERS");
					pstmt2.setString(3, logDetail);
					pstmt2.setString(4, d_code);

					if (pstmt2.executeUpdate() == 1) {
						// ????????????
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

		try
		{
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = " UPDATE DRV_DRIVERS SET d_hash = ? " + "\n"
					+ "  , d_filesize = ? "  + "\n"
					+	"  , d_filename =  ? "  + "\n"
					+ "  , d_update = now()"  + "\n"
					+ "  , d_url = ( SELECT CONCAT( ?, ? ) FROM dual ) "  + "\n"
					+ " WHERE d_idx = ? " ;



			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, d_hash);
			pstmt.setString(2, d_filesize);
			pstmt.setString(3, d_filename);
			pstmt.setString(4, strUrl);
			pstmt.setString(5, d_filename);
			pstmt.setString(6, d_idx);

			System.out.println(" update ?????? ?????? : ");
			System.out.println( sql );

			if (pstmt.executeUpdate() == 1) {
				// ????????????
			}
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}

	}
	public void fileDelete(HashMap<String,String>paraMap) throws ClassNotFoundException {




		String d_code=paraMap.get("d_code");
		String d_name=paraMap.get("d_name");

		System.out.println(" DELETE SQL in d_code : " + d_code);

		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
		DBManager db = new DBManager();


		// ------------------------------------------------------------------------------------
		//------------------------------- DRV_LOG ????????? INSERT
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
			pstmt2.setString(2, "DRV_DRIVERS");
			pstmt2.setString(3, "????????? '" + d_name + "' ???(???) ?????????????????????.");
			pstmt2.setString(4, d_code);

			if (pstmt2.executeUpdate() == 1) {
				// ????????????
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

			String sql = "DELETE FROM DRV_DRIVERS WHERE d_code = '"+d_code+"' ";

			pstmt = con.prepareStatement( sql );
			// pstmt.setString(1, d_code);

			System.out.println("delete ?????? ?????? : " + pstmt.toString());

			if (pstmt.executeUpdate() == 1) {
				// ????????????
			}

			//-------------------------DRV_LINK ??????
			PreparedStatement pstmt2=null ; //create statement

			String sql2 = "DELETE FROM DRV_LINK WHERE l_code = '"+d_code+"' ";

			pstmt2 = con.prepareStatement( sql2 );
			// pstmt2.setString(1, d_code);

			System.out.println("DRV_LINK delete ?????? ?????? : " + pstmt2.toString());

			if (pstmt2.executeUpdate() == 1) {
				// ????????????
			}


		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
	public List<DriverDTO> Driverserch (HashMap<String,String>paraMap) throws ClassNotFoundException {



		List<DriverDTO> result = new ArrayList<DriverDTO>();
		String kind=paraMap.get("kind_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String model=paraMap.get("model_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String part=paraMap.get("part_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String type=paraMap.get("type_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable

		System.out.println("???????????? ??????");
		System.out.println("kind : " + kind);
		System.out.println("model : " + model);
		System.out.println("part : " + part);
		System.out.println("type : " + type);

		try
		{

			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
			DBManager db = new DBManager();

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement



			StringBuffer query = new StringBuffer();

			String subQuery = "( " 
					+ " SELECT AA.d_idx d_idx"
					+ " , BB.l_model d_model"
					+ " , BB.l_kind d_kind"
					+ " , AA.d_part"
					+ " , AA.d_type"
					+ " , AA.d_code" 
					+ " , AA.d_name"
					+ " , AA.d_version"
					+ " , AA.d_filename"
					+ " , AA.d_hash"
					+ " , AA.d_filesize"
					+ " , AA.d_exec"
					+ " , AA.d_url"
					+ " , AA.d_datetime"
					+ " , AA.d_enable"
					+ " , AA.d_etc"
					+ " FROM DRV_DRIVERS AA"
					+ " LEFT OUTER JOIN DRV_LINK BB"
					+ " ON AA.d_code = BB.l_code"
					+ " ORDER BY AA.d_code "
					+ " )";

			query.append( "  SELECT A.k_name "   // ??????
					+ ", B.m_name "  // ?????? 
					+ ", C.p_name "  // ??????
					+ ", IFNULL(E.t_name, 'SOFTWARE')   as t_name "   // ??????
					+ ", D.d_version "  // ??????
					+ ", D.d_name "  // name
					+ ", D.d_idx "  // idx
					+ ", D.d_filename "  // filename
					+ ", D.d_etc "  // etc
					+ "  FROM DRV_KIND   A "
					+ ", DRV_MODEL  B "
					+ ", DRV_PART   C "
					+ ", " + subQuery + " AS D "
					+ "	  LEFT OUTER JOIN DRV_TYPE E "
					+ "	    ON D.d_type = E.t_code "
					+ " WHERE 1=1 "
					+ " AND D.d_kind  = A.k_code"
					+ " AND D.d_model = B.m_code"
					+ " AND A.k_code  = B.m_kind"
					+ " AND D.d_part  = C.p_code"
					+ " AND A.k_enable = '1' "
					+ " AND B.m_enable = '1' "
					+ " AND C.p_enable = '1' "
					+ " AND D.d_enable  = '1' " );        

			if( !kind.equals("none") && !(kind == null) ) {
				query.append(" AND D.d_kind = '" + kind + "'");
				// params.add(kind);
			}

			if( !model.equals("none") && !(model == null)) {
				query.append(" AND D.d_model = '" + model + "'");
				// params.add(model);
			}

			if( !part.equals("none") && !(part == null)) {
				query.append(" AND D.d_part = '" + part +"' ");
				// params.add(part);
			}

			if( !type.equals("none") && !(type == null) ) {
				query.append(" AND D.d_type = '" + type + "'" );
				// params.add(type);
			}

			query.append(" ORDER BY D.d_idx ");

			pstmt=con.prepareStatement( query.toString() );
			/*
			for (int i= 0; i<params.size(); i++) {
				pstmt.setString(i+1, params.get(i).toString() );
			}
			 */
			HttpServletRequest request = null;

			System.out.println(" ?????? ?????? : ");
			System.out.println( pstmt.toString() );

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// ???????????? ?????? ????????? ?????????
			rs.last();

			System.out.println("rs.getRow() : " + rs.getRow() );
			if ( rs.getRow() > 0 ) {

				// ???????????? ?????? ???????????? ?????????
				rs.beforeFirst();
				while( rs.next() ){

					DriverDTO driverdto = new DriverDTO();

					driverdto.setD_kind(rs.getString("k_name"));
					driverdto.setD_model(rs.getString("m_name"));
					driverdto.setD_part(rs.getString("p_name"));
					driverdto.setD_type(rs.getString("t_name"));
					driverdto.setD_version(rs.getString("d_version"));
					driverdto.setD_name(rs.getString("d_name"));
					driverdto.setD_filename(rs.getString("d_filename"));
					driverdto.setD_etc(rs.getString("d_etc"));
					driverdto.setD_idx(rs.getInt("d_idx"));


					result.add(driverdto);




				}

			} 

		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
		return result;

	}
}
