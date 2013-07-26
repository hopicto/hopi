package com.hopi.web.security;

import javax.servlet.http.HttpSessionEvent;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.ui.session.HttpSessionEventPublisher;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.hopi.web.cache.SecurityCache;

public class EnhancedHttpSessionEventPublisher extends
		HttpSessionEventPublisher {
	private final static Log log = LogFactory.getLog(EnhancedHttpSessionEventPublisher.class);
//	public static Log log = LogFactory
//			.getLog(EnhancedHttpSessionEventPublisher.class);

	public void sessionCreated(HttpSessionEvent event) {
		// 将用户加入到在线用户列表中
		Authentication auth = SecurityContextHolder.getContext()
				.getAuthentication();
		if (auth != null) {
			Object principal = auth.getPrincipal();
			if (principal instanceof EnhancedUser) {
				EnhancedUser user = (EnhancedUser) principal;
				WebApplicationContext wac = WebApplicationContextUtils
						.getRequiredWebApplicationContext(event.getSession()
								.getServletContext());
				SecurityCache securityCache = (SecurityCache) wac
						.getBean("securityCache");
				securityCache.addOnlineUser(user.getId());
				log.info("用户：" + user.getUsername() + "登录");
			}
		}
		super.sessionCreated(event);
	}

	public void sessionDestroyed(HttpSessionEvent event) {
		// 将用户从在线用户列表中移除
		Authentication auth = SecurityContextHolder.getContext()
				.getAuthentication();
		if (auth != null) {
			Object principal = auth.getPrincipal();
			if (principal instanceof EnhancedUser) {
				EnhancedUser user = (EnhancedUser) principal;
				WebApplicationContext wac = WebApplicationContextUtils
						.getRequiredWebApplicationContext(event.getSession()
								.getServletContext());
				SecurityCache securityCache = (SecurityCache) wac
						.getBean("securityCache");
				securityCache.deleteOnlineUser(user.getId());
				log.info("用户：" + user.getUsername() + "退出");
			}
		}
		super.sessionDestroyed(event);
	}
}
