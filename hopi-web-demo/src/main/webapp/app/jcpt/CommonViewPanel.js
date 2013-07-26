Ext.define('Ado.jcpt.CommonViewPanel', {
	extend : 'Ext.panel.Panel',
	autoEl : true,
	closable : true,
	autoScroll : true,
	border : false,
	refresh : function() {
		this.loader.load( {
			url : this.extprop.url
		});
	},
	listeners : {
		activate : function(p) {
			p.loader.load( {
				url : p.extprop.url
			});
		}
	},
	initComponent : function() {
		this.loader = Ext.create('Ext.ComponentLoader', {
			loadMask : {
				msg : '数据加载中，请稍等...'
			}
		});
		this.tbar = [ {
			text : '刷新',
			handler : this.refresh,
			iconCls : 'icon-refresh',
			scope : this
		} ];
		this.callParent();
	}
});