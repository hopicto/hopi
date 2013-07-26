Ext.define('Ado.rup.DmTableSpacePanel', {
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
		flex : 1,
		sortable : true,
		dataIndex : 'NAME'
	}, {
		header : '编码',
		dataIndex : 'CODE'
	}, {
		header : '类型',
		dataIndex : 'TYPE_NAME'
	}, {
		header : '路径',
		dataIndex : 'PATH'
	}, {
		header : '初始大小',
		dataIndex : 'INIT_SIZE'
	}, {
		header : '递增大小',
		dataIndex : 'NEXT_SIZE'
	}, {
		header : '最大值',
		dataIndex : 'MAX_SIZE'
	}, {
		header : '开始',
		dataIndex : 'BEGIN'
	}, {
		header : '结束',
		dataIndex : 'END'
	}, {
		header : '步长',
		dataIndex : 'STEP'
	} ],
	loadMask : {
		msg : '数据加载中，请稍等...'
	},
	saveTableSpace : function() {
		if (this.tableSpaceForm.getForm().isValid()) {
			this.tableSpaceForm.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.baseUrl + 'save',
				method : 'POST',
				success : function() {
					this.closeTableSpace();
					this.store.load();
				},
				failure : function(form, action) {
					Ext.Msg.alert('保存失败：', action.result.errors.msg);
				},
				scope : this
			});
		}
	},
	closeTableSpace : function() {
		if (this.tableSpaceWin)
			this.tableSpaceWin.close();
		this.tableSpaceWin = null;
		this.tableSpaceForm = null;
	},
	resetTableSpace : function() {
		if (this.tableSpaceWin)
			this.tableSpaceForm.getForm().reset();
	},
	editTableSpace : function() {
		var rs = this.selModel.selected;
		if (rs.length == 0) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		} else if (rs.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else {
			this.createTableSpaceWin('修改表空间');
			this.tableSpaceForm.getForm().load( {
				url : this.baseUrl + 'edit',
				params : {
					id : rs.get(0).get(this.idProperty)
				},
				waitMsg : '数据加载中，请稍等...',
				failure : function(form, action) {
					Ext.Msg.alert('编辑失败：', action.result.errors.msg);
					this.closeTableSpace();
				},
				scope : this
			})
		}
	},
	createTableSpaceWin : function(title) {
		if (!this.tableSpaceWin) {
			if (!this.tableSpaceForm) {
				var dbId = this.dbCombo.getValue();
				var tableSpaceTypeStore = Ext.create('Ext.data.Store', {
					idProperty : 'ID',
					fields : [ 'ID', 'ITEM' ],
					autoLoad : true,
					proxy : {
						type : 'ajax',
						url : 'dictType.do?method=dictTypeItemCombo',
						extraParams : {
							code : 'TABLE_SPACE_TYPE'
						},
						reader : {
							type : 'json',
							root : 'data'
						}
					}
				});

				var tableSpaceTypeCombo = Ext.create('Ext.form.field.ComboBox',
						{
							store : tableSpaceTypeStore,
							name : 'TYPE',
							displayField : 'ITEM',
							fieldLabel : '分区类型',
							labelWidth : 80,
							labelAlign : 'right',
							editable : false,
							width : 320,
							valueField : 'ID',
							queryMode : 'remote',
							forceSelection : true,
							allowBlank : false
						});

				this.tableSpaceForm = Ext.create('Ext.form.Panel', {
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
					}, tableSpaceTypeCombo, {
						fieldLabel : '代码前缀',
						name : 'CODE',
						allowBlank : false
					}, {
						fieldLabel : '路径',
						name : 'PATH',
						allowBlank : false
					}, {
						fieldLabel : '初始大小',
						name : 'INIT_SIZE',
						allowBlank : false,
						value : '20M'
					}, {
						fieldLabel : '递增大小',
						name : 'NEXT_SIZE',
						allowBlank : false,
						value : '10M'
					}, {
						fieldLabel : '最大值',
						name : 'MAX_SIZE',
						allowBlank : false,
						value : '2048M'
					}, {
						fieldLabel : '开始',
						name : 'BEGIN',
						allowBlank : false
					}, {
						fieldLabel : '结束',
						name : 'END',
						allowBlank : false
					}, {
						fieldLabel : '步长',
						name : 'STEP',
						allowBlank : false
					} ]
				});
			}
			this.tableSpaceWin = Ext.create('Ext.window.Window', {
				autoHeight : true,
				width : 360,
				buttonAlign : 'center',
				plain : true,
				modal : true,
				shadow : true,
				border : false,
				maximizable : true,
				closeAction : 'hide',
				items : [ this.tableSpaceForm ],
				buttons : [ {
					text : '保存',
					handler : this.saveTableSpace,
					scope : this
				}, {
					text : '清空',
					handler : this.resetTableSpace,
					scope : this
				} ]
			});
			this.tableSpaceWin.on('close', function() {
				this.tableSpaceWin = null;
				this.tableSpaceForm = null;
			}, this);
		}
		this.tableSpaceWin.title = title;
		this.tableSpaceWin.show();
	},
	createTableSpace : function() {
		this.createTableSpaceWin('新增表空间');
		this.tableSpaceForm.getForm().reset();
		this.tableSpaceForm.getForm().findField('DB_ID').setValue(
				this.dbCombo.getValue());
	},
	removeTableSpace : function() {
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
	refreshTableSpace : function() {
		this.store.load();
	},
	genData : function() {
		var id = this.dbCombo.getValue();
		openTab( {
			type : 'TAB_DM_TABLESPACE',
			id : id,
			title : '表空间生成脚本',
			code : 'Ado.jcpt.CommonViewPanel'
		}, {
			url : this.baseUrl + 'genSql&id=' + id
		});
	},
	initComponent : function() {
		this.baseUrl = 'dmTableSpace.do?method=';
		this.databaseBaseUrl = 'dmDataBase.do?method=';
		this.store = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			fields : [ 'ID', 'NAME', 'CODE', 'TYPE_NAME', 'PATH', 'INIT_SIZE',
					'NEXT_SIZE', 'MAX_SIZE', 'BEGIN', 'END', 'STEP' ],
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
			handler : this.createTableSpace,
			iconCls : 'icon-add',
			scope : this
		}, '-', {
			text : '修改',
			handler : this.editTableSpace,
			iconCls : 'icon-edit',
			scope : this
		}, '-', {
			text : '删除',
			handler : this.removeTableSpace,
			iconCls : 'icon-delete',
			scope : this
		}, '-', {
			text : '生成',
			handler : this.genData,
			iconCls : 'icon-add',
			scope : this
		}, '-', {
			text : '刷新',
			handler : this.refreshTableSpace,
			iconCls : 'icon-refresh',
			scope : this
		} ];
		this.callParent();
	}
});