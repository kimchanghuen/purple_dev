package com.Golfzon.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.Golfzon.DBManager;
import com.Golfzon.dto.LinkDTO;
import com.Golfzon.dto.ToolDTO;

public class LinkDAO {

	public  List<LinkDTO>  LinkList (HashMap<String,String> paraMap){
		List<LinkDTO> list = new ArrayList<LinkDTO>();


		String kind=paraMap.get("Linkkind"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String model=paraMap.get("Linkmodel"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String type=paraMap.get("type"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String driver=paraMap.get("Linkdriver"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable

		System.out.println("파라미터 확인");
		System.out.println("kind : " + kind);
		System.out.println("model : " + model);
		System.out.println("driver : " + driver);    

		try
		{

			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
			DBManager db = new DBManager();

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();

			query.append( " SELECT A.l_idx"
					+" , A.l_kind"
					+" , B.k_name"
					+"  , A.l_model"
					+"  , C.m_name"
					+"  , A.l_code"
					+"  , D.d_name"
					+"  , A.l_enable"
					+"  , A.l_update"
					+" , IFNULL((SELECT AA.t_name FROM DRV_TYPE AA WHERE AA.t_code = D.d_type AND AA.t_enable = '1'),'SOFTWARE' ) AS t_name "
					+" , D.d_etc_type "
					+" , D.d_etc_module "
					+" , D.d_etc_name"
					+" , D.d_etc_uninst"
					+" FROM DRV_LINK A"
					+"   RIGHT OUTER JOIN DRV_DRIVERS D "
					+"   ON A.l_code = D.d_code "
					+" , DRV_KIND B  "
					+" , DRV_MODEL C "
					+"WHERE A.l_kind = B.k_code "
					+ " AND B.k_enable = '1' "
					+ " AND C.m_enable = '1' "
					+ " AND A.l_enable = '1' "
					+"  AND A.l_model = C.m_code " );        

			if( !kind.equals("none") && !(kind == null) ) {
				query.append(" AND A.l_kind = '" + kind + "'");
			}

			if( !model.equals("none") && !(model == null)) {
				query.append(" AND A.l_model = '" + model + "'");
			}

			if( !type.equals("none") && !(type == null)) {
				query.append(" AND D.d_type = '" + type +"' ");
			}


			if( !driver.equals("none") && !(driver == null)) {
				query.append(" AND A.l_code = '" + driver +"' ");
			}

			query.append(" ORDER BY D.d_type, D.d_name, A.l_model ");

			pstmt=con.prepareStatement( query.toString() );


			System.out.println(" 쿼리 확인 : ");
			System.out.println( pstmt.toString() );

			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();
			if ( rs.getRow() > 0 ) {

				// 데이터의 가장 처음으로 보내기
				rs.beforeFirst();

				while( rs.next() ){

					LinkDTO linkdto = new LinkDTO();
					String strUse = "";

					if (rs.getString("l_enable").equals("1")) {
						strUse = "사용";
					} else {
						strUse = "미사용";
					}

					// ----------------- 드라이버 정보 찾기 -----------------------------
					PreparedStatement pstmt2=null ; //create statement

					StringBuffer query2 = new StringBuffer();
					query2.append( " SELECT * FROM DRV_DRIVERS WHERE d_code = '" + rs.getString("l_code") + "' AND d_enable = '1'  LIMIT 1 " );        

					pstmt2=con.prepareStatement( query2.toString() );		

					ResultSet rs2=pstmt2.executeQuery(); //execute query and set in resultset object rs.

					rs2.beforeFirst();
					rs2.next();

					String d_type = "temp";

					if ( rs2.getString("d_type") != null && !(rs2.getString("d_type").equals(""))) {
						d_type = rs2.getString("d_type");
					}

					String d_etc = "temp";

					if ( rs2.getString("d_etc") != null && !(rs2.getString("d_etc").equals(""))) {
						d_etc = rs2.getString("d_etc");

						d_etc = d_etc.replaceAll("\"", "&quot;");

						// System.out.println("치환 값 확인 : " + d_etc);
					}

					String d_filename= "temp";

					if ( rs2.getString("d_filename") != null && !(rs2.getString("d_filename").equals(""))) {
						d_filename = rs2.getString("d_filename");
					}

					String d_exec = "temp";

					if ( rs2.getString("d_exec") != null && !(rs2.getString("d_exec").equals(""))) {
						d_exec = rs2.getString("d_exec");
					}

					linkdto.setL_idx(rs.getInt("l_idx"));
					linkdto.setL_code(rs.getString("l_code"));
					linkdto.setL_kind(rs.getString("k_name"));
					linkdto.setL_model(rs.getString("m_name"));
					linkdto.setL_type(rs.getString("t_name"));
					linkdto.setL_driver(rs.getString("d_name"));
					linkdto.setL_update(rs.getDate("l_update"));
					linkdto.setD_idx(rs2.getString("d_idx"));
					linkdto.setD_code(rs2.getString("d_code"));



					list.add(linkdto);

				}


			}

		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
		return list;
	}
	public void LinkDelete(String l_idx) throws ClassNotFoundException {




		System.out.println(" DELETE SQL in l_idx : " + l_idx);

		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
		DBManager db = new DBManager();


		String k_name = "";
		String m_name = "";
		String d_name = "";

		try
		{  
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();

			query.append( " SELECT * " + "\n" +
					"          , (SELECT k_name FROM DRV_KIND WHERE k_code = l_kind) k_name " + "\n" +
					"          , (SELECT m_name FROM DRV_MODEL WHERE m_code = l_model) m_name "  + "\n" +
					"          , (SELECT d_name FROM DRV_DRIVERS WHERE d_code = l_code) d_name "  + "\n" +
					"  FROM DRV_LINK " );        

			pstmt=con.prepareStatement( query.toString() );   
			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			k_name = rs.getString("k_name");
			m_name = rs.getString("m_name");
			d_name = rs.getString("d_name");

		}  catch(Exception e)
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
			pstmt2.setString(2, "DRV_LINK");
			pstmt2.setString(3, " '" + k_name + "' 의 '" + m_name + "' 에 등록된 '" + d_name + "'이(가) 삭제되었습니다.");
			pstmt2.setString(4, "");

			if (pstmt2.executeUpdate() == 1) {
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

			String sql = "DELETE FROM DRV_LINK WHERE l_idx = '"+l_idx+"' ";

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
	public List<HashMap<String, String>> serch_SubLinkData (String kind_value,String model_value){
		List<HashMap<String,String>> result = new ArrayList<HashMap<String,String>>();


		try
		{
			Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
			DBManager db = new DBManager();

			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			pstmt=con.prepareStatement(   "SELECT A.d_code"
					+ " , A.d_name " 
					+ " , IFNULL(B.t_name, 'SOTFWARE') AS t_name "
					+ " FROM DRV_DRIVERS A "
					+ " LEFT OUTER JOIN DRV_TYPE B " 
					+ " ON A.d_type = B.t_code "
					+ " AND     B.t_enable = '1' "
					+ " WHERE A.d_enable = '1' "  
					+ " and A.d_code NOT IN ( SELECT C.l_code " 
					+ " FROM DRV_LINK C " 
					+	" WHERE C.l_kind  = '"+ kind_value +"' "	
					+ " AND C.l_model = '" + model_value  + "' )  "); //sql select query
			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			System.out.println("쿼리 확인 : " + pstmt.toString());

			while(rs.next()) {
				HashMap<String,String> paramMap = new HashMap<String,String>();


				paramMap.put("d_code", rs.getString("d_code"));
				paramMap.put("d_name", rs.getString("d_name"));
				paramMap.put("t_name", rs.getString("t_name"));

				result.add(paramMap);


			}

			con.close(); //close connection
		}
		catch(Exception e)
		{
			System.out.println(e);
		}


		return result;

	}
	public void insert_LinkData (HashMap<String,String> paraMap) throws ClassNotFoundException{

		String kind=paraMap.get("kind_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String model=paraMap.get("model_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable
		String driver=paraMap.get("driver_value"); //get country_id from index.jsp page with function country_change() through ajax and store in id variable

		System.out.println("파라미터 확인");
		System.out.println("kind : " + kind);
		System.out.println("model : " + model);
		System.out.println("driver : " + driver);    

		Class.forName("com.mysql.cj.jdbc.Driver"); //load driver
		DBManager db = new DBManager();

		//------------------------------- select 하여 k_idx 가져오기
		try
		{
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			String sql = "INSERT INTO DRV_LINK " + "\n"
					+ " ( l_idx, "  + "\n"
					+	"   l_kind, "  + "\n"
					+ "   l_model, "  + "\n"
					+ "   l_code, "  + "\n"
					+ "   l_datetime, "  + "\n"
					+ "   l_enable) "  + "\n"
					+ "VALUES "  + "\n"
					+ "(  (SELECT l_idx FROM ( SELECT MAX(l_idx)+1 l_idx FROM DRV_LINK ) tmp ), "  + "\n"  
					+ "  ?, "  + "\n" // kind
					+  " ?, "  + "\n" // model
					+  " ?, "  + "\n" // driver
					+  " now(), " + "\n" 
					+ " '1' )";

			pstmt = con.prepareStatement( sql );
			pstmt.setString(1, kind);
			pstmt.setString(2, model);
			pstmt.setString(3, driver);

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

		String k_name = "";
		String m_name = "";
		String d_name = "";

		try
		{  
			Connection con = db.dbConn();

			PreparedStatement pstmt=null ; //create statement

			StringBuffer query = new StringBuffer();

			query.append( " SELECT * " + "\n" +
					"          , (SELECT k_name FROM DRV_KIND WHERE k_code = l_kind) k_name " + "\n" +
					"          , (SELECT m_name FROM DRV_MODEL WHERE m_code = l_model) m_name "  + "\n" +
					"          , (SELECT d_name FROM DRV_DRIVERS WHERE d_code = l_code) d_name "  + "\n" +
					"  FROM DRV_LINK " );        

			pstmt=con.prepareStatement( query.toString() );   
			ResultSet rs=pstmt.executeQuery(); //execute query and set in resultset object rs.

			// 데이터의 가장 끝으로 보내기
			rs.last();

			k_name = rs.getString("k_name");
			m_name = rs.getString("m_name");
			d_name = rs.getString("d_name");

		}  catch(Exception e)
		{
			System.out.println(e.toString());
		} 

		//------------------------------- DRV_LOG 테이블 INSERT
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
			pstmt.setString(2, "DRV_LINK"); // log_table
			pstmt.setString(3, "'" + d_name + "' 이(가) '" + k_name + "' 의 '" + m_name + "' 에 신규 생성되었습니다."); // log_detail
			pstmt.setString(4, ""); // log_code

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
