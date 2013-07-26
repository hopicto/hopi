Ext.define('Ado.xr.XrModuleGridPanel', {
	extend : 'Ext.grid.Panel',	
	autoScroll : true,
	border : false,
	idProperty : 'ID',
	baseUrl : 'xrModule.do?method=',
	nameSuffix : '模块',
	columnLines : true,
	enableColumnMove : true,
	storeMapping : [ 'ID', 'NAME', 'CODE','WIDTH','HEIGHT', 'DESCRIPTION' ],
	viewConfig : {
		stripeRows : true
	},
	selType : 'checkboxmodel',
	multiSelect : true,
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
	}, {
		header : '说明',
		flex : 1,
		dataIndex : 'DESCRIPTION'
	} ],
	loadMask : {
		msg : '数据加载中，请稍等...'
	},
	refresh : function() {
		this.store.removeAll();
		this.store.load();
	},
	createForm : function() {
		var formPanel = new Ext.form.FormPanel( {
			frame : true,
			border : false,
			method : 'post',
			defaultType : 'textfield',
			defaults : {
				labelWidth : 60,
				labelAlign : 'right',
				width : 320
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
			},  {
				fieldLabel : '宽度',
				name : 'WIDTH',
				allowBlank : false
			}, {
				fieldLabel : '高度',
				name : 'HEIGHT',
				allowBlank : false
			},{
				xtype : 'filefield',
				name : 'VIEW_IMG',
				fieldLabel : '视图',
				buttonText : '选择图片'
			}, {
				fieldLabel : '描述',
				name : 'DESCRIPTION',
				xtype : 'textarea',
				width : 320,
				height : 60
			} ]
		});
		return formPanel;
	},
	createWin : function() {
		return this.initWin(360);
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
		} ];
		this.callParent();
		this.store.load();
	}
});