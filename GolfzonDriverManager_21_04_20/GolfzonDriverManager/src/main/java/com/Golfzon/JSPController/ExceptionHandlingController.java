package com.Golfzon.JSPController;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@RequestMapping(value = "/error", method = {RequestMethod.GET, RequestMethod.POST})
@Controller
public class ExceptionHandlingController {
	
	@ExceptionHandler(CustomAuthException.class)
	public ModelAndView LoginAuthError(HttpServletRequest req, CustomAuthException exception) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("exception", exception);
		mav.addObject("url", req.getRequestURL());
		mav.setViewName("name");
		return mav;
	}
}

