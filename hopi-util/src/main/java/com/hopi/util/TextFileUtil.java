package com.hopi.util;

import java.io.File;
import java.io.FileWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * @author 董依良
 * @since 2013-7-11
 */

public class TextFileUtil {
	public static void saveData(String fp, String data) {
		File file = null;
		FileWriter fw = null;
		try {
			file = new File(fp);
			fw = new FileWriter(file);// 追加内容
			fw.write(data);
			fw.flush();
			fw.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fw != null)
				try {
					fw.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
