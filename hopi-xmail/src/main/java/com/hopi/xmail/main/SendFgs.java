package com.hopi.xmail.main;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.hopi.xmail.service.XmailService;

public class SendFgs {
	private final Log log = LogFactory.getLog(SendFgs.class);

	private ApplicationContext context;

	public SendFgs() {
		String contextDir = "./config/";
		context = new FileSystemXmlApplicationContext(new String[] { contextDir
				+ "context-config.xml" });
	}

	public void sendFgs() {
		XmailService xs = (XmailService) this.context.getBean("xmailService");
		log.info("开始发送邮件:分公司");
		xs.sendFgs();
		log.info("结束发送邮件");
	}

	public static void main(String[] args) {
		SendFgs sf = new SendFgs();
		sf.sendFgs();
	}
}
