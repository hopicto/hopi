package com.hopi.util;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author 董依良
 * @since 2013-6-20
 */

public class DataTypeUtil {
	public static final int DATA_TYPE_STRING = 0;
	public static final int DATA_TYPE_INTEGER = 1;
	public static final int DATA_TYPE_DOUBLE = 2;

	/**
	 * 将指定字段的数据类型取整之后，转化为字符串<br/>
	 * 
	 * 用于处理excel中本该是文本的数据类型<br/>
	 * 
	 * @param data
	 * @param kset
	 */
	public static void changeDataTypeToString(List data, Set kset) {
		if (data == null || data.size() == 0) {
			return;
		} else {
			for (Iterator it = data.iterator(); it.hasNext();) {
				Map map = (Map) it.next();
				for (Iterator kit = map.keySet().iterator(); kit.hasNext();) {
					String k = (String) kit.next();
					if (kset.contains(k)) {
						Object ov = map.get(k);
						String td = null;
						if (ov == null) {
						} else if (ov instanceof Double) {
							td = String.valueOf(Math.round((Double) ov));
						} else if (ov instanceof Integer) {
							td = ((Integer) ov).toString();
						} else if (ov instanceof Long) {
							td = ((Long) ov).toString();
						} else if (ov instanceof Float) {
							td = String.valueOf(Math.round((Float) ov));
						} else {
							td = (String) ov;
						}
						map.put(k, td);
					}
				}
			}
		}
	}

	public static void exchangeDataType(List data, Map typeMap) {
		if (data == null || data.size() == 0) {
			return;
		} else {
			for (Iterator it = data.iterator(); it.hasNext();) {
				Map map = (Map) it.next();
				for (Iterator kit = map.keySet().iterator(); kit.hasNext();) {
					String k = (String) kit.next();
					if (typeMap.containsKey(k)) {
						int ts = (Integer) typeMap.get(k);
						Object ov = map.get(k);
						String sv = changeDataToString(ov);
						Object nv = null;
						if (sv != null) {
							switch (ts) {
							case DATA_TYPE_INTEGER:
								nv = Integer.parseInt(sv);
								break;
							case DATA_TYPE_DOUBLE:
								nv = Double.parseDouble(sv);
								break;
							default:
								nv = sv;
							}
						}
						map.put(k, nv);
					}
				}
			}
		}
	}

	public static String changeDataToString(Object ov) {
		String td = null;
		if (ov == null) {
			return null;
		} else if (ov instanceof Double) {
			td = ((Double) ov).toString();
		} else if (ov instanceof Integer) {
			td = ((Integer) ov).toString();
		} else if (ov instanceof Long) {
			td = ((Long) ov).toString();
		} else if (ov instanceof Float) {
			td = ((Float) ov).toString();
		} else {
			td = (String) ov;
		}
		return td;
	}
}
