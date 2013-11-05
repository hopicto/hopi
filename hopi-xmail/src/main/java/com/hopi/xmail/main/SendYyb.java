package com.hopi.xmail.main;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;

import com.hopi.xmail.service.XmailService;

public class SendYyb {
	private final Log log = LogFactory.getLog(SendYyb.class);

	private ApplicationContext context;

	public SendYyb() {
		String contextDir = "./config/";
		context = new FileSystemXmlApplicationContext(new String[] { contextDir
				+ "context-config.xml" });
	}

	public void sendYyb() {
		XmailService xs = (XmailService) this.context.getBean("xmailService");
		log.info("开始发送邮件:营业部");
		xs.sendYyb();
		log.info("结束发送邮件");
	}

	public static void main(String[] args) {
		SendYyb sf = new SendYyb();
		sf.sendYyb();
	}

}
