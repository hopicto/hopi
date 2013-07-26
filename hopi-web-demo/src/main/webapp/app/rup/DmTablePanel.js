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
					this.treeStore.load();
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
	editTable : function() {
		this.createTableWin('修改数据表');
		this.tableForm.getForm().load( {
			url : this.tableBaseUrl + 'edit',
			params : {
				id : this.selectTreeId
			},
			waitMsg : '数据加载中，请稍等...',
			failure : function(form, action) {
				Ext.Msg.alert('编辑失败：', action.result.errors.msg);
				this.closeTable();
			},
			scope : this
		})
	},
	validatorTable : function(v) {
		if (this.tableForm) {
			var form = this.tableForm.getForm();
			var editTag = form.findField('_EDIT_TAG').getValue();
			var dbId = form.findField('DB_ID').getValue();
			var id = form.findField('ID').getValue();
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
						name : 'CATE_ID',
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
	addTable : function() {
		this.createTableWin('新增数据表');
		this.tableForm.getForm().reset();
		this.tableForm.getForm().findField('CATE_ID').setValue(
				this.selectTreeId);
		this.tableForm.getForm().findField('DB_ID').setValue(
				this.dbCombo.getValue());
	},
	deleteTable : function() {
		var m = Ext.MessageBox.confirm('删除提示', '是否真的要删除数据？', function(ret) {
			if (ret == 'yes') {
				Ext.Ajax.request( {
					url : this.tableBaseUrl + 'delete',
					params : {
						'id' : this.selectTreeId
					},
					method : 'POST',
					success : function(response) {
						var r = Ext.decode(response.responseText);
						if (!r.success) {
							Ext.Msg.alert('删除失败：', r.errors.msg);
						} else {
							this.treeStore.load();
						}
					},
					scope : this
				});
			}
		}, this);
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
					},  {
						fieldLabel : '精度',
						name : 'DATA_SCALE',
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
							inputValue : 0
						} ]
					}, {
						fieldLabel : '是否批量添加',
						xtype : 'radiogroup',
						columns : 2,
						vertical : true,
						items : [ {
							boxLabel : '是',
							name : 'IS_BATCH',
							inputValue : 1
						}, {
							boxLabel : '否',
							name : 'IS_BATCH',
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
						if (!r.success) {
							Ext.Msg.alert('删除失败：', r.errors.msg);
						} else {
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
	createTcWin : function(title) {
		if (!this.tcWin) {
			if (!this.tcForm) {
				this.tcForm = Ext.create('Ext.form.Panel', {
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
						name : 'PARENT_ID',
						xtype : 'hidden'
					}, {
						fieldLabel : '名称',
						name : 'NAME',
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
			this.tcWin = Ext.create('Ext.window.Window', {
				autoHeight : true,
				width : 360,
				buttonAlign : 'center',
				plain : true,
				modal : true,
				shadow : true,
				border : false,
				maximizable : true,
				closeAction : 'hide',
				items : [ this.tcForm ],
				buttons : [ {
					text : '保存',
					handler : this.saveTc,
					scope : this
				}, {
					text : '取消',
					handler : this.closeTc,
					scope : this
				} ]
			});
			this.tcWin.on('close', function() {
				this.tcWin = null;
				this.tcForm = null;
			}, this);
		}
		this.tcWin.title = title;
		this.tcWin.show();
	},
	addTc : function() {
		this.createTcWin('新增表分类');
		this.tcForm.getForm().reset();
		console.log(this.dbCombo.getValue());
		this.tcForm.getForm().findField('DB_ID').setValue(
				this.dbCombo.getValue());
		this.tcForm.getForm().findField('PARENT_ID')
				.setValue(this.selectTreeId);
	},
	saveTc : function() {
		if (this.tcForm.getForm().isValid()) {
			this.tcForm.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.tableBaseUrl + 'saveTc',
				method : 'POST',
				success : function() {
					this.closeTc();
					this.treeStore.load();
				},
				failure : function(form, action) {
					Ext.Msg.alert('保存失败：', action.result.errors.msg);
					this.closeTc();
				},
				scope : this
			});
		}
	},
	closeTc : function() {
		if (this.tcWin)
			this.tcWin.close();
		this.tcWin = null;
		this.tcForm = null;
	},
	editTc : function() {
		this.createTcWin('修改表分类');
		this.tcForm.getForm().load( {
			url : this.tableBaseUrl + 'editTc',
			params : {
				id : this.selectTreeId
			},
			waitMsg : '数据加载中，请稍等...',
			failure : function(form, action) {
				Ext.Msg.alert('编辑失败：', action.result.errors.msg);
				this.closeTc();
			},
			scope : this
		})
	},
	deleteTc : function() {
		var m = Ext.MessageBox.confirm('删除提示', '是否真的要删除数据？', function(ret) {
			if (ret == 'yes') {
				Ext.Ajax.request( {
					url : this.tableBaseUrl + 'deleteTc',
					params : {
						'id' : this.selectTreeId
					},
					method : 'POST',
					success : function(response) {
						var r = Ext.decode(response.responseText);
						if (!r.success) {
							Ext.Msg.alert('删除失败：', r.errors.msg);
						} else {
							this.treeStore.load();
						}
					},
					scope : this
				});
			}
		}, this);
	},
	initComponent : function() {
		this.tableBaseUrl = 'dmTable.do?method=';
		this.databaseBaseUrl = 'dmDataBase.do?method=';
		this.propertyBaseUrl = 'dmProperty.do?method=';
		this.dbComboStore = Ext.create('Ext.data.Store', {
			idProperty : 'ID',
			fields : [ 'ID', 'NAME' ],
			autoLoad : true,
			listeners : {
				scope : this,
				load : function(store, records, success) {
					if (success && records.length > 0) {
						var dbId = records[0].get('ID');
						this.dbCombo.select(dbId);
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
			labelWidth : 42,
			forceSelection : true,
			editable : false,
			store : this.dbComboStore,
			queryMode : 'remote',
			displayField : 'NAME',
			valueField : 'ID',
			listeners : {
				scope : this,
				change : function(f, n, o) {
					this.treeStore.proxy.extraParams = {
						dbId : n
					};
					this.treeStore.load();
				}
			}
		});

		this.treeStore = Ext.create('Ext.data.TreeStore', {
			proxy : {
				type : 'ajax',
				url : 'dmTable.do?method=tableTree'
			},
			root : {
				text : '根节点',
				draggable : false,
				id : 'TC_1',
				expanded : true
			},
			folderSort : true,
			sorters : [ {
				property : 'text',
				direction : 'ASC'
			} ]
		});
		this.treePanel = Ext.create('Ext.tree.Panel', {
			title : '数据库对象',
			region : 'west',
			// region : 'center',
			width : 200,
			minSize : 120,
			maxSize : 360,
			lines : true,
			border : false,
			style : 'border-right: 1px solid #8db2e3;',
			singleExpand : false,
			useArrows : false,
			collapsible : true,
			collapseMode : 'mini',
			split : true,
			autoScroll : true,
			tbar : [ this.dbCombo ],
			store : this.treeStore,
			viewConfig : {
				plugins : {
					ptype : 'treeviewdragdrop',
					ddGroup : 'tableTreeDD',
					enableDrop : false
				}
			},
			listeners : {
				scope : this,
				itemclick : function(view, node, item, index, e, o) {
					if (node.isLeaf()) {
						e.stopEvent();
						var tbId = node.data.id.substring(3);
						this.selectedTableId = tbId;
						this.selectedTable.setValue(node.data.text);
						this.propertyStore.proxy.extraParams = {
							tbId : tbId
						};
						this.propertyStore.load( {
							params : {
								start : 0
							}
						});
					}
				},
				itemcontextmenu : function(view, node, item, index, e, o) {
					e.stopEvent();
					var rid = node.data.id;
					var prefix = rid.substring(0, 2);
					var pid = rid.substring(3);
					this.selectTreeId = pid;
					var contextmenu;
					if (prefix == 'TC') {
						if (pid == '1') {
							contextmenu = new Ext.menu.Menu( {
								items : [ {
									text : '添加表分类',
									iconCls : 'icon-add',
									handler : this.addTc,
									scope : this
								} ]
							});
						} else {
							contextmenu = new Ext.menu.Menu( {
								items : [ {
									text : '添加表分类',
									iconCls : 'icon-add',
									handler : this.addTc,
									scope : this
								}, {
									text : '修改表分类',
									iconCls : 'icon-edit',
									handler : this.editTc,
									scope : this
								}, {
									text : '删除表分类',
									iconCls : 'icon-delete',
									handler : this.deleteTc,
									scope : this
								}, '-', {
									text : '添加数据表',
									iconCls : 'icon-add',
									handler : this.addTable,
									scope : this
								} ]
							});
						}
						contextmenu.showAt(e.getXY());
					} else {
						contextmenu = new Ext.menu.Menu( {
							items : [ {
								text : '修改数据表',
								iconCls : 'icon-edit',
								handler : this.editTable,
								scope : this
							}, {
								text : '删除数据表',
								iconCls : 'icon-delete',
								handler : this.deleteTable,
								scope : this
							} ]
						});
						contextmenu.showAt(e.getXY());
					}
				}
			}
		});
		this.propertyStore = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			fields : [ 'ID', 'NAME', 'CODE', 'SEQ', 'DATA_TYPE',
					'DATA_TYPE_NAME', 'DATA_LENGTH','DATA_SCALE', 'IS_PK', 'IS_PART',
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
			},  {
				header : '精度',
				dataIndex : 'DATA_SCALE'
			},{
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
		this.items = [ this.treePanel, this.propertyPanel ];
		this.callParent();
	}
});