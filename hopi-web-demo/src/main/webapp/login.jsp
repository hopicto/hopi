<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Ado基础平台</title>
<%@ include file="/common/head.jsp"%>
<%
	response.addHeader("_timeout", "true");
%>
</head>
<body>
<script type="text/javascript">
Ext.onReady(function() {	
	var loginWindow=Ext.create('Hopi.common.LoginWindow', {});
	loginWindow.show();
});
</script>
</body>
</html>