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
import org.springframework.web.servlet.view.InternalResourceView;

import com.hopi.web.WebConstants;

/**
 * 报告访问视图
 * 
 * @author:dongyl
 * @since:2010-4-19
 */
public class HtmlReportViewResolver implements ViewResolver, Ordered {
	private final static Log log = LogFactory
			.getLog(HtmlReportViewResolver.class);
	private int order = Ordered.HIGHEST_PRECEDENCE;
	private String viewPrefix = WebConstants.HTML_VIEW_PREFIX;
	private String prefix = "";
	private String suffix = "";

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	public String getSuffix() {
		return suffix;
	}

	public void setSuffix(String suffix) {
		this.suffix = suffix;
	}

	public String getViewPrefix() {
		return viewPrefix;
	}

	public void setViewPrefix(String viewPrefix) {
		this.viewPrefix = viewPrefix;
	}

	public View resolveViewName(String viewName, Locale locale)
			throws Exception {
		if (viewName.startsWith(this.viewPrefix)) {
			final String url = this.prefix
					+ viewName.substring(viewPrefix.length()) + this.suffix;
			// log.info("url="+url);
			return new View() {
				public String getContentType() {
					return "text/html; charset=UTF-8";
				}

				public void render(final Map map, HttpServletRequest request,
						HttpServletResponse response) throws Exception {
					View v = new InternalResourceView(url);
					v.render(map, request, response);
					// IOUtils.copy(new FileReader(url),
					// response.getOutputStream());
				}

			};
		}
		return null;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public int getOrder() {
		return this.order;
	}
}
