<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>电子商城首页</title>
<%@ include file="/common/head_jquery.jsp"%>
</head>
<body>
<div id="shortcut">
<div class="w">
<ul class="fl lh">
	<li class="fore1 ld" clstag="homepage|keycount|home2012|01a"><b></b><a
		href="javascript:addToFavorite()">收藏XMALL</a></li>
	<li class="fore2" clstag="homepage|keycount|home2012|01b"><a
		href="#" target="_blank">test1</a></li>
	<li class="fore3" clstag="homepage|keycount|home2012|01d"><a
		href="#" target="_blank">test2</a></li>
</ul>
<ul class="fr lh">
	<li class="fore1 ld" id="loginbar"
		clstag="homepage|keycount|home2012|01e">您好！欢迎来到XMALL！<a
		href="javascript:login()">[登录]</a>&nbsp;<a href="javascript:regist()">[免费注册]</a></li>
	<li class="fore2" clstag="homepage|keycount|home2012|01f"><a
		href="http://jd2008.360buy.com/JdHome/OrderList.aspx">我的订单</a></li>
	<li class="fore3 menu" data-widget="dropdown"
		clstag="homepage|keycount|home2012|01g">
	<dl>
		<dt class="ld">特色栏目<b></b></dt>
		<dd>
		<div><a href="http://read.360buy.com/" target="_blank">在线读书</a></div>
		<div><a href="http://diy.360buy.com/" target="_blank">装机大师</a></div>
		<div><a href="http://market.360buy.com/giftcard/"
			target="_blank">礼品卡</a></div>
		</dd>
	</dl>
	</li>
	<li class="fore4" clstag="homepage|keycount|home2012|01h"><a
		href="http://app.360buy.com/" target="_blank">移动京东</a></li>
	<li class="fore5 menu" data-widget="dropdown"
		clstag="homepage|keycount|home2012|01i">
	<dl>
		<dt class="ld">企业服务<b></b></dt>
		<dd>
		<div><a
			href="http://market.360buy.com/giftcard/company/default.aspx"
			target="_blank">企业客户</a></div>
		<div><a href="http://wop.360buy.com/p962.html" target="_blank">办公直通车</a></div>
		</dd>
	</dl>
	</li>
	<li class="fore6 menu" data-widget="dropdown"
		clstag="homepage|keycount|home2012|01j">
	<dl>
		<dt class="ld"><a href="http://help.360buy.com/" target="_blank">客户服务<b></b></a></dt>
		<dd>
		<div><a href="http://help.360buy.com/help/question-61.html"
			target="_blank">常见问题</a></div>
		<div><a href="http://myjd.360buy.com/repair/orderlist.action"
			target="_blank">售后服务</a></div>
		<div><a href="http://myjd.360buy.com/opinion/list.action"
			target="_blank">投诉中心</a></div>
		<div><a href="http://www.360buy.com/contact/service.html"
			target="_blank">客服邮箱</a></div>
		</dd>
	</dl>
	</li>
</ul>
<span class="clr"></span></div>
</div>
</body>
</html>