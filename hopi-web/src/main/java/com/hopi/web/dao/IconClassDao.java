package com.hopi.web.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;

/**
 * 图标样式
 * 
 * @author 董依良
 * @since 2013-8-19
 */

public interface IconClassDao extends Dao {
	List queryIconClassAll() throws DataAccessException;

	public Page queryIconClassForPage(String sv, Map hsMap, long start,
			long limit, Sorter sorter) throws DataAccessException;

	List queryIconClassForList(String sv, Map hsMap, Sorter sorter)
			throws DataAccessException;

	/**
	 * 确认code是否唯一
	 * 
	 * @param code
	 * @param oldId
	 * @return
	 * @throws DataAccessException
	 */
	boolean checkUniqueData(String code, String oldId)
			throws DataAccessException;
}
