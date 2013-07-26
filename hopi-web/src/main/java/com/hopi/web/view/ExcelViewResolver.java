package com.hopi.web.view;

import java.math.BigDecimal;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.ViewResolver;

import com.hopi.web.WebConstants;

/**
 * excel导出视图
 * 
 * 使用样例：
 * public ModelAndView export(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map result = new HashMap();
		List data = psStockTrackDao.queryStockTrackAll();
		String[] headConfig = new String[] { "推荐日期", "代码", "推荐前5日", "推荐前5日全市",
				"推荐后2日", "推荐后2日全市", "变化", "变化率" };
		String[] dataConfig = new String[] { "RECOMMEND_DATE", "CODE",
				"PREV_FIVE", "PREV_FIVE_ALL", "NEXT_TWO", "NEXT_TWO_ALL",
				"CHANGE", "CHANGE_RATE" };
		result.put(HopiWebConstants.EXCEL_VIEW_FILE_NAME, "早盘快递.xls");
		result.put(HopiWebConstants.EXCEL_VIEW_HEAD_CONFIG, headConfig);
		result.put(HopiWebConstants.EXCEL_VIEW_DATA_CONFIG, dataConfig);
		result.put(HopiWebConstants.EXCEL_VIEW_DATA, data);
		return new ModelAndView(HopiWebConstants.EXCEL_VIEW, result);
	}
 * 
 * 
 * @author 董依良
 * @since 2012-12-13
 */
public class ExcelViewResolver implements ViewResolver, Ordered {
	private final static Log log = LogFactory.getLog(ExcelViewResolver.class);
	private int order = Ordered.HIGHEST_PRECEDENCE;
	private String viewName = WebConstants.EXCEL_VIEW;
	private String charset = WebConstants.DEFAULT_CHARTSET;

	public void setCharset(String charset) {
		this.charset = charset;
	}

	public View resolveViewName(String viewName, Locale locale)
			throws Exception {
		if (this.viewName.equals(viewName)) {
			return new View() {
				public String getContentType() {
					return "application/vnd.ms-excel;charset=" + charset;
				}

				public void render(final Map map, HttpServletRequest request,
						HttpServletResponse response) throws Exception {

					HSSFWorkbook workbook = new HSSFWorkbook();
					HSSFSheet s = workbook.createSheet();
					String fileName = (String) map
							.get(WebConstants.EXCEL_VIEW_FILE_NAME);
					String[] headConfig = (String[]) map
							.get(WebConstants.EXCEL_VIEW_HEAD_CONFIG);
					String[] dataConfig = (String[]) map
					.get(WebConstants.EXCEL_VIEW_DATA_CONFIG);
					if(headConfig==null){
						headConfig=dataConfig;
					}
					List data = (List) map.get(WebConstants.EXCEL_VIEW_DATA);
					int rowNum = 0;
					HSSFRow row = s.createRow(rowNum++);
					for (int i = 0; i < headConfig.length; i++) {
						row.createCell(i).setCellValue(headConfig[i]);
					}

					for (Iterator it = data.iterator(); it.hasNext();) {
						Map m = (Map) it.next();
						row = s.createRow(rowNum++);
						for (int i = 0; i < dataConfig.length; i++) {
							Object o = m.get(dataConfig[i]);
							HSSFCell cell=row.createCell(i);
							if (o instanceof Number) {
								BigDecimal b=(BigDecimal)o;
								cell.setCellValue(b.doubleValue());
							} else {
								String b=(String)o;
								cell.setCellValue(b);
							}							
						}
					}
					
					response.setContentType(getContentType());
					fileName = new String(fileName.getBytes(), "iso8859-1");
					response.setHeader("Content-Disposition", "attachment;" + "filename=" + fileName);  
					ServletOutputStream out = response.getOutputStream();
					workbook.write(out);
					out.flush();
				}
			};
		}
		return null;
	}

	public void setViewName(String viewName) {
		this.viewName = viewName;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public int getOrder() {
		return this.order;
	}
}
