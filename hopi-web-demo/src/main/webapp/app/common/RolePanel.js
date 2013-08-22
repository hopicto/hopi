Ext.define('Hopi.common.RolePanel', {
	extend : 'Hopi.common.CrudMainPanel',
	title : '角色管理',
	baseUrl : 'role.do?method=',
	nameSuffix : '角色',
	storeMapping : [ 'ID', 'NAME', 'CODE' ],
	columns : [ {
		xtype : 'rownumberer'
	}, {
		header : '名称',
		sortable : true,
		dataIndex : 'NAME'
	}, {
		header : '编码',
		sortable : true,
		dataIndex : 'CODE'
	} ],
	createForm : function() {
		var fp = Ext.create('Ext.form.FormPanel', {
			frame : true,
			border : false,
			method : 'post',			
			layout : 'anchor',
			defaults : {
				xtype:'textfield',
				anchor : '100%',
				labelWidth : 80,
				labelAlign : 'right'
			},
			items : [ {
				name : '_EDIT_TAG',
				xtype : 'hidden'
			}, {
				name : 'ID',
				xtype : 'hidden'
			}, {
				fieldLabel : '名称',
				name : 'NAME',
				allowBlank : false
			}, {
				fieldLabel : '编码',
				name : 'CODE',
				allowBlank : false
			} ]
		});
		return fp;
	},
	initComponent : function() {
		this.highQueryForm = Ext.create('Hopi.common.CrudHighQueryForm', {
			crudMainPanel : this,
			items : [ {
				fieldLabel : '名称',
				name : 'NAME'
			}, {
				fieldLabel : '编码',
				name : 'CODE'
			} ]
		});
		this.dataFormSetting = {
			type : 1,
			width : 360
		};
		this.toolBar = Ext.create("Hopi.common.CrudToolBar", {
			crudMainPanel : this,
			items : []
		});
		this.callParent();
	}
});