package com.hopi.web;

import java.util.Map;

import net.sf.json.JSONArray;

/**
 * 排序字段处理
 * @author 董依良
 * @since 2013-8-20
 */

public class Sorter {
	public static final String SORT_PROPERTY = "property";
	public static final String SORT_DIRECTION = "direction";
	private JSONArray sortConfig;

	public Sorter(String sorterData) {
		if (sorterData != null) {
			this.sortConfig = JSONArray.fromObject(sorterData);
		}
	}

	public JSONArray getSortConfig() {
		return this.sortConfig;
	}

	public String getSortString() {
		if (this.sortConfig != null) {
			StringBuffer sb = new StringBuffer(" order by ");
			for (int i = 0; i < this.sortConfig.size(); i++) {
				Map so = (Map) this.sortConfig.get(i);
				if(i>0){
					sb.append(",");
				}
				sb.append((String) so.get(SORT_PROPERTY)).append(" ").append(
						(String) so.get(SORT_DIRECTION));
			}
			return sb.toString();
		} else {
			return null;
		}
	}
}
