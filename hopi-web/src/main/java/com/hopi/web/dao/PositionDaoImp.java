package com.hopi.web.dao;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.BaseDao;
import com.hopi.dao.Page;
import com.hopi.util.DebugUtil;
import com.hopi.web.Sorter;

/**
 * @author 董依良
 * @since 2013-8-21
 */

public class PositionDaoImp extends BaseDao implements PositionDao {
	public Map getPositionById(String id) throws DataAccessException {
		StringBuffer sql = new StringBuffer("select t1.*,t2.NAME as DEPARTMENT_NAME from HW_POSITION t1");
		sql.append(" left join HW_DEPARTMENT t2 on t1.DEPARTMENT_ID=t2.ID");
		sql.append(" where t1.ID=:id order by t1.CODE");
		Map param = new HashMap();
		param.put("id", id);
		List data = this.queryForListAll(sql.toString(), param);
		if (data.size() > 0) {
			return (Map) data.get(0);
		} else {
			return null;
		}
	}

	public Page queryPositionForPage(String sv, Map hsMap,
			long start, long limit, Sorter sorter) throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select t1.*,t2.NAME as DEPARTMENT_NAME from HW_POSITION t1 left join HW_DEPARTMENT t2 on t1.DEPARTMENT_ID=t2.ID where 1=1");
		Map param = new HashMap();		
		if (hsMap != null && hsMap.size() > 0) {
			sql.append(" and (");
			int hi = 0;
			for (Iterator it = hsMap.entrySet().iterator(); it.hasNext();) {
				Entry entry = (Entry) it.next();
				String key = (String) entry.getKey();
				String value = (String) entry.getValue();				
				if(key.equalsIgnoreCase("DEPARTMENT_NAME")){
					continue;
				}
				if (hi > 0) {
					sql.append(" or ");
				}
				log.info("key:"+key+" value:"+value);
				if(key.equalsIgnoreCase("DEPARTMENT_ID")){
					sql.append("t1.DEPARTMENT_ID=:DEPARTMENT_ID");
					param.put(key, value);
				}else{
					sql.append(key).append(" like :").append(key);
					param.put(key,  "%" + value + "%");					
				}							
				hi++;
			}
			sql.append(")");
		} else if (sv != null && !"".equals(sv)) {
			sql.append(" and (t1.NAME like :sv or t1.CODE like :sv)");
			param.put("sv", "%" + sv + "%");
		}

		String sorterData = sorter.getSortString();
		if (sorterData != null) {
			sql.append(sorterData);
		}

		log.info("sql:"+sql);
		log.info("param:"+DebugUtil.viewEntity(param));
		return this.queryForPage(start, limit, sql.toString(), param);
	}
}
