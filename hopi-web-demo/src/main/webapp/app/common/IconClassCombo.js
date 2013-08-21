/**
 * 图标样式
 */
Ext.define('Hopi.common.IconClassCombo', {
	extend : 'Ext.form.ComboBox',
	name:'ICON_CLASS',
	fieldLabel : '选择图标',
	store : Ext.create('Ext.data.Store', {
		idProperty : 'CODE',
		fields : [ 'NAME','CODE','ICON_NAME' ],
		autoLoad : true,
		proxy : {
			type : 'ajax',
			url : '/iconClass.do?method=iconCombo',
			reader : {
				type : 'json',
				root : 'data'
			}
		}
	}),
	queryMode : 'remote',
	valueField : 'CODE',
	tpl : Ext.create('Ext.XTemplate', '<tpl for=".">',
			'<div class="x-boundlist-item">',
			'<img src="',HOPI_GLOBAL.ICON_PATH,'{ICON_NAME}"/>', '{NAME}',
			'</div>', '</tpl>'),
	displayTpl : Ext.create('Ext.XTemplate', '<tpl for=".">',
			'{NAME}', '</tpl>'),
	initComponent : function() {		
		this.callParent();
	}
});