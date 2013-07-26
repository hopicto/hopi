package com.hopi.web.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;

public interface RoleDao extends Dao {
	List getAllRole() throws DataAccessException;

	Page queryRoleForPage(String roleCode, long start, long limit,
			String orderBy, String orderType) throws DataAccessException;
}
