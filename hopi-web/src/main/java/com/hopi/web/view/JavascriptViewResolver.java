package com.hopi.web.view;

import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.ViewResolver;

import com.hopi.web.WebConstants;

public class JavascriptViewResolver implements ViewResolver, Ordered {
	private final static Log log = LogFactory
			.getLog(JavascriptViewResolver.class);
	private int order = Ordered.HIGHEST_PRECEDENCE;
	private String viewName = WebConstants.JSON_VIEW;

	public View resolveViewName(String viewName, Locale locale)
			throws Exception {
		if (this.viewName.equals(viewName)) {
			return new View() {
				public String getContentType() {
					return "application/x-javascript;charset=UTF-8";
				}

				public void render(Map map, HttpServletRequest request,
						HttpServletResponse response) throws Exception {
					String result = (String) map
							.get(WebConstants.JAVASCRIPT_VIEW_CONTENT);
					response.getWriter().write(result);
				}
			};
		}
		return null;
	}

	public void setViewName(String viewName) {
		this.viewName = viewName;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public int getOrder() {
		return this.order;
	}
}
