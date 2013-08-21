package com.hopi.web.action;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.hopi.dao.Page;
import com.hopi.util.QueryParamMapUtil;
import com.hopi.web.Sorter;
import com.hopi.web.WebConstants;
import com.hopi.web.dao.RoleDao;

public class RoleAction extends MultiActionController {
	private final static Log log = LogFactory.getLog(RoleAction.class);
	public static final String TB_NAME = "HW_ROLE";
	private RoleDao roleDao;

	public void setRoleDao(RoleDao roleDao) {
		this.roleDao = roleDao;
	}

	public ModelAndView importData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		return null;
	}

	public ModelAndView query(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
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
		Page page = roleDao.queryRoleForPage(sv, hsMap, pageStart, pageSize,
				sort);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, page);
	}

	public ModelAndView save(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map param = new HashMap();
		String id = request.getParameter("ID");
		param.put("NAME", request.getParameter("NAME"));
		param.put("CODE", request.getParameter("CODE"));
		String editTag = request.getParameter(WebConstants.JSON_EDIT_TAG);
		if (editTag != null && editTag.equalsIgnoreCase("true")) {
			// update
			param.put("ID", id);
			roleDao.update(TB_NAME, param, null, null);
		} else {
			// insert
			roleDao.insert(TB_NAME, param, null, null);
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView delete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		if (id != null) {
			if (id.indexOf(",") > 0) {
				String[] ids = id.split(",");
				roleDao.batchDelete(TB_NAME, ids);
			} else {
				roleDao.delete(TB_NAME, id);
			}
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView edit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		Map role = roleDao.getById(TB_NAME, id);
		Map resultMap = new HashMap();
		role.put(WebConstants.JSON_EDIT_TAG, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, role);
		return new ModelAndView(WebConstants.JSON_VIEW, resultMap);
	}
}
