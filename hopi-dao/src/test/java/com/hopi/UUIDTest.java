package com.hopi;

import java.util.UUID;

/**
 * @author 董依良
 * @since 2013-7-23
 */

public class UUIDTest {
	public static void main(String[] args) {
		String id=UUID.randomUUID().toString();
		System.out.println(id);
		System.out.println(id.length());
	}
}
