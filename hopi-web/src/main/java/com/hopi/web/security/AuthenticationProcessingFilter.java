package com.hopi.web.security;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationManager;
import org.springframework.security.AuthenticationServiceException;
import org.springframework.security.concurrent.SessionRegistry;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.event.authentication.InteractiveAuthenticationSuccessEvent;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.ui.AuthenticationDetailsSource;
import org.springframework.security.ui.FilterChainOrder;
import org.springframework.security.ui.SpringSecurityFilter;
import org.springframework.security.ui.WebAuthenticationDetailsSource;
import org.springframework.security.ui.rememberme.NullRememberMeServices;
import org.springframework.security.ui.rememberme.RememberMeServices;
import org.springframework.security.util.SessionUtils;
import org.springframework.security.util.TextUtils;
import org.springframework.security.util.UrlUtils;
import org.springframework.util.Assert;

import com.hopi.web.WebConstants;
import com.hopi.web.dao.StaffDao;

/**
 * 认证过滤器
 * 
 * @author:dongyl
 * @since:2010-3-23
 */
public class AuthenticationProcessingFilter extends SpringSecurityFilter
		implements ApplicationEventPublisherAware, InitializingBean {
	private final static Log log = LogFactory
			.getLog(AuthenticationProcessingFilter.class);
	private boolean useJcaptcha = false;
	public static final String SPRING_SECURITY_LAST_USERNAME_KEY = "SPRING_SECURITY_LAST_USERNAME";
	public static final String SPRING_SECURITY_LAST_EXCEPTION_KEY = "SPRING_SECURITY_LAST_EXCEPTION";
	protected ApplicationEventPublisher eventPublisher;
	private RememberMeServices rememberMeServices = null;
	private AuthenticationManager authenticationManager;
	private boolean invalidateSessionOnSuccessfulAuthentication = false;
	private boolean migrateInvalidatedSessionAttributes = true;
	private boolean allowSessionCreation = true;
	private SessionRegistry sessionRegistry;
	private String filterProcessesUrl = "/login.do";
	protected AuthenticationDetailsSource authenticationDetailsSource = new WebAuthenticationDetailsSource();
	private StaffDao staffDao;

	public void setStaffDao(StaffDao staffDao) {
		this.staffDao = staffDao;
	}

	public String getFilterProcessesUrl() {
		return filterProcessesUrl;
	}

	public void setFilterProcessesUrl(String filterProcessesUrl) {
		this.filterProcessesUrl = filterProcessesUrl;
	}

	public AuthenticationDetailsSource getAuthenticationDetailsSource() {
		return authenticationDetailsSource;
	}

	public void setAuthenticationDetailsSource(
			AuthenticationDetailsSource authenticationDetailsSource) {
		this.authenticationDetailsSource = authenticationDetailsSource;
	}

	public void setAuthenticationManager(
			AuthenticationManager authenticationManager) {
		this.authenticationManager = authenticationManager;
	}

	public SessionRegistry getSessionRegistry() {
		return sessionRegistry;
	}

	public void setSessionRegistry(SessionRegistry sessionRegistry) {
		this.sessionRegistry = sessionRegistry;
	}

	public boolean isInvalidateSessionOnSuccessfulAuthentication() {
		return invalidateSessionOnSuccessfulAuthentication;
	}

	public void setInvalidateSessionOnSuccessfulAuthentication(
			boolean invalidateSessionOnSuccessfulAuthentication) {
		this.invalidateSessionOnSuccessfulAuthentication = invalidateSessionOnSuccessfulAuthentication;
	}

	public boolean isMigrateInvalidatedSessionAttributes() {
		return migrateInvalidatedSessionAttributes;
	}

	public void setMigrateInvalidatedSessionAttributes(
			boolean migrateInvalidatedSessionAttributes) {
		this.migrateInvalidatedSessionAttributes = migrateInvalidatedSessionAttributes;
	}

	public boolean isAllowSessionCreation() {
		return allowSessionCreation;
	}

	public void setAllowSessionCreation(boolean allowSessionCreation) {
		this.allowSessionCreation = allowSessionCreation;
	}

	public RememberMeServices getRememberMeServices() {
		return rememberMeServices;
	}

	public void setRememberMeServices(RememberMeServices rememberMeServices) {
		this.rememberMeServices = rememberMeServices;
	}

	public void setUseJcaptcha(boolean useJcaptcha) {
		this.useJcaptcha = useJcaptcha;
	}

	private boolean checkJcaptchaCode(HttpServletRequest request) {
		String jcaptchCode = request.getParameter(WebConstants.JCAPTCHA_CODE);
		String sessionCode = (String) request.getSession().getAttribute(
				WebConstants.JCAPTCHA_CODE);
		// log.info("jcaptchCode="+jcaptchCode+" sessionCode="+sessionCode);
		// log.info("rememberme = "+request.getParameter("dozeRememberMe"));
		log.info("jcaptchCode="+jcaptchCode+" sessionCode="+sessionCode);
		if (jcaptchCode == null || sessionCode == null) {			
			return false;
		}
		return jcaptchCode.equals(sessionCode);
	}

	protected void setDetails(HttpServletRequest request,
			UsernamePasswordAuthenticationToken authRequest) {
		authRequest.setDetails(authenticationDetailsSource
				.buildDetails(request));
	}

	public Authentication attemptAuthentication(HttpServletRequest request)
			throws AuthenticationException {
		if (useJcaptcha) {
			if (!checkJcaptchaCode(request)) {
				throw new AuthenticationServiceException("验证码输入不对");
			}
		}
		String username = request.getParameter("loginName");
		String password = request.getParameter("password");

		if (username == null) {
			username = "";
		}

		if (password == null) {
			password = "";
		}

		username = username.trim();
		UsernamePasswordAuthenticationToken authRequest = new UsernamePasswordAuthenticationToken(
				username, password);
		HttpSession session = request.getSession(false);

		if (session != null || isAllowSessionCreation()) {
			request.getSession().setAttribute(
					SPRING_SECURITY_LAST_USERNAME_KEY,
					TextUtils.escapeEntities(username));
		}
		setDetails(request, authRequest);
		return authenticationManager.authenticate(authRequest);
	}

	public int getOrder() {
		return FilterChainOrder.AUTHENTICATION_PROCESSING_FILTER;
	}

	private boolean requiresAuthentication(HttpServletRequest request,
			HttpServletResponse response) {
		String uri = request.getRequestURI();
		int pathParamIndex = uri.indexOf(';');

		if (pathParamIndex > 0) {
			uri = uri.substring(0, pathParamIndex);
		}

		if ("".equals(request.getContextPath())) {
			return uri.endsWith(filterProcessesUrl);
		}

		return uri.endsWith(request.getContextPath() + filterProcessesUrl);
	}

	protected void doFilterHttp(HttpServletRequest request,
			HttpServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		if (requiresAuthentication(request, response)) {
			if (logger.isDebugEnabled()) {
				logger.debug("Request is to process authentication");
			}
			Authentication authResult;
			try {
				authResult = attemptAuthentication(request);

			} catch (AuthenticationException failed) {
				log.info("AuthenticationException failed!");
				unsuccessfulAuthentication(request, response, failed);
				return;
			}
			successfulAuthentication(request, response, authResult);
			response.getWriter().flush();
			return;
		}
		chain.doFilter(request, response);
	}

	protected void unsuccessfulAuthentication(HttpServletRequest request,
			HttpServletResponse response, AuthenticationException failed)
			throws IOException, ServletException {
		SecurityContextHolder.getContext().setAuthentication(null);
		if (logger.isDebugEnabled()) {
			logger
					.debug("Updated SecurityContextHolder to contain null Authentication");
		}
		try {
			HttpSession session = request.getSession(false);
			if (session != null || allowSessionCreation) {
				request.getSession().setAttribute(
						SPRING_SECURITY_LAST_EXCEPTION_KEY, failed);
			}
		} catch (Exception ignored) {
		}
		rememberMeServices.loginFail(request, response);
		response.setContentType("text/x-json;charset=UTF-8");
		response.getWriter().write(
				"{success:false,errors:{msg:'" + failed.getMessage() + "'}}");
	}

	protected void successfulAuthentication(HttpServletRequest request,
			HttpServletResponse response, Authentication authResult)
			throws IOException, ServletException {
		if (logger.isDebugEnabled()) {
			logger.debug("Authentication success: " + authResult.toString());
		}
		SecurityContextHolder.getContext().setAuthentication(authResult);
		if (logger.isDebugEnabled()) {
			logger
					.debug("Updated SecurityContextHolder to contain the following Authentication: '"
							+ authResult + "'");
		}
		if (invalidateSessionOnSuccessfulAuthentication) {
			SessionUtils.startNewSessionIfRequired(request,
					migrateInvalidatedSessionAttributes, sessionRegistry);
		}
		rememberMeServices.loginSuccess(request, response, authResult);
		// Fire event
		if (this.eventPublisher != null) {
			eventPublisher
					.publishEvent(new InteractiveAuthenticationSuccessEvent(
							authResult, this.getClass()));
		}

		// log.info("登录成功：loginName="+request.getParameter("loginName")+" 登录IP="+request.getRemoteHost());
		staffDao.processStaffLogin(request.getParameter("loginName"), request
				.getRemoteHost());
		response.setContentType("text/x-json;charset=UTF-8");
		response.getWriter().write("{success:true}");
	}

	public void setApplicationEventPublisher(
			ApplicationEventPublisher eventPublisher) {
		this.eventPublisher = eventPublisher;
	}

	public void afterPropertiesSet() throws Exception {
		Assert.hasLength(filterProcessesUrl,
				"filterProcessesUrl must be specified");
		Assert.isTrue(UrlUtils.isValidRedirectUrl(filterProcessesUrl),
				filterProcessesUrl + " isn't a valid redirect URL");
		if (rememberMeServices == null) {
			rememberMeServices = new NullRememberMeServices();
		}
	}

}
