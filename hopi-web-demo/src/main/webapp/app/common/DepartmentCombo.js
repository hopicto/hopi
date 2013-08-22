/**
 * 部门
 */
Ext.define('Hopi.common.DepartmentCombo', {
	extend : 'Ext.form.field.Picker',
	fieldLabel : '部门',
	labelWidth : 80,
	labelAlign : 'right',	
	name : 'DEPARTMENT_NAME',
	editable :false,
	createPicker : function() {
		var store = Ext.create('Ext.data.TreeStore', {
			proxy : {
				type : 'ajax',
				reader : 'json',
				url : 'department.do?method=tree'
			},
			fields : [ 'id', 'text', 'code', 'seq', 'leaf', 'expanded' ],
			clearOnLoad : true,
			autoLoad : true
		});
		var picker = Ext.create('Ext.tree.Panel', {
			height : 200,
			autoScroll : true,
			floating : true,
			focusOnToFront : false,
			shadow : true,
			useArrows : true,
			store : store,
			rootVisible : false,
			listeners : {
				scope : this,
				itemclick : function(tree, record, item, index, e, eOpts) {
					this.ownerCt.form.findField('DEPARTMENT_ID').setValue(
							record.data.id)
					this.setValue(record.data.text);
					this.collapse();
				}
			}
		});
		return picker;
	},
	initComponent : function() {
		this.callParent();
	}
});