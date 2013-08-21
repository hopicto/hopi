/**
 * 部门
 */
Ext.define('Hopi.common.DepartmentCombo', {
	extend : 'Ext.form.field.Picker',
	fieldLabel : '部门',
	name : 'DEPARTMENT_NAME',	
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
//					console.log(record.data.id);
//					console.log(record.data.text);
					
					this.setRawValue(record.data.id);
//					this.setValue(record.data.text);		
//					console.log(this.getRawValue());
//					console.log(this.getValue());
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