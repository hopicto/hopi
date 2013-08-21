package com.hopi.web.dao;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.BaseDao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;

public class DictDaoImp extends BaseDao implements DictDao {
	public Page queryDictTypeForPage(String sv, Map hsMap, long start,
			long limit, Sorter sorter)
			throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select * from HW_DICT_TYPE where 1=1");
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
				param.put(key, "%" + value+ "%");
				hi++;
			}
			sql.append(")");
		} else if (sv != null && !"".equals(sv)) {
			sql.append(" and (TYPE like :sv or ITEM like :sv)");
			param.put("sv", "%" + sv + "%");
		}
		//
		// if (queryKey != null && !"".equals(queryKey)) {
		// sql.append(" and name like :name");
		// param.put("name", "%" + queryKey + "%");
		// }

//		if (orderBy != null && !"".equals(orderBy)) {
//			sql.append(" order by ").append(orderBy);
//			if (orderType != null && !"".equals(orderType)) {
//				sql.append(" ").append(orderType);
//			}
//		}
		
		String sorterData=sorter.getSortString();
		if(sorterData!=null){
			sql.append(sorterData);
		}
		
		// log.info("sql="+sql);
		return this.queryForPage(start, limit, sql.toString(), param);
	}

	public List findAllDictType() throws DataAccessException {
		String sql = "select TYPE_CODE,TYPE from HW_DICT_TYPE group by TYPE_CODE,TYPE";
		Map param = new HashMap();
		return this.getJdbcTemplate().queryForList(sql, param);
	}

	public List findDictTypeByCode(String code) throws DataAccessException {
		String sql = "select ID,ITEM,ITEM_VALUE from HW_DICT_TYPE where TYPE_CODE=:code order by SEQ";
		Map param = new HashMap();
		param.put("code", code);
		return this.getJdbcTemplate().queryForList(sql, param);
	}

	public List queryDictTypeForList(String sv, Map hsMap,Sorter sorter) throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select * from HW_DICT_TYPE where 1=1");
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
			sql.append(" and (TYPE like :sv or ITEM like :sv)");
			param.put("sv", "%" + sv + "%");
		}
		//
		// if (queryKey != null && !"".equals(queryKey)) {
		// sql.append(" and name like :name");
		// param.put("name", "%" + queryKey + "%");
		// }

//		if (orderBy != null && !"".equals(orderBy)) {
//			sql.append(" order by ").append(orderBy);
//			if (orderType != null && !"".equals(orderType)) {
//				sql.append(" ").append(orderType);
//			}
//		}
		String sorterData=sorter.getSortString();
		if(sorterData!=null){
			sql.append(sorterData);
		}
		return this.queryForListAll(sql.toString(), param);
	}

	// public String getFileDownloadType(String suffix) throws
	// DataAccessException {
	// log.info("suffix="+suffix);
	// String
	// sql="select ITEM from pt_dict_type where TYPE_CODE=:typeCode and ITEM_CODE=:itemCode";
	// Map param = new HashMap();
	// param.put("typeCode", JConstants.FILE_TYPE);
	// param.put("itemCode", suffix.toLowerCase());
	// List data = this.getJdbcTemplate().queryForList(sql, param);
	// if(data.size()>0){
	// Map r=(Map)data.get(0);
	// return (String)r.get("ITEM");
	// }
	// return "application/download";
	// }
}