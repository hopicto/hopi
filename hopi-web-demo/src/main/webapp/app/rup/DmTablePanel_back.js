Ext.define('Ado.rup.DmTablePanel', {
	extend : 'Ext.panel.Panel',
	closable : true,
	border : false,
	layout : 'border',
	idProperty : 'ID',
	saveTable : function() {
		if (this.tableForm.getForm().isValid()) {
			this.tableForm.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.tableBaseUrl + 'save',
				method : 'POST',
				success : function() {
					this.closeTable();
					this.tableStore.load();
				},
				failure : function(form, action) {
					Ext.Msg.alert('保存失败：', action.result.errors.msg);
				},
				scope : this
			});
		}
	},
	closeTable : function() {
		if (this.tableWin)
			this.tableWin.close();
		this.tableWin = null;
		this.tableForm = null;
	},
	resetTable : function() {
		if (this.tableWin)
			this.tableForm.getForm().reset();
	},
	editTable : function() {
		var rs = this.tablePanel.selModel.selected;
		if (rs.length == 0) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		} else if (rs.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else {
			this.createTableWin('修改数据表');
			this.tableForm.getForm().load( {
				url : this.tableBaseUrl + 'edit',
				params : {
					id : rs.get(0).get(this.idProperty)
				},
				waitMsg : '数据加载中，请稍等...',
				failure : function(form, action) {
					Ext.Msg.alert('编辑失败：', action.result.errors.msg);
					this.closeTable();
				},
				scope : this
			})
		}
	},
	validatorTable : function(v) {
		if (this.tableForm) {
			var form = this.tableForm.getForm();
			var editTag = form.findField('_EDIT_TAG').getValue();
			var dbId = form.findField('DB_ID').getValue();
			var id = form.findField('ID').getValue();
			console.log(editTag);
			console.log(dbId);
			console.log(id);
			Ext.Ajax.request( {
				url : this.tableBaseUrl + 'checkName',
				params : {
					'DB_ID' : dbId,
					'ID' : id,
					'_EDIT_TAG' : editTag,
					'NAME' : v
				},
				method : 'POST',
				success : function(response) {
					var r = Ext.decode(response.responseText);
					console.log(r);
					if (!r.success) {
						return false;
					} else {
						return true;
					}
				},
				scope : this
			});
			return true;
		}
	},
	createTableWin : function(title) {
		if (!this.tableWin) {
			if (!this.tableForm) {
				this.tableForm = Ext.create('Ext.form.Panel', {
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
						fieldLabel : '描述',
						name : 'DESCRIPTION',
						xtype : 'textarea',
						width : 320,
						height : 60
					} ]
				});
			}
			this.tableWin = Ext.create('Ext.window.Window', {
				autoHeight : true,
				width : 360,
				buttonAlign : 'center',
				plain : true,
				modal : true,
				shadow : true,
				border : false,
				maximizable : true,
				closeAction : 'hide',
				items : [ this.tableForm ],
				buttons : [ {
					text : '保存',
					handler : this.saveTable,
					scope : this
				}, {
					text : '清空',
					handler : this.resetTable,
					scope : this
				}, {
					text : '取消',
					handler : this.closeTable,
					scope : this
				} ]
			});
			this.tableWin.on('close', function() {
				this.tableWin = null;
				this.tableForm = null;
			}, this);
		}
		this.tableWin.title = title;
		this.tableWin.show();
	},
	createTable : function() {
		this.createTableWin('新增数据表');
		this.tableForm.getForm().reset();
		this.tableForm.getForm().findField('DB_ID').setValue(
				this.dbCombo.getValue());
	},
	removeTable : function() {
		var records = this.tablePanel.selModel.selected;
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
					url : this.tableBaseUrl + 'delete',
					params : {
						'id' : ids
					},
					method : 'POST',
					success : function(response) {
						var r = Ext.decode(response.responseText);
						if (!r.success){
							Ext.Msg.alert('删除失败：', r.errors.msg);							
						}
						else {
							this.tableStore.load();
							this.selectedTableId = null;
							this.selectedTable.setValue('未选择');
							this.propertyStore.proxy.extraParams = {
								tbId : null
							};
							this.propertyStore.load();
						}
					},
					scope : this
				});
			}
		}, this);
	},
	refreshTable : function() {
		this.tableStore.load();
	},
	saveProperty : function() {
		if (this.propertyForm.getForm().isValid()) {
			this.propertyForm.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.propertyBaseUrl + 'save',
				method : 'POST',
				success : function() {
					this.closeProperty();
					this.propertyStore.load();
				},
				failure : function(form, action) {
					Ext.Msg.alert('保存失败：', action.result.errors.msg);					
				},
				scope : this
			});
		}
	},
	closeProperty : function() {
		if (this.propertyWin)
			this.propertyWin.close();
		this.propertyWin = null;
		this.propertyForm = null;
	},
	resetProperty : function() {
		if (this.propertyWin)
			this.propertyForm.getForm().reset();
	},
	editProperty : function() {
		var rs = this.propertyPanel.selModel.selected;
		if (rs.length == 0) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		} else if (rs.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else {
			this.createPropertyWin('修改表属性');
			this.propertyForm.getForm().load( {
				url : this.propertyBaseUrl + 'edit',
				params : {
					id : rs.get(0).get(this.idProperty)
				},
				waitMsg : '数据加载中，请稍等...',
				failure : function(form, action) {
					Ext.Msg.alert('编辑失败：', action.result.errors.msg);
					this.closeProperty();
				},
				scope : this
			})
		}
	},
	createPropertyWin : function(title) {
		if (!this.propertyWin) {
			if (!this.propertyForm) {
				var dataTypeStore = Ext.create('Ext.data.Store', {
					idProperty : 'ID',
					fields : [ 'ID', 'ITEM' ],
					autoLoad : true,
					proxy : {
						type : 'ajax',
						url : 'dictType.do?method=dictTypeItemCombo',
						extraParams : {
							code : 'DATA_TYPE'
						},
						reader : {
							type : 'json',
							root : 'data'
						}
					}
				});

				var dataTypeCombo = Ext.create('Ext.form.field.ComboBox', {
					store : dataTypeStore,
					name : 'DATA_TYPE',
					displayField : 'ITEM',
					fieldLabel : '数据类型',
					labelAlign : 'right',
					labelWidth : 80,
					editable : false,
					width : 320,
					valueField : 'ID',
					queryMode : 'remote',
					forceSelection : true,
					allowBlank : false
				});

				var partStore = Ext.create('Ext.data.Store', {
					idProperty : 'ID',
					fields : [ 'ID', 'NAME' ],
					autoLoad : true,
					proxy : {
						type : 'ajax',
						url : 'dmTableSpace.do?method=comboList',
						reader : {
							type : 'json',
							root : 'data'
						}
					}
				});

				var partCombo = Ext.create('Ext.form.field.ComboBox', {
					store : partStore,
					name : 'PART_ID',
					displayField : 'NAME',
					fieldLabel : '分区表空间',
					labelAlign : 'right',
					labelWidth : 80,
					editable : false,
					width : 320,
					valueField : 'ID',
					queryMode : 'remote',
					forceSelection : true
				});
				this.propertyForm = Ext.create('Ext.form.Panel', {
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
						name : 'TB_ID',
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
						fieldLabel : '序号',
						name : 'SEQ',
						allowBlank : false
					}, dataTypeCombo, {
						fieldLabel : '长度',
						name : 'DATA_LENGTH',
						allowBlank : false
					}, {
						fieldLabel : '是否主键',
						xtype : 'radiogroup',
						columns : 2,
						vertical : true,
						items : [ {
							boxLabel : '是',
							name : 'IS_PK',
							inputValue : '1'
						}, {
							boxLabel : '否',
							name : 'IS_PK',
							// checked : true,
							inputValue : '0'
						} ]
					}, {
						fieldLabel : '是否分区',
						xtype : 'radiogroup',
						columns : 2,
						vertical : true,
						items : [ {
							boxLabel : '是',
							name : 'IS_PART',
							inputValue : 1
						}, {
							boxLabel : '否',
							name : 'IS_PART',
							// checked : true,
							inputValue : 0
						} ]
					}, partCombo, {
						fieldLabel : '描述',
						name : 'DESCRIPTION',
						xtype : 'textarea',
						width : 320,
						height : 60
					} ]
				});
			}
			this.propertyWin = Ext.create('Ext.window.Window', {
				autoHeight : true,
				width : 360,
				buttonAlign : 'center',
				plain : true,
				modal : true,
				shadow : true,
				border : false,
				maximizable : true,
				closeAction : 'hide',
				items : [ this.propertyForm ],
				buttons : [ {
					text : '保存',
					handler : this.saveProperty,
					scope : this
				}, {
					text : '清空',
					handler : this.resetProperty,
					scope : this
				}, {
					text : '取消',
					handler : this.closeProperty,
					scope : this
				} ]
			});
			this.propertyWin.on('close', function() {
				this.propertyWin = null;
				this.propertyForm = null;
			}, this);
		}
		this.propertyWin.title = title;
		this.propertyWin.show();
	},
	createProperty : function() {
		if (this.selectedTableId == null) {
			Ext.Msg.alert('提示', '请先选择数据表!');
			return;
		} else {
			this.createPropertyWin('新增表属性');
			this.propertyForm.getForm().reset();
			this.propertyForm.getForm().findField('TB_ID').setValue(
					this.selectedTableId);
		}
	},
	removeProperty : function() {
		var records = this.propertyPanel.selModel.selected;
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
					url : this.propertyBaseUrl + 'delete',
					params : {
						'id' : ids
					},
					method : 'POST',
					success : function(response) {
						var r = Ext.decode(response.responseText);
						if (!r.success){
							Ext.Msg.alert('删除失败：', r.errors.msg);
						}							
						else {
							this.propertyStore.load();
						}
					},
					scope : this
				});
			}
		}, this);
	},
	refreshProperty : function() {
		this.propertyStore.load();
	},
	initComponent : function() {
		this.tableBaseUrl = 'dmTable.do?method=';
		this.databaseBaseUrl = 'dmDataBase.do?method=';
		this.propertyBaseUrl = 'dmProperty.do?method=';
		this.tableStore = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			fields : [ 'ID', 'NAME', 'CODE', 'DESCRIPTION' ],
			proxy : {
				type : 'ajax',
				url : this.tableBaseUrl + 'query',
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
					this.tableStore.proxy.extraParams = {
						dbId : n
					};
					this.tableStore.load( {
						params : {
							start : 0
						}
					});
				}
			}
		});
		this.selectedTableId = null;
		this.tablePanel = Ext.create('Ext.grid.Panel', {
			region : 'west',
			autoEl : true,
			autoScroll : true,
			idProperty : 'ID',
			width : 500,
			resizable : {
				minWidth : 500,
				maxWidth : 680,
				handles : 'e'
			},
			border : false,
			style : 'border-right: 1px solid #8db2e3;',
			margins : '0 5 0 0',
			viewConfig : {
				stripeRows : true
			},
			selModel : Ext.create('Ext.selection.CheckboxModel', {}),
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
			store : this.tableStore,
			bbar : Ext.create('Ext.toolbar.Paging', {
				pageSize : 25,
				store : this.tableStore,
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
			}),
			loadMask : {
				msg : '数据加载中，请稍等...'
			},
			tbar : [ this.dbCombo, '-', {
				text : '新增',
				handler : this.createTable,
				iconCls : 'icon-add',
				scope : this
			}, '-', {
				text : '修改',
				handler : this.editTable,
				iconCls : 'icon-edit',
				scope : this
			}, '-', {
				text : '删除',
				handler : this.removeTable,
				iconCls : 'icon-delete',
				scope : this
			}, '-', {
				text : '刷新',
				handler : this.refreshTable,
				iconCls : 'icon-refresh',
				scope : this
			} ],
			listeners : {
				scope : this,
				itemclick : function(v, r) {
					var tbId = r.get('ID');
					this.selectedTableId = tbId;
					this.selectedTable.setValue(r.get('NAME'));
					this.propertyStore.proxy.extraParams = {
						tbId : tbId
					};
					this.propertyStore.load( {
						params : {
							start : 0
						}
					});
				}
			}
		});
		this.propertyStore = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			fields : [ 'ID', 'NAME', 'CODE', 'SEQ', 'DATA_TYPE',
					'DATA_TYPE_NAME', 'DATA_LENGTH', 'IS_PK', 'IS_PART',
					'PART_NAME', 'DESCRIPTION' ],
			proxy : {
				type : 'ajax',
				url : this.propertyBaseUrl + 'query',
				reader : {
					type : 'json',
					totalProperty : 'totalCount',
					root : 'list'
				}
			}
		});
		this.selectedTable = Ext.create('Ext.form.field.Display', {
			width : 240,
			fieldLabel : '当前表',
			labelWidth : 60,
			labelAlign : 'right',
			value : '未选中'
		});
		this.propertyPanel = Ext.create('Ext.grid.Panel', {
			region : 'center',
			autoEl : true,
			autoScroll : true,
			idProperty : 'ID',
			border : false,
			style : 'border-left: 1px solid #8db2e3;',
			viewConfig : {
				stripeRows : true
			},
			selModel : Ext.create('Ext.selection.CheckboxModel', {}),
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
				header : '序号',
				sortable : true,
				dataIndex : 'SEQ'
			}, {
				header : '数据类型',
				dataIndex : 'DATA_TYPE_NAME'
			}, {
				header : '长度',
				dataIndex : 'DATA_LENGTH'
			}, {
				header : '是否主键',
				dataIndex : 'IS_PK',
				renderer : function(value) {
					if (value == 1) {
						return '是';
					}
					return '';
				}
			}, {
				header : '是否分区',
				dataIndex : 'IS_PART',
				renderer : function(value) {
					if (value == 1) {
						return '是';
					}
					return '';
				}
			}, {
				header : '分区表空间',
				dataIndex : 'PART_NAME'
			}, {
				header : '说明',
				flex : 1,
				dataIndex : 'DESCRIPTION'
			} ],
			store : this.propertyStore,
			bbar : Ext.create('Ext.toolbar.Paging', {
				pageSize : 25,
				store : this.propertyStore,
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
			}),
			loadMask : {
				msg : '数据加载中，请稍等...'
			},
			tbar : [ {
				text : '新增',
				handler : this.createProperty,
				iconCls : 'icon-add',
				scope : this
			}, '-', {
				text : '修改',
				handler : this.editProperty,
				iconCls : 'icon-edit',
				scope : this
			}, '-', {
				text : '删除',
				handler : this.removeProperty,
				iconCls : 'icon-delete',
				scope : this
			}, '-', {
				text : '刷新',
				handler : this.refreshProperty,
				iconCls : 'icon-refresh',
				scope : this
			}, '->', this.selectedTable ]
		});
		this.items = [ this.tablePanel, this.propertyPanel ];
		this.callParent();
	}
});