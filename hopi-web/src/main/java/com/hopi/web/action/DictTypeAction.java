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
import com.hopi.web.Sorter;
import com.hopi.web.WebConstants;
import com.hopi.web.dao.DictDao;

public class DictTypeAction extends MultiActionController {
	private final static Log log = LogFactory.getLog(DictTypeAction.class);
	public static final String TB_NAME = "HW_DICT_TYPE";
	private DictDao dictDao;

	public void setDictDao(DictDao dictDao) {
		this.dictDao = dictDao;
	}

	public ModelAndView importData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		return null;
	}

	public ModelAndView exportData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map result = new HashMap();
		Sorter sort = new Sorter(request.getParameter("sort"));
		Map hsMap = QueryParamMapUtil.getQueryParamMap(
				WebConstants.HIGH_SEARCH_PREFIX, request.getParameterMap());
		String sv = request.getParameter("sv");
		List data = dictDao.queryDictTypeForList(sv, hsMap, sort);

		String[] headConfig = new String[] { "分类名称", "分类代码", "元素名称", "元素编码",
				"元素值", "序号" };
		String[] dataConfig = new String[] { "TYPE", "TYPE_CODE", "ITEM",
				"ITEM_CODE", "ITEM_VALUE", "SEQ" };
		result.put(WebConstants.EXCEL_VIEW_FILE_NAME, "数据类别字典.xls");
		result.put(WebConstants.EXCEL_VIEW_HEAD_CONFIG, headConfig);
		result.put(WebConstants.EXCEL_VIEW_DATA_CONFIG, dataConfig);
		result.put(WebConstants.EXCEL_VIEW_DATA, data);
		return new ModelAndView(WebConstants.EXCEL_VIEW, result);
	}

	public ModelAndView query(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String limit = request.getParameter("limit");
		String start = request.getParameter("start");
		Sorter sort = new Sorter(request.getParameter("sort"));
		// String orderBy = request.getParameter("orderBy");
		// String orderType = request.getParameter("orderType");
		Map hsMap = QueryParamMapUtil.getQueryParamMap(
				WebConstants.HIGH_SEARCH_PREFIX, request.getParameterMap());
		String sv = request.getParameter("sv");
		long pageSize = limit == null ? WebConstants.PAGE_SIZE_DEFAULT : Long
				.parseLong(limit);
		long pageStart = start == null || "".equals(start) ? 0 : Long
				.parseLong(start);
		Page page = dictDao.queryDictTypeForPage(sv, hsMap, pageStart,
				pageSize, sort);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, page);
	}

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
			dictDao.update(TB_NAME, param, null, null);
		} else {
			// insert
			dictDao.insert(TB_NAME, param, null, null);
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView delete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		if (id != null) {
			if (id.indexOf(",") > 0) {
				String[] ids = id.split(",");
				dictDao.batchDelete(TB_NAME, ids);
			} else {
				dictDao.delete(TB_NAME, id);
			}
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView edit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		Map role = dictDao.getById(TB_NAME, id);
		Map resultMap = new HashMap();
		role.put(WebConstants.JSON_EDIT_TAG, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, role);
		return new ModelAndView(WebConstants.JSON_VIEW, resultMap);
	}

	/**
	 * 类别字典下拉列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView dictTypeCombo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		List data = dictDao.findAllDictType();
		Map all = new HashMap();
		all.put("TYPE", "全部类别");
		all.put("TYPE_CODE", "-1");
		data.add(0, all);
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, data);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, resultMap);
	}

	// 类型字典combo
	public ModelAndView dictTypeItemCombo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String code = request.getParameter("code");
		String tag = request.getParameter("tag");
		String fullText = request.getParameter("fullText");
		List data = dictDao.findDictTypeByCode(code);
		if (tag != null && "1".equals(tag)) {
			Map all = new HashMap();
			all.put("ITEM", fullText);
			all.put("ID", "-1");
			data.add(0, all);
		}
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, data);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, resultMap);
	}
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
