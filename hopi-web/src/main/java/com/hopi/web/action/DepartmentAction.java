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
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.hopi.web.WebConstants;
import com.hopi.web.dao.DepartmentDao;

public class DepartmentAction extends MultiActionController {
	private final static Log log = LogFactory.getLog(DepartmentAction.class);
	public static final String TB_NAME = "HW_DEPARTMENT";
	private DepartmentDao departmentDao;

	public void setDepartmentDao(DepartmentDao departmentDao) {
		this.departmentDao = departmentDao;
	}

	public ModelAndView importData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		return null;
	}
	public ModelAndView tree(HttpServletRequest request,
			HttpServletResponse response) {
		String parentId=request.getParameter("node");
		List ur = this.departmentDao.findDepartmentByParentId(parentId);
		List result = new ArrayList();
		for (Iterator it = ur.iterator(); it.hasNext();) {
			Map re = (Map) it.next();
			Map map = new HashMap();
			map.put("id", re.get("ID"));
			map.put("text", re.get("NAME"));
			map.put("code", re.get("CODE"));
			map.put("seq",(BigDecimal)re.get("SEQ"));
			BigDecimal leaf = (BigDecimal) re.get("COUNT");
			boolean isLeaf = leaf.intValue() ==0;
//			if (isLeaf) {
//				// map.put("href", re.get("CONTENT"));
//				map.put("module", re.get("CONTENT"));
//			} else {
//				map.put("expanded", Boolean.FALSE);
//			}
			map.put("leaf", new Boolean(isLeaf));
			result.add(map);
		}
//		Map resultMap = new HashMap();
//		resultMap.put(Constants.JSON_DATA, result);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				result);
	}
	
//	public ModelAndView query(HttpServletRequest request,
//			HttpServletResponse response) throws Exception {
//		String limit = request.getParameter("limit");
//		String start = request.getParameter("start");
//		Sorter sort = new Sorter(request.getParameter("sort"));
//		// String orderBy = request.getParameter("orderBy");
//		// String orderType = request.getParameter("orderType");
//		Map hsMap = QueryParamMapUtil.getQueryParamMap(
//				WebConstants.HIGH_SEARCH_PREFIX, request.getParameterMap());
//		String sv = request.getParameter("sv");
//		long pageSize = limit == null ? WebConstants.PAGE_SIZE_DEFAULT : Long
//				.parseLong(limit);
//		long pageStart = start == null || "".equals(start) ? 0 : Long
//				.parseLong(start);
//		Page page = departmentDao.queryDepartmentForPage(sv, hsMap, pageStart,
//				pageSize, sort);
//		return new ModelAndView(WebConstants.JSON_VIEW,
//				WebConstants.JSON_CLEAN, page);
//	}

	public ModelAndView save(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map param = new HashMap();
		String id = request.getParameter("ID");
		param.put("TYPE", request.getParameter("TYPE"));
		param.put("TYPE_CODE", request.getParameter("TYPE_CODE"));
		param.put("ITEM", request.getParameter("ITEM"));
		param.put("ITEM_CODE", request.getParameter("ITEM_CODE"));
		param.put("ITEM_VALUE", request.getParameter("ITEM_VALUE"));
		param.put("SEQ", request.getParameter("SEQ"));
		param.put("DESCRIPTION", request.getParameter("DESCRIPTION"));
		String editTag = request.getParameter(WebConstants.JSON_EDIT_TAG);
		if (editTag != null && editTag.equalsIgnoreCase("true")) {
			// update
			param.put("ID", id);
			departmentDao.update(TB_NAME, param, null, null);
		} else {
			// insert
			departmentDao.insert(TB_NAME, param, null, null);
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView delete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		if (id != null) {
			if (id.indexOf(",") > 0) {
				String[] ids = id.split(",");
				departmentDao.batchDelete(TB_NAME, ids);
			} else {
				departmentDao.delete(TB_NAME, id);
			}
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView edit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		Map role = departmentDao.getById(TB_NAME, id);
		Map resultMap = new HashMap();
		role.put(WebConstants.JSON_EDIT_TAG, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, role);
		return new ModelAndView(WebConstants.JSON_VIEW, resultMap);
	}

//	/**
//	 * 类别字典下拉列表
//	 * 
//	 * @param request
//	 * @param response
//	 * @return
//	 * @throws Exception
//	 */
//	public ModelAndView departmentTypeCombo(HttpServletRequest request,
//			HttpServletResponse response) throws Exception {
//		List data = departmentDao.findAllDepartmentType();
//		Map all = new HashMap();
//		all.put("TYPE", "全部类别");
//		all.put("TYPE_CODE", "-1");
//		data.add(0, all);
//		Map resultMap = new HashMap();
//		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
//		resultMap.put(WebConstants.JSON_DATA, data);
//		return new ModelAndView(WebConstants.JSON_VIEW,
//				WebConstants.JSON_CLEAN, resultMap);
//	}
//
//	// 类型字典combo
//	public ModelAndView departmentTypeItemCombo(HttpServletRequest request,
//			HttpServletResponse response) throws Exception {
//		String code = request.getParameter("code");
//		String tag = request.getParameter("tag");
//		String fullText = request.getParameter("fullText");
//		List data = departmentDao.findDepartmentTypeByCode(code);
//		if (tag != null && "1".equals(tag)) {
//			Map all = new HashMap();
//			all.put("ITEM", fullText);
//			all.put("ID", "-1");
//			data.add(0, all);
//		}
//		Map resultMap = new HashMap();
//		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
//		resultMap.put(WebConstants.JSON_DATA, data);
//		return new ModelAndView(WebConstants.JSON_VIEW,
//				WebConstants.JSON_CLEAN, resultMap);
//	}
	
	// public ModelAndView combo(HttpServletRequest request,
	// HttpServletResponse response) throws Exception {
	// String appId = request.getParameter("appId");
	// List data = moduleDao.findModuleByApp(appId);
	// Map resultMap = new HashMap();
	// resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
	// resultMap.put(WebConstants.JSON_DATA, data);
	// return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
	// resultMap);
	// }
}
