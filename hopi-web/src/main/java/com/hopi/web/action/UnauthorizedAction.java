package com.hopi.web.action;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import com.hopi.web.WebConstants;

public class UnauthorizedAction implements Controller {
	private final static Log log = LogFactory.getLog(UnauthorizedAction.class);

	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// Map resultMap = new HashMap();
		// resultMap.put(WebConstants.JSON_DATA, result);
		Map errors = new HashMap();
		errors.put("code", "1");
		errors.put("msg", "您没有权限访问该页面");
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, errors);
	}
}
