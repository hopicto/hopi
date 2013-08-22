Ext.define('Hopi.common.PositionPanel',
		{
			extend : 'Hopi.common.CrudMainPanel',
			title : '岗位管理',
			baseUrl : 'position.do?method=',
			nameSuffix : '岗位',
			storeMapping : [ 'ID', 'NAME', 'CODE', 'DEPARTMENT_ID',
					'DEPARTMENT_NAME' ],
			columns : [ {
				xtype : 'rownumberer'
			}, {
				header : '部门名称',
				sortable : true,
				dataIndex : 'DEPARTMENT_NAME'
			}, {
				header : '岗位名称',
				sortable : true,
				dataIndex : 'NAME'
			}, {
				header : '编码',
				sortable : true,
				dataIndex : 'CODE'
			} ],
			createForm : function() {
				var departmentCombo = Ext.create('Hopi.common.DepartmentCombo',
						{
							name : 'DEPARTMENT_NAME'
						});
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
						name : 'DEPARTMENT_ID',
						xtype : 'hidden'
					}, departmentCombo, {
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
				this.highQueryForm = Ext.create(
						'Hopi.common.CrudHighQueryForm', {
							crudMainPanel : this,
							items : [
									Ext.create('Hopi.common.DepartmentCombo', {
										name : 'DEPARTMENT_NAME'
									}), {
										name : 'DEPARTMENT_ID',
										xtype : 'hidden'
									}, {
										fieldLabel : '名称',
										name : 'NAME'
									}, {
										fieldLabel : '编码',
										name : 'CODE'
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