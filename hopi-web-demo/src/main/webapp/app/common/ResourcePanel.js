Ext.define('Hopi.common.ResourcePanel', {
	extend : 'Ext.tree.Panel',
	title : '资源管理',
	baseUrl : 'resource.do?method=',
	nameSuffix : '资源',
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
						text : '新增资源',
						iconCls : 'icon-create',
						handler : treePanel.createResource,
						scope : treePanel
					} ]
				})
			} else {
				contextmenu = Ext.create('Ext.menu.Menu', {
					items : [ {
						text : '新增资源',
						iconCls : 'icon-create',
						handler : treePanel.createResource,
						scope : treePanel
					}, {
						text : '修改资源',
						iconCls : 'icon-edit',
						handler : treePanel.modifyResource,
						scope : treePanel
					}, {
						text : '删除资源',
						iconCls : 'icon-delete',
						handler : treePanel.deleteResource,
						scope : treePanel
					} ]
				})
			}
			contextmenu.showAt(e.getXY());
		},		
		scope : this
	},
	reloadData : function() {
		this.store.load();
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
				name : 'PARENT_ID',
				xtype : 'hidden'
			}, {
				fieldLabel : '上级资源',
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
	createResource : function() {
		this.showWin('新增' + this.nameSuffix);
		this.win.fp.form.findField('PARENT_ID').setValue(this.selectNode.id);
		this.win.fp.form.findField('PARENT_NAME')
				.setValue(this.selectNode.name);
	},
	modifyResource : function() {
		this.showWin('修改' + this.nameSuffix);
		this.win.fp.form.load( {
			url : this.baseUrl + 'edit',
			params : {
				id : this.selectNode.id
			},
			waitMsg : 'Loading'
		});
	},
	deleteResource : function() {
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