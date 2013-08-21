/**
 * 类型字典
 */
Ext.define('Hopi.common.DictTypeCombo', {
	extend : 'Ext.form.ComboBox',
	name : 'TYPE',
	fieldLabel : '类别',
	store : Ext.create('Ext.data.Store', {
		idProperty : 'ID',
		fields : [ 'ID', 'ITEM' ],
		autoLoad : true,
		proxy : {
			type : 'ajax',
			url : '/dictType.do?method=dictTypeItemCombo',
			extraParams : {
				code : this.code
			},
			reader : {
				type : 'json',
				root : 'data'
			}
		}
	}),
	initComponent : function() {
		this.callParent();
	}
});