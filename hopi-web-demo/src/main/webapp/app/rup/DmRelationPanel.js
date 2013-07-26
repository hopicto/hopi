Ext.define('Ado.rup.DmRelationPanel', {
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
		header : '表名',
		dataIndex : 'TB_NAME'
	}, {
		header : '表属性',
		dataIndex : 'PROPERTY_NAME'
	}, {
		header : '关联表',
		dataIndex : 'REF_TB_NAME'
	}, {
		header : '关联表属性',
		dataIndex : 'REF_PROPERTY_NAME'
	}, {
		header : '级联操作',
		dataIndex : 'RELATION_TYPE_NAME'
	} ],
	loadMask : {
		msg : '数据加载中，请稍等...'
	},

	saveRelation : function() {
		if (this.relationForm.getForm().isValid()) {
			this.relationForm.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.baseUrl + 'save',
				method : 'POST',
				success : function() {
					this.closeRelation();
					this.store.load();
				},
				failure : function(form, action) {
					Ext.Msg.alert('保存失败：', action.result.errors.msg);
				},
				scope : this
			});
		}
	},
	closeRelation : function() {
		if (this.relationWin)
			this.relationWin.close();
		this.relationWin = null;
		this.relationForm = null;
	},
	resetRelation : function() {
		if (this.relationWin)
			this.relationForm.getForm().reset();
	},
	editRelation : function() {
		var rs = this.selModel.selected;
		console.log(rs.get(0).get(this.idProperty));
		if (rs.length == 0) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		} else if (rs.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else {
			this.createRelationWin('修改表关联');

			Ext.Msg.alert('提示', rs.get(0).get(this.idProperty));
			this.relationForm.getForm().load( {
				url : this.baseUrl + 'edit',
				params : {
					id : rs.get(0).get(this.idProperty)
				},
				waitMsg : '数据加载中，请稍等...',
				failure : function(form, action) {
					Ext.Msg.alert('编辑失败：', action.result.errors.msg);
					this.closeRelation();
				},
				scope : this
			})
		}
	},
	createRelationWin : function(title) {
		if (!this.relationWin) {
			if (!this.relationForm) {
				var dbId = this.dbCombo.getValue();
				this.tbStore = Ext.create('Ext.data.Store', {
					idProperty : 'ID',
					fields : [ 'ID', 'NAME', 'CODE' ],
					autoLoad : true,
					proxy : {
						type : 'ajax',
						url : this.tableBaseUrl + 'comboList',
						extraParams : {
							dbId : dbId
						},
						reader : {
							type : 'json',
							root : 'data'
						}
					}
				});
				this.tbStoreCombo1 = Ext.create('Ext.form.ComboBox', {
					fieldLabel : '数据表',
					labelWidth : 80,
					labelAlign : 'right',
					forceSelection : true,
					editable : false,
					store : this.tbStore,
					queryMode : 'remote',
					name : 'TB_ID',
					displayField : 'CODE',
					valueField : 'ID',
					listeners : {
						scope : this,
						change : function(f, n, o) {
							this.propertyStore1.proxy.extraParams = {
								tbId : n
							}
							this.propertyStore1.load();
						}
					}
				});
				this.propertyStore1 = Ext.create('Ext.data.Store', {
					idProperty : 'ID',
					fields : [ 'ID', 'NAME' ],
					autoLoad : true,
					proxy : {
						type : 'ajax',
						url : this.propertyBaseUrl + 'comboList',
						reader : {
							type : 'json',
							root : 'data'
						}
					}
				});
				this.propertyCombo1 = Ext.create('Ext.form.ComboBox', {
					fieldLabel : '数据表属性',
					labelWidth : 80,
					labelAlign : 'right',
					forceSelection : true,
					editable : false,
					store : this.propertyStore1,
					queryMode : 'remote',
					name : 'PROPERTY_ID',
					displayField : 'NAME',
					valueField : 'ID'
				});
				this.tbStoreCombo2 = Ext.create('Ext.form.ComboBox', {
					fieldLabel : '关联表',
					labelWidth : 80,
					labelAlign : 'right',
					forceSelection : true,
					editable : false,
					store : this.tbStore,
					queryMode : 'remote',
					name : 'REF_TB_ID',
					displayField : 'CODE',
					valueField : 'ID',
					listeners : {
						scope : this,
						change : function(f, n, o) {
							this.propertyStore2.proxy.extraParams = {
								tbId : n
							}
							this.propertyStore2.load();
						}
					}
				});
				this.propertyStore2 = Ext.create('Ext.data.Store', {
					idProperty : 'ID',
					fields : [ 'ID', 'NAME' ],
					autoLoad : true,
					proxy : {
						type : 'ajax',
						url : this.propertyBaseUrl + 'comboList',
						reader : {
							type : 'json',
							root : 'data'
						}
					}
				});
				this.propertyCombo2 = Ext.create('Ext.form.ComboBox', {
					fieldLabel : '关联表属性',
					labelWidth : 80,
					labelAlign : 'right',
					forceSelection : true,
					editable : false,
					store : this.propertyStore2,
					queryMode : 'remote',
					name : 'REF_PROPERTY_ID',
					displayField : 'NAME',
					valueField : 'ID'
				});

				var relationTypeStore = Ext.create('Ext.data.Store', {
					idProperty : 'ID',
					fields : [ 'ID', 'ITEM' ],
					autoLoad : true,
					proxy : {
						type : 'ajax',
						url : 'dictType.do?method=dictTypeItemCombo',
						extraParams : {
							code : 'DATA_RELATION_TYPE'
						},
						reader : {
							type : 'json',
							root : 'data'
						}
					}
				});

				var relationTypeCombo = Ext.create('Ext.form.field.ComboBox', {
					store : relationTypeStore,
					name : 'RELATION_TYPE',
					displayField : 'ITEM',
					fieldLabel : '级联操作',
					labelWidth : 80,
					labelAlign : 'right',
					editable : false,
					width : 320,
					valueField : 'ID',
					queryMode : 'remote',
					forceSelection : true,
					allowBlank : false
				});
				this.relationForm = Ext.create('Ext.form.Panel', {
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
					}, relationTypeCombo, this.tbStoreCombo1,
							this.propertyCombo1, this.tbStoreCombo2,
							this.propertyCombo2 ]
				});
			}
			this.relationWin = Ext.create('Ext.window.Window', {
				autoHeight : true,
				width : 360,
				buttonAlign : 'center',
				plain : true,
				modal : true,
				shadow : true,
				border : false,
				maximizable : true,
				closeAction : 'hide',
				items : [ this.relationForm ],
				buttons : [ {
					text : '保存',
					handler : this.saveRelation,
					scope : this
				}, {
					text : '清空',
					handler : this.resetRelation,
					scope : this
				}, {
					text : '生成名字',
					handler : this.genName,
					scope : this
				} ]
			});
			this.relationWin.on('close', function() {
				this.relationWin = null;
				this.relationForm = null;
			}, this);
		}
		this.relationWin.title = title;
		this.relationWin.show();
	},
	genName : function() {
		var form = this.relationForm.getForm();
		var name = 'FK_' + this.tbStoreCombo1.getRawValue() + '_'
				+ this.tbStoreCombo2.getRawValue();
		form.findField('NAME').setValue(name);
	},
	createRelation : function() {
		this.createRelationWin('新增表关联');
		this.relationForm.getForm().reset();
		this.relationForm.getForm().findField('DB_ID').setValue(
				this.dbCombo.getValue());
	},
	removeRelation : function() {
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
	refreshRelation : function() {
		this.store.load();
	},
	initComponent : function() {
		this.baseUrl = 'dmRelation.do?method=';
		this.databaseBaseUrl = 'dmDataBase.do?method=';
		this.tableBaseUrl = 'dmTable.do?method=';
		this.propertyBaseUrl = 'dmProperty.do?method=';
		this.store = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			fields : [ 'ID', 'NAME', 'TB_NAME', 'PROPERTY_NAME', 'REF_TB_NAME',
					'REF_PROPERTY_NAME', 'RELATION_TYPE_NAME' ],
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
			handler : this.createRelation,
			iconCls : 'icon-add',
			scope : this
		}, '-', {
			text : '修改',
			handler : this.editRelation,
			iconCls : 'icon-edit',
			scope : this
		}, '-', {
			text : '删除',
			handler : this.removeRelation,
			iconCls : 'icon-delete',
			scope : this
		}, '-', {
			text : '刷新',
			handler : this.refreshRelation,
			iconCls : 'icon-refresh',
			scope : this
		} ];
		this.callParent();
	}
});