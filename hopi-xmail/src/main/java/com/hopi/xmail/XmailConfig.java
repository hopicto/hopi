package com.hopi.xmail;

import java.io.UnsupportedEncodingException;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.mail.internet.InternetAddress;

/**
 * 
 * @author dongyl
 * 
 */
public class XmailConfig {
	public static final String TEMPLATE_SUBJECT = "邮件标题";
	public static final String TEMPLATE_MAIL = "邮件正文";

	public static final String MAIL_GROUP_FGS = "分公司";
	public static final String MAIL_GROUP_YYB = "营业部";
	
	public static final String MAIL_PROP_HOST="host";
	public static final String MAIL_PROP_PORT="port";
	public static final String MAIL_PROP_USERNAME="username";
	public static final String MAIL_PROP_PASSWORD="password";
	public static final String MAIL_PROP_SENDFROM="sendFrom";
	public static final String MAIL_PROP_SENDFROMNAME="sendFromName";

//	private String sendFromName;
	private Map sendFromMap;
	private Set defaultCc;
	private Map userList;

	private Map mailGroup;

	public InternetAddress[] getReceiverAddress(String type,String groupName) {
		Map mg=this.getMailGroupByType(type);
		if(mg!=null){
			Set set = (Set) mg.get(groupName);
			InternetAddress[] ia = new InternetAddress[set.size()];
			int tag = 0;
			try {
				for (Iterator it = set.iterator(); it.hasNext();) {
					String r1 = (String) it.next();
					String rn = (String) userList.get(r1);
					ia[tag++] = new InternetAddress(r1, rn);
				}
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			return ia;
		}else{
			return null;
		}		
	}
	
	public InternetAddress[] getCcAddress() {
		if(this.defaultCc!=null){
			InternetAddress[] ia = new InternetAddress[this.defaultCc.size()];
			int tag = 0;
			try {
				for (Iterator it = this.defaultCc.iterator(); it.hasNext();) {
					String r1 = (String) it.next();
					String rn = (String) userList.get(r1);
					ia[tag++] = new InternetAddress(r1, rn);
				}
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			return ia;
		}else{
			return null;
		}		
	}

	public Map getMailGroupByType(String type){
		Map mg=(Map)this.mailGroup.get(type);
		return mg;
	}
	public String getUserName(String address) {
		return (String) this.userList.get(address);
	}

	public Set getDefaultCc() {
		return defaultCc;
	}

	public void setDefaultCc(Set defaultCc) {
		this.defaultCc = defaultCc;
	}

	public Map getUserList() {
		return userList;
	}

	public void setUserList(Map userList) {
		this.userList = userList;
	}

	public Map getMailGroup() {
		return mailGroup;
	}

	public void setMailGroup(Map mailGroup) {
		this.mailGroup = mailGroup;
	}

	public Map getSendFromMap() {
		return sendFromMap;
	}

	public void setSendFromMap(Map sendFromMap) {
		this.sendFromMap = sendFromMap;
	}

	
}
