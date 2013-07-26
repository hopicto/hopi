<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>ADO基础平台后台管理</title>
<%@ include file="/common/head.jsp"%>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/fix/ComboBox.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/fix/CheckboxGroup.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/Ext.ux.grid.RowActions.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/ux/ExtEnsure.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/module/MainViewport.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/ux/Ext.ux.CRUDPanel.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/MultiSelect.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/ItemSelector.js"></script>	
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/Ext.ux.tree.State.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/Ext.ux.FormWindow.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/Validate.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/vtypes.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/RowExpander.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/gridsummary.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/Ext.ux.FileUploadWindow.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/ux/Ext.ux.TreeCombo.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/module/InfoZxzxViewPanel.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/module/MessageMinListPanel.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/module/InfoMinViewPanel.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/FusionCharts/FusionCharts.js"></script>
<script type="text/javascript">
Ext.chart.Chart.CHART_URL = '<%=request.getContextPath() %>/extjs/resources/charts.swf';
Ext.BLANK_IMAGE_URL = "<%=request.getContextPath() %>/extjs/resources/images/default/s.gif";
GLOBAL_MASK=new Ext.LoadMask(Ext.getBody(),{msg:'数据加载中，请稍等...'});
var mainViewport;
var TAB_INFO='info_';
var TAB_MESSAGE='message_';//消息提醒
/**
 使用方法：
 openTab( {
		type : TAB_PORTFOLIO,
		id : id,
		title : '投资组合:' + records.get('NAME'),
		code : 'PortfolioPanel'
	}, {
		customer : id
	});
 */
function openTab(config,extparams){
	var tabId=config.type+config.id;
	var tab = mainViewport.tabPanel.getComponent(tabId);
	if (tab) {
		mainViewport.tabPanel.setActiveTab(tab);
	} else {				
		if(config.code==null){
			var p = mainViewport.tabPanel.add({
				id :tabId,
				title :config.text,
				closable :true,
				autoDestroy:true,
				bodyStyle:'padding:10px',
				html:'页面不存在'
			});
			mainViewport.tabPanel.setActiveTab(p);
		}else{
			Ext.ensure({
	    	    js: ['js/module/'+config.code+'.js'],
	    	    callback: function() {	    	    	
		        	var p = this.tabPanel.add(Ext.apply({
						id :tabId,
						title :config.title,
						closable :true,
						autoDestroy:true,
						xtype:config.code
					},extparams));
		        	this.tabPanel.setActiveTab(p);
	    	    },
	    	    scope:mainViewport
	    	});	
		}					
	}
}
Ext
.onReady( function() {	
	GLOBAL_MASK.show();	
	//Ext.History.init();	
	Ext.QuickTips.init();	
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());			
    Ext.util.Observable.observeClass(Ext.data.Connection);   
    Ext.data.Connection.on('requestcomplete', function(conn, resp,options ){
        if (resp && resp.getResponseHeader && resp.getResponseHeader('_timeout')) {   
    	    window.location.href='<%=request.getContextPath() %>/login.jsp';   
        }   
    });   
	mainViewport=new MainViewport({
		id:'mainViewport',
		rootId:1,		
		headData:{
			headMsg:'ADO基础平台后台管理',
			welcomeMsg:'您好，${user.NAME}',
			lastLoginDate:'<fmt:formatDate value="${user.LAST_LOGIN_DATE}" type="date" pattern="yyyy-MM-dd HH:mm:ss"/>',
			lastLoginIp:'${user.LAST_LOGIN_IP}'					
		},
		listeners : {
			afterrender:function(cp){
				GLOBAL_MASK.hide();	
			}
		}
	});	
});
</script>
</head>
<body>
</body>
</html>