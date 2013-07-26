Ext.define('Ado.rup.DmSyncWorkPanel', {
	extend : 'Ext.grid.Panel',
	closable : true,
	autoScroll : true,
	border : false,
	idProperty : 'ID',
	baseUrl : 'dmSyncWork.do?method=',
	nameSuffix : '同步工作',
	columnLines : true,
	enableColumnMove : false,
	storeMapping : [ 'ID', 'NAME', 'TYPE_NAME', 'STATUS_NAME',
			'DEST_TABLE_NAME', 'SYNC_TAG', 'BEGIN_DATE','PRIORITY' ],
	viewConfig : {
		stripeRows : true
	},
	selType : 'checkboxmodel',
	multiSelect : true,
	columns : [ {
		xtype : 'rownumberer'
	}, {
		header : '数据源',
		dataIndex : 'TYPE_NAME'
	}, {
		header : '名称',
		sortable : true,
		dataIndex : 'NAME'
	}, {
		header : '状态',
		dataIndex : 'STATUS_NAME'
	}, {
		header : '目标表',
		dataIndex : 'DEST_TABLE_NAME'
	}, {
		header : '优先级',
		dataIndex : 'PRIORITY'
	},{
		header : '同步标识',
		dataIndex : 'SYNC_TAG'
	}, {
		header : '起始日期',
		dataIndex : 'BEGIN_DATE'
	} ],
	loadMask : {
		msg : '数据加载中，请稍等...'
	},
	refresh : function() {
		this.store.removeAll();
		this.store.load();
	},
	createForm : function() {
		var syncWorkTypeStore = Ext.create('Ext.data.Store', {
			idProperty : 'ID',
			fields : [ 'ID', 'ITEM' ],
			autoLoad : true,
			proxy : {
				type : 'ajax',
				url : 'dictType.do?method=dictTypeItemCombo',
				extraParams : {
					code : 'DM_SYNC_WORK_TYPE'
				},
				reader : {
					type : 'json',
					root : 'data'
				}
			}
		});

		var syncWorkTypeCombo = Ext.create('Ext.form.field.ComboBox', {
			store : syncWorkTypeStore,
			name : 'TYPE',
			displayField : 'ITEM',
			fieldLabel : '同步数据来源',
			labelAlign : 'right',
			labelWidth : 80,
			edicomp : false,
			width : 400,
			valueField : 'ID',
			queryMode : 'remote',
			forceSelection : true,
			allowBlank : false
		});

		var destTableComboStore = Ext.create('Ext.data.Store', {
			idProperty : 'ID',
			fields : [ 'ID', 'CODE' ],
			autoLoad : true,
			proxy : {
				type : 'ajax',
				url : 'dmTable.do?method=comboList',
				extraParams : {
					dbId : 2
				},
				reader : {
					type : 'json',
					root : 'data'
				}
			}
		});
		var destTableCombo = Ext.create('Ext.form.ComboBox', {
			fieldLabel : '目标表',
			labelWidth : 80,
			labelAlign : 'right',
			width : 400,
			name : 'DEST_TABLE',
			forceSelection : true,
			editable : false,
			store : destTableComboStore,
			queryMode : 'remote',
			displayField : 'CODE',
			valueField : 'ID'
		});
		var formPanel = new Ext.form.FormPanel( {
			frame : true,
			border : false,
			method : 'post',
			defaultType : 'textfield',
			defaults : {
				labelWidth : 80,
				labelAlign : 'right',
				width : 400
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
				fieldLabel : '同步标识',
				name : 'SYNC_TAG',
				allowBlank : false
			}, {
				fieldLabel : '开始日期',
				name : 'BEGIN_DATE',
				allowBlank : false
			}, {
				fieldLabel : '优先级',
				name : 'PRIORITY'
			}, syncWorkTypeCombo, destTableCombo, {
				fieldLabel : '查询语句',
				name : 'QUERY_SQL',
				xtype : 'textarea',
				width : 420,
				height : 120
			} ]
		});
		return formPanel;
	},
	createWin : function() {
		return this.initWin(480);
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
					this.store.load();
				},
				failure : function(form, action) {
					Ext.Msg.alert('保存失败：', action.result.errors.msg);
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
		var rs = this.selModel.selected;
		if (rs.length == 0) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		} else if (rs.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else {
			this.showWin('修改' + this.nameSuffix);
			this.fp.form.load( {
				url : this.baseUrl + 'edit',
				params : {
					id : rs.get(0).get(this.idProperty)
				},
				waitMsg : '数据加载中，请稍等...',
				failure : function(form, action) {
					Ext.Msg.alert('编辑失败：', action.result.errors.msg);
					this.closeWin();
				},
				scope : this
			})
		}
	},
	removeData : function() {
		var records = this.selModel.selected;
		if (records.length < 1) {
			Ext.Msg.alert('提示', '请先选择要删除的行!');
			return;
		}
		var ids = '';
		for ( var i = 0; i < records.length; i++) {
			if (i > 0) {
				ids = ids + ',' + records.get(i).get(this.idProperty);
			} else {
				ids = records.get(i).get(this.idProperty);
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
						if (!r.success) {
							Ext.Msg.alert('删除失败：', r.errors.msg);
						} else {
							this.store.load();
						}
					},
					scope : this
				});
			}
		}, this);
	},
	checkColumn : function() {

	},
	initComponent : function() {
		this.store = Ext.create('Ext.data.Store', {
			idProperty : this.idProperty || 'id',
			fields : this.storeMapping,
			proxy : {
				type : 'ajax',
				url : this.baseUrl + 'query',
				reader : {
					type : 'json',
					root : 'list'
				}
			}
		});
		this.bbar = Ext.create('Ext.toolbar.Paging', {
			pageSize : 25,
			store : this.store,
			displayInfo : true,
			beforePageText : '当前',
			afterPageText : '页/共{0}页',
			firstText : '首页',
			lastText : '末页',
			nextText : '下一页',
			prevText : '上一页',
			refreshText : '刷新',
			displayMsg : '当前显示 {0} - {1}条记录 /共 {2}条记录',
			emptyMsg : '未找到合适的记录！'
		});
		this.tbar = [ {
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
		}, '-', {
			text : '验证字段匹配',
			handler : this.checkColumn,
			iconCls : 'icon-check',
			scope : this
		} ];
		this.callParent();
		this.store.load();
	}
});