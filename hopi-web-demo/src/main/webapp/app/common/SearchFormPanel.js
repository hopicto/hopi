/**
 * 弹出输入表单
 */
Ext.define('Hopi.common.SearchFormPanel', {
	extend : 'Ext.form.FormPanel',
	hidden : true,
	frame : true,
	style : 'margin-top:2px;',
	border : false,
	method : 'post',
	defaultType : 'textfield',
	defaults : {
		labelAlign : 'right'
	},
	layout : {
		type : 'table',
		columns : 4
	},
	initComponent : function() {
		this.callParent();
	}
});