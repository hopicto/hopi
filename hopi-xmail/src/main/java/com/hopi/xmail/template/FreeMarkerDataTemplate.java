package com.hopi.xmail.template;

import java.io.IOException;
import java.io.StringWriter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

public class FreeMarkerDataTemplate implements DataTemplate {
	protected Log log = LogFactory.getLog(getClass());
	private Configuration configuration;
	private String templateSuffix = ".ftl";

	public void setTemplateSuffix(String templateSuffix) {
		this.templateSuffix = templateSuffix;
	}

	public void setConfiguration(Configuration configuration) {
		this.configuration = configuration;
	}

	public String genString(String templateName, Object model)
			throws IOException, TemplateException {
		StringWriter sw = new StringWriter();
		Template template = (Template) this.configuration
				.getTemplate(templateName + templateSuffix);
		template.process(model, sw);
		return sw.toString();
	}
}
