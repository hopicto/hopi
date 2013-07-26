package com.hopi.web.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.Locale;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.ViewResolver;

import com.hopi.web.WebConstants;

/**
 * 保护资源视图，用于需要控制访问权限的资源
 * 
 * @author:dongyl
 * @since:2010-4-19
 */
public class ProtectedViewResolver implements ViewResolver, Ordered {
	private final static Log log = LogFactory
			.getLog(ProtectedViewResolver.class);
	private int order = Ordered.HIGHEST_PRECEDENCE;
	private String viewName = WebConstants.PROTECTED_VIEW;
	private String fileDirPath = "";

	public String getFileDirPath() {
		return fileDirPath;
	}

	public void setFileDirPath(String fileDirPath) {
		this.fileDirPath = fileDirPath;
	}

	public String getViewName() {
		return viewName;
	}

	public void setViewName(String viewName) {
		this.viewName = viewName;
	}

	public View resolveViewName(String viewName, Locale locale)
			throws Exception {
		if (this.getViewName().equals(viewName)) {
			final String dir = this.getFileDirPath();
			return new View() {
				private String contentType;

				public String getContentType() {
					return contentType;
				}

				public void setContentType(String contentType) {
					this.contentType = contentType;
				}

				public void render(final Map map, HttpServletRequest request,
						HttpServletResponse response) throws Exception {
					String ctype = (String) map.get(WebConstants.CONTENT_TYPE_KEY);
					this.setContentType(ctype);// 没用到。。
					response.setHeader("Cache-Control", "no-store");
					response.setHeader("Pragma", "no-cache");
					response.setDateHeader("Expires", 0);
					response.setContentType(ctype);
					String fileName = (String) map
							.get(WebConstants.CONTENT_FILENAME_KEY);
					String fullPath = dir + fileName;
					if (ctype.equals(WebConstants.PROTECTED_JPG)) {
						ImageIO.write(ImageIO.read(new File(fullPath)), "jpeg",
								response.getOutputStream());
					} else {
						InputStreamReader is = new InputStreamReader(
								new FileInputStream(fullPath), "UTF-8");
						IOUtils.copy(is, response.getOutputStream(), "UTF-8");
						is.close();
					}
					response.getOutputStream().flush();
					response.getOutputStream().close();
				}
			};
		}
		return null;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public int getOrder() {
		return this.order;
	}
}
