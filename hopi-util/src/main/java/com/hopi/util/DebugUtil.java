package com.hopi.util;

import java.sql.Timestamp;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

public class DebugUtil {
	public static String viewEntity(Object jsonData) {
		String result;
		JsonConfig jsonConfig = new JsonConfig();

		// 日期处理
		final String datePattern = "yyyyMMdd";
		jsonConfig.registerJsonValueProcessor(Timestamp.class,
				new JsonValueProcessor() {
					public Object processArrayValue(Object value,
							JsonConfig arg1) {
						return null;
					}

					public Object processObjectValue(String key, Object value,
							JsonConfig arg2) {
						String date = DateUtil.formatDate((Timestamp) value,
								datePattern);
						return date;
					}
				});
		if (jsonData instanceof List) {
			result = JSONArray.fromObject(jsonData, jsonConfig).toString();
		} else {
			result = JSONObject.fromObject(jsonData, jsonConfig).toString();
		}
		return result;
	}
}
