package com.hopi.dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.PreparedStatementCallback;
import org.springframework.jdbc.support.lob.LobCreator;
import org.springframework.jdbc.support.lob.LobHandler;

/**
 * 大对象设置代理类 usage: 参数为Map类型
 * 
 * this.getJdbcTemplate().getJdbcOperations().execute( sql.toString(), new
 * XLobMap(this.lobHandler,param,lobProps,lobTypes,false));
 * 
 * @author dongyl
 * @since 2010-4-28
 */
public class XLobMap implements PreparedStatementCallback {
	private final static Log log = LogFactory.getLog(XLobMap.class);
	private LobHandler lobHandler;
	private Map param;
	private String[] lobProps;
	private int[] lobTypes;
	private boolean lastId = false;

	/**
	 * 大对象设置代理类
	 * 
	 * @param lobHandler
	 * @param param
	 * @param lobProps
	 * @param lobTypes
	 */
	public XLobMap(LobHandler lobHandler, Map param, String[] lobProps,
			int[] lobTypes, boolean lastId) {
		this.lobHandler = lobHandler;
		this.param = param;
		this.lobProps = lobProps;
		this.lobTypes = lobTypes;
		this.lastId = lastId;
	}

	/**
	 * 大对象设置代理类
	 * 
	 * @param lobHandler
	 * @param param
	 * @param lobProps
	 * @param lobTypes
	 */
	public XLobMap(LobHandler lobHandler, Map param, String[] lobProps,
			int[] lobTypes) {
		this.lobHandler = lobHandler;
		this.param = param;
		this.lobProps = lobProps;
		this.lobTypes = lobTypes;
	}

	public final Object doInPreparedStatement(PreparedStatement ps)
			throws SQLException, DataAccessException {
		LobCreator lobCreator = this.lobHandler.getLobCreator();
		try {
			setValues(ps, lobCreator);
			return new Integer(ps.executeUpdate());
		} finally {
			lobCreator.close();
		}
	}

	protected void setValues(PreparedStatement ps, LobCreator lc)
			throws SQLException, DataAccessException {
		int i = 1;
		for (Iterator it = param.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			if (lastId && key.equalsIgnoreCase("ID")) {
				continue;
			}
			boolean isLob = false;
			Object v = param.get(key);
			if (this.lobProps != null) {
				for (int j = 0; j < lobProps.length; j++) {
					if (lobProps[j].equals(key)) {
						if (lobTypes[j] == Types.BLOB) {
							lc.setBlobAsBytes(ps, i, (byte[]) v);
						} else {
							lc.setClobAsString(ps, i, (String) v);
						}
						isLob = true;
						break;
					}
				}
			}
			if (!isLob) {
				if (v == null) {
					ps.setObject(i, null);
				} else if (v instanceof String) {
					ps.setString(i, (String) v);
				} else if (v instanceof Integer) {
					ps.setInt(i, ((Integer) v).intValue());
				} else if (v instanceof Float) {
					ps.setFloat(i, ((Float) v).floatValue());
				} else if (v instanceof Long) {
					ps.setLong(i, ((Long) v).longValue());
				} else if (v instanceof BigDecimal) {
					ps.setBigDecimal(i, (BigDecimal) v);
				} else if (v instanceof Date) {
					ps.setTimestamp(i, new java.sql.Timestamp(((Date) v)
							.getTime()));
				} else {
					log.info("string value=" + v);
					ps.setString(i, v.toString());
				}
			}
			i++;
		}
		if (lastId)
			ps.setString(i, param.get("ID").toString());
		// if (update) {
		// ps.setString(i, param.get("ID").toString());
		// }
	}
}