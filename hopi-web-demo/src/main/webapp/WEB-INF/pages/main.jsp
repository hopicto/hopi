<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>工欲善其事，必先利其器。</title>
<%@ include file="/common/head.jsp"%>
<script type="text/javascript">
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
				title :config.title,
				closable :true,
				autoDestroy:true,
				bodyStyle:'padding:10px',
				html:'页面不存在'
			});
			mainViewport.tabPanel.setActiveTab(p);
		}else{
			var pe=Ext.create(config.code,{
				title : config.title,
				id : tabId,
				closable : true,
				autoDestroy : true,
				extprop:extparams
			});
			//Ext.apply(pe,extparams);						
			var p=mainViewport.tabPanel.add(pe);
			mainViewport.tabPanel.setActiveTab(p);
			return p;
		}					
	}
}
Ext
.onReady( function() {	
	//GLOBAL_MASK.show();		
	Ext.QuickTips.init();	
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());			
    Ext.util.Observable.observeClass(Ext.data.Connection);   
    Ext.data.Connection.on('requestcomplete', function(conn, resp,options ){
        if (resp && resp.getResponseHeader && resp.getResponseHeader('_timeout')) {   
    	    window.location.href='<%=request.getContextPath() %>/login.jsp';   
        }   
    });   
    Ext.data.Connection.on('requestexception', function(conn, resp,options ){        
        Ext.Msg.alert('访问异常：','服务器无法访问');
    }); 
	mainViewport=Ext.create('Hopi.common.MainViewport', {
		id:'mainViewport',
		rootId:'1',		
		headData:{
			userName:'${staff.NAME}'					
		},
		listeners : {
			afterrender:function(cp){
				//GLOBAL_MASK.hide();	
			}
		}
	});
});
</script>
</head>
<body>
</body>
</html>