package com.hopi.web.security;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.dao.DataAccessException;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.SpringSecurityMessageSource;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UserDetailsService;
import org.springframework.security.userdetails.UsernameNotFoundException;

import com.hopi.web.WebConstants;
import com.hopi.web.dao.StaffDao;


public class UserDetailsServiceImp implements UserDetailsService {	
	private final static Log log = LogFactory.getLog(UserDetailsServiceImp.class);
	private StaffDao staffDao;
	protected MessageSourceAccessor messages = SpringSecurityMessageSource
			.getAccessor();

	
	public void setStaffDao(StaffDao staffDao) {
		this.staffDao = staffDao;
	}

	public UserDetails loadUserByUsername(String userName)
			throws UsernameNotFoundException, DataAccessException {
		Map user=staffDao.findStaffByLoginName(userName);
		if (user==null)
			throw new UsernameNotFoundException(messages.getMessage(
					"JdbcDaoImpl.notFound", new Object[] { userName },
					"Username {0} not found"), userName);
		List authsList = new ArrayList();
//		BigDecimal id=(BigDecimal)user.get("ID");
//		long userId=id.longValue();
		
		String userId=(String)user.get("ID");		
		
		String loginName=(String)user.get("LOGIN_NAME");
		String password=(String)user.get("PASSWORD");
		String status=(String)user.get("STATUS");		
		List roles=staffDao.findStaffRole(userId);		
		
		// 添加普通用户权限
//		authsList.add(new GrantedAuthorityImpl(Constants.ROLE_PREFIX + "USER"));
		for(Iterator it=roles.iterator();it.hasNext();){
			Map ri=(Map)it.next();			
			String role=(String)ri.get("CODE");
			authsList.add(new GrantedAuthorityImpl(WebConstants.ROLE_PREFIX
					+ role.toUpperCase()));
		}		

		GrantedAuthority[] ga=(GrantedAuthority[])authsList.toArray(new GrantedAuthority[0]);		
		// 目前没有accountNonExpired,credentialsNonExpired, accountNonLocked等属性
//		org.springframework.security.userdetails.User userdetail=new org.springframework.security.userdetails.User(loginName, password, status.intValue()==1, true, true,true, ga);
		
		boolean valid=WebConstants.USER_STATUS_VALID.equalsIgnoreCase(status);
		boolean unlock=!WebConstants.USER_STATUS_LOCK.equalsIgnoreCase(status);
		EnhancedUser userdetail=new EnhancedUser(userId,loginName, password, valid, true, true,unlock, ga);		
		userdetail.setName((String)user.get("NAME"));
		userdetail.setEmail((String)user.get("EMAIL"));
		userdetail.setMobile((String)user.get("MOBILE"));
		userdetail.setPhone((String)user.get("PHONE"));
//		log.info("设置登录用户信息。");
//		userdetail.setLastLoginDate((Date)user.get("LAST_LOGIN_DATE"));		
//		userdetail.setLastLoginIp((String)user.get("LAST_LOGIN_IP"));
//		userdetail.setLoginCount((BigDecimal)user.get("LOGIN_COUNT"));
		
		userdetail.setAdmin(staffDao.isAdmin(userId));
		userdetail.setOrgName((String)user.get("ORG_NAME"));
		return userdetail;		
	}

}
