/**
 * 弹出输入表单
 */
Ext.define('Hopi.common.CrudHighQueryForm', {
	extend : 'Ext.form.FormPanel',
	hidden : true,
	// frame : true,
	style : 'padding-top:2px;',
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
	highQueryReset : function() {
		this.form.reset();
	},
	initComponent : function() {
		var crudMainPanel = this.crudMainPanel;
		this.items.push( {
			xtype : 'container',
			layout : 'anchor',
			defaults : {
				anchor : '50%',
				margin : 5
			},
			items : [ {
				xtype : 'button',
				text : '查询',
				handler : crudMainPanel.highQueryData,
				iconCls:'icon-query',
				scope : crudMainPanel
			}, {
				xtype : 'button',
				text : '清空',
				iconCls:'icon-reset',
				handler : this.highQueryReset,
				scope : this
			} ]
		});
		this.callParent();
	}
});