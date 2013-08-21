package com.hopi.web.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;

public interface StaffDao extends Dao {
	/**
	 * 判断用户是否存在
	 * 
	 * @param loginName
	 * @return
	 * @throws DataAccessException
	 */
	boolean isStaffExist(String loginName) throws DataAccessException;

	/**
	 * 根据登录名查找用户ID
	 * 
	 * @param loginName
	 * @return
	 * @throws DataAccessException
	 */
	String findStaffIdByLoginName(String loginName) throws DataAccessException;

	/**
	 * 查找用户
	 * 
	 * @param loginName
	 * @return
	 * @throws DataAccessException
	 */
	Map findStaffByLoginName(String loginName) throws DataAccessException;

	/**
	 * 查找用户拥有的角色
	 * 
	 * @param id
	 * @return
	 * @throws DataAccessException
	 */
	List findStaffRole(String id) throws DataAccessException;

	/**
	 * 查找用户可访问的资源
	 * 
	 * @param userId
	 * @param type
	 * @param parentId
	 * @return
	 * @throws DataAccessException
	 */
	List findStaffResource(String userId, String type, String parentId)
			throws DataAccessException;

	/**
	 * 是否系统管理员
	 * 
	 * @param userId
	 * @return
	 * @throws DataAccessException
	 */
	boolean isAdmin(String userId) throws DataAccessException;

	/**
	 * 分页查找用户
	 * 
	 * @param loginName
	 * @param orgId
	 * @param start
	 * @param limit
	 * @param orderBy
	 * @param orderType
	 * @return
	 * @throws DataAccessException
	 */
	Page queryStaffForPage(String sv, Map hsMap, long start, long limit,
			Sorter sorter) throws DataAccessException;

	/**
	 * 加载用户，关联查询用户所在部门
	 * 
	 * @param id
	 * @return
	 * @throws DataAccessException
	 */
	Map loadStaffById(String id) throws DataAccessException;

	/**
	 * 加载个人信息
	 * 
	 * @param id
	 * @return
	 * @throws DataAccessException
	 */
	Map ownerSettingLoad(String id) throws DataAccessException;

	/**
	 * 更新用户角色
	 * 
	 * @param userId
	 * @param roleIds
	 * @throws DataAccessException
	 */
	void saveStaffRole(String userId, final String[] roleIds)
			throws DataAccessException;

	/**
	 * 处理用户登录，记录登录时间、IP、更新登录次数
	 * 
	 * @param loginName
	 * @param loginIp
	 * @throws DataAccessException
	 */
	void processStaffLogin(String loginName, String loginIp)
			throws DataAccessException;

	/**
	 * 用户访问较多次数的列表
	 * 
	 * @param size
	 * @return
	 * @throws DataAccessException
	 */
	List loginCountList(int size) throws DataAccessException;

	/**
	 * 查询访问次数
	 * 
	 * @param start
	 * @param limit
	 * @param orderBy
	 * @param orderType
	 * @return
	 * @throws DataAccessException
	 */
	Page queryAccessLogForPage(long start, long limit, String orderBy,
			String orderType) throws DataAccessException;

	// /**
	// * 初始化营业部用户数据，如果营业部名称不存在，则自动添加
	// * @param orgName
	// * @param name
	// * @param loginName
	// * @throws DataAccessException
	// */
	// void insertStaff(String orgName,String name,String loginName)throws
	// DataAccessException;
}
