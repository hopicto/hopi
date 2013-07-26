package com.hopi.util;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateUtil {
	public static final String DEFAULT_PATTERN = "yyyy-MM-dd";
	public static final String LONG_PATTERN = "yyyy-MM-dd HH:mm:ss";

	public static String formatDate(Timestamp date, String pattern) {
		SimpleDateFormat sdf = new SimpleDateFormat(pattern, Locale.CHINA);
		return sdf.format(date);
	}

	// yyyyMMddHHmmss
	public static String formatDate(Date date, String pattern) {
		SimpleDateFormat sdf = new SimpleDateFormat(pattern, Locale.CHINA);
		return sdf.format(date);
	}

	public static Date addDays(Date date, int days) {
		Calendar c = Calendar.getInstance(Locale.CHINA);
		c.setTime(date);
		c.add(Calendar.DAY_OF_MONTH, days);
		return c.getTime();
	}

	public static String exchangeFormat(String dateStr, String fromPattern,
			String toPattern) {
		if (dateStr == null) {
			return dateStr;
		} else {
			Date d = parse(dateStr, fromPattern);
			return formatDate(d, toPattern);
		}
	}

	public static String addDays(String date, int days, String pattern) {
		SimpleDateFormat sdf = new SimpleDateFormat(pattern, Locale.CHINA);
		Calendar c = Calendar.getInstance(Locale.CHINA);
		try {
			c.setTime(sdf.parse(date));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		c.add(Calendar.DAY_OF_MONTH, days);
		return sdf.format(c.getTime());
	}

	public static String formatLongToTime(long time) {
		long a = time % 1000;
		long b = time % 60000 / 1000;// 秒
		long c = time % 3600000 / 60000;// 分钟
		long d = time % (3600000 * 24)/ 3600000;// 小时
		long e = time / (3600000 * 24);// 天
		StringBuffer result = new StringBuffer();
		result.append(e).append("天").append(d).append("小时").append(c).append(
				"分").append(b).append("秒").append(a);
		return result.toString();
	}

	public static String checkDateRange(Date date1, Date date2) {
		if (date1 == null || date2 == null)
			throw new IllegalArgumentException("The date must not be null");
		Calendar cal1 = Calendar.getInstance(Locale.CHINA);
		cal1.setTime(date1);
		Calendar cal2 = Calendar.getInstance(Locale.CHINA);
		cal2.setTime(date2);
		long range = cal1.getTimeInMillis() - cal2.getTimeInMillis();
		return formatLongToTime(range);
	}

	public static boolean isSameDay(Date date1, Date date2) {
		if (date1 == null || date2 == null)
			throw new IllegalArgumentException("The date must not be null");
		Calendar cal1 = Calendar.getInstance(Locale.CHINA);
		cal1.setTime(date1);
		Calendar cal2 = Calendar.getInstance(Locale.CHINA);
		cal2.setTime(date2);
		return isSameDay(cal1, cal2);
	}

	public static boolean isSameDay(Calendar cal1, Calendar cal2) {
		if (cal1 == null || cal2 == null)
			throw new IllegalArgumentException("The date must not be null");
		return (cal1.get(0) == cal2.get(0) && cal1.get(1) == cal2.get(1) && cal1
				.get(6) == cal2.get(6));
	}

	public static Date roundDay(Date date) {
		Calendar c = Calendar.getInstance(Locale.CHINA);
		c.setTime(date);
		c.set(Calendar.HOUR_OF_DAY, 0);
		c.set(Calendar.MINUTE, 0);
		c.set(Calendar.MILLISECOND, 0);
		return c.getTime();
	}

	public static Date parse(String dateStr, String pattern) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat(pattern, Locale.CHINA);
			return sdf.parse(dateStr);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public static boolean inSameRange(Date day1, Date day2, int field) {
		Calendar c1 = Calendar.getInstance(Locale.CHINA);
		c1.setTime(day1);
		Calendar c2 = Calendar.getInstance(Locale.CHINA);
		c2.setTime(day2);
		return c1.get(field) == c2.get(field);
	}

	/**
	 * 根据两日期计算相差的年份
	 * 
	 * @param beginDate-开始日期
	 * @param endDate-结束日期
	 * @return
	 */
	public static int caculateRangeByYear(Date beginDate, Date endDate) {
		if(beginDate==null||endDate==null){
			return 0;
		}
		Calendar c1 = Calendar.getInstance(Locale.CHINA);
		c1.setTime(beginDate);
		Calendar c2 = Calendar.getInstance(Locale.CHINA);
		c2.setTime(endDate);
		long range=c2.getTimeInMillis()-c1.getTimeInMillis();	
//		Long d=new Long("31536000000");
		BigDecimal d=new BigDecimal(range);
		return d.divide(new BigDecimal("31536000000"),0,BigDecimal.ROUND_UP).intValue();		
	}

	public static void main(String args[]) {
		long d=1;
		d=d*365*24*60*60*1000;
		System.out.println(d);
		long years=DateUtil.caculateRangeByYear(DateUtil.parse("1981-01-01", "yyyy-MM-dd"), new Date());
		System.out.println(years);
		// String pattern = "yyyy-MM-dd";
		// System.out.println(DateUtil.formatDate(new Date(), pattern));
		// System.out.println(DateUtil.formatDate(
		// DateUtil.addDays(new Date(), -1), pattern));
		// long begin = System.currentTimeMillis();
		// try {
		// for (int i = 0; i < 100; i++) {
		// Thread.sleep(20);
		// }
		// } catch (Exception e) {
		// e.printStackTrace();
		// }
		// long range = System.currentTimeMillis() - begin;
//		long range = 19990;
//		System.out.println(range % 1000);// 毫秒
//		System.out.println(range % 60000 / 1000);
//
//		System.out.println(DateUtil.formatLongToTime(129013041));
	}
}
