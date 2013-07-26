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
<title>${info.TITLE}</title>
</head>
<body>
<div style="padding:5px;">
<p style="text-align:center;font-weight:bold;font-size:14pt;line-height:28px;">${info.TITLE}</p>
<p style="text-align:center;font-size:11pt;line-height:20px;">作者：${info.CREATOR_NAME}&nbsp;&nbsp;发布时间：<fmt:formatDate value="${info.CREATE_DATE}" type="date" dateStyle="long"/>&nbsp;&nbsp;点击数：${info.CLICKS}</p>
<div style="font-size:10pt;text-indent:20pt;line-height:20px;word-break:break-all;">
${info.CONTENT}
</div>
<hr/>
附件：
<ul>
<c:forEach items="${affixList}" var="item">
<li><a href="<%=request.getContextPath()%>/affix.do?method=download&id=${item.ID}" target='_blank'>${item.NAME}</a></li>
</c:forEach>
</ul>
</div>
</body>
</html>