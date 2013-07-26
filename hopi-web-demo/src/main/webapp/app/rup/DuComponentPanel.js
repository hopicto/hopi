Ext.define('Ado.rup.DuComponentPanel', {
	extend : 'Ext.panel.Panel',
	closable : true,
	border : false,
	layout : 'border',
	idProperty : 'ID',
	saveComp : function() {
		if (this.compForm.getForm().isValid()) {
			this.compForm.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.compBaseUrl + 'save',
				method : 'POST',
				success : function() {
					this.closeComp();
					this.compStore.load();
				},
				failure : function(form, action) {
					Ext.Msg.alert('保存失败：', action.result.errors.msg);
				},
				scope : this
			});
		}
	},
	closeComp : function() {
		if (this.compWin)
			this.compWin.close();
		this.compWin = null;
		this.compForm = null;
	},
	resetComp : function() {
		if (this.compWin)
			this.compForm.getForm().reset();
	},
	editComp : function() {
		var rs = this.compPanel.selModel.selected;
		if (rs.length == 0) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		} else if (rs.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else {
			this.createCompWin('修改数据表');
			this.compForm.getForm().load( {
				url : this.compBaseUrl + 'edit',
				params : {
					id : rs.get(0).get(this.idProperty)
				},
				waitMsg : '数据加载中，请稍等...',
				failure : function(form, action) {
					Ext.Msg.alert('编辑失败：', action.result.errors.msg);
					this.closeComp();
				},
				scope : this
			})
		}
	},
	createCompWin : function(title) {
		if (!this.compWin) {
			if (!this.compForm) {
				var compTypeStore = Ext.create('Ext.data.Store', {
					idProperty : 'ID',
					fields : [ 'ID', 'ITEM' ],
					autoLoad : true,
					proxy : {
						type : 'ajax',
						url : 'dictType.do?method=dictTypeItemCombo',
						extraParams : {
							code : 'UI_COMPONENT_TYPE'
						},
						reader : {
							type : 'json',
							root : 'data'
						}
					}
				});

				var compTypeCombo = Ext.create('Ext.form.field.ComboBox', {
					store : compTypeStore,
					name : 'TYPE',
					displayField : 'ITEM',
					fieldLabel : '组件类型',
					labelAlign : 'right',
					labelWidth : 80,
					edicomp : false,
					width : 320,
					valueField : 'ID',
					queryMode : 'remote',
					forceSelection : true,
					allowBlank : false
				});
				this.compForm = Ext.create('Ext.form.Panel', {
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
						fieldLabel : '父代码',
						name : 'PARENT_CODE'
					}, compTypeCombo, {
						fieldLabel : '简码',
						name : 'VTYPE'
					}, {
						fieldLabel : '描述',
						name : 'DESCRIPTION',
						xtype : 'textarea',
						width : 320,
						height : 60
					} ]
				});
			}
			this.compWin = Ext.create('Ext.window.Window', {
				autoHeight : true,
				width : 360,
				buttonAlign : 'center',
				plain : true,
				modal : true,
				shadow : true,
				border : false,
				maximizable : true,
				closeAction : 'hide',
				items : [ this.compForm ],
				buttons : [ {
					text : '保存',
					handler : this.saveComp,
					scope : this
				}, {
					text : '清空',
					handler : this.resetComp,
					scope : this
				}, {
					text : '取消',
					handler : this.closeComp,
					scope : this
				} ]
			});
			this.compWin.on('close', function() {
				this.compWin = null;
				this.compForm = null;
			}, this);
		}
		this.compWin.title = title;
		this.compWin.show();
	},
	createComp : function() {
		this.createCompWin('新增数据表');
		this.compForm.getForm().reset();
	},
	removeComp : function() {
		var records = this.compPanel.selModel.selected;
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
					url : this.compBaseUrl + 'delete',
					params : {
						'id' : ids
					},
					method : 'POST',
					success : function(response) {
						var r = Ext.decode(response.responseText);
						if (!r.success) {
							Ext.Msg.alert('删除失败：', r.errors.msg);
						} else {
							this.compStore.load();
							this.selectedCompId = null;
							this.selectedComp.setValue('未选择');
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
	refreshComp : function() {
		this.compStore.load();
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
			this.propertyForm.form.load( {
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
						name : 'COMPONENT_ID',
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
					}, {
						fieldLabel : '默认值 ',
						name : 'DEFAULT_VALUE'
					}, {
						fieldLabel : '当前值 ',
						name : 'CUR_VALUE'
					}, {
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
		if (this.selectedCompId == null) {
			Ext.Msg.alert('提示', '请先选择数据表!');
			return;
		} else {
			this.createPropertyWin('新增表属性');
			this.propertyForm.getForm().reset();
			this.propertyForm.getForm().findField('COMPONENT_ID').setValue(
					this.selectedCompId);
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
	initComponent : function() {
		this.compBaseUrl = 'duComponent.do?method=';
		this.propertyBaseUrl = 'duComponentProperty.do?method=';
		this.selectedCompId = null;
		this.compStore = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			autoLoad : true,
			fields : [ 'ID', 'NAME', 'CODE', 'TYPE_NAME', 'VTYPE',
					'PARENT_CODE', 'DESCRIPTION' ],
			proxy : {
				type : 'ajax',
				url : this.compBaseUrl + 'query',
				reader : {
					type : 'json',
					totalProperty : 'totalCount',
					root : 'list'
				}
			}
		});
		this.compPanel = Ext.create('Ext.grid.Panel', {
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
				header : '父编码',
				sortable : true,
				dataIndex : 'PARENT_CODE'
			}, {
				header : '类型',
				dataIndex : 'TYPE_NAME'
			}, {
				header : '简码',
				dataIndex : 'VTYPE'
			}, {
				header : '说明',
				flex : 1,
				dataIndex : 'DESCRIPTION'
			} ],
			store : this.compStore,
			bbar : Ext.create('Ext.toolbar.Paging', {
				pageSize : 25,
				store : this.compStore,
				displayInfo : true
			// beforePageText : '当前',
					// afterPageText : '页/共{0}页',
					// firstText : '首页',
					// lastText : '末页',
					// nextText : '下一页',
					// prevText : '上一页',
					// refreshText : '刷新',
					// displayMsg : '当前显示 {0} - {1}条记录 /共 {2}条记录',
					// emptyMsg : '未找到合适的记录！'
					}),
			loadMask : {
				msg : '数据加载中，请稍等...'
			},
			tbar : [ {
				text : '新增',
				handler : this.createComp,
				iconCls : 'icon-add',
				scope : this
			}, '-', {
				text : '修改',
				handler : this.editComp,
				iconCls : 'icon-edit',
				scope : this
			}, '-', {
				text : '删除',
				handler : this.removeComp,
				iconCls : 'icon-delete',
				scope : this
			}, '-', {
				text : '刷新',
				handler : this.refreshComp,
				iconCls : 'icon-refresh',
				scope : this
			} ],
			listeners : {
				scope : this,
				itemclick : function(v, r) {
					var compId = r.get('ID');
					this.selectedCompId = compId;
					this.selectedComp.setValue(r.get('NAME'));
					this.propertyStore.proxy.extraParams = {
						compId : compId
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
			fields : [ 'ID', 'NAME', 'CODE', 'SEQ', 'CUR_VALUE',
					'DEFAULT_VALUE', 'DESCRIPTION' ],
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
		this.selectedComp = Ext.create('Ext.form.field.Display', {
			width : 240,
			fieldLabel : '当前组件',
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
				header : '默认值',
				dataIndex : 'DEFAULT_VALUE'
			}, {
				header : '当前值',
				dataIndex : 'CUR_VALUE'
			}, {
				header : '说明',
				flex : 1,
				dataIndex : 'DESCRIPTION'
			} ],
			store : this.propertyStore,
			bbar : Ext.create('Ext.toolbar.Paging', {
				pageSize : 25,
				store : this.propertyStore,
				displayInfo : true
			// beforePageText : '当前',
					// afterPageText : '页/共{0}页',
					// firstText : '首页',
					// lastText : '末页',
					// nextText : '下一页',
					// prevText : '上一页',
					// refreshText : '刷新',
					// displayMsg : '当前显示 {0} - {1}条记录 /共 {2}条记录',
					// emptyMsg : '未找到合适的记录！'
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
			}, '->', this.selectedComp ]
		});
		this.items = [ this.compPanel, this.propertyPanel ];
		this.callParent();
	}
});