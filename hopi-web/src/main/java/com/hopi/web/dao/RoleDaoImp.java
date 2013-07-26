package com.hopi.web.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.BaseDao;
import com.hopi.dao.Page;

public class RoleDaoImp extends BaseDao implements RoleDao {
	public List getAllRole() throws DataAccessException {
		String sql = "select ID,NAME from HW_ROLE order by ID";
		return this.getJdbcTemplate().queryForList(sql, new HashMap());
	}

	public Page queryRoleForPage(String roleCode, long start, long limit,
			String orderBy, String orderType) throws DataAccessException {
		StringBuffer sql = new StringBuffer("select * from HW_ROLE");
		Map param = new HashMap();
		if (roleCode != null && !"".equals(roleCode)) {
			sql.append(" where instr(CODE,:roleCode)>0 or instr(NAME,:roleCode)>0");
			param.put("roleCode", roleCode);
		}
		if (orderBy != null && !"".equals(orderBy)) {
			sql.append(" order by ").append(orderBy);
			if (orderType != null && !"".equals(orderType)) {
				sql.append(" ").append(orderType);
			}
		}
		return this.queryForPage(start, limit, sql.toString(), param);
	}
}
