package com.hopi.web.action;

import java.io.File;
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

import com.hopi.dao.Page;
import com.hopi.util.QueryParamMapUtil;
import com.hopi.util.TextFileUtil;
import com.hopi.web.HopiWebException;
import com.hopi.web.Sorter;
import com.hopi.web.WebConstants;
import com.hopi.web.dao.IconClassDao;

public class IconClassAction extends MultiActionController {
	private final static Log log = LogFactory.getLog(IconClassAction.class);
	public static final String TB_NAME = "HW_ICON_CLASS";
	private IconClassDao iconClassDao;
	private String iconSrcPrefix = "/images/icon/";
	private String iconClassPath = "/css/iconClass.css";

	public void setIconClassPath(String iconClassPath) {
		this.iconClassPath = iconClassPath;
	}

	public void setIconSrcPrefix(String iconSrcPrefix) {
		this.iconSrcPrefix = iconSrcPrefix;
	}

	public void setIconClassDao(IconClassDao iconClassDao) {
		this.iconClassDao = iconClassDao;
	}

	public ModelAndView importData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		return null;
	}

	public ModelAndView exportData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map result = new HashMap();
		// String orderBy = request.getParameter("orderBy");
		// String orderType = request.getParameter("orderType");
		Sorter sort = new Sorter(request.getParameter("sort"));
		Map hsMap = QueryParamMapUtil.getQueryParamMap(
				WebConstants.HIGH_SEARCH_PREFIX, request.getParameterMap());
		String sv = request.getParameter("sv");
		List data = iconClassDao.queryIconClassForList(sv, hsMap, sort);

		String[] headConfig = new String[] { "名称", "编码" };
		String[] dataConfig = new String[] { "NAME", "CODE" };
		result.put(WebConstants.EXCEL_VIEW_FILE_NAME, "图标类别.xls");
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
		Map hsMap = QueryParamMapUtil.getQueryParamMap(
				WebConstants.HIGH_SEARCH_PREFIX, request.getParameterMap());
		String sv = request.getParameter("sv");
		long pageSize = limit == null ? WebConstants.PAGE_SIZE_DEFAULT : Long
				.parseLong(limit);
		long pageStart = start == null || "".equals(start) ? 0 : Long
				.parseLong(start);
		Page page = iconClassDao.queryIconClassForPage(sv, hsMap, pageStart,
				pageSize, sort);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, page);
	}

	public ModelAndView save(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map param = new HashMap();
		String id = request.getParameter("ID");
		param.put("NAME", request.getParameter("NAME"));
		String code = request.getParameter("CODE");
		param.put("CODE", code);
		param.put("ICON_NAME", request.getParameter("ICON_NAME"));
		String editTag = request.getParameter(WebConstants.JSON_EDIT_TAG);
		if (editTag != null && editTag.equalsIgnoreCase("true")) {
			// update
			param.put("ID", id);
			if (iconClassDao.checkUniqueData(code, id)) {
				iconClassDao.update(TB_NAME, param, null, null);
			} else {
				throw new HopiWebException("代码重复，请修改代码");
			}

		} else {
			// insert
			if (iconClassDao.checkUniqueData(code, null)) {
				iconClassDao.insert(TB_NAME, param, null, null);
			} else {
				throw new HopiWebException("代码重复，请修改代码");
			}			
		}
		this.refreshIconClass();
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView delete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		if (id != null) {
			if (id.indexOf(",") > 0) {
				String[] ids = id.split(",");
				iconClassDao.batchDelete(TB_NAME, ids);
			} else {
				iconClassDao.delete(TB_NAME, id);
			}
		}
		this.refreshIconClass();
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView edit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String id = request.getParameter("id");
		Map role = iconClassDao.getById(TB_NAME, id);
		Map resultMap = new HashMap();
		role.put(WebConstants.JSON_EDIT_TAG, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, role);
		return new ModelAndView(WebConstants.JSON_VIEW, resultMap);
	}

	public void refreshIconClass() {
		String icp = this.getServletContext().getRealPath("/")
				+ this.iconClassPath;
		List data = iconClassDao.queryIconClassAll();
		StringBuffer sb = new StringBuffer();
		for (Iterator it = data.iterator(); it.hasNext();) {
			Map map = (Map) it.next();
			String code = (String) map.get("CODE");
			String iconName = (String) map.get("ICON_NAME");
			sb.append(".").append(code).append("{background-image: url(");
			sb.append(this.iconSrcPrefix).append(iconName).append(
					") !important;}\n");
		}
		TextFileUtil.saveData(icp, sb.toString());
	}

	/**
	 * 图标样式下拉列表
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView iconCombo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		List data=iconClassDao.queryIconClassAll();		
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, data);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, resultMap);
	}
	/**
	 * 图标下拉列表（icon目录下所有图标）
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView iconComboAll(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String iconRootPath = this.getServletContext().getRealPath("/")
				+ this.iconSrcPrefix;
		// log.info(iconRootPath);
		File file = new File(iconRootPath);
		List data = new ArrayList();
		if (file != null && file.isDirectory()) {
			String[] fns = file.list();
			for (int i = 0; i < fns.length; i++) {
				Map m = new HashMap();
				m.put("ICON_NAME", fns[i]);
				data.add(m);
			}
		}
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, data);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, resultMap);
	}
}
