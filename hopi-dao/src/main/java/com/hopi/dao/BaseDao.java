package com.hopi.dao;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.lob.LobCreator;
import org.springframework.jdbc.support.lob.LobHandler;
import org.springframework.util.Assert;

/**
 * @author 董依良
 * @since 2013-7-23
 */

public class BaseDao implements Dao {
	protected final Log log = LogFactory.getLog(this.getClass());
	private NamedParameterJdbcTemplate jdbcTemplate;
	private LobHandler lobHandler;

	public LobHandler getLobHandler() {
		return this.lobHandler;
	}

	public void setLobHandler(LobHandler lobHandler) {
		this.lobHandler = lobHandler;
	}

	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
	}

	public NamedParameterJdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	private String getCountStr(String queryStr) {
		Assert.hasText(queryStr);
		int beginPos = queryStr.toLowerCase().indexOf("from");
		Assert.isTrue(beginPos != -1, " hql : " + queryStr
				+ " must has a keyword 'from'");
		Pattern p = Pattern.compile("order\\s*by[\\w|\\W|\\s|\\S]*",
				Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(queryStr.substring(beginPos));
		StringBuffer sb = new StringBuffer();
		while (m.find()) {
			m.appendReplacement(sb, "");
		}
		m.appendTail(sb);
		return "select count(*) " + sb.toString();
	}

	public Page queryForPage(long start, long limit, String sql, Map param)
			throws DataAccessException {
		String countSql = getCountStr(sql);
		long totalCount = this.getJdbcTemplate().queryForLong(countSql, param);
		StringBuffer pageSql = new StringBuffer();
		pageSql.append("select * from ( select row_.*, rownum rownum_ from (");
		pageSql.append(sql);
		pageSql.append(" ) row_ where rownum <= ");
		pageSql.append(start + limit);
		pageSql.append(" ) where rownum_ > ");
		pageSql.append(start);
		List list = this.getJdbcTemplate().query(pageSql.toString(), param,
				new XColumnMapRowMapper(this.getLobHandler()));
		return new Page(start, totalCount, limit, list);
	}

	public List queryForList(long start, long limit, String sql, Map param)
			throws DataAccessException {
		StringBuffer pageSql = new StringBuffer();
		pageSql.append("select * from ( select row_.*, rownum rownum_ from (");
		pageSql.append(sql);
		pageSql.append(" ) row_ where rownum <= ");
		pageSql.append(start + limit);
		pageSql.append(" ) where rownum_ > ");
		pageSql.append(start);
		List list = this.getJdbcTemplate().query(pageSql.toString(), param,
				new XColumnMapRowMapper(this.getLobHandler()));
		return list;
	}

	public List queryForListAll(String sql, Map param) {
		return this.getJdbcTemplate().query(sql, param,
				new XColumnMapRowMapper(this.getLobHandler()));
	}

	public String insert(String tbName, final Map param,
			final String[] lobProps, final int[] lobTypes)
			throws DataAccessException {
		String id = UUID.randomUUID().toString();
		param.put("ID", id);

		StringBuffer sql = new StringBuffer("insert into ");
		sql.append(tbName).append("(");

		for (Iterator it = param.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			sql.append(key).append(",");
		}

		sql.deleteCharAt(sql.length() - 1);
		sql.append(") values(");

		for (int i = 0; i < param.keySet().size(); i++) {
			sql.append("?,");
		}

		sql.deleteCharAt(sql.length() - 1);
		sql.append(")");
		this.getJdbcTemplate().getJdbcOperations().execute(sql.toString(),
				new XLobMap(this.getLobHandler(), param, lobProps, lobTypes));
		return id;
	}

	/**
	 * 原始的添加，不使用UUID生成ID
	 * 
	 * @param tbName
	 * @param param
	 * @throws DataAccessException
	 */
	public void insertRaw(String tbName, final Map param,
			final String[] lobProps, final int[] lobTypes)
			throws DataAccessException {
		StringBuffer sql = new StringBuffer("insert into ");
		sql.append(tbName).append("(");

		for (Iterator it = param.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			sql.append(key).append(",");
		}

		sql.deleteCharAt(sql.length() - 1);
		sql.append(") values(");

		for (int i = 0; i < param.keySet().size(); i++) {
			sql.append("?,");
		}

		sql.deleteCharAt(sql.length() - 1);
		sql.append(")");
		this.getJdbcTemplate().getJdbcOperations().execute(sql.toString(),
				new XLobMap(this.getLobHandler(), param, lobProps, lobTypes));
	}

	public void update(String tbName, final Map param, final String[] lobProps,
			final int[] lobTypes) throws DataAccessException {
		StringBuffer sql = new StringBuffer("update ");
		sql.append(tbName).append(" set ");

		for (Iterator it = param.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();

			if (key.equalsIgnoreCase("ID")) {
				continue;
			}

			sql.append(key).append("=?,");
		}

		sql.deleteCharAt(sql.length() - 1);
		sql.append(" where ID=?");
		this.getJdbcTemplate().getJdbcOperations().execute(
				sql.toString(),
				new XLobMap(this.getLobHandler(), param, lobProps, lobTypes,
						true));
	}

	public void updateRaw(String sql, Map param, String[] lobProps,
			int[] lobTypes) throws DataAccessException {
		this.getJdbcTemplate().getJdbcOperations().execute(sql.toString(),
				new XLobMap(this.getLobHandler(), param, lobProps, lobTypes));
	}

	public void delete(String tbName, String id) throws DataAccessException {
		StringBuffer sql = new StringBuffer("delete ");
		sql.append(tbName).append(" where id=:ID");
		Map param = new HashMap();
		param.put("ID", id);
		this.getJdbcTemplate().update(sql.toString(), param);
	}

	public int[] batchDelete(String tbName, final String[] ids)
			throws DataAccessException {
		StringBuffer sql = new StringBuffer("delete ");
		sql.append(tbName).append(" where id=?");

		int[] deleteCounts = this.getJdbcTemplate().getJdbcOperations()
				.batchUpdate(sql.toString(),
						new BatchPreparedStatementSetter() {
							public int getBatchSize() {
								return ids.length;
							}

							public void setValues(PreparedStatement ps, int i)
									throws SQLException {
								ps.setString(1, ids[i]);
							}
						});
		return deleteCounts;
	}

	public int[] batchInsert(String tbName, final List data,
			final String[] lobProps, final int[] lobTypes)
			throws DataAccessException {
		if (data == null || data.size() < 1) {
			return null;
		}
		StringBuffer sql = new StringBuffer("insert into ");
		sql.append(tbName).append("(");

		Map param = (Map) data.get(0);

		final String[] params = new String[param.keySet().size() + 1];
		int i = 0;
		sql.append("ID,");
		params[i++] = "ID";
		for (Iterator it = param.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			sql.append(key).append(",");
			params[i] = key;
			i++;
		}

		sql.deleteCharAt(sql.length() - 1);

		sql.append(") values(");

		for (int j = 0; j < params.length; j++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(")");

		final LobCreator lobCreator = this.lobHandler.getLobCreator();
		int[] insertCounts = this.getJdbcTemplate().getJdbcOperations()
				.batchUpdate(sql.toString(),
						new BatchPreparedStatementSetter() {
							public int getBatchSize() {
								return data.size();
							}

							public void setValues(PreparedStatement ps, int i)
									throws SQLException {
								Map pm = (Map) data.get(i);

								String id = UUID.randomUUID().toString();
								pm.put("ID", id);

								for (int j = 1; j < params.length + 1; j++) {
									Object v = pm.get(params[j - 1]);
									boolean isLob = false;
									if (lobProps != null && lobProps.length > 0) {
										for (int li = 0; li < lobProps.length; li++) {
											if (params[j - 1]
													.equals(lobProps[li])) {
												if (lobTypes[li] == Types.BLOB) {
													lobCreator.setBlobAsBytes(
															ps, j, (byte[]) v);
												} else {
													lobCreator.setClobAsString(
															ps, j, (String) v);
												}
												isLob = true;
											}
										}
									}
									if (!isLob)
										ps.setObject(j, v);
								}
							}
						});
		return insertCounts;
	}

	public int[] batchInsertRaw(String tbName, final List data,
			final String[] lobProps, final int[] lobTypes)
			throws DataAccessException {
		if (data == null || data.size() < 1) {
			return null;
		}
		StringBuffer sql = new StringBuffer("insert into ");
		sql.append(tbName).append("(");
		Map param = (Map) data.get(0);
		final String[] params = new String[param.keySet().size()];
		int i = 0;
		for (Iterator it = param.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			sql.append(key).append(",");
			params[i] = key;
			i++;
		}

		sql.deleteCharAt(sql.length() - 1);
		sql.append(") values(");

		for (int j = 0; j < params.length; j++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(")");
		final LobCreator lobCreator = this.lobHandler.getLobCreator();
		int[] insertCounts = this.getJdbcTemplate().getJdbcOperations()
				.batchUpdate(sql.toString(),
						new BatchPreparedStatementSetter() {
							public int getBatchSize() {
								return data.size();
							}

							public void setValues(PreparedStatement ps, int i)
									throws SQLException {
								Map pm = (Map) data.get(i);
								for (int j = 1; j < params.length + 1; j++) {
									Object v = pm.get(params[j - 1]);
									boolean isLob = false;
									if (lobProps != null && lobProps.length > 0) {
										for (int li = 0; li < lobProps.length; li++) {
											if (params[j - 1]
													.equals(lobProps[li])) {
												if (lobTypes[li] == Types.BLOB) {
													lobCreator.setBlobAsBytes(
															ps, j, (byte[]) v);
												} else {
													lobCreator.setClobAsString(
															ps, j, (String) v);
												}
												isLob = true;
											}
										}
									}
									if (!isLob)
										ps.setObject(j, v);
								}
							}
						});
		return insertCounts;
	}

	public Map getById(String tbName, String id) throws DataAccessException {
		StringBuffer sql = new StringBuffer("select * from ");
		sql.append(tbName).append(" where id=:ID");
		Map param = new HashMap();
		param.put("ID", id);
		List data = this.getJdbcTemplate().query(sql.toString(), param,
				new XColumnMapRowMapper(this.getLobHandler()));
		if (data == null || data.size() < 1) {
			return null;
		} else {
			return (Map) data.get(0);
		}
		// return (Map) this.getJdbcTemplate().queryForObject(sql.toString(),
		// param, new XColumnMapRowMapper(this.getLobHandler()));
	}

	public void truncateTable(String tbName) throws DataAccessException {
		String sql = "truncate table " + tbName;
		this.getJdbcTemplate().getJdbcOperations().execute(sql);
	}
}
