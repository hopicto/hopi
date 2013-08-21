package com.hopi.web.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;

public interface RoleDao extends Dao {
	List getAllRole() throws DataAccessException;

	Page queryRoleForPage(String sv, Map hsMap, long start,
			long limit, Sorter sorter) throws DataAccessException;
}
