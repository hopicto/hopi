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
							fp : fp
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
							items : [ {
								fieldLabel : '名称',
								name : 'NAME'
							}, {
								fieldLabel : '编码',
								name : 'CODE'
							}, {
								fieldLabel : '图标名称',
								name : 'ICON_NAME'
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