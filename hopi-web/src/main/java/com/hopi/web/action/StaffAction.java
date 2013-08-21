package com.hopi.web.action;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.dao.SaltSource;
import org.springframework.security.providers.encoding.PasswordEncoder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.hopi.dao.Page;
import com.hopi.util.QueryParamMapUtil;
import com.hopi.web.Sorter;
import com.hopi.web.WebConstants;
import com.hopi.web.dao.StaffDao;
import com.hopi.web.security.EnhancedUser;

public class StaffAction extends MultiActionController {
	private final static Log log = LogFactory.getLog(StaffAction.class);
	public static final String TB_NAME = "HW_STAFF";
	private PasswordEncoder passwordEncoder;
	private SaltSource saltSource;
	private StaffDao staffDao;
//	private StaffCustomerDao userCustomerDao;
//
//	public void setStaffCustomerDao(StaffCustomerDao userCustomerDao) {
//		this.userCustomerDao = userCustomerDao;
//	}

	public void setSaltSource(SaltSource saltSource) {
		this.saltSource = saltSource;
	}

	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	public void setStaffDao(StaffDao staffDao) {
		this.staffDao = staffDao;
	}

	public ModelAndView query(HttpServletRequest request,
			HttpServletResponse response) {
		String limit = request.getParameter("limit");
		String start = request.getParameter("start");
		Sorter sort = new Sorter(request.getParameter("sort"));
		Map hsMap = QueryParamMapUtil.getQueryParamMap(
				WebConstants.HIGH_SEARCH_PREFIX, request.getParameterMap());
		String sv = request.getParameter("sv");
		long pageSize = limit == null ? WebConstants.PAGE_SIZE_DEFAULT : Long
				.parseLong(limit);
		long pageStart = start == null || "".equals(start) ? 0 : Long
				.parseLong(start);
		Page page = staffDao.queryStaffForPage(sv, hsMap, pageStart, pageSize,
				sort);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, page);
//		List list = page.getList();
//		for (Iterator it = list.iterator(); it.hasNext();) {
//			Map m = (Map) it.next();
//			String status = (String) m.get("STATUS");
//			if (WebConstants.USER_STATUS_LOCK.equalsIgnoreCase(status)) {
//				m.put("LOCK", Boolean.TRUE);
//			} else {
//				m.put("UNLOCK", Boolean.TRUE);
//			}
//		}
//		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN, page);
	}

	public ModelAndView save(HttpServletRequest request,
			HttpServletResponse response) {
		Map param = new HashMap();
		String loginName=request.getParameter("LOGIN_NAME");
		param.put("LOGIN_NAME", loginName);
		param.put("NAME", request.getParameter("NAME"));
		param.put("EMAIL", request.getParameter("EMAIL"));
		param.put("MOBILE", request.getParameter("MOBILE"));
		param.put("PHONE", request.getParameter("PHONE"));
		param.put("DESCRIPTION", request.getParameter("DESCRIPTION"));
		String editTag = request.getParameter(WebConstants.JSON_EDIT_TAG);
		if (editTag != null && editTag.equalsIgnoreCase("true")) {
			// update
			param.put("ID", request.getParameter("ID"));
			staffDao.update(TB_NAME, param,null,null);
		} else {
			// insert
			boolean isExists=staffDao.isStaffExist(loginName);
			if(isExists){
				Map resultMap = new HashMap();				
				resultMap.put(WebConstants.JSON_SUCCESS, Boolean.FALSE);
				resultMap.put(WebConstants.JSON_ERROR_MSG, "用户名已经存在！");
				return new ModelAndView(WebConstants.JSON_VIEW, resultMap);
			}else{
				param.put("ORG_ID", request.getParameter("ORG_ID"));
				param.put("STATUS", new Long(WebConstants.USER_STATUS_VALID));
				param.put("PASSWORD", passwordEncoder.encodePassword(request
						.getParameter("PASSWORD"), saltSource.getSalt(null)));
				param.put("LOGIN_COUNT", new Integer(0));
				staffDao.insert(TB_NAME, param,null,null);
				Map curStaff=this.staffDao.findStaffByLoginName(loginName);
				String userId=(String)curStaff.get("ID");
				String[] ids=new String[2];
				ids[0]=WebConstants.ROLE_USER_ID;//默认设置两个角色
				ids[1]=WebConstants.ROLE_ANOYMOUS_ID;//默认设置两个角色
				staffDao.saveStaffRole(userId.toString(), ids);
			}			
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView delete(HttpServletRequest request,
			HttpServletResponse response) {
		String id = request.getParameter("id");
		if (id != null) {
			if (id.indexOf(",") > 0) {
				String[] ids = id.split(",");
				staffDao.batchDelete(TB_NAME, ids);
			} else {
				staffDao.delete(TB_NAME, id);
			}
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView edit(HttpServletRequest request,
			HttpServletResponse response) {
		String id = request.getParameter("id");
		Map role = staffDao.loadStaffById(id);
		Map resultMap = new HashMap();
		role.put(WebConstants.JSON_EDIT_TAG, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, role);
		return new ModelAndView(WebConstants.JSON_VIEW, resultMap);
	}

	public ModelAndView userRoleCombo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String userId = request.getParameter("userId");
		List data = staffDao.findStaffRole(userId);
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, data);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}

	public ModelAndView saveStaffRole(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String userRoles = request.getParameter("USER_ROLES");
		String userId = request.getParameter("USER_ID");
		String[] ids = null;
		if (userRoles != null && !"".equals(userRoles)) {
			ids = userRoles.split(",");
		}
		staffDao.saveStaffRole(userId, ids);
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}

	// 锁定用户
	public ModelAndView lock(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		Map param = new HashMap();
		param.put("ID", id);
		param.put("STATUS", new Long(WebConstants.USER_STATUS_LOCK));
		staffDao.update(TB_NAME, param,null,null);
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}

	// 解除锁定
	public ModelAndView unlock(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		Map param = new HashMap();
		param.put("ID", id);
		param.put("STATUS", new Long(WebConstants.USER_STATUS_VALID));
		staffDao.update(TB_NAME, param,null,null);
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}

	// 重置密码
	public ModelAndView resetPassword(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");
		Map param = new HashMap();
		param.put("ID", userId);
		param.put("PASSWORD", passwordEncoder.encodePassword(password,
				saltSource.getSalt(null)));
		staffDao.update(TB_NAME, param,null,null);
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}

	// 修改个人密码
	public ModelAndView changeSelfPass(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Authentication au = SecurityContextHolder.getContext()
				.getAuthentication();
		EnhancedUser user = (EnhancedUser) au.getPrincipal();
		String oldPassword = request.getParameter("OLD_PASSWORD");
		String newPassword = request.getParameter("NEW_PASSWORD");
		Map resultMap = new HashMap();
		Map u = staffDao.getById(TB_NAME, user.getId());
		String spass = (String) u.get("PASSWORD");
		if (passwordEncoder.isPasswordValid(spass, oldPassword, saltSource
				.getSalt(user))) {
			Map param = new HashMap();
			param.put("ID", new Long(user.getId()));
			param.put("PASSWORD", passwordEncoder.encodePassword(newPassword,
					saltSource.getSalt(user)));
			staffDao.update(TB_NAME, param,null,null);
			resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		} else {
			resultMap.put(WebConstants.JSON_SUCCESS, Boolean.FALSE);
			resultMap.put(WebConstants.JSON_ERROR_MSG, "原密码错误");
		}
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}
	// 修改个人信息_加载
	public ModelAndView ownerSettingLoad(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Authentication au = SecurityContextHolder.getContext()
				.getAuthentication();
		EnhancedUser user = (EnhancedUser) au.getPrincipal();				
		Map role = staffDao.ownerSettingLoad(String.valueOf(user.getId()));
		Map resultMap = new HashMap();
		role.put(WebConstants.JSON_EDIT_TAG, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, role);
		return new ModelAndView(WebConstants.JSON_VIEW, resultMap);	
	}
	// 修改个人信息
	public ModelAndView ownerSetting(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Authentication au = SecurityContextHolder.getContext()
				.getAuthentication();
		EnhancedUser user = (EnhancedUser) au.getPrincipal();
		Map param=new HashMap();
		param.put("NAME", request.getParameter("NAME"));
		param.put("EMAIL", request.getParameter("EMAIL"));
		param.put("MOBILE", request.getParameter("MOBILE"));
		param.put("PHONE", request.getParameter("PHONE"));		
		param.put("ID", new Long(user.getId()));
		staffDao.update(TB_NAME, param,null,null);		
		return new ModelAndView(WebConstants.JSON_VIEW);		
	}

	// /**
	// * 类别字典下拉列表
	// *
	// * @param request
	// * @param response
	// * @return
	// * @throws Exception
	// */
	// public ModelAndView dictTypeCombo(HttpServletRequest request,
	// HttpServletResponse response) throws Exception {
	// List data = dictDao.findAllDictType();
	// Map all = new HashMap();
	// all.put("TYPE", "全部类别");
	// all.put("TYPE_CODE", "-1");
	// data.add(0, all);
	// Map resultMap = new HashMap();
	// resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
	// resultMap.put(WebConstants.JSON_DATA, data);
	// return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
	// resultMap);
	// }

//	// 用户可选组织范围
//	public ModelAndView validOrg(HttpServletRequest request,
//			HttpServletResponse response) throws Exception {
//		Authentication au = SecurityContextHolder.getContext()
//				.getAuthentication();
//		EnhancedUser user = (EnhancedUser) au.getPrincipal();
//		List data = userCustomerDao.findStaffOrgList(String
//				.valueOf(user.getId()));
//		Map all=new HashMap();
//		all.put("ID", "-1");
//		all.put("NAME", "全部可选部门");		
//		data.add(0, all);
//		Map resultMap = new HashMap();
//		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
//		resultMap.put(WebConstants.JSON_DATA, data);
//		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
//				resultMap);
//	}
//
//	// 用户可选投顾范围
//	public ModelAndView validTg(HttpServletRequest request,
//			HttpServletResponse response) throws Exception {
//		Authentication au = SecurityContextHolder.getContext()
//				.getAuthentication();
//		EnhancedUser user = (EnhancedUser) au.getPrincipal();
//		String orgId = request.getParameter("orgId");
//		List data = userCustomerDao.findStaffTGList(orgId, String.valueOf(user
//				.getId()));
//		Map all=new HashMap();
//		all.put("ID", "-1");
//		all.put("NAME", "全部可选投顾");		
//		data.add(0, all);
//		Map resultMap = new HashMap();
//		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
//		resultMap.put(WebConstants.JSON_DATA, data);
//		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
//				resultMap);
//	}	
}
