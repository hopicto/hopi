package com.hopi.web.dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;

import com.hopi.dao.BaseDao;
import com.hopi.dao.Page;
import com.hopi.web.WebConstants;

public class StaffDaoImp extends BaseDao implements StaffDao {

	public boolean isStaffExist(String loginName) throws DataAccessException {
		String sql = "select count(1) from HW_STAFF where LOGIN_NAME=:loginName";
		Map param = new HashMap();
		param.put("loginName", loginName);
		long count = this.getJdbcTemplate().queryForLong(sql, param);
		return count > 0;
	}

	public String findStaffIdByLoginName(String loginName) throws DataAccessException {
		String sql = "select ID from HW_STAFF where LOGIN_NAME=:loginName";
		Map param = new HashMap();
		param.put("loginName", loginName);
		List data=this.queryForListAll(sql, param);
		if(data.size()>0){
			Map m1=(Map)data.get(0);
			return (String)m1.get("ID");
		}
		return null;		
	}
	
	public Map findStaffByLoginName(String loginName)
			throws DataAccessException {
		String sql = "select t1.*,t2.NAME as ORG_NAME from HW_STAFF t1 left join HW_DEPARTMENT t2 on t1.DEPARTMENT_ID=t2.ID where LOGIN_NAME=:loginName";
		Map param = new HashMap();
		param.put("loginName", loginName);
		List result = this.getJdbcTemplate().queryForList(sql, param);
		if (result.size() == 0)
			return null;
		else
			return (Map) result.get(0);
	}

	public List findStaffRole(String id) throws DataAccessException {
//		String sql = "select r.ID,r.NAME,r.CODE from HW_STAFF_ROLE ur,HW_ROLE r where ur.ROLE_ID=r.ID(+) and ur.STAFF_ID=:staffId";
		String sql = "select t3.ID,t3.NAME,t3.CODE from HW_STAFF_POSITION t1 left join HW_POSITION_ROLE t2 on t1.POSITION_ID=t2.POSITION_ID left join HW_ROLE t3 on t2.ROLE_ID=t3.ID where t1.STAFF_ID=:staffId";
		Map param = new HashMap();
		param.put("staffId", id);
		return this.getJdbcTemplate().queryForList(sql, param);
	}

	public List findStaffResource(String userId, String type, String parentId)
			throws DataAccessException {
		boolean isAdmin = isAdmin(userId);
		if (isAdmin) {
			String sql = "select * from HW_RESOURCE where PARENT_ID=:parentId and TYPE=:type order by SEQ";
			Map param = new HashMap();
			param.put("type", new Long(type));
			param.put("parentId", parentId);
			return this.getJdbcTemplate().queryForList(sql, param);
		} else {
//			String sql = "select distinct re.* from HW_STAFF_ROLE ur,HW_ROLE_RESOURCE rr,HW_RESOURCE re where ur.ROLE_ID=rr.ROLE_ID(+) and ur.USER_ID=:userId  and rr.RESOURCE_ID=re.ID and re.PARENT_ID=:parentId and re.TYPE=:type order by re.SEQ";
			StringBuffer sql=new StringBuffer();
			sql.append("select distinct t4.* from HW_STAFF_POSITION t1");
			sql.append(" left join HW_POSITION_ROLE t2 on t1.POSITION_ID=t2.POSITION_ID");
			sql.append(" left join HW_ROLE_RESOURCE t3 on t2.ROLE_ID=t3.ROLE_ID");
			sql.append(" left join HW_RESOURCE t4 on t3.RESOURCE_ID=t4.ID");
			sql.append(" where t1.STAFF_ID=:staffId and t4.TYPE=:type and t4.PARENT_ID=:parentId");
			sql.append(" order by t4.SEQ");
			
			Map param = new HashMap();
			param.put("staffId", userId);
			param.put("type", type);
			param.put("parentId", parentId);
			return this.getJdbcTemplate().queryForList(sql.toString(), param);
		}
	}

	public boolean isAdmin(String userId) throws DataAccessException {
//		String sql = "select count(1) from HW_STAFF_ROLE where USER_ID=:userId and ROLE_ID=:roleId";
		StringBuffer sql=new StringBuffer();
		sql.append("select count(t2.ROLE_ID) from HW_STAFF_POSITION t1");
		sql.append(" left join HW_POSITION_ROLE t2 on t1.POSITION_ID=t2.POSITION_ID");
		sql.append(" where t1.STAFF_ID=:staffId and t2.ROLE_ID=:roleId");		
		Map param = new HashMap();
		param.put("staffId", userId);
		param.put("roleId", WebConstants.ROLE_ADMIN_ID);
		long count = this.getJdbcTemplate().queryForLong(sql.toString(), param);
		return count > 0;
	}

	public Page queryStaffForPage(String loginName, String orgId, long start,
			long limit, String orderBy, String orderType)
			throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select u.ID,u.LOGIN_NAME,u.NAME,o.NAME as ORG_FULL_NAME,u.STATUS,u.DESCRIPTION,t.ITEM as STATUS_NAME from HW_STAFF u left join HW_DEPARTMENT o on u.DEPARTMENT_ID=o.id left join HW_DICT_TYPE t on u.status=t.id where 1=1");
		Map param = new HashMap();

		if (orgId != null && !"-1".equals(orgId)) {
			sql.append(" and u.DEPARTMENT_ID=:orgId");
			param.put("orgId", orgId);
		}

		if (loginName != null && !"".equals(loginName)) {
			sql
					.append(" and (instr(u.LOGIN_NAME,:loginName)>0 or instr(u.NAME,:loginName)>0)");
			param.put("loginName", loginName);
		}

		if (orderBy != null && !"".equals(orderBy)) {
			sql.append(" order by u.").append(orderBy);
			if (orderType != null && !"".equals(orderType)) {
				sql.append(" ").append(orderType);
			}
		}
		return this.queryForPage(start, limit, sql.toString(), param);
	}

	public Map loadStaffById(String id) throws DataAccessException {
		String sql = "select u.ID,u.DEPARTMENT_ID,u.LOGIN_NAME,u.NAME,u.EMAIL,u.MOBILE,u.PHONE,u.DESCRIPTION,o.NAME as ORG_NAME from HW_STAFF u left join HW_DEPARTMENT o on u.DEPARTMENT_ID=o.id(+) where u.ID=:id";
		Map param = new HashMap();
		param.put("id", id);
		return (Map) this.getJdbcTemplate().queryForMap(sql, param);
	}

	public void saveStaffRole(final String userId, final String[] roleIds)
			throws DataAccessException {
		Map param = new HashMap();
		param.put("userId", userId);
		this.getJdbcTemplate().update(
				"delete from HW_STAFF_ROLE where USER_ID=:userId", param);
		if (roleIds != null && roleIds.length > 0) {
			String sql = "insert into HW_STAFF_ROLE(USER_ID,ROLE_ID) values(?,?)";
//			final long id = Long.parseLong(userId);
			this.getJdbcTemplate().getJdbcOperations().batchUpdate(sql,
					new BatchPreparedStatementSetter() {
						public int getBatchSize() {
							return roleIds.length;
						}

						public void setValues(PreparedStatement ps, int i)
								throws SQLException {
							ps.setString(1, userId);
							ps.setString(2,roleIds[i]);
						}
					});
		}
	}

	public Map ownerSettingLoad(String id) throws DataAccessException {
		String sql = "select u.LOGIN_NAME,u.NAME,u.EMAIL,u.MOBILE,u.PHONE from HW_STAFF u where u.ID=:id";
		Map param = new HashMap();
		param.put("id", id);
		return (Map) this.getJdbcTemplate().queryForMap(sql, param);
	}

	public void processStaffLogin(String loginName, String loginIp)
			throws DataAccessException {
		// 记录本次登录信息
//		StringBuffer sql = new StringBuffer(
//				"update HW_STAFF set LAST_LOGIN_DATE=sysdate,LOGIN_COUNT=LOGIN_COUNT+1");// where
//		// LOGIN_NAME=:loginName");
//		Map param = new HashMap();
//		if (loginIp != null) {
//			sql.append(",LAST_LOGIN_IP=:loginIp");
//			param.put("loginIp", loginIp);
//		}
//		sql.append(" where LOGIN_NAME=:loginName");
//		param.put("loginName", loginName);
//
//		this.updateRaw(sql.toString(), param, null, null);
		String staffId=findStaffIdByLoginName(loginName);				
		Map param=new HashMap();
		param.put("STAFF_ID", staffId);
		param.put("ACCESS_IP", loginIp);
		param.put("ACCESS_TIME", new Date());
		
		this.insertRaw("HW_ACCESS_LOG", param, null, null);
	}

	public List loginCountList(int size) throws DataAccessException {
		String sql = "select ID,NAME,LOGIN_COUNT from HW_STAFF order by LOGIN_COUNT desc";
		return this.queryForList(0, size, sql, null);
	}

	public Page queryAccessLogForPage(long start, long limit, String orderBy,
			String orderType) throws DataAccessException {
		StringBuffer sql = new StringBuffer(
				"select u.ID,u.NAME,o.NAME as ORG_FULL_NAME,u.LOGIN_COUNT,u.LAST_LOGIN_DATE,u.LAST_LOGIN_IP from HW_STAFF u left join HW_ORG o on u.org_id=o.id order by u.LOGIN_COUNT desc");
		Map param = new HashMap();
		// if (orderBy != null && !"".equals(orderBy)) {
		// sql.append(" order by u.").append(orderBy);
		// if (orderType != null && !"".equals(orderType)) {
		// sql.append(" ").append(orderType);
		// }
		// }else{
		// sql.append(" order by u.LOGIN_COUNT desc");
		// }
		return this.queryForPage(start, limit, sql.toString(), param);
	}
	// //
	// public String getOrgOrCreateByName(String orgName)throws
	// DataAccessException {
	// String sql = "select ID from HW_ORG where NAME=:orgName";
	// Map param = new HashMap();
	// param.put("orgName", orgName);
	// List data=this.queryListMap(sql, param);
	// if(data.size()>0){
	// Map m=(Map)data.get(0);
	// BigDecimal id=(BigDecimal)m.get("ID");
	// return id.toString();
	// }else{
	// //添加营业部
	// String parentId="7";
	// sql = "select SEQ_HW_ORG.nextVal as ID from dual";
	// long id = this.getJdbcTemplate().queryForLong(sql, new HashMap());
	//			
	// sql="select count(1) from HW_ORG where PARENT_ID=:parentId";
	// param=new HashMap();
	// param.put("parentId", parentId);
	// long count = this.getJdbcTemplate().queryForLong(sql, param);
	//			
	// param=new HashMap();
	// param.put("ID", new Long(id));
	// param.put("NAME", orgName);
	// param.put("PARENT_ID", parentId);
	// param.put("SEQ", new Long(count+1));
	// this.insertRaw("HW_ORG", param);
	// return String.valueOf(id);
	// }
	// }
	//	
	//	
	// public void insertStaff(String orgName,String name,String
	// loginName)throws
	// DataAccessException {
	// //添加用户，先查询部门是否存在，如果不存在，则添加部门
	// // String loginName=email.substring(0,email.indexOf("@"));
	// if(isStaffExist(loginName)){
	// log.warn("用户名已经存在：loginName="+loginName);
	// }else{
	// String orgId=getOrgOrCreateByName(orgName);
	// Map param=new HashMap();
	// String sql = "select SEQ_HW_STAFF.nextVal as ID from dual";
	// long id = this.getJdbcTemplate().queryForLong(sql, new HashMap());
	// param.put("ID", new Long(id));
	// param.put("ORG_ID", orgId);
	// param.put("NAME", name);
	// param.put("LOGIN_NAME", loginName);
	// param.put("STATUS", new Long(WebConstants.USER_STATUS_VALID));
	// param.put("PASSWORD", "9cc6cdd82aa1cb48c185f000e00bf1e5");//111111
	// param.put("EMAIL", loginName+"@xyzq.com.cn");
	// this.insertRaw("HW_STAFF", param);
	//						
	// String[] ids=new String[3];
	// ids[0]=String.valueOf(WebConstants.ROLE_USER_ID);//普通用户角色
	// ids[1]=String.valueOf(WebConstants.ROLE_ANOYMOUS_ID);//匿名用户角色
	// ids[2]=String.valueOf(WebConstants.ROLE_TOUGU_ID);//投顾角色
	// this.saveStaffRole(String.valueOf(id), ids);
	// log.info("添加用户成功：name="+name+" orgName="+orgName+" loginName="+loginName);
	// }
	// }
}
