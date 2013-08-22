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

import com.hopi.dao.Page;
import com.hopi.web.WebConstants;
import com.hopi.web.dao.ResourceDao;

public class ResourceAction extends MultiActionController {
	private final static Log log = LogFactory.getLog(ResourceAction.class);
	public static final String TB_NAME = "HW_RESOURCE";
	private ResourceDao resourceDao;

	public void setResourceDao(ResourceDao resourceDao) {
		this.resourceDao = resourceDao;
	}
	
	public ModelAndView oldTree(HttpServletRequest request,
			HttpServletResponse response) {
		String parentId=request.getParameter("node");
		List ur = resourceDao.findMenuResourceByParentId(parentId);		
		List result = new ArrayList();
		for (Iterator it = ur.iterator(); it.hasNext();) {
			Map re = (Map) it.next();
			Map map = new HashMap();
			map.put("id", (BigDecimal) re.get("ID"));
			map.put("text", re.get("NAME"));
			BigDecimal leaf = (BigDecimal) re.get("COUNT");
			boolean isLeaf = leaf.intValue() ==0;
			map.put("leaf", new Boolean(isLeaf));
			result.add(map);
		}
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_DATA, result);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				result);
	}
	public ModelAndView tree(HttpServletRequest request,
			HttpServletResponse response) {
		String parentId=request.getParameter("node");
		List result=resourceDao.findMenuResourceByTree(parentId);
//		List ur = resourceDao.findMenuResourceByParentId(parentId);		
//		List result = new ArrayList();
//		for (Iterator it = ur.iterator(); it.hasNext();) {
//			Map re = (Map) it.next();
//			Map map = new HashMap();
//			map.put("id", (BigDecimal) re.get("ID"));
//			map.put("text", re.get("NAME"));
//			BigDecimal leaf = (BigDecimal) re.get("COUNT");
//			boolean isLeaf = leaf.intValue() ==0;
//			map.put("leaf", new Boolean(isLeaf));
//			result.add(map);
//		}
//		Map resultMap = new HashMap();
//		resultMap.put(WebConstants.JSON_DATA, result);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				result);
	}
	public ModelAndView query(HttpServletRequest request,
			HttpServletResponse response) {
		String limit = request.getParameter("limit");
		String start = request.getParameter("start");
		String orderBy = request.getParameter("orderBy");
		String orderType = request.getParameter("orderType");		
		String parentId=request.getParameter("parentId");
		long pageSize = limit == null ? WebConstants.PAGE_SIZE_DEFAULT : Long
				.parseLong(limit);
		long pageStart = start == null || "".equals(start) ? 0 : Long
				.parseLong(start);
		Page page = resourceDao.queryUrlResourceForPage(parentId,pageStart, pageSize, orderBy,
				orderType);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN, page);
	}
	public ModelAndView save(HttpServletRequest request,
			HttpServletResponse response) {
		Map param = new HashMap();		
		param.put("NAME", request.getParameter("NAME"));
		param.put("CODE", request.getParameter("CODE"));
		param.put("TYPE", request.getParameter("TYPE"));		
		param.put("SEQ", request.getParameter("SEQ"));	
		param.put("LEAF", request.getParameter("LEAF"));	
		param.put("CONTENT", request.getParameter("CONTENT"));
		param.put("DESCRIPTION", request.getParameter("DESCRIPTION"));
		param.put("EXT_PROP", request.getParameter("EXT_PROP"));
		String editTag = request.getParameter(WebConstants.JSON_EDIT_TAG);
		if (editTag != null && editTag.equalsIgnoreCase("true")) {
			// update
			param.put("ID", request.getParameter("ID"));			
			resourceDao.update(TB_NAME, param,null,null);
		} else {
			// insert
			param.put("PARENT_ID", request.getParameter("PARENT_ID"));
			resourceDao.insert(TB_NAME, param,null,null);
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView delete(HttpServletRequest request,
			HttpServletResponse response) {
		String id = request.getParameter("id");
		if (id != null) {
			if (id.indexOf(",") > 0) {
				String[] ids = id.split(",");
				resourceDao.batchDelete(TB_NAME, ids);
			} else {
				resourceDao.delete(TB_NAME, id);
			}
		}
		return new ModelAndView(WebConstants.JSON_VIEW);
	}

	public ModelAndView edit(HttpServletRequest request,
			HttpServletResponse response) {
		String id = request.getParameter("id");
		Map role = resourceDao.getById(TB_NAME, id);
		Map resultMap = new HashMap();
		role.put(WebConstants.JSON_EDIT_TAG, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, role);
		return new ModelAndView(WebConstants.JSON_VIEW, resultMap);
	}
	public ModelAndView resourceRoleCombo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String resourceId = request.getParameter("resourceId");
		List data = resourceDao.findResourceRole(resourceId);
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, data);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}
	public ModelAndView iconCombo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {		
		List data = resourceDao.findIconList();
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, data);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}
	
	// 资源所赋予的角色列表显示
	public ModelAndView resourceRoles(HttpServletRequest request,
			HttpServletResponse response) {
		String resourceId = request.getParameter("resourceId");
		List data;
		if(resourceId==null||"".equals(resourceId)){
			data=null;
		}else{
			data = resourceDao.findResourceRole(resourceId);
		}				
		Map result = new HashMap();
		result.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		result.put("totalCount", new Integer(data.size()));
		result.put("list", data);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				result);
	}

	public ModelAndView saveResourceRole(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String resourceRoles = request.getParameter("RESOURCE_ROLES");
		String resourceId = request.getParameter("RESOURCE_ID");
		String[] ids = null;
		if (resourceRoles != null && !"".equals(resourceRoles)) {
			ids = resourceRoles.split(",");
		}
		resourceDao.saveResourceRole(resourceId, ids);		
		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		return new ModelAndView(WebConstants.JSON_VIEW, WebConstants.JSON_CLEAN,
				resultMap);
	}
}
