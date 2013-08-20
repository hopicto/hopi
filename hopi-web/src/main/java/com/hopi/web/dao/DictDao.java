package com.hopi.web.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.hopi.dao.Dao;
import com.hopi.dao.Page;
import com.hopi.web.Sorter;

public interface DictDao extends Dao {
	Page queryDictTypeForPage(String sv, Map hsMap, long start, long limit,
			Sorter sorter) throws DataAccessException;

	List queryDictTypeForList(String sv, Map hsMap,Sorter sorter) throws DataAccessException;

	List findAllDictType() throws DataAccessException;

	List findDictTypeByCode(String code) throws DataAccessException;

	// /**
	// * 根据客户识别分数获取客户风险特征
	// * @param score
	// * @return {ITEM:风险特征,DESCRIPTION:风险特征描述}
	// * @throws DataAccessException
	// */
	// Map getCustomerRiskType(BigDecimal score)throws DataAccessException;

	// String getFileDownloadType(String suffix)throws DataAccessException;
}
