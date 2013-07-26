package com.hopi.web.cache;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import net.sf.ehcache.CacheException;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.Element;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataRetrievalFailureException;

import com.hopi.web.WebConstants;
import com.hopi.web.dao.ResourceDao;

/**
 * 安全认证缓存
 * 
 * @author:dongyl
 * @since:2010-3-23
 */
public class SecurityCacheImp implements SecurityCache {
	private static final Log log = LogFactory.getLog(SecurityCacheImp.class);
//	private UserDao userDao;
	private ResourceDao resourceDao;
	private Ehcache cache;

	public void setCache(Ehcache cache) {
		this.cache = cache;
	}

//	public void setUserDao(UserDao userDao) {
//		this.userDao = userDao;
//	}

	public void setResourceDao(ResourceDao resourceDao) {
		this.resourceDao = resourceDao;
	}

	public List findAllUrlResources() {
		String eln = ELN_URL_RESOURCE;
		Element element = null;
		try {
			element = this.cache.get(eln);
		} catch (CacheException cacheException) {
			throw new DataRetrievalFailureException("缓存失败: "
					+ cacheException.getMessage());
		}
		if (log.isDebugEnabled() && element != null) {
			log.debug("命中缓存： " + eln);
		}
		if (element == null) {
			List data = resourceDao
					.findResourceByType(WebConstants.RESOURCE_TYPE_URL);
			if (data != null) {
				element = new Element(eln, data);
				if (log.isDebugEnabled()) {
					log.debug("添加缓存: " + element.getKey());
				}
				cache.put(element);
			}
			return data;
		} else {
			return (List) element.getValue();
		}
	}

	public List findResourceRole(String resourceId) {
		String eln = ELN_RESOURCE_ROLE + resourceId;
		Element element = null;

		try {
			element = this.cache.get(eln);
		} catch (CacheException cacheException) {
			throw new DataRetrievalFailureException("缓存失败: "
					+ cacheException.getMessage());
		}

		if (log.isDebugEnabled() && element != null) {
			log.debug("命中缓存： " + eln);
		}

		if (element == null) {
			List data = resourceDao.findResourceRole(resourceId);
			if (data != null) {
				element = new Element(eln, data);
				if (log.isDebugEnabled()) {
					log.debug("添加缓存: " + element.getKey());
				}
				cache.put(element);
			}
			return data;
		} else {
			return (List) element.getValue();
		}
	}

	public void addOnlineUser(String userId) {
		String eln = ELN_ONLINE_USER;
		Element element = null;
		try {
			element = this.cache.get(eln);
		} catch (CacheException cacheException) {
			throw new DataRetrievalFailureException("缓存失败: "
					+ cacheException.getMessage());
		}
		Set data = null;
		if (element == null) {
			data = new HashSet();
			data.add(new Long(userId));
			element = new Element(eln, data);
			cache.put(element);
		} else {
			data = (Set) element.getValue();
			data.add(new Long(userId));
		}
	}

	public void deleteOnlineUser(String userId) {
		String eln = ELN_ONLINE_USER;
		Element element = null;
		try {
			element = this.cache.get(eln);
		} catch (CacheException cacheException) {
			throw new DataRetrievalFailureException("缓存失败: "
					+ cacheException.getMessage());
		}
		if (element != null) {
			Set data = (Set) element.getValue();
			data.remove(new Long(userId));
		}
	}

	public int countOnlineUser() {
		String eln = ELN_ONLINE_USER;
		Element element = null;
		try {
			element = this.cache.get(eln);
		} catch (CacheException cacheException) {
			throw new DataRetrievalFailureException("缓存失败: "
					+ cacheException.getMessage());
		}
		if (element != null) {
			Set data = (Set) element.getValue();
			return data.size();
		}
		return 0;
	}
}
