package com.hopi.demo.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.hopi.web.WebConstants;

/**
 * @author 董依良
 * @since 2013-8-14
 */

public class DemoAction extends MultiActionController {
	public ModelAndView menuItem(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		List menuList = new ArrayList();
		Map menuMap = null;

		menuMap = new HashMap();
		menuMap.put("type", WebConstants.TOOLBAR_CREATE);
		menuMap.put("text", "新增");
		menuMap.put("iconCls", "icon-create");
		menuList.add(menuMap);

		menuMap = new HashMap();
		menuMap.put("type", WebConstants.TOOLBAR_MODIFY);
		menuMap.put("text", "修改");
		menuMap.put("iconCls", "icon-edit");
		menuList.add(menuMap);

		menuMap = new HashMap();
		menuMap.put("type", WebConstants.TOOLBAR_DELETE);
		menuMap.put("text", "删除");
		menuMap.put("iconCls", "icon-delete");
		menuList.add(menuMap);
		
		menuMap = new HashMap();
		menuMap.put("type", WebConstants.TOOLBAR_IMPORT);
		menuMap.put("text", "导入");
		menuMap.put("iconCls", "icon-import");
		menuList.add(menuMap);
		
		menuMap = new HashMap();
		menuMap.put("type", WebConstants.TOOLBAR_EXPORT);
		menuMap.put("text", "导出");
		menuMap.put("iconCls", "icon-export");
		menuList.add(menuMap);

		menuMap = new HashMap();
		menuMap.put("type", WebConstants.TOOLBAR_REFRESH);
		menuMap.put("text", "刷新");
		menuMap.put("iconCls", "icon-refresh");
		menuList.add(menuMap);

		menuMap = new HashMap();
		menuMap.put("type", WebConstants.TOOLBAR_QUERY);
		menuMap.put("text", "查询");
		menuMap.put("iconCls", "icon-query");
		menuList.add(menuMap);

		menuMap = new HashMap();
		menuMap.put("type", WebConstants.TOOLBAR_HIGHQUERY);
		menuMap.put("text", "展开高级查询");
		menuMap.put("iconCls", "icon-openhighquery");
		menuList.add(menuMap);

		Map resultMap = new HashMap();
		resultMap.put(WebConstants.JSON_SUCCESS, Boolean.TRUE);
		resultMap.put(WebConstants.JSON_DATA, menuList);
		return new ModelAndView(WebConstants.JSON_VIEW,
				WebConstants.JSON_CLEAN, resultMap);
	}
}
