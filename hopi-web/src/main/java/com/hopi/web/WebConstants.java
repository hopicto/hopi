package com.hopi.web;

/**
 * @author 董依良
 * @since 2013-7-23
 */

public class WebConstants {
	// 视图
	public static final String DEFAULT_CHARTSET = "UTF-8";
	public static final String JSON_VIEW = "json";
	public static final String XML_VIEW = "xml";
	public static final String EXCEL_VIEW = "xls";
	public static final String XML_TAG_NAME = "_tag";// xml标签名
	public static final String XML_LIST = "_list";// xml list数据

	public static final String HTML_VIEW_PREFIX = "html_";
	public static final String PROTECTED_VIEW = "protected";// 受保护资源，直接读取文件并输出
	public static final String JAVASCRIPT_VIEW = "javascript";
	public static final String JAVASCRIPT_VIEW_CONTENT = "content";
	public static final String JCAPTCHA_CODE = "jcaptchaCode";
	public static final String ROLE_PREFIX = "ROLE_";
	public static final String ROLE_SUPERVISOR = "SUPERVISOR";
	public static final String MENU_PREFIX = "menu_";
	public static final long MENU_ROOT = 0;

	// xls
	public static final String EXCEL_VIEW_FILE_NAME = "fileName";
	public static final String EXCEL_VIEW_HEAD_CONFIG = "headConfig";
	public static final String EXCEL_VIEW_DATA_CONFIG = "dataConfig";
	public static final String EXCEL_VIEW_DATA = "data";

	// 树型菜单根节点ID
	public static final String TREE_ROOT = "1";

	public static final String SUCCESS = "success";
	public static final String JSON_CLEAN = "_jsonclean"; // 用户树形菜单直接输出json，不封装success
	public static final String JSON_SUCCESS = "success";
	public static final String JSON_DATA = "data";
	public static final String JSON_EDIT_TAG = "_EDIT_TAG";
	public static final String JSON_ERRORS = "errors";
	public static final String JSON_ERROR_MSG = "msg";
	public static final String DATE_PATTERN = "yyyy-MM-dd HH:mm:ss";
	public static final String DATE_PATTERN_CUSTOM = "_DATE_PATTERN_CUSTOM";// 日期格式化
	// public static final String NUMBER_PATTERN_CUSTOM =
	// "_NUMBER_PATTERN_CUSTOM";//数字格式化

	// 分页数据
	public static final int PAGE_START_DEFAULT = 0;
	public static final long PAGE_SIZE_DEFAULT = 25;
	public static final String PARAM_QUERY_START = "start";
	public static final String PARAM_QUERY_LIMIT = "limit";
	public static final String PARAM_QUERY_ORDERBY = "orderBy";
	public static final String PARAM_QUERY_ORDERTYPE = "orderType";
	public static final String PARAM_QUERY_LIST = "list";
	public static final String PARAM_QUERY_TOTALCOUNT = "totalCount";
	public static final String PARAM_QUERY_FIELDS = "fields";
	public static final String PARAM_QUERY = "query";

	// 参数数据类型
	public static final String DB_TYPE_STRING = "string";
	public static final String DB_TYPE_LONG = "long";

	// 保护资源类型
	public static final String CONTENT_TYPE_KEY = "contentType";
	public static final String CONTENT_FILENAME_KEY = "contentFileName";
	public static final String PROTECTED_HTML = "text/html; charset=UTF-8";
	public static final String PROTECTED_JPG = "image/jpeg";
	public static final String PROTECTED_FILENAME = "fileName";

	// public static final String JCAPTCHA_CODE = "jcaptchaCode";//
	// 图形验证码session变量名
	public static final String RESOURCE_TYPE_URL = "1";// URL资源
	public static final String RESOURCE_TYPE_MENU = "2";// 菜单资源
	// public static final String ROLE_PREFIX = "ROLE_";

	public static final String ROLE_ADMIN_ID = "0";// 系统管理员角色ID
	public static final String ROLE_USER_ID = "2";// 普通用户角色ID
	public static final String ROLE_ANOYMOUS_ID = "1";// 匿名用户角色ID

	public static final String ROLE_ADMIN_CODE = "ADMIN";// 系统管理员角色编码
	public static final String USER_STATUS_VALID = "3";
	public static final String USER_STATUS_LOCK = "4";
	public static final String USER_STATUS_DELETE = "5";

	public static final String USER_ADMIN = "0";// 系统管理员ID

	public static final String DEPARTMENT_ROOT="root";//部门根节点ID
	
	// 高级查询前缀
	public static final String HIGH_SEARCH_PREFIX = "HS_";

	// 菜单按钮编号
	public static final int TOOLBAR_CREATE = 1;//新增
	public static final int TOOLBAR_MODIFY = 2;//修改
	public static final int TOOLBAR_DELETE = 3;//删除
	public static final int TOOLBAR_EXPORT = 4;//导出
	public static final int TOOLBAR_REFRESH = 5;//刷新
	public static final int TOOLBAR_QUERY = 6;//查询
	public static final int TOOLBAR_HIGHQUERY = 7;//高级查询
	public static final int TOOLBAR_IMPORT = 8;//导入
}
