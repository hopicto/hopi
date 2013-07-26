package com.hopi.web.cache;

import java.util.List;

public interface SecurityCache {
	public static final String ELN_URL_RESOURCE = "ELN_URL_RESOURCE";
	public static final String ELN_RESOURCE_ROLE = "ELN_RESOURCE_ROLE";
	public static final String ELN_ONLINE_USER = "ELN_ONLINE_USER";

	List findAllUrlResources();

	List findResourceRole(String resourceId);

	void addOnlineUser(String userId);

	void deleteOnlineUser(String userId);

	int countOnlineUser();
}