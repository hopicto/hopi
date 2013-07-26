package com.hopi.dao;

import java.sql.Blob;
import java.sql.Clob;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.core.CollectionFactory;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.jdbc.support.lob.LobHandler;

/**
 * this.getJdbcTemplate().query(pageSql.toString(), param, new
 * XColumnMapRowMapper(this.lobHandler));
 * 
 * @author 董依良
 * @since 2013-7-23
 */
public class XColumnMapRowMapper implements RowMapper {
	private LobHandler lobHandler;

	/**
	 * 大对象查询映射类
	 * 
	 * @param lobHandler
	 */
	public XColumnMapRowMapper(LobHandler lobHandler) {
		this.lobHandler = lobHandler;
	}

	public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
		ResultSetMetaData rsmd = rs.getMetaData();
		int columnCount = rsmd.getColumnCount();
		Map mapOfColValues = new LinkedHashMap();
		for (int i = 1; i <= columnCount; i++) {
			String key = getColumnKey(JdbcUtils.lookupColumnName(rsmd, i));
			Object obj = getColumnValue(rs, i);
			mapOfColValues.put(key, obj);
		}
		return mapOfColValues;
	}

	protected String getColumnKey(String columnName) {
		return columnName;
	}

	protected Object getColumnValue(ResultSet rs, int index)
			throws SQLException {
		Object obj = rs.getObject(index);
		if (obj == null) {
			return null;
		}
		String className = null;
		if (obj != null) {
			className = obj.getClass().getName();
		}
		if (obj instanceof Blob) {
			obj = lobHandler.getBlobAsBytes(rs, index);
		} else if (obj instanceof Clob) {
			obj = lobHandler.getClobAsString(rs, index);
		} else if (className != null
				&& ("oracle.sql.TIMESTAMP".equals(className) || "oracle.sql.TIMESTAMPTZ"
						.equals(className))) {
			obj = rs.getTimestamp(index);
		} else if (className != null && className.startsWith("oracle.sql.DATE")) {
			String metaDataClassName = rs.getMetaData().getColumnClassName(
					index);
			if ("java.sql.Timestamp".equals(metaDataClassName)
					|| "oracle.sql.TIMESTAMP".equals(metaDataClassName)) {
				obj = rs.getTimestamp(index);
			} else {
				obj = rs.getDate(index);
			}
		} else if (obj != null && obj instanceof java.sql.Date) {
			if ("java.sql.Timestamp".equals(rs.getMetaData()
					.getColumnClassName(index))) {
				obj = rs.getTimestamp(index);
			}
		}
		return obj;
		// return JdbcUtils.getResultSetValue(rs, index);
	}

}
