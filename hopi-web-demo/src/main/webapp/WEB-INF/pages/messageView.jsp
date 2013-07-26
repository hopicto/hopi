<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<meta http-equiv="Content-Language" content="zh_CN">
<meta name="keywords" content="xyzq">
<meta name="robots" content="all" />
<meta name="googlebot" content="all" />
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
<title>消息读取</title>
</head>
<body>
<div style="padding: 5px;">
<p
	style="text-align: center; font-weight: bold; font-size: 14pt; line-height: 28px;">${TITLE}</p>
<p style="text-align: center; font-size: 11pt; line-height: 20px;">发送时间：<fmt:formatDate
	value="${SEND_DATE}" type="date" dateStyle="long" /></p>
<hr />
<div
	style="font-size: 10pt; text-indent: 20pt; line-height: 20px; word-break: break-all;">
${CONTENT}</div>
<hr />
</div>
</body>
</html>