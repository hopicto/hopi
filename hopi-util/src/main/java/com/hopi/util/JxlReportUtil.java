package com.hopi.util;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import jxl.Cell;
import jxl.CellType;
import jxl.NumberCell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.NumberFormat;
import jxl.write.WritableCell;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import org.apache.log4j.Logger;

/**
 * excel报表工具
 * 
 * @author 董依良
 * @since 2013-5-14
 */

public class JxlReportUtil {
	private static Logger log = Logger.getLogger(JxlReportUtil.class);
	public static final String XLS_SUFFIX = ".xls";

	public static final String PERCENT_SUFFIX = "%";// 以表头列名以%结尾的，默认按照百分比设置格式

	public static final int FORMAT_TITLE = 0;
	public static final int FORMAT_NUMBER = 1;
	public static final int FORMAT_PERCENT = 2;
	public static final int FORMAT_TEXT_RIGHT = 3;
	public static final int FORMAT_TEXT_CENTER = 4;

	public static void checkDir(String dirPath) {
		File dir = new File(dirPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
	}

	public static WritableCellFormat getCellFormat(int type) throws Exception {
		WritableCellFormat cellFormat = null;
		switch (type) {
		case FORMAT_TITLE:
			cellFormat = new WritableCellFormat();
			cellFormat.setAlignment(Alignment.CENTRE);
			cellFormat.setBorder(Border.ALL, BorderLineStyle.THIN);
			WritableFont titlefont = new WritableFont(WritableFont.ARIAL, 10,
					WritableFont.BOLD);
			cellFormat.setFont(titlefont);
			// 设置自动换行
			cellFormat.setWrap(true);
			break;
		case FORMAT_NUMBER:
			cellFormat = new WritableCellFormat(new NumberFormat("#,##0"));
			break;
		case FORMAT_PERCENT:
			cellFormat = new WritableCellFormat(new NumberFormat("0.00%"));
			break;
		case FORMAT_TEXT_RIGHT:
			cellFormat = new WritableCellFormat();
			cellFormat.setAlignment(Alignment.RIGHT);
			break;
		default:
			cellFormat = new WritableCellFormat();
			cellFormat.setAlignment(Alignment.CENTRE);
		}
		return cellFormat;
	}

	public static String getXlsStringData(Object o) {
		if (o instanceof Double) {
			double d = (Double) o;
			return String.valueOf(Math.round(d));
		} else {
			return (String) o;
		}
	}

	public static double getXlsDoubleData(Object o) {
		if (o instanceof Double) {
			return (Double) o;
		} else {
			String t = (String) o;
			if (t == null || t.trim().length() == 0) {
				return 0;
			} else {
				return new Double(t);
			}
		}
	}

	/**
	 * 根据列表数据生成单个报表文件<br/>
	 * 
	 * 简单样式
	 * 
	 * @param dirPath
	 * @param name
	 * @param data
	 */
	public static void genSimpleReport(String dirPath, String name, List data) {
		if (data == null || data.size() == 0) {
			log.error(name + " 记录数异常");
			return;
		}

		checkDir(dirPath);

		long startTime = System.currentTimeMillis();
		log.info("开始生成报告：" + name + " 数据记录数：" + data.size());
		WritableWorkbook writeWb = null;

		try {
			WritableCellFormat titleFormat = getCellFormat(FORMAT_TITLE);
			WritableCellFormat textFormat = getCellFormat(FORMAT_TEXT_CENTER);
			WritableCellFormat numberFormat = getCellFormat(FORMAT_NUMBER);
			WritableCellFormat percentFormat = getCellFormat(FORMAT_PERCENT);

			File destFile = new File(dirPath + "/" + name + XLS_SUFFIX);
			if (destFile.exists()) {
				destFile.delete();
			}

			writeWb = Workbook.createWorkbook(destFile);

			WritableSheet destSheet = writeWb.createSheet(name, 0);
			WritableCell destCell = null;

			// 设置表头
			int rowTag = 0;
			int cellTag = 0;
			Map fm = (Map) data.get(0);
			Map km = new LinkedHashMap();
			for (Iterator it = fm.keySet().iterator(); it.hasNext();) {
				String key = (String) it.next();
				destCell = new Label(cellTag, rowTag, key);
				destCell.setCellFormat(titleFormat);
				destSheet.addCell(destCell);
				km.put(cellTag, key);
				cellTag++;
			}

			rowTag++;
			cellTag = 0;
			for (Iterator it = data.iterator(); it.hasNext();) {
				Map dm = (Map) it.next();
				for (Iterator kit = km.entrySet().iterator(); kit.hasNext();) {
					Entry ke = (Entry) kit.next();
					cellTag = (Integer) ke.getKey();
					String cn = (String) ke.getValue();
					boolean isPercent = cn.endsWith("%");
					Object dmo = dm.get(cn);
					destCell = null;
					if (dmo == null) {

					} else if (dmo instanceof BigDecimal) {
						BigDecimal pvalue = (BigDecimal) dmo;
						destCell = new Number(cellTag, rowTag, pvalue
								.doubleValue());
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}

					} else if (dmo instanceof Double) {
						Double pvalue = (Double) dmo;
						destCell = new Number(cellTag, rowTag, pvalue);
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
					} else if (dmo instanceof Float) {
						Float pvalue = (Float) dmo;
						destCell = new Number(cellTag, rowTag, pvalue);
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
					} else if (dmo instanceof Long) {
						Long pvalue = (Long) dmo;
						destCell = new Number(cellTag, rowTag, pvalue);
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
					} else if (dmo instanceof Integer) {
						Integer pvalue = (Integer) dmo;
						destCell = new Number(cellTag, rowTag, pvalue);
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
					} else if (dmo instanceof String) {
						String pvalue = (String) dmo;
						destCell = new Label(cellTag, rowTag, pvalue);
						destCell.setCellFormat(textFormat);
					} else {
						log.warn("未处理的数据类型：" + dmo);
					}
					if (destCell != null) {
						destSheet.addCell(destCell);
					}
				}
				rowTag++;
			}

			// 冻结首行
			destSheet.getSettings().setVerticalFreeze(1);
			destSheet.getSettings().setHorizontalFreeze(0);

			writeWb.write();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (writeWb != null) {
				try {
					writeWb.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * 根据列表数据生成复杂报表<br/>
	 * 
	 * 简单样式
	 * 
	 * @param dirPath
	 * @param name
	 * @param data
	 */
	public static void genReportByType(String dirPath, String name, List data,Map typeMap) {
		if (data == null || data.size() == 0) {
			log.error(name + " 记录数异常");
			return;
		}

		checkDir(dirPath);

		long startTime = System.currentTimeMillis();
		log.info("开始生成报告：" + name + " 数据记录数：" + data.size());
		WritableWorkbook writeWb = null;

		try {
			WritableCellFormat titleFormat = getCellFormat(FORMAT_TITLE);
			WritableCellFormat textFormat = getCellFormat(FORMAT_TEXT_CENTER);
			WritableCellFormat numberFormat = getCellFormat(FORMAT_NUMBER);
			WritableCellFormat percentFormat = getCellFormat(FORMAT_PERCENT);

			File destFile = new File(dirPath + "/" + name + XLS_SUFFIX);
			if (destFile.exists()) {
				destFile.delete();
			}

			writeWb = Workbook.createWorkbook(destFile);

			WritableSheet destSheet = writeWb.createSheet(name, 0);
			WritableCell destCell = null;

			// 设置表头
			int rowTag = 0;
			int cellTag = 0;
			Map fm = (Map) data.get(0);
			Map km = new LinkedHashMap();
			Map rm = new LinkedHashMap();//设置列宽-自适应
			for (Iterator it = fm.keySet().iterator(); it.hasNext();) {
				String key = (String) it.next();
				destCell = new Label(cellTag, rowTag, key);
				destCell.setCellFormat(titleFormat);
				destSheet.addCell(destCell);
				km.put(cellTag, key);
				rm.put(cellTag, 0);
				cellTag++;
			}

			rowTag++;
			cellTag = 0;
			for (Iterator it = data.iterator(); it.hasNext();) {
				Map dm = (Map) it.next();
				for (Iterator kit = km.entrySet().iterator(); kit.hasNext();) {
					Entry ke = (Entry) kit.next();
					cellTag = (Integer) ke.getKey();
					String cn = (String) ke.getValue();
					boolean isPercent = cn.endsWith("%");
					Object dmo = dm.get(cn);
					destCell = null;
					int cl=0;
					if (dmo == null) {

					} else if (dmo instanceof BigDecimal) {
						BigDecimal pvalue = (BigDecimal) dmo;
						destCell = new Number(cellTag, rowTag, pvalue
								.doubleValue());
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
						cl=String.valueOf(pvalue.doubleValue()).length();
					} else if (dmo instanceof Double) {
						Double pvalue = (Double) dmo;
						destCell = new Number(cellTag, rowTag, pvalue);
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
					} else if (dmo instanceof Float) {
						Float pvalue = (Float) dmo;
						destCell = new Number(cellTag, rowTag, pvalue);
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
					} else if (dmo instanceof Long) {
						Long pvalue = (Long) dmo;
						destCell = new Number(cellTag, rowTag, pvalue);
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
					} else if (dmo instanceof Integer) {
						Integer pvalue = (Integer) dmo;
						destCell = new Number(cellTag, rowTag, pvalue);
						if (isPercent) {
							destCell.setCellFormat(percentFormat);
						} else {
							destCell.setCellFormat(numberFormat);
						}
					} else if (dmo instanceof String) {
						String pvalue = (String) dmo;
						destCell = new Label(cellTag, rowTag, pvalue);
						destCell.setCellFormat(textFormat);
					} else {
						log.warn("未处理的数据类型：" + dmo);
					}
					if (destCell != null) {
						destSheet.addCell(destCell);
					}
				}
				rowTag++;
			}

			// 冻结首行
			destSheet.getSettings().setVerticalFreeze(1);
			destSheet.getSettings().setHorizontalFreeze(0);

			writeWb.write();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (writeWb != null) {
				try {
					writeWb.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	public static void copySheet(Sheet srcSheet, WritableSheet destSheet)
			throws Exception {
		int columnum = srcSheet.getColumns(); // 得到列数
		int rownum = srcSheet.getRows(); // 得到行数
		WritableCell destCell = null;
		Map headMap = new HashMap();

		WritableCellFormat titleFormat = getCellFormat(FORMAT_TITLE);
		WritableCellFormat numberFormat = getCellFormat(FORMAT_NUMBER);
		WritableCellFormat percentFormat = getCellFormat(FORMAT_PERCENT);

		for (int i = 0; i < rownum; i++) // 循环进行读写
		{
			for (int j = 0; j < columnum; j++) {
				Cell cell = srcSheet.getCell(j, i);
				destCell = null;
				if (cell.getType() == CellType.LABEL) {
					destCell = new Label(j, i, cell.getContents().trim());
				} else if (cell.getType() == CellType.NUMBER) {
					NumberCell numberCell = (NumberCell) cell;
					destCell = new Number(j, i, numberCell.getValue());
					destCell.setCellFormat(numberFormat);
				}
				if (destCell != null) {
					destSheet.addCell(destCell);
				}
				if (i == 0) {
					destCell.setCellFormat(titleFormat);
					headMap.put(j, cell.getContents().trim());
				} else {
					String hs = (String) headMap.get(j);
					if (hs.endsWith(PERCENT_SUFFIX)) {
						destCell.setCellFormat(percentFormat);
					}
				}
			}
		}

		// 冻结首行
		destSheet.getSettings().setVerticalFreeze(1);
		destSheet.getSettings().setHorizontalFreeze(0);
	}
	/**
	 * 读取多页的xls文件
	 * @param file
	 * @return
	 */
	public static LinkedHashMap readXlsDataMultiSheet(File file) {		
		LinkedHashMap result=new LinkedHashMap();
		Workbook wb = null;
		try {
			wb = Workbook.getWorkbook(file);
			Sheet[] sheets=wb.getSheets();
			for(int si=0;si<sheets.length;si++){
				Sheet sheet = wb.getSheet(si);
				String sheetName=sheet.getName();
				int columnum = sheet.getColumns(); // 得到列数
				int rownum = sheet.getRows(); // 得到行数
				Map columnKeyMap = new LinkedHashMap();
				for (int j = 0; j < columnum; j++) {
					Cell cell = sheet.getCell(j, 0);
					int pri = 0;
					if (cell.getType() == CellType.LABEL) {
						String columnKey = cell.getContents();
						columnKeyMap.put(j, columnKey.trim());
					}
				}
				List data = new ArrayList();
				for (int i = 1; i < rownum; i++) // 循环进行读写
				{
					Map map = new LinkedHashMap();
					for (int j = 0; j < columnum; j++) {
						Cell cell = sheet.getCell(j, i);
						String mk = (String) columnKeyMap.get(j);
						if (cell == null) {
							map.put(mk, null);
						} else if (cell.getType() == CellType.NUMBER) {
							NumberCell numberCell = (NumberCell) cell;
							map.put(mk, numberCell.getValue());
						} else {
							String cs = cell.getContents();
							map.put(mk, cs == null ? "" : cs.trim());
						}
					}
					data.add(map);
				}
				result.put(sheetName, data);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (wb != null) {
				try {
					wb.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return result;
	}
	
	public static List readXlsData(File file) {
		List data = new ArrayList();
		Workbook wb = null;
		try {
			wb = Workbook.getWorkbook(file);
			Sheet sheet = wb.getSheet(0);
			int columnum = sheet.getColumns(); // 得到列数
			int rownum = sheet.getRows(); // 得到行数
			Map columnKeyMap = new LinkedHashMap();
			for (int j = 0; j < columnum; j++) {
				Cell cell = sheet.getCell(j, 0);
				int pri = 0;
				if (cell.getType() == CellType.LABEL) {
					String columnKey = cell.getContents();
					columnKeyMap.put(j, columnKey.trim());
				}
			}

			for (int i = 1; i < rownum; i++) // 循环进行读写
			{
				Map map = new LinkedHashMap();
				for (int j = 0; j < columnum; j++) {
					Cell cell = sheet.getCell(j, i);
					String mk = (String) columnKeyMap.get(j);
					if (cell == null) {
						map.put(mk, null);
					} else if (cell.getType() == CellType.NUMBER) {
						NumberCell numberCell = (NumberCell) cell;
						map.put(mk, numberCell.getValue());
					} else {
						String cs = cell.getContents();
						map.put(mk, cs == null ? "" : cs.trim());
					}
				}
				data.add(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (wb != null) {
				try {
					wb.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return data;
	}

	public static Object getMergeCellData(Map mcMap, int column, int row) {
		Object rs = null;
		if (mcMap == null || mcMap.size() < 1) {
			return rs;
		} else {
			for (Iterator it = mcMap.entrySet().iterator(); it.hasNext();) {
				Entry entry = (Entry) it.next();
				String k = (String) entry.getKey();
				Object o = entry.getValue();
				String[] ss = k.split("_");
				int[] si = new int[4];
				for (int i = 0; i < 4; i++) {
					si[i] = Integer.parseInt(ss[i]);
				}
				if (column >= si[0] && column <= si[2] && row >= si[1]
						&& row <= si[3]) {
					return o;
				}
			}
		}
		return rs;
	}

	/**
	 * 读取带合并单元格的excel
	 * 
	 * 合并单元格，根据左上角第一个单元，复制到合并单元每个格子里面
	 * 
	 * @param file
	 * @return
	 */
	public static List readMergedXlsData(File file) {
		List data = new ArrayList();
		Workbook wb = null;
		try {
			wb = Workbook.getWorkbook(file);
			Sheet sheet = wb.getSheet(0);
			int columnum = sheet.getColumns(); // 得到列数
			int rownum = sheet.getRows(); // 得到行数
			Map columnKeyMap = new LinkedHashMap();
			for (int j = 0; j < columnum; j++) {
				Cell cell = sheet.getCell(j, 0);
				int pri = 0;
				if (cell.getType() == CellType.LABEL) {
					String columnKey = cell.getContents();
					columnKeyMap.put(j, columnKey.trim());
				}
			}

			// 预处理合并单元格
			Map mcMap = new HashMap();
			for (int k = 0; k < sheet.getMergedCells().length; k++) {
				Cell mc = sheet.getMergedCells()[k].getTopLeft();
				Object mv = null;
				if (mc != null) {
					if (mc.getType() == CellType.NUMBER) {
						NumberCell numberCell = (NumberCell) mc;
						mv = numberCell.getValue();
					} else {
						mv = mc.getContents();
					}
				}
				Cell mr = sheet.getMergedCells()[k].getBottomRight();
				int y1 = mc.getRow();
				int x1 = mc.getColumn();
				int y2 = mr.getRow();
				int x2 = mr.getColumn();
				mcMap.put(x1 + "_" + y1 + "_" + x2 + "_" + y2, mv);
			}

			for (int i = 1; i < rownum; i++) // 循环进行读写
			{
				Map map = new LinkedHashMap();
				for (int j = 0; j < columnum; j++) {
					Cell cell = sheet.getCell(j, i);
					String mk = (String) columnKeyMap.get(j);

					Object cv = getMergeCellData(mcMap, j, i);
					if (cv != null) {
						// 在合并单元格范围内，则取合并单元格左上角单元数据
						map.put(mk, cv);
					} else {
						if (cell == null) {
							map.put(mk, null);
						} else if (cell.getType() == CellType.NUMBER) {
							NumberCell numberCell = (NumberCell) cell;
							map.put(mk, numberCell.getValue());
						} else {
							String cs = cell.getContents();
							map.put(mk, cs == null ? "" : cs.trim());
						}
					}
				}
				data.add(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (wb != null) {
				try {
					wb.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return data;
	}

	/**
	 * 合并目录下全部报表为汇总报表
	 * 
	 * @param name
	 * @param rootPath
	 * @param sourcePath
	 */
	public static void combineReport(String name, String rootPath,
			String sourcePath) {
		File file = new File(sourcePath);
		if (file.exists() && file.isDirectory()) {
			Workbook sourceWb = null;
			WritableWorkbook destWb = null;
			try {
				File destFile = new File(rootPath + "/" + name + ".xls");
				if (destFile.exists()) {
					destFile.delete();
				}
				destWb = Workbook.createWorkbook(destFile);
				File[] fs = file.listFiles();
				for (int i = 0; i < fs.length; i++) {
					sourceWb = Workbook.getWorkbook(fs[i]);
					String sheetName = fs[i].getName();
					sheetName = sheetName.substring(0, sheetName.indexOf("."));
					WritableSheet destSheet = destWb.createSheet(sheetName, i);
					copySheet(sourceWb.getSheet(0), destSheet);
					sourceWb.close();
				}
				destWb.write();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (sourceWb != null) {
					sourceWb.close();
				}
				if (destWb != null) {
					try {
						destWb.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

			}
		}
	}
	public static void compareReport(String dir,String fn1,String fn2){
		String fp1=dir+fn1;
		String fp2=dir+fn2;		
		LinkedHashMap data1=readXlsDataMultiSheet(new File(fp1));
		LinkedHashMap data2=readXlsDataMultiSheet(new File(fp2));
		if(data1.size()!=data2.size()){
			System.out.println("页码不一致");
		}
		
		for(Iterator it=data1.entrySet().iterator();it.hasNext();){
			Entry entry=(Entry)it.next();
			String sn=(String)entry.getKey();
			List d1=(List)entry.getValue();
			List d2=(List)data2.get(sn);
			LinkedHashMap sumData1=getSumData(d1);
			LinkedHashMap sumData2=getSumData(d2);
//			List rd=new ArrayList();
			int row=0;
			List resultList=new ArrayList();			
			for(Iterator sit=sumData1.entrySet().iterator();sit.hasNext();){
				Entry se=(Entry)sit.next();
				String sk=(String)se.getKey();
				double sv=(Double)se.getValue();
				double sv2=0;
				if(sumData2.containsKey(sk)){
					sv2=(Double)sumData2.get(sk);
				}				
				Map rm=new HashMap();	
				rm.put("序号", row++);
				rm.put("列_1", sk);
				rm.put("值_1", sv);
//				rm.put("列_2", sk);
				rm.put("值_2", sv2);
				resultList.add(rm);
			}			
			JxlReportUtil.genSimpleReport(dir+"/比较结果", sn, resultList);
		}		
	}
	
	public static LinkedHashMap getSumData(List data){
		LinkedHashMap rm=new LinkedHashMap();
		for(Iterator it=data.iterator();it.hasNext();){
			Map m=(Map)it.next();
			for(Iterator mit=m.entrySet().iterator();mit.hasNext();){
				Entry me=(Entry)mit.next();
				String mk=(String)me.getKey();
				Object mo=me.getValue();
				double d1=0;
				if(mo instanceof Double){
					d1+=(Double)mo;					
				}
				if(!rm.containsKey(mk)){
					rm.put(mk, d1);
				}else{
					rm.put(mk, d1);
				}				
			}
		}
		return rm;
	}
	
	public static String compareReport(File f1,File f2){
		LinkedHashMap data1=readXlsDataMultiSheet(f1);
		LinkedHashMap data2=readXlsDataMultiSheet(f2);
		StringBuffer sb=new StringBuffer();		
		for(Iterator dit=data1.entrySet().iterator();dit.hasNext();){
			Entry de=(Entry)dit.next();
			String sn=(String)de.getKey();
			List l1=(List)de.getValue();
			List l2=(List)data2.get(sn);			
			if(l1!=null&&l2!=null&&l1.size()==l2.size()){
				for(int i=0;i<l1.size();i++){
					Map m1=(Map)l1.get(i);
					Map m2=(Map)l2.get(i);
					for(Iterator mit=m1.entrySet().iterator();mit.hasNext();){
						Entry me1=(Entry)mit.next();
						String mk=(String)me1.getKey();
						Object mo1=me1.getValue();
						if(mo1!=null){
							Object mo2=m2.get(mk);
							if(mo2==null){
								sb.append(mk).append(" mo2=null");
							}else if(mo1 instanceof Double){
								double d1=(Double)mo1;
								double d2=0;
								if(mo2 instanceof String){
									String s2=(String)mo2;
									if(s2.length()>0){
										d2=Double.parseDouble((String)mo2);
									}									
								}else{
									d2=(Double)mo2;
								}								 
								if(d1!=d2){
									sb.append(mk).append(" ").append(d1).append(" ").append(d2).append("\n");
								}
							}else{
								String d1=(String)mo1;
								String d2=null;
								if(mo2 instanceof Double){
									d2=String.valueOf(Math.round((Double)mo2));
								}else{
									d2=(String)mo2;
								}								
								if(!d1.equals(d2)){
									sb.append(mk).append(" ").append(d1).append(" ").append(d2).append("\n");
								}
							}
						}
					}
				}
			}else{
				sb.append(sn).append("记录数不一致:").append(l1.size()).append(" ").append(l2.size()).append("\n");
			}			
		}
		return sb.toString();
	}
	
	public static void main(String[] args){
		String dir="C:/Users/xyzq/Desktop/";
//		String s=JxlReportUtil.compareReport(new File(dir+"周报原始数据_20130625.xls"), new File(dir+"周报原始数据_20130613_20130621.xls"));
		String fn1="周报原始数据_20130625.xls";
		String fn2="周报原始数据_20130613_20130621.xls";
		compareReport(dir,fn1,fn2);		
	}
}
