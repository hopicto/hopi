package com.hopi.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

/**
 * 
 * @author 董依良
 * @since 2013-7-23
 */

public interface Dao {
	/**
	 * 分页查询
	 * 
	 * @param start
	 * @param limit
	 * @param sql
	 * @param param
	 * @return
	 * @throws DataAccessException
	 */
	Page queryForPage(long start, long limit, String sql, Map param)
			throws DataAccessException;

	/**
	 * 根据区间查询列表
	 * 
	 * @param start
	 * @param limit
	 * @param sql
	 * @param param
	 * @return
	 * @throws DataAccessException
	 */
	List queryForList(long start, long limit, String sql, Map param)
			throws DataAccessException;

	/**
	 * 查询全部列表
	 * 
	 * @param sql
	 * @param param
	 * @return
	 * @throws DataAccessException
	 */
	List queryForListAll(String sql, Map param) throws DataAccessException;

	/**
	 * 插入数据，返回ID
	 * 
	 * @param tbName
	 * @param param
	 * @param lobProps
	 * @param lobTypes
	 * @return
	 * @throws DataAccessException
	 */
	String insert(String tbName, final Map param, final String[] lobProps,
			final int[] lobTypes) throws DataAccessException;

	/**
	 * 批量添加
	 * 
	 * @param tbName
	 * @param data
	 * @param lobProps
	 * @param lobTypes
	 * @return
	 * @throws DataAccessException
	 */
	int[] batchInsert(String tbName, final List data, final String[] lobProps,
			final int[] lobTypes) throws DataAccessException;

	/**
	 * 插入原始数，不生成ID
	 * 
	 * @param tbName
	 * @param param
	 * @param lobProps
	 * @param lobTypes
	 * @throws DataAccessException
	 */
	void insertRaw(String tbName, final Map param, final String[] lobProps,
			final int[] lobTypes) throws DataAccessException;

	/**
	 * 批量添加原始数，不生成ID
	 * 
	 * @param tbName
	 * @param data
	 * @param lobProps
	 * @param lobTypes
	 * @return
	 * @throws DataAccessException
	 */
	int[] batchInsertRaw(String tbName, final List data,
			final String[] lobProps, final int[] lobTypes)
			throws DataAccessException;

	/**
	 * 更新
	 * 
	 * @param tbName
	 * @param param
	 * @param lobProps
	 * @param lobTypes
	 * @throws DataAccessException
	 */
	void update(String tbName, final Map param, final String[] lobProps,
			final int[] lobTypes) throws DataAccessException;

	/**
	 * 根据原始sql更新数据
	 * 
	 * @param sql
	 * @param param
	 * @param lobProps
	 * @param lobTypes
	 * @throws DataAccessException
	 */
	void updateRaw(String sql, Map param, String[] lobProps, int[] lobTypes)
			throws DataAccessException;

	/**
	 * 删除
	 * 
	 * @param tbName
	 * @param id
	 * @throws DataAccessException
	 */
	void delete(String tbName, String id) throws DataAccessException;

	/**
	 * 批量删除
	 * 
	 * @param tbName
	 * @param ids
	 * @return
	 * @throws DataAccessException
	 */
	int[] batchDelete(String tbName, final String[] ids)
			throws DataAccessException;

	/**
	 * 根据ID获取对象
	 * 
	 * @param tbName
	 * @param id
	 * @return
	 * @throws DataAccessException
	 */
	Map getById(String tbName, String id) throws DataAccessException;

	/**
	 * 清空数据表
	 * 
	 * @param tbName
	 * @throws DataAccessException
	 */
	void truncateTable(String tbName) throws DataAccessException;
}
