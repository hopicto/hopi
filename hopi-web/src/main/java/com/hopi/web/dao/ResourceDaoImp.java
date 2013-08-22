package com.hopi.web.dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;

import com.hopi.dao.BaseDao;
import com.hopi.dao.Page;
import com.hopi.web.WebConstants;

public class ResourceDaoImp extends BaseDao implements ResourceDao {
	public List findResourceByType(String type) throws DataAccessException {
		String sql = "select * from HW_RESOURCE where TYPE=:TYPE";
		Map param = new HashMap();
		param.put("TYPE", type);
		return this.getJdbcTemplate().queryForList(sql, param);
	}

	public List findAllUrlResources() throws DataAccessException {
		String sql = "select * from HW_RESOURCE where TYPE=:TYPE order by CONTENT";
		Map param = new HashMap();
		param.put("TYPE", new Long(WebConstants.RESOURCE_TYPE_URL));
		return this.getJdbcTemplate().queryForList(sql, param);
	}

	public List findResourceRole(String resourceId) throws DataAccessException {
		String sql = "select r.ID,r.NAME,r.CODE from HW_ROLE_RESOURCE rr,HW_ROLE r where rr.role_id=r.id(+) and rr.resource_id=:resourceId";
		Map param = new HashMap();
		param.put("resourceId", resourceId);
		return this.getJdbcTemplate().queryForList(sql, param);
	}

	/**
	 * 根据父菜单查找子菜单
	 * 
	 * @param parentId
	 * @return
	 * @throws DataAccessException
	 */
	public List findMenuResourceByParentId(String parentId)
			throws DataAccessException {
		String sql = "select t1.id,t1.name,t1.seq,count(t2.id) as COUNT from HW_RESOURCE t1 left join HW_RESOURCE t2 on t1.ID = t2.PARENT_ID where t1.type=:type and t1.PARENT_ID=:parentId group by t1.ID,t1.name,t1.seq order by t1.seq";
		Map param = new HashMap();
		param.put("parentId", parentId);
		param.put("type", new Long(WebConstants.RESOURCE_TYPE_MENU));
		return this.getJdbcTemplate().queryForList(sql, param);
	}

	public List findMenuResourceByTree(String parentId)
			throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select ID,NAME,SEQ,ICON_CLASS from HW_RESOURCE");
		sql.append(" where TYPE=:type and PARENT_ID=:parentId order by SEQ");
		Map param = new HashMap();
		param.put("parentId", parentId);
		param.put("type", WebConstants.RESOURCE_TYPE_MENU);
		List rawData = this.queryForListAll(sql.toString(), param);
		List newData = new ArrayList();
		for (Iterator it = rawData.iterator(); it.hasNext();) {
			Map m = (Map) it.next();
			String id = (String) m.get("ID");
			String name = (String) m.get("NAME");
			String iconClass = (String) m.get("ICON_CLASS");
			BigDecimal seq = (BigDecimal) m.get("SEQ");
			Map nm = new HashMap();
			nm.put("id", id);
			nm.put("text", name);
			nm.put("iconCls", iconClass);
			boolean leaf = true;
			List childData = findMenuResourceByTree(id);
			if (childData != null && childData.size() > 0) {
				nm.put("children", childData);
				leaf = false;
			}
			nm.put("leaf", leaf);
			newData.add(nm);
		}
		return newData;
	}

	/**
	 * 查找图标列表
	 * 
	 * @return
	 * @throws DataAccessException
	 */
	public List findIconList() throws DataAccessException {
		String sql = "select ID,ICON_CLASS from HW_RESOURCE_ICON order by ID";
		return this.queryForListAll(sql, null);
	}

	/**
	 * 根据菜单查找URL资源
	 * 
	 * @param parentId
	 * @return
	 * @throws DataAccessException
	 */
	public List findUrlResourceByParentId(String parentId)
			throws DataAccessException {
		String sql = "select * from HW_RESOURCE where TYPE=:type and PARENT_ID=:parentId";
		Map param = new HashMap();
		param.put("parentId", parentId);
		param.put("type", new Long(WebConstants.RESOURCE_TYPE_URL));
		return this.getJdbcTemplate().queryForList(sql, param);
	}

	public Page queryUrlResourceForPage(String parentId, long start,
			long limit, String orderBy, String orderType)
			throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select * from HW_RESOURCE where PARENT_ID=:parentId and TYPE=:type");
		Map param = new HashMap();
		param.put("parentId", parentId);
		param.put("type", new Long(WebConstants.RESOURCE_TYPE_URL));
		if (orderBy != null && !"".equals(orderBy)) {
			sql.append(" order by ").append(orderBy);
			if (orderType != null && !"".equals(orderType)) {
				sql.append(" ").append(orderType);
			}
		}
		return this.queryForPage(start, limit, sql.toString(), param);
	}

	public void saveResourceRole(final String resourceId, final String[] roleIds)
			throws DataAccessException {
		Map param = new HashMap();
		param.put("resourceId", resourceId);
		this.getJdbcTemplate().update(
				"delete from HW_ROLE_RESOURCE where RESOURCE_ID=:resourceId",
				param);
		if (roleIds != null && roleIds.length > 0) {
			String sql = "insert into HW_ROLE_RESOURCE(RESOURCE_ID,ROLE_ID) values(?,?)";
			// final long id = Long.parseLong(resourceId);
			this.getJdbcTemplate().getJdbcOperations().batchUpdate(sql,
					new BatchPreparedStatementSetter() {
						public int getBatchSize() {
							return roleIds.length;
						}

						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							ps.setString(1, resourceId);
							ps.setString(2, roleIds[i]);
						}
					});
		}
	}
}
