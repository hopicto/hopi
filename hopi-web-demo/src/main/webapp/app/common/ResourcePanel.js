Ext.define('Hopi.common.ResourcePanel', {
	extend : 'Ext.tree.Panel',
	title : '资源管理',
	baseUrl : 'resource.do?method=',
	nameSuffix : '资源',
	collapsible : true,
	loadMask : true,
	useArrows : true,
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
						handler : treePanel.createData,
						scope : treePanel
					} ]
				})
			} else {
				contextmenu = Ext.create('Ext.menu.Menu', {
					items : [ {
						text : '新增资源',
						iconCls : 'icon-create',
						handler : treePanel.createData,
						scope : treePanel
					}, {
						text : '修改资源',
						iconCls : 'icon-edit',
						handler : treePanel.modifyData,
						scope : treePanel
					}, {
						text : '删除资源',
						iconCls : 'icon-delete',
						handler : treePanel.deleteData,
						scope : treePanel
					} ]
				})
			}
			contextmenu.showAt(e.getXY());
		},
		scope : this
	},
	reloadData:function(){
		this.store.getRootNode().removeAll();
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
				allowBlank : false
			} ]
		});
		return fp;
	},
	createData : function() {
		this.showWin('新增' + this.nameSuffix);
		this.win.fp.form.findField('PARENT_ID').setValue(this.selectNode.id);
		this.win.fp.form.findField('PARENT_NAME')
				.setValue(this.selectNode.name);
	},
	modifyData : function() {
		this.showWin('修改' + this.nameSuffix);
		this.win.fp.form.load( {
			url : this.baseUrl + 'edit',
			params : {
				id : this.selectNode.id
			},
			waitMsg : 'Loading'
		});
	},
	deleteData : function() {
		var m = Ext.MessageBox.confirm('删除提示', '是否真的要删除数据？', function(ret) {
			if (ret == 'yes') {
				Ext.Ajax.request( {
					url : this.baseUrl + 'delete',
					params : {
						'id' : this.selectNode.id
					},
					method : 'POST',
					success : function(response) {
						var r = Ext.decode(response.responseText);
						if (!r.success)
							Ext.Msg.alert('提示信息',
									'数据删除失败，由以下原因所致：<br/>' + (r.msg ? r.msg
											: '未知原因'));
						else {
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
			fields : [ 'id', 'text', 'code', 'seq', 'leaf' ],
			autoLoad : true,
			lazyFill : true
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
