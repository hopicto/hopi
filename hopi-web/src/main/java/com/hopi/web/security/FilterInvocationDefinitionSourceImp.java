package com.hopi.web.security;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.ConfigAttributeDefinition;
import org.springframework.security.ConfigAttributeEditor;
import org.springframework.security.intercept.web.FilterInvocation;
import org.springframework.security.intercept.web.FilterInvocationDefinitionSource;
import org.springframework.security.util.UrlMatcher;

import com.hopi.web.WebConstants;
import com.hopi.web.cache.SecurityCache;

/**
 * 
 * @author:dongyl
 * @since:2010-3-23
 */
public class FilterInvocationDefinitionSourceImp implements
		FilterInvocationDefinitionSource {
	private static Log log = LogFactory
			.getLog(FilterInvocationDefinitionSourceImp.class);

	private SecurityCache securityCache;
	private UrlMatcher urlMatcher;

	public void setUrlMatcher(UrlMatcher urlMatcher) {
		this.urlMatcher = urlMatcher;
	}

	public void setSecurityCache(SecurityCache securityCache) {
		this.securityCache = securityCache;
	}

	public ConfigAttributeDefinition getAttributes(Object object)
			throws IllegalArgumentException {
		if (object == null || !(this.supports(object.getClass()))) {
			throw new IllegalArgumentException(
					"Object must be a FilterInvocation");
		}
		FilterInvocation filterInvocation = (FilterInvocation) object;
		String url = filterInvocation.getRequestUrl();
		List rights = securityCache.findAllUrlResources();
		ConfigAttributeEditor configAttrEditor = new ConfigAttributeEditor();
		Set roleSet = new HashSet();
		for (Iterator it = rights.iterator(); it.hasNext();) {
			Map r = (Map) it.next();
			String c = (String) r.get("CONTENT");
			if (this.urlMatcher.pathMatchesUrl(c, url)) {
				String id = (String) r.get("ID");
				List roles = securityCache.findResourceRole(id);
				for (Iterator rit = roles.iterator(); rit.hasNext();) {
					Map ri = (Map) rit.next();
					roleSet.add(ri.get("CODE"));
				}
				break;
			}
		}
		StringBuffer rolesList = new StringBuffer();
		for (Iterator it = roleSet.iterator(); it.hasNext();) {
			String r = (String) it.next();
			rolesList.append(WebConstants.ROLE_PREFIX).append(r.toUpperCase())
					.append(",");
		}
		if (rolesList.length() > 0)
			rolesList.deleteCharAt(rolesList.length() - 1);
		configAttrEditor.setAsText(rolesList.toString());
		return (ConfigAttributeDefinition) configAttrEditor.getValue();
	}

	public Collection getConfigAttributeDefinitions() {
		return null;
	}

	public boolean supports(Class clazz) {
		return FilterInvocation.class.isAssignableFrom(clazz);
	}
}
