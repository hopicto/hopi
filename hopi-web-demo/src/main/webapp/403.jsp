<%@ page language="java" contentType="text/x-json;charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	response.getWriter().print("{errors:{code:'1',msg:'您没有权限访问该页面！'}}");
	response.getWriter().flush();
%>