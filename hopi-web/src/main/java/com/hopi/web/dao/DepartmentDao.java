package com.hopi.web.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;

public interface DepartmentDao extends Dao {
	Page queryDepartmentForPage(String parentId, long start, long limit, Sorter sorter)
			throws DataAccessException;

	List findDepartmentByParentId(String parentId) throws DataAccessException;
}
