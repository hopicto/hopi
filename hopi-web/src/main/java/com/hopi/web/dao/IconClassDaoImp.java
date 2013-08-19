package com.hopi.web.dao;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.BaseDao;
import com.hopi.dao.Page;

/**
 * @author 董依良
 * @since 2013-8-19
 */

public class IconClassDaoImp extends BaseDao implements IconClassDao {

	public Page queryIconClassForPage(String sv, Map hsMap, long start,
			long limit, String orderBy, String orderType)
			throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select * from HW_ICON_CLASS where 1=1");
		Map param = new HashMap();
		if (hsMap != null && hsMap.size() > 0) {
			sql.append(" and (");
			int hi = 0;
			for (Iterator it = hsMap.entrySet().iterator(); it.hasNext();) {
				Entry entry = (Entry) it.next();
				String key = (String) entry.getKey();
				String value = (String) entry.getValue();
				if (hi > 0) {
					sql.append(" or ");
				}
				sql.append(key).append(" like :").append(key);
				param.put(key, value);
				hi++;
			}
			sql.append(")");
		} else if (sv != null && !"".equals(sv)) {
			sql.append(" and (NAME like :sv or CODE like :sv)");
			param.put("sv", "%" + sv + "%");
		}

		if (orderBy != null && !"".equals(orderBy)) {
			sql.append(" order by ").append(orderBy);
			if (orderType != null && !"".equals(orderType)) {
				sql.append(" ").append(orderType);
			}
		}
		return this.queryForPage(start, limit, sql.toString(), param);
	}

	public List queryIconClassForList(String sv, Map hsMap, String orderBy,
			String orderType) throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select * from HW_ICON_CLASS where 1=1");
		Map param = new HashMap();
		if (hsMap != null && hsMap.size() > 0) {
			sql.append(" and (");
			int hi = 0;
			for (Iterator it = hsMap.entrySet().iterator(); it.hasNext();) {
				Entry entry = (Entry) it.next();
				String key = (String) entry.getKey();
				String value = (String) entry.getValue();
				if (hi > 0) {
					sql.append(" or ");
				}
				sql.append(key).append(" like :").append(key);
				param.put(key, value);
				hi++;
			}
			sql.append(")");
		} else if (sv != null && !"".equals(sv)) {
			sql.append(" and (NAME like :sv or CODE like :sv)");
			param.put("sv", "%" + sv + "%");
		}

		if (orderBy != null && !"".equals(orderBy)) {
			sql.append(" order by ").append(orderBy);
			if (orderType != null && !"".equals(orderType)) {
				sql.append(" ").append(orderType);
			}
		}
		return this.queryForListAll(sql.toString(), param);
	}
}
