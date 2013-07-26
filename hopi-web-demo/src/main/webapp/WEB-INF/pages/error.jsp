<%@ page language="java" contentType="text/x-json;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	Exception e = (Exception) request.getAttribute("exception");
	response.getWriter().print(
			"{success:false,errors:{msg:'"
					+ (e == null ? "" : e.getMessage()) + "'}}");
%>