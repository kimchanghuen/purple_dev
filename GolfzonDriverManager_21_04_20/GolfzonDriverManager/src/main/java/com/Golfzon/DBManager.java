package com.Golfzon;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBManager {

	public Connection dbConn() throws SQLException {
		Connection reconn = null;
		
		InputStream is;
		Properties props;
		
		try {
			// 로컬환경
			// is = getClass().getClassLoader().getResourceAsStream("golfzon.properties");
			
			// real 환경
			try {
				is = new FileInputStream("./Properties/golfzon.properties");
			} catch ( IOException e ) {
				System.out.println("file error : " + e.toString());
				is = getClass().getClassLoader().getResourceAsStream("golfzon.properties");
			}
			
			// System.out.println("ip?? : " +  Inet4Address.getLocalHost().getHostAddress());;
			
			props = new Properties();
			props.load(is);
			
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			Properties prop = new Properties();
			prop.put("user", props.getProperty("DB_USER"));
			prop.put("password", props.getProperty("DB_PASSWORD"));
			
			prop.put("autoReconnect", "true");
			prop.put("testOnIdle", "true");
			prop.put("testWhileIdle", "true");
			prop.put("testOnBorrow", "true");
			prop.put("ValidationQuery", "select 1");
			prop.put("timeBetweenEvictionRunsMillis", "30000");
			prop.put("minEvictableIdleTimeMillis", "10000");
	
			reconn = DriverManager.getConnection(props.getProperty("DB_URL"), prop);
			return reconn;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public String getDomain()  {
		
		InputStream is;
		Properties props;
		
		try {
			// 로컬환경
			// is = getClass().getClassLoader().getResourceAsStream("golfzon.properties");
			
			// real 환경
			try {
				is = new FileInputStream("./Properties/golfzon.properties");
			} catch ( IOException e ) {
				System.out.println("file error : " + e.toString());
				is = getClass().getClassLoader().getResourceAsStream("golfzon.properties");
			}
										
			props = new Properties();
			props.load(is);
	
			String strDomain = props.getProperty("DOMAIN");

			return strDomain;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

}
