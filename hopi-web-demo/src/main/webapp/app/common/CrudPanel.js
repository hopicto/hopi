/**
 * 增删改查面板
 */
Ext.define('Hopi.common.CrudPanel', {
	extend : 'Ext.grid.GridPanel',
	autoEl : true,
	closable : true,
	autoScroll : true,
	border : false,
	forceFit : true,
	idProperty : 'ID',
	stripeRows : true,
	columnLines : true,
	multiSelect : true,
	selModel : {
		selType : 'checkboxmodel'
	},
	refresh : function() {
		this.store.removeAll();
		this.store.reload();
	},
	initWin : function(width) {
		var win = new Ext.Window( {
			autoHeight : true,
			width : width,
			buttonAlign : 'center',
			plain : true,
			modal : true,
			shadow : true,
			border : false,
			maximizable : true,
			closeAction : 'hide',
			items : [ this.fp ],
			buttons : [ {
				text : '保存',
				handler : this.save,
				scope : this
			}, {
				text : '清空',
				handler : this.reset,
				scope : this
			}, {
				text : '取消',
				handler : this.closeWin,
				scope : this
			} ]
		});
		return win;
	},
	showWin : function(title) {
		if (!this.win) {
			if (!this.fp) {
				this.fp = this.createForm();
			}
			this.win = this.createWin();
			this.win.on('close', function() {
				this.win = null;
				this.fp = null;
			}, this);
		}
		this.win.title = title;
		this.win.show();
	},
	create : function() {
		this.showWin('新增' + this.nameSuffix);
		this.reset();
	},
	save : function() {
		if (this.fp.getForm().isValid()) {
			this.fp.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.baseUrl + 'save',
				method : 'POST',
				success : function() {
					this.closeWin();
					this.store.reload();
				},
				failure : function(form, action) {
					obj = Ext.util.JSON.decode(action.response.responseText);
					Ext.Msg.alert('保存失败：', obj.msg);
				},
				scope : this
			});
		}
	},
	reset : function() {
		if (this.win)
			this.fp.form.reset();
	},
	closeWin : function() {
		if (this.win)
			this.win.close();
		this.win = null;
		this.fp = null;
	},
	edit : function() {
		var records = this.getSelectionModel().getSelection();
		if (records.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		}
		this.showWin('修改' + this.nameSuffix);
		this.fp.form.load( {
			url : this.baseUrl + 'edit',
			params : {
				id : records[0].get(this.idProperty)
			},
			waitMsg : '数据加载中，请稍等...',
			failure : function(form, action) {
				Ext.Msg.alert('编辑失败：', action.result.msg);
				this.closeWin();
			},
			scope : this
		})
	},
	removeData : function() {
		var records = this.getSelectionModel().getSelection();
		if (records.length < 1) {
			Ext.Msg.alert('提示', '请先选择要删除的行!');
			return;
		}
		var ids = '';
		for ( var i = 0; i < records.length; i++) {
			if (i > 0) {
				ids = ids + ',' + records[i].get(this.idProperty);
			} else {
				ids = records[i].get(this.idProperty);
			}
		}
		var m = Ext.MessageBox.confirm('删除提示', '是否真的要删除数据？', function(ret) {
			if (ret == 'yes') {
				Ext.Ajax.request( {
					url : this.baseUrl + 'delete',
					params : {
						'id' : ids
					},
					method : 'POST',
					success : function(response) {
						var r = Ext.decode(response.responseText);
						if (!r.success)
							Ext.Msg.alert('提示信息',
									'数据删除失败，由以下原因所致：<br/>' + (r.msg ? r.msg
											: '未知原因'));
						else {
							this.store.reload();
						}
					},
					scope : this
				});
			}
		}, this);
	},
	search : function() {
		var sv = this.searchField.getValue();
		this.store.on('beforeload', function() {
			this.baseParams = {
				sv : sv
			};
		}, this.store);
		this.store.load( {
			params : {
				start : 0,
				sv : sv
			}
		});
	},
	switchHighSearch : function() {
		if (this.queryForm.hidden) {
			this.highSearchButton.setText('隐藏查询');
			this.queryForm.show();
			this.syncFx();
		} else {
			this.highSearchButton.setText('高级查询');
			this.queryForm.hide();
			this.syncFx();
		}
	},
	highSearch : function() {
		var fieldValues = this.queryForm.form.getFieldValues();
		var baseParams = {};
		var loadParams = {
			start : 0
		};
		Object.getOwnPropertyNames(fieldValues).forEach(
				function(val, idx, array) {
					baseParams['HS_' + val] = fieldValues[val];
				});
		Ext.apply(loadParams, baseParams);
		this.store.on('beforeload', function() {
			this.baseParams = baseParams;
		}, this.store);
		this.store.load( {
			params : loadParams
		});
	},
	highSearchReset : function() {
		this.queryForm.form.reset();
	},
	initComponent : function() {
		this.store = new Ext.data.JsonStore( {
			proxy : {
				type : 'ajax',
				url : this.baseUrl + 'query',
				reader : {
					type : 'json',
					root : 'list',
					idProperty : this.idProperty || 'id',
					totalProperty : 'totalCount'
				}
			},
			autoLoad : true,
			pageSize : 20,
			remoteSort : true,
			baseParams : this.baseParams,
			fields : this.storeMapping
		});
		this.dockedItems = [ {
			xtype : 'pagingtoolbar',
			store : this.store,
			dock : 'bottom',
			displayInfo : true
		} ];

		this.highSearchButton = Ext.create('Ext.Button', {
			text : '高级查询',
			handler : this.switchHighSearch,
			iconCls : 'icon-search',
			scope : this
		});

		this.searchField = Ext.create('Ext.form.field.Text', {
			name : 'searchField',
			hideLabel : true,
			width : 250
		});
		this.queryForm.add( {
			xtype : 'container',
			layout : 'anchor',
			defaults : {
				anchor : '50%',
				margin : 5
			},
			items : [ {
				xtype : 'button',
				text : '查询',
				handler : this.highSearch,
				scope : this
			}, {
				xtype : 'button',
				text : '清空',
				handler : this.highSearchReset,
				scope : this
			} ]
		});
		this.tbar = Ext.create("Ext.Toolbar", {
			xtype : 'container',
			layout : 'anchor',
			defaults : {
				anchor : '0'
			},
			defaultType : 'toolbar',
			items : [ {
				items : [ {
					text : '新增',
					handler : this.create,
					iconCls : 'icon-add',
					scope : this
				}, '-', {
					text : '修改',
					handler : this.edit,
					iconCls : 'icon-edit',
					scope : this
				}, '-', {
					text : '删除',
					handler : this.removeData,
					iconCls : 'icon-delete',
					scope : this
				}, '-', {
					text : '刷新',
					handler : this.refresh,
					iconCls : 'icon-refresh',
					scope : this
				}, '->', this.searchField, '-', {
					text : '查询',
					handler : this.search,
					iconCls : 'icon-search',
					scope : this
				}, '-', this.highSearchButton ]
			}, this.queryForm ]
		});
		this.callParent();
	}
});