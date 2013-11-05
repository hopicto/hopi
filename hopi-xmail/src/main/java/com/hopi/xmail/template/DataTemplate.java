package com.hopi.xmail.template;

import java.io.IOException;

import freemarker.template.TemplateException;

public interface DataTemplate {

	String genString(String templateName, Object model)
			throws IOException, TemplateException;
}
