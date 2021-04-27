package com.Golfzon.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;


import com.Golfzon.DBManager;

public class LoginDAO {

	public Long LoginCheck(HashMap<String,String> paraMap) {
		long longResult = 0;

		String id =	paraMap.get("id");
		String pw =	paraMap.get("pw");
		System.out.println( "id : " +id + " /rwwr pw : "  + pw);


		Connection conn = null;
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			DBManager db = new DBManager();

			conn = db.dbConn();

			// BINARY : 대소문자 구분
			String sql = "SELECT count(*) as cnt from DRV_USER where BINARY u_id=? and BINARY u_pw=? and u_enable = '1'";

			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, id);
			pstmt.setString(2, pw);			
			rs = pstmt.executeQuery();
			rs.next();

			longResult = rs.getLong("cnt");

	

		}catch(Exception e) {
			System.out.println("error : " + e.toString());
		}
		return longResult;

	}
}
