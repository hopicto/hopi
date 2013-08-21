Ext.define('Hopi.common.DepartmentPanel', {
	extend : 'Ext.tree.Panel',
	title : '部门管理',
	baseUrl : 'department.do?method=',
	nameSuffix : '部门',
	collapsible : true,
	loadMask : true,
	useArrows : true,
	columnLines : true,
	rowLines : true,
	rootVisible : false,
	animate : false,	
	listeners : {
		itemcontextmenu : function(dataView, record, node, index, e, eopts) {
			e.stopEvent();
			var treePanel = dataView.ownerCt;
			treePanel.selectNode = {
				id : record.data.id,
				name : record.data.text
			};
			var contextmenu;
			if (record.data.id == '1') {
				contextmenu = Ext.create('Ext.menu.Menu', {
					items : [ {
						text : '新增部门',
						iconCls : 'icon-create',
						handler : treePanel.createDepartment,
						scope : treePanel
					} ]
				})
			} else {
				contextmenu = Ext.create('Ext.menu.Menu', {
					items : [ {
						text : '新增部门',
						iconCls : 'icon-create',
						handler : treePanel.createDepartment,
						scope : treePanel
					}, {
						text : '修改部门',
						iconCls : 'icon-edit',
						handler : treePanel.modifyDepartment,
						scope : treePanel
					}, {
						text : '删除部门',
						iconCls : 'icon-delete',
						handler : treePanel.deleteDepartment,
						scope : treePanel
					} ]
				})
			}
			contextmenu.showAt(e.getXY());
		},		
		scope : this
	},
	reloadData : function() {
//		this.store.getRootNode().removeAll();
		this.store.load();
//		this.getStore.load();
	},
	showWin : function(title) {
		this.win = Ext.create('Hopi.common.PopupFormWindow', {
			mainPanel : this,
			width : 320,
			title : title
		});
		this.win.show();
	},
	createForm : function() {
		var iconClassCombo = Ext.create('Hopi.common.IconClassCombo', {
			name : 'ICON_CLASS'
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
				name : 'PARENT_ID',
				xtype : 'hidden'
			}, {
				fieldLabel : '上级部门',
				name : 'PARENT_NAME',
				xtype : 'displayfield'
			}, {
				fieldLabel : '名称',
				name : 'NAME',
				allowBlank : false
			}, {
				fieldLabel : '编码',
				name : 'CODE',
				allowBlank : false
			}, {
				fieldLabel : '序号',
				name : 'SEQ',
				xtype: 'numberfield',
				allowBlank : false
			}, iconClassCombo ]
		});
		return fp;
	},
	createDepartment : function() {
		this.showWin('新增' + this.nameSuffix);
		this.win.fp.form.findField('PARENT_ID').setValue(this.selectNode.id);
		this.win.fp.form.findField('PARENT_NAME')
				.setValue(this.selectNode.name);
	},
	modifyDepartment : function() {
		this.showWin('修改' + this.nameSuffix);
		this.win.fp.form.load( {
			url : this.baseUrl + 'edit',
			params : {
				id : this.selectNode.id
			},
			waitMsg : 'Loading'
		});
	},
	deleteDepartment : function() {
		var m = Ext.MessageBox.confirm('删除提示', '是否真的要删除数据？', function(ret) {
			if (ret == 'yes') {
				Ext.Ajax.request( {
					url : this.baseUrl + 'delete',
					params : {
						'id' : this.selectNode.id
					},
					method : 'POST',
					success : function(response) {
						var obj = Ext.decode(response.responseText);
						if (!obj.success) {
							Ext.Msg.alert('操作失败：', obj.msg);
						} else {
							this.reloadData();
						}
					},
					scope : this
				});
			}
		}, this);
	},
	initComponent : function() {
		this.store = Ext.create('Ext.data.TreeStore', {
			proxy : {
				type : 'ajax',
				reader : 'json',
				url : this.baseUrl + 'tree'
			},
			fields : [ 'id', 'text', 'code', 'seq', 'leaf', 'expanded' ],
			clearOnLoad:true,
			autoLoad : true
		});
		this.columns = [ {
			xtype : 'treecolumn',
			text : '名称',
			flex : 2.5,
			sortable : true,
			dataIndex : 'text'
		}, {
			text : '编码',
			flex : 1,
			dataIndex : 'code',
			sortable : true
		}, {
			text : '序号',
			flex : 1,
			dataIndex : 'seq'
		} ];
		this.callParent();
	}
});
