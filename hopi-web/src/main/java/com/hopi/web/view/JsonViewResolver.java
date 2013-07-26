package com.hopi.web.view;

import java.sql.Timestamp;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.ViewResolver;

import com.hopi.util.DateUtil;
import com.hopi.web.WebConstants;

public class JsonViewResolver implements ViewResolver, Ordered {
	private final static Log log = LogFactory.getLog(JsonViewResolver.class);
	private int order = Ordered.HIGHEST_PRECEDENCE;
	private String viewName = WebConstants.JSON_VIEW;

	public View resolveViewName(String viewName, Locale locale)
			throws Exception {
		if (this.viewName.equals(viewName)) {
			return new View() {
				public String getContentType() {
					return "text/x-json;charset=UTF-8";
				}

				public void render(final Map map, HttpServletRequest request,
						HttpServletResponse response) throws Exception {
					String result;
					if (map == null) {
						result = "{success:true}";
					} else {
						JsonConfig jsonConfig = new JsonConfig();

						// 日期处理
						String datePattern = WebConstants.DATE_PATTERN;
						if (map.containsKey(WebConstants.DATE_PATTERN_CUSTOM)) {
							datePattern = (String) map
									.get(WebConstants.DATE_PATTERN_CUSTOM);
						}
						final String finalDatePattern = datePattern;
						jsonConfig.registerJsonValueProcessor(Timestamp.class,
								new JsonValueProcessor() {
									public Object processArrayValue(
											Object value, JsonConfig arg1) {
										return null;
									}

									public Object processObjectValue(
											String key, Object value,
											JsonConfig arg2) {
										String date = DateUtil.formatDate(
												(Timestamp) value,
												finalDatePattern);
										return date;
									}
								});

						if (map.containsKey(WebConstants.JSON_CLEAN)) {
							Object jsonData = map.get(WebConstants.JSON_CLEAN);
							if (jsonData instanceof List) {
								result = JSONArray.fromObject(jsonData,
										jsonConfig).toString();
							} else {
								result = JSONObject.fromObject(jsonData,
										jsonConfig).toString();
							}
						} else {
							result = JSONObject.fromObject(map, jsonConfig)
									.toString();
						}
					}
					// log.info("json:" + result);
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
