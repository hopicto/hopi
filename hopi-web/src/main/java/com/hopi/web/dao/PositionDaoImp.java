package com.hopi.web.dao;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.BaseDao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;

/**
 * @author 董依良
 * @since 2013-8-21
 */

public class PositionDaoImp extends BaseDao implements PositionDao {
	public Page queryPositionForPage(String departmentId, String sv, Map hsMap,
			long start, long limit, Sorter sorter) throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select * from HW_POSITION where 1=1");
		Map param = new HashMap();
		if(departmentId!=null&&departmentId.length()>0){
			sql.append(" and DEPARTMENT_ID=:departmentId");
			param.put("departmentId", departmentId);
		}
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

		String sorterData = sorter.getSortString();
		if (sorterData != null) {
			sql.append(sorterData);
		}

		return this.queryForPage(start, limit, sql.toString(), param);
	}
}
