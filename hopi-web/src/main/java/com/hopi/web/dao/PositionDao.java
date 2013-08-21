package com.hopi.web.dao;

import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;

/**
 * @author 董依良
 * @since 2013-8-21
 */

public interface PositionDao extends Dao {
	Map getPositionById(String id) throws DataAccessException;

	Page queryPositionForPage(String sv, Map hsMap, long start, long limit,
			Sorter sorter) throws DataAccessException;
}
