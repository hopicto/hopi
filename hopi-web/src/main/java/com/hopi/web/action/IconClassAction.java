package com.hopi.web.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.hopi.dao.Page;
import com.hopi.util.QueryParamMapUtil;
import com.hopi.web.WebConstants;
import com.hopi.web.dao.IconClassDao;

public class IconClassAction extends MultiActionController {
	private final static Log log = LogFactory.getLog(IconClassAction.class);
	public static final String TB_NAME = "HW_ICON_CLASS";
	private IconClassDao iconClass;

	public void setIconClassDao(IconClassDao iconClass) {
		this.iconClass = iconClass;
	}

	public ModelAndView importData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		return null;
	}

	public ModelAndView exportData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map result = new HashMap();
		String orderBy = request.getParameter("orderBy");
		String orderType = request.getParameter("orderType");
		Map hsMap = QueryParamMapUtil.getQueryParamMap(
				WebConstants.HIGH_SEARCH_PREFIX, request.getParameterMap());
		String sv = request.getParameter("sv");
		List data = iconClass.queryIconClassForList(sv, hsMap, orderBy,
				orderType);

		String[] headConfig = new String[] { "名称", "编码" };
		String[] dataConfig = new String[] { "NAME", "CODE" };
		result.put(WebConstants.EXCEL_VIEW_FILE_NAME, "图表类别.xls");
		result.put(WebConstants.EXCEL_VIEW_HEAD_CONFIG, headConfig);
		result.put(WebConstants.EXCEL_VIEW_DATA_CONFIG, dataConfig);
		result.put(WebConstants.EXCEL_VIEW_DATA, data);
		return new ModelAndView(WebConstants.EXCEL_VIEW, result);
	}

	public ModelAndView query(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String limit = request.getParameter("limit");
		String start = request.getParameter("start");
		String orderBy = request.getParameter("orderBy");
		String orderType = request.getParameter("orderType");
		Map hsMap = QueryParamMapUtil.getQueryParamMap(
				WebConstants.HIGH_SEARCH_PREFIX, request.getParameterMap());
		String sv = request.getParameter("sv");
		long pageSize = limit == null ? WebConstants.PAGE_SIZE_DEFAULT : Long
				.parseLong(limit);
		long pageStart = start == null || "".equals(start) ? 0 : Long
				.parseLong(start);
		Page page = iconClass.queryIconClassForPage(sv, hsMap, pageStart,
				pageSize, orderBy, orderType);
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
			iconClass.update(TB_NAME, param, null, null);
		} else {
			// insert
			iconClass.insert(TB_NAME, param, null, null);
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView delete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		if (id != null) {
			if (id.indexOf(",") > 0) {
				String[] ids = id.split(",");
				iconClass.batchDelete(TB_NAME, ids);
			} else {
				iconClass.delete(TB_NAME, id);
			}
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView edit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		Map role = iconClass.getById(TB_NAME, id);
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
//	public ModelAndView dictTypeCombo(HttpServletRequest request,
//			HttpServletResponse response) throws Exception {
//		List data = iconClass.findAllIconClassType();
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
//	public ModelAndView dictTypeItemCombo(HttpServletRequest request,
//			HttpServletResponse response) throws Exception {
//		String code = request.getParameter("code");
//		String tag = request.getParameter("tag");
//		String fullText = request.getParameter("fullText");
//		List data = iconClass.findIconClassTypeByCode(code);
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
