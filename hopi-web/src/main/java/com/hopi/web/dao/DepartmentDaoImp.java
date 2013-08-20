package com.hopi.web.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.BaseDao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;
import com.hopi.web.WebConstants;

public class DepartmentDaoImp extends BaseDao implements DepartmentDao {

	public List findDepartmentByParentId(String parentId)
			throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select t1.ID,t1.NAME,t1.CODE,t1.SEQ,count(t2.id) as count");
		sql
				.append(" from HW_DEPARTMENT t1 left join HW_DEPARTMENT t2 on t1.ID = t2.PARENT_ID");
		sql.append(" where t1.parent_id=:parentId");
		if (WebConstants.DEPARTMENT_ROOT.equalsIgnoreCase(parentId)) {
			// 如果是忽略根节点本身
			sql.append(" and t1.id<>:parentId");
		}
		sql.append(" group by t1.ID,t1.NAME,t1.CODE,t1.SEQ order by t1.SEQ");
		Map param = new HashMap();
		param.put("parentId", parentId);
		return this.getJdbcTemplate().queryForList(sql.toString(), param);
	}

	public Page queryDepartmentForPage(String parentId, long start, long limit,
			Sorter sorter) throws DataAccessException {
		StringBuffer sql = new StringBuffer("select * from HW_DEPARTMENT");
		Map param = new HashMap();
		if (parentId != null && !"".equals(parentId)) {
			sql.append(" where PARENT_ID=:parentId");
			param.put("parentId", parentId);
		}

		// if (orderBy != null && !"".equals(orderBy)) {
		// sql.append(" order by ").append(orderBy);
		// if (orderType != null && !"".equals(orderType)) {
		// sql.append(" ").append(orderType);
		// }
		// }
		String sorterData = sorter.getSortString();
		if (sorterData != null) {
			sql.append(sorterData);
		}
		return this.queryForPage(start, limit, sql.toString(), param);
	}

	public Map getDepartmentById(String id) throws DataAccessException {
		String sql = "select t1.*,t2.NAME as PARENT_NAME from HW_DEPARTMENT t1 left join HW_DEPARTMENT t2 on t1.PARENT_ID=t2.ID where t1.ID=:id";
		Map param = new HashMap();
		param.put("id", id);
		List data = this.queryForListAll(sql, param);
		if (data.size() > 0) {
			return (Map) data.get(0);
		} else {
			return null;
		}
	}

}
