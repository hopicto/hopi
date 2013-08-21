package com.hopi.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 根据变量前缀，获取查询变量
 * 
 * @author 董依良
 * @since 2013-7-25
 */

public class QueryParamMapUtil {
	public static Map getQueryParamMap(String prefix, Map param) {
		if (param == null) {
			return null;
		} else {
			Map rm = new HashMap();			
			for (Iterator it = param.entrySet().iterator(); it.hasNext();) {
				Entry entry = (Entry) it.next();
				String key = (String) entry.getKey();
				String[] kv = (String[])entry.getValue();
				if (key.startsWith(prefix) && kv != null && kv.length > 0&&kv[0].trim().length()>0) {					
					key = key.substring(prefix.length());
//					String av = "%" + kv[0].trim() + "%";
//					
//					rm.put(key, av);
					rm.put(key, kv[0].trim());
				}
			}
			return rm;
		}
	}

	public static void main(String[] args) {
		Map param = new HashMap();
		param.put("T_KK", "123");
		param.put("T_MM", "123");
		System.out.println(DebugUtil.viewEntity(getQueryParamMap("T_", param)));
	}
}
