package com.hopi.web.security;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.MessageSource;
import org.springframework.context.MessageSourceAware;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.BadCredentialsException;
import org.springframework.security.SpringSecurityMessageSource;
import org.springframework.security.providers.AuthenticationProvider;
import org.springframework.security.providers.rememberme.RememberMeAuthenticationToken;
import org.springframework.util.Assert;

import com.hopi.web.dao.StaffDao;

public class RememberMeAuthenticationProvider implements
		AuthenticationProvider, InitializingBean, MessageSourceAware {
	// ~ Static fields/initializers
	// =====================================================================================

	private static final Log logger = LogFactory
			.getLog(RememberMeAuthenticationProvider.class);

	// ~ Instance fields
	// ================================================================================================

	protected MessageSourceAccessor messages = SpringSecurityMessageSource
			.getAccessor();
	private String key;
	private StaffDao staffDao;

	// ~ Methods
	// ========================================================================================================

	public void setStaffDao(StaffDao staffDao) {
		this.staffDao = staffDao;
	}

	public void afterPropertiesSet() throws Exception {
		Assert.hasLength(key);
		Assert.notNull(this.messages, "A message source must be set");
	}

	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {
		if (!supports(authentication.getClass())) {
			return null;
		}

		if (this.key.hashCode() != ((RememberMeAuthenticationToken) authentication)
				.getKeyHash()) {
			logger.info("从cookie登录失败：loginName=" + authentication.getName());
			throw new BadCredentialsException(
					messages
							.getMessage(
									"RememberMeAuthenticationProvider.incorrectKey",
									"The presented RememberMeAuthenticationToken does not contain the expected key"));
		}
		
		logger.info("从cookie登录成功：loginName=" + authentication.getName());
		staffDao.processStaffLogin(authentication.getName(), null);
		return authentication;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public void setMessageSource(MessageSource messageSource) {
		this.messages = new MessageSourceAccessor(messageSource);
	}

	public boolean supports(Class authentication) {
		return (RememberMeAuthenticationToken.class
				.isAssignableFrom(authentication));
	}
}