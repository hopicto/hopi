Ext.define('Ado.rup.DmQueryPanel', {
	extend : 'Ext.grid.Panel',
	autoEl : true,
	autoScroll : true,
	idProperty : 'ID',
	border : false,
	viewConfig : {
		stripeRows : true
	},
	selType:'checkboxmodel',
	multiSelect:true,
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
		header : '查询语句',
		dataIndex : 'QUERY_SQL'
	}, {
		header : '说明',
		flex : 1,
		dataIndex : 'DESCRIPTION'
	} ],
	loadMask : {
		msg : '数据加载中，请稍等...'
	},
	saveQuery : function() {
		if (this.queryForm.getForm().isValid()) {
			this.queryForm.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.baseUrl + 'save',
				method : 'POST',
				success : function() {
					this.closeQuery();
					this.store.load();
				},
				failure : function(form, action) {
					Ext.Msg.alert('保存失败：', action.result.errors.msg);
				},
				scope : this
			});
		}
	},
	closeQuery : function() {
		if (this.queryWin)
			this.queryWin.close();
		this.queryWin = null;
		this.queryForm = null;
	},
	resetQuery : function() {
		if (this.queryWin)
			this.queryForm.getForm().reset();
	},
	editQuery : function() {
		var rs = this.selModel.selected;
		if (rs.length == 0) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		} else if (rs.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else {
			this.createQueryWin('修改表空间');
			this.queryForm.getForm().load( {
				url : this.baseUrl + 'edit',
				params : {
					id : rs.get(0).get(this.idProperty)
				},
				waitMsg : '数据加载中，请稍等...',
				failure : function(form, action) {
					Ext.Msg.alert('编辑失败：', action.result.errors.msg);
					this.closeQuery();
				},
				scope : this
			})
		}
	},
	createQueryWin : function(title) {
		if (!this.queryWin) {
			if (!this.queryForm) {
				var dbId = this.dbCombo.getValue();
				this.queryForm = Ext.create('Ext.form.Panel', {
					frame : true,
					border : false,
					method : 'post',
					defaultType : 'textfield',
					defaults : {
						labelWidth : 80,
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
						name : 'DB_ID',
						xtype : 'hidden'
					}, {
						fieldLabel : '名称',
						name : 'NAME',
						allowBlank : false
					}, {
						fieldLabel : '编码',
						name : 'CODE',
						allowBlank : false
					}, {
						fieldLabel : '查询语句',
						name : 'QUERY_SQL',
						xtype : 'textarea',
						width : 320,
						height : 60
					}, {
						fieldLabel : '描述',
						name : 'DESCRIPTION',
						xtype : 'textarea',
						width : 320,
						height : 60
					} ]
				});
			}
			this.queryWin = Ext.create('Ext.window.Window', {
				autoHeight : true,
				width : 360,
				buttonAlign : 'center',
				plain : true,
				modal : true,
				shadow : true,
				border : false,
				maximizable : true,
				closeAction : 'hide',
				items : [ this.queryForm ],
				buttons : [ {
					text : '保存',
					handler : this.saveQuery,
					scope : this
				}, {
					text : '清空',
					handler : this.resetQuery,
					scope : this
				} ]
			});
			this.queryWin.on('close', function() {
				this.queryWin = null;
				this.queryForm = null;
			}, this);
		}
		this.queryWin.title = title;
		this.queryWin.show();
	},
	createQuery : function() {
		this.createQueryWin('新增表查询');
		this.queryForm.getForm().reset();
		this.queryForm.getForm().findField('DB_ID').setValue(
				this.dbCombo.getValue());
	},
	removeQuery : function() {
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
	refreshQuery : function() {
		this.store.load();
	},
	editQuerySql : function() {
		var rs = this.selModel.selected;
		if (rs.length == 0) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		} else if (rs.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else {
			openTab( {
				type : 'TAB_QUERYSET_',
				id : rs.get(0).get(this.idProperty),
				title : '编辑SQL:' + rs.get(0).get('NAME'),
				code : 'Ado.rup.DmQuerySetPanel'
			}, {
				dbId : this.dbCombo.getValue(),
				dbName : this.dbCombo.getRawValue()
			});
		}

	},
	initComponent : function() {
		this.baseUrl = 'dmQuery.do?method=';
		this.databaseBaseUrl = 'dmDataBase.do?method=';
		this.store = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			fields : [ 'ID', 'NAME', 'CODE', 'QUERY_SQL', 'DESCRIPTION' ],
			proxy : {
				type : 'ajax',
				url : this.baseUrl + 'query',
				reader : {
					type : 'json',
					totalProperty : 'totalCount',
					root : 'list'
				}
			}
		});
		this.dbComboLoaded = false;
		this.dbComboStore = Ext.create('Ext.data.Store', {
			idProperty : 'ID',
			fields : [ 'ID', 'NAME' ],
			autoLoad : true,
			listeners : {
				scope : this,
				load : function(store, records, success) {
					if (!this.dbComboLoaded && success && records.length > 0) {
						var dbId = records[0].get('ID');
						this.dbCombo.select(dbId);
						this.dbComboLoaded = true;
					}
				}
			},
			proxy : {
				type : 'ajax',
				url : this.databaseBaseUrl + 'comboList',
				reader : {
					type : 'json',
					root : 'data'
				}
			}
		});
		this.dbCombo = Ext.create('Ext.form.ComboBox', {
			fieldLabel : '数据库',
			labelWidth : 48,
			forceSelection : true,
			editable : false,
			store : this.dbComboStore,
			queryMode : 'remote',
			displayField : 'NAME',
			valueField : 'ID',
			listeners : {
				scope : this,
				change : function(f, n, o) {
					this.store.proxy.extraParams = {
						dbId : n
					};
					this.store.load( {
						params : {
							start : 0
						}
					});
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

		this.tbar = [ this.dbCombo, '-', {
			text : '新增',
			handler : this.createQuery,
			iconCls : 'icon-add',
			scope : this
		}, '-', {
			text : '修改',
			handler : this.editQuery,
			iconCls : 'icon-edit',
			scope : this
		}, '-', {
			text : '编辑SQL',
			handler : this.editQuerySql,
			iconCls : 'icon-edit',
			scope : this
		}, '-', {
			text : '删除',
			handler : this.removeQuery,
			iconCls : 'icon-delete',
			scope : this
		}, '-', {
			text : '刷新',
			handler : this.refreshQuery,
			iconCls : 'icon-refresh',
			scope : this
		} ];
		this.callParent();
	}
});