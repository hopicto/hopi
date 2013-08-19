package com.hopi.web.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;

/**
 * 图标样式
 * 
 * @author 董依良
 * @since 2013-8-19
 */

public interface IconClassDao extends Dao {
	public Page queryIconClassForPage(String sv, Map hsMap, long start,
			long limit, String orderBy, String orderType)
			throws DataAccessException;

	List queryIconClassForList(String sv, Map hsMap, String orderBy,
			String orderType) throws DataAccessException;
}
