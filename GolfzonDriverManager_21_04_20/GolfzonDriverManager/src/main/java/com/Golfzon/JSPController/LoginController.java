package com.Golfzon.JSPController;

import java.nio.ByteBuffer;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.SendResult;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Golfzon.DBController.DbService;
import com.Golfzon.service.LoginService;

@Controller
@Component
@RequestMapping("/Login/*")
public class LoginController {

	@Autowired
	DbService dbService;
	LoginService loginservice;

	// Loginmain.jsp 호출    
	@RequestMapping(value = "/LoginMain", method = {RequestMethod.GET, RequestMethod.POST})
	public String LoginMain() throws Exception {


		return "Login/loginForm";
	}

	//로그인 확인
	@RequestMapping(value = "/loginCheck", method = {RequestMethod.GET, RequestMethod.POST} )
	public String loginCheck( 
			 HttpServletRequest request
			,HttpSession session
			,HttpServletResponse response ) throws Exception {

		loginservice = new LoginService();

		HashMap<String,String> paraMap = new HashMap<String,String>();
		String ID = request.getParameter("id");
		String PW = request.getParameter("pw");

		paraMap.put("id", ID);
		paraMap.put("pw", PW);
		long longResult =loginservice.LoginCheck(paraMap);


		// if(strResult.equals("1")) {
		if( longResult == 1 ) {
			session.setAttribute("id",ID);
			session.setAttribute("pw",PW);

			// 로그인 유지시간 10분
			session.setMaxInactiveInterval(60 * 10); 

			response.sendRedirect("/DriverManager");

		} else {
			response.sendRedirect("/Login/LoginMain?error=Login Failed");
		}

		return null;
	}

	//로그아웃
	@RequestMapping(value = "/logOut", method = {RequestMethod.GET, RequestMethod.POST})
	public String logOut(HttpSession session,HttpServletResponse response) throws Exception {
		session.invalidate();
		response.sendRedirect("/Login/LoginMain");

		return null;
	}

	//세션 확인
	@RequestMapping(value = "/loginChk_javascript", method = {RequestMethod.GET, RequestMethod.POST})
	public String loginChk_javascript() throws Exception {
		return "Login/sessionChk";
	}


	@RequestMapping(value = "/blank", method = RequestMethod.GET)
	public String gotoBlank() throws Exception {
		return "Login/blank";
	}

	//쿠키생성
	@RequestMapping(value = "/LoginCookie", method = {RequestMethod.GET,RequestMethod.POST})
	public @ResponseBody Map<String, String> LoginCookie(
			HttpServletResponse response
			, @RequestParam("user") String user
			, @RequestParam("cookieName") String cookieName
			) throws Exception {



		String key = "secret key";
		String encryptedID = encryptAES256(user, key);



		Cookie cookieID = new Cookie(cookieName,encryptedID);

		cookieID.setMaxAge(60*60*24*7);
		response.addCookie(cookieID);



		return null;
	}

	@RequestMapping(value = "/LoginCookieGet", method = {RequestMethod.GET,RequestMethod.POST})
	public @ResponseBody Map<String, String> LoginCookieGet(
			HttpServletRequest request
			, @RequestParam("cookiename") String cookiename
			) throws Exception {

		System.out.println("쿠키 : " + cookiename);

		Map<String,String> map = new HashMap<String,String>();

		String key = "secret key";
		Cookie[] cookies = request.getCookies();

		if(cookies != null) {
			for(Cookie cookie : cookies) {

				if(cookie.getName().equals(cookiename)) {

					if(cookie.getValue().equals("")) {
						map.put("value","");	
					}else {
						map.put("value", decryptAES256(cookie.getValue(),key));
					}
				}
			}
		}




		//		Cookie cookies = new Cookie("userInputPw",userInputPw);
		//		cookies.setMaxAge(60*60*24*7);


		return map;
	}

	// 암호화
	public static String encryptAES256(String msg, String key) throws Exception {

		SecureRandom random = new SecureRandom();

		byte bytes[] = new byte[20];

		random.nextBytes(bytes);

		byte[] saltBytes = bytes;



		// Password-Based Key Derivation function 2

		SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");

		// 70000번 해시하여 256 bit 길이의 키를 만든다.

		PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 70000, 256);



		SecretKey secretKey = factory.generateSecret(spec);

		SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");



		// 알고리즘/모드/패딩

		// CBC : Cipher Block Chaining Mode

		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");

		cipher.init(Cipher.ENCRYPT_MODE, secret);

		AlgorithmParameters params = cipher.getParameters();

		// Initial Vector(1단계 암호화 블록용)

		byte[] ivBytes = params.getParameterSpec(IvParameterSpec.class).getIV();



		byte[] encryptedTextBytes = cipher.doFinal(msg.getBytes("UTF-8"));



		byte[] buffer = new byte[saltBytes.length + ivBytes.length + encryptedTextBytes.length];

		System.arraycopy(saltBytes, 0, buffer, 0, saltBytes.length);

		System.arraycopy(ivBytes, 0, buffer, saltBytes.length, ivBytes.length);

		System.arraycopy(encryptedTextBytes, 0, buffer, saltBytes.length + ivBytes.length, encryptedTextBytes.length);



		return Base64.getEncoder().encodeToString(buffer);

	}
	//복호화
	public static String decryptAES256(String msg, String key) throws Exception {

		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");

		ByteBuffer buffer = ByteBuffer.wrap(Base64.getDecoder().decode(msg));



		byte[] saltBytes = new byte[20];

		buffer.get(saltBytes, 0, saltBytes.length);

		byte[] ivBytes = new byte[cipher.getBlockSize()];

		buffer.get(ivBytes, 0, ivBytes.length);

		byte[] encryoptedTextBytes = new byte[buffer.capacity() - saltBytes.length - ivBytes.length];

		buffer.get(encryoptedTextBytes);



		SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");

		PBEKeySpec spec = new PBEKeySpec(key.toCharArray(), saltBytes, 70000, 256);



		SecretKey secretKey = factory.generateSecret(spec);

		SecretKeySpec secret = new SecretKeySpec(secretKey.getEncoded(), "AES");



		cipher.init(Cipher.DECRYPT_MODE, secret, new IvParameterSpec(ivBytes));



		byte[] decryptedTextBytes = cipher.doFinal(encryoptedTextBytes);

		return new String(decryptedTextBytes);

	}





}

