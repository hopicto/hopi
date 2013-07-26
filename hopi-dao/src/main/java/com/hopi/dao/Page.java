package com.hopi.dao;

import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

/**
 * 分页查询封装类
 * 
 * @author 董依良
 * @since 2013-7-23
 */
public class Page implements Serializable {
	private static final long serialVersionUID = -5773412403123454369L;
	public static final long PAGE_SIZE_DEFAULT = 20;
	private long limit = PAGE_SIZE_DEFAULT;
	private long start;
	private List list;
	private long totalCount;
	private boolean success = true;

	public Page() {
		this(0, 0, PAGE_SIZE_DEFAULT, new ArrayList());
	}

	public Page(long start, long totalCount, long pageSize, List list) {
		this.limit = (pageSize == 0) ? PAGE_SIZE_DEFAULT : pageSize;
		this.start = start;
		this.totalCount = totalCount;
		this.list = list;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public List getList() {
		return list;
	}

	public void setList(List list) {
		this.list = list;
	}

	public long getLimit() {
		return limit;
	}

	public void setLimit(long limit) {
		this.limit = limit;
	}

	public long getStart() {
		return start;
	}

	public void setStart(long start) {
		this.start = start;
	}

	public long getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(long totalCount) {
		this.totalCount = totalCount;
	}
}
