package com.hopi.web;

import org.springframework.core.NestedRuntimeException;

/**
 * @author 董依良
 * @since 2013-8-21
 */

public class HopiWebException extends NestedRuntimeException {
	private static final long serialVersionUID = -6004642703653577295L;

	public HopiWebException(String msg) {
		super(msg);
	}
}
