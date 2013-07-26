package com.hopi.web.dao;

import java.util.List;


import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;

public interface ResourceDao extends Dao {
	List findResourceByType(String type) throws DataAccessException;

	List findAllUrlResources() throws DataAccessException;

	List findResourceRole(String resourceId) throws DataAccessException;

	/**
	 * 查找图标资源
	 * 
	 * @return
	 * @throws DataAccessException
	 */
	List findIconList() throws DataAccessException;

	/**
	 * 根据父菜单查找子菜单
	 * 
	 * @param parentId
	 * @return
	 * @throws DataAccessException
	 */
	List findMenuResourceByParentId(String parentId) throws DataAccessException;

	/**
	 * 根据菜单查找URL资源
	 * 
	 * @param parentId
	 * @return
	 * @throws DataAccessException
	 */
	List findUrlResourceByParentId(String parentId) throws DataAccessException;

	/**
	 * 分页查找URL资源
	 * 
	 * @param parentId
	 * @param start
	 * @param limit
	 * @param orderBy
	 * @param orderType
	 * @return
	 * @throws DataAccessException
	 */
	Page queryUrlResourceForPage(String parentId, long start, long limit,
			String orderBy, String orderType) throws DataAccessException;

	/**
	 * 保存资源赋予的角色
	 * 
	 * @param resourceId
	 * @param roleIds
	 * @throws DataAccessException
	 */
	void saveResourceRole(String resourceId, final String[] roleIds)
			throws DataAccessException;
}
