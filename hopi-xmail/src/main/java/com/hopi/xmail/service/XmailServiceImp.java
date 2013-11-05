package com.hopi.xmail.service;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import com.hopi.xmail.XmailConfig;
import com.hopi.xmail.template.DataTemplate;

public class XmailServiceImp implements XmailService {
	private final static Log log = LogFactory.getLog(XmailServiceImp.class);
	private XmailConfig xmailConfig;
	private DataTemplate dataTemplate;
	private JavaMailSenderImpl mailSender;
	private String encode = "UTF-8";
	private String rootPath = "./config/发送数据/";
	private String sendFrom;
	private String sendFromName;

	public String getSendFrom() {
		return sendFrom;
	}

	public void setSendFrom(String sendFrom) {
		this.sendFrom = sendFrom;
	}

	public String getSendFromName() {
		return sendFromName;
	}

	public void setSendFromName(String sendFromName) {
		this.sendFromName = sendFromName;
	}

	public void setXmailConfig(XmailConfig xmailConfig) {
		this.xmailConfig = xmailConfig;
	}

	public void setDataTemplate(DataTemplate dataTemplate) {
		this.dataTemplate = dataTemplate;
	}

	public void setEncode(String encode) {
		this.encode = encode;
	}

	public void setRootPath(String rootPath) {
		this.rootPath = rootPath;
	}

	public void init() {
		this.mailSender = new JavaMailSenderImpl();
		Map sm = xmailConfig.getSendFromMap();
		String host = (String) sm.get(XmailConfig.MAIL_PROP_HOST);
		String port = (String) sm.get(XmailConfig.MAIL_PROP_PORT);
		String username = (String) sm.get(XmailConfig.MAIL_PROP_USERNAME);
		String password = (String) sm.get(XmailConfig.MAIL_PROP_PASSWORD);
		String sendFrom = (String) sm.get(XmailConfig.MAIL_PROP_SENDFROM);
		String sendFromName = (String) sm
				.get(XmailConfig.MAIL_PROP_SENDFROMNAME);
		this.mailSender.setHost(host);
		this.mailSender.setPort(Integer.parseInt(port));
		this.mailSender.setUsername(username);
		this.mailSender.setPassword(password);
		this.setSendFrom(sendFrom);
		this.setSendFromName(sendFromName);
	}

	public void sendMail(String type) {
		Map fgsList = this.xmailConfig.getMailGroupByType(type);
		String fgsPath = this.rootPath + type + "/";
		File file = new File(fgsPath);
		if (file.exists() && file.isDirectory()) {
			for (Iterator it = fgsList.entrySet().iterator(); it.hasNext();) {
				Entry ms = (Entry) it.next();
				String key = (String) ms.getKey();
				Set mset = (Set) ms.getValue();
				File df = new File(fgsPath + key);
				if (df.exists() && df.isDirectory()) {
					File[] fs = df.listFiles();
					if (fs.length > 0) {
						InternetAddress[] receivers = this.xmailConfig
								.getReceiverAddress(type, key);
						InternetAddress[] cc = this.xmailConfig.getCcAddress();
						Map model = new HashMap();
						// log.info("fs length:"+fs.length);
						boolean sr = sendMailWithAttachment(receivers,cc, model,
								fs);
						if (sr) {
							log.info("发送成功，" + type + "：" + key + " 接收人数："
									+ receivers.length + " 附件数量：" + fs.length);
						} else {
							log.error("发送失败，" + type + "：" + key + " 接收人数："
									+ receivers.length + " 附件数量：" + fs.length);
						}
					}
				}
			}
		} else {
			log.error("发送数据目录不存在，请核对。");
		}
	}

	public void sendFgs() {
		sendMail(XmailConfig.MAIL_GROUP_FGS);

	}

	public void sendYyb() {
		sendMail(XmailConfig.MAIL_GROUP_YYB);
	}

	public boolean sendMailWithAttachment(InternetAddress[] receivers,
			InternetAddress[] cc, Map model, File[] attachs) {
		MimeMessage msg = this.mailSender.createMimeMessage();

		try {
			MimeMessageHelper helper = new MimeMessageHelper(msg, true, encode);
			helper.setFrom(this.getSendFrom(), this.getSendFromName());
			String subject = dataTemplate.genString(
					XmailConfig.TEMPLATE_SUBJECT, model);
			helper.setSubject(subject);
			helper.setTo(receivers);
			if(cc!=null){
				helper.setCc(cc);
			}			
			String text = dataTemplate.genString(XmailConfig.TEMPLATE_MAIL,
					model);
			helper.setText(text, true);
			if (attachs != null)
				for (int i = 0; i < attachs.length; i++) {
					if (attachs[i] != null && attachs[i].exists()) {
						FileSystemResource rarfile = new FileSystemResource(
								attachs[i]);
						helper.addAttachment(new String(attachs[i].getName()
								.getBytes(encode), "ISO8859-1"), rarfile);
					}
				}
			this.mailSender.send(msg);
		} catch (Exception e) {
			log.warn("发送邮件失败:" + e.getMessage());
			e.printStackTrace();
			return false;
		}
		return true;
	}
}
