Ext.define('Hopi.common.StaffPanel', {
	extend : 'Hopi.common.CrudMainPanel',
	title : '人员管理',
	baseUrl : 'staff.do?method=',
	nameSuffix : '人员',
	storeMapping : [ 'ID', 'LOGIN_NAME', 'NAME', 'EMAIL', 'PHONE', 'MOBILE',
			'DEPARTMENT_ID', 'DEPARTMENT_NAME' ],
	columns : [ {
		xtype : 'rownumberer'
	}, {
		header : '部门名称',
		sortable : true,
		dataIndex : 'DEPARTMENT_NAME'
	}, {
		header : '登录名',
		sortable : true,
		dataIndex : 'LOGIN_NAME'
	}, {
		header : '姓名',
		sortable : true,
		dataIndex : 'NAME'
	}, {
		header : '邮箱',
		sortable : true,
		dataIndex : 'EMAIL'
	}, {
		header : '电话',
		sortable : true,
		dataIndex : 'PHONE'
	}, {
		header : '手机',
		sortable : true,
		dataIndex : 'MOBILE'
	} ],
	createForm : function() {
		var departmentCombo = Ext.create('Hopi.common.DepartmentCombo', {
			name : 'DEPARTMENT_NAME',
			labelWidth : 80
		});
		var fp = Ext.create('Ext.form.FormPanel', {
			frame : true,
			labelWidth : 80,
			labelAlign : 'right',
			border : false,
			method : 'post',
			defaultType : 'textfield',
			layout : 'anchor',
			defaults : {
				anchor : '100%'
			},
			items : [ {
				name : '_EDIT_TAG',
				xtype : 'hidden'
			}, {
				name : 'ID',
				xtype : 'hidden'
			}, {
				name : 'DEPARTMENT_ID',
				xtype : 'hidden'
			}, departmentCombo, {
				fieldLabel : '登录名',
				name : 'LOGIN_NAME',
				allowBlank : false
			}, {
				fieldLabel : '姓名',
				name : 'NAME',
				allowBlank : false
			}, {
				fieldLabel : '邮箱',
				name : 'EMAIL',
				allowBlank : false
			}, {
				fieldLabel : '电话',
				name : 'PHONE',
				allowBlank : false
			}, {
				fieldLabel : '手机',
				name : 'MOBILE',
				allowBlank : false
			} ]
		});
		return fp;
	},
	initComponent : function() {
		this.highQueryForm = Ext.create('Hopi.common.CrudHighQueryForm', {
			crudMainPanel : this,
			items : [ Ext.create('Hopi.common.DepartmentCombo', {
				name : 'DEPARTMENT_NAME'
			}), {
				name : 'DEPARTMENT_ID',
				xtype : 'hidden'
			}, {
				fieldLabel : '姓名',
				name : 'NAME'
			}, {
				fieldLabel : '邮箱',
				name : 'EMAIL'
			}, {
				fieldLabel : '电话',
				name : 'PHONE'
			}, {
				fieldLabel : '手机',
				name : 'MOBILE'
			} ]
		});
		this.dataFormSetting = {
			type : 1,
			width : 300
		};
		this.toolBar = Ext.create("Hopi.common.CrudToolBar", {
			crudMainPanel : this,
			items : []
		});
		this.callParent();
	}
});