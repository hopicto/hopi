package com.hopi.web.action;

import java.math.BigDecimal;
import java.util.ArrayList;
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
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.hopi.web.WebConstants;
import com.hopi.web.dao.StaffDao;
import com.hopi.web.security.EnhancedUser;

public class MainAction extends MultiActionController {
	private final static Log log = LogFactory.getLog(MainAction.class);
	// private ResourceDao resourceDao;
	private StaffDao staffDao;

	// private SecurityCache securityCache;

	// public void setSecurityCache(SecurityCache securityCache) {
	// this.securityCache = securityCache;
	// }

	public void setStaffDao(StaffDao staffDao) {
		this.staffDao = staffDao;
	}

	// public void setResourceDao(ResourceDao resourceDao) {
	// this.resourceDao = resourceDao;
	// }

	public ModelAndView main(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// int countOnlineStaff = securityCache.countOnlineStaff();
		Authentication au = SecurityContextHolder.getContext()
				.getAuthentication();
		String theme=request.getParameter("theme");
		if(theme==null||theme.length()<1){
			theme="classic";
		}
		EnhancedUser staff = (EnhancedUser) au.getPrincipal();
		Map um = staffDao.findStaffByLoginName(staff.getUsername());
		Map result = new HashMap();
		result.put("staff", um);		
		result.put("theme", theme);
		// result.put("onlineStaffs", new Integer(countOnlineStaff));
		return new ModelAndView("main", result);
	}

	public ModelAndView tree(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Authentication au = SecurityContextHolder.getContext()
				.getAuthentication();
		EnhancedUser staff = (EnhancedUser) au.getPrincipal();
		String parentId = request.getParameter("node");
		List ur = staffDao.findStaffResource(staff.getId(),
				WebConstants.RESOURCE_TYPE_MENU, parentId);
		List result = new ArrayList();
		for (Iterator it = ur.iterator(); it.hasNext();) {
			Map re = (Map) it.next();
			Map map = new HashMap();
			map.put("id", re.get("ID"));
			map.put("text", re.get("NAME"));
			BigDecimal leaf = (BigDecimal) re.get("LEAF");
			boolean isLeaf = leaf.intValue() == 1;
			if (isLeaf) {
				// map.put("href", re.get("CONTENT"));
				map.put("module", re.get("CONTENT"));
				map.put("extprop", re.get("EXT_PROP"));
			} else {
//				map.put("expanded", Boolean.FALSE);
				map.put("expanded", Boolean.TRUE);
			}
			map.put("leaf", new Boolean(isLeaf));
			result.add(map);
		}
		// Map resultMap = new HashMap();
		// resultMap.put(WebConstants.JSON_DATA, result);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, result);
	}

	// // 访问次数
	// public ModelAndView accessStore(HttpServletRequest request,
	// HttpServletResponse response) throws Exception {
	// List data = staffDao.loginCountList(10);
	// // List data = customerDao.findProfitByCustomer(customer, beginDate,
	// // endDate);
	// Map resultMap = new HashMap();
	// resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
	// resultMap.put(WebConstants.JSON_DATA, data);
	// return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
	// resultMap);
	// }

}
