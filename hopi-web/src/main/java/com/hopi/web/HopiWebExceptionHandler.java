package com.hopi.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.exception.ExceptionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

public class HopiWebExceptionHandler implements HandlerExceptionResolver {
	private final static Log log = LogFactory
			.getLog(HopiWebExceptionHandler.class);

	public ModelAndView resolveException(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception exception) {	
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.FALSE);
		resultMap.put(WebConstants.JSON_ERROR_MSG, ExceptionUtils
				.getRootCauseMessage(exception));
		response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);	
		if(!(exception instanceof HopiWebException)){
			log.error(ExceptionUtils.getFullStackTrace(exception));
		}		
		return new ModelAndView(WebConstants.JSON_VIEW, resultMap);
	}
}
