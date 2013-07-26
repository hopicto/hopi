Ext.define('Ado.rup.DmTestPanel', {
	extend : 'Ext.panel.Panel',
	autoEl : true,
	autoScroll : true,
	border : false,
	loadMask : {
		msg : '数据加载中，请稍等...'
	},
	initComponent : function() {
		this.html = '测试panel';
		this.callParent();
	}
});