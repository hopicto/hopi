Ext.define('Ado.rup.DmQuerySetPanel', {
	extend : 'Ext.panel.Panel',
	closable : true,
	border : false,
	layout : 'border',
	afterComponentLayout : function() {
		var formPanel = this.sqlEditor;
		var formPanelDropTargetEl = formPanel.el.dom;
		this.fromTables = [];
		this.selects = [];
		Ext.create('Ext.dd.DropTarget', formPanelDropTargetEl, {
			ddGroup : 'tableTreeDD',
			qsp : this,
			notifyEnter : function(ddSource, e, data) {
				formPanel.body.stopAnimation();
				formPanel.body.highlight();
			},
			notifyDrop : function(ddSource, e, data) {
				var node = ddSource.dragData.records[0];
				var editor = formPanel.getForm().findField('QUERY_SQL');
				var oldValue = editor.getValue();
				if (oldValue == '') {
					this.qsp.fromTables = [];
				}
				for ( var i = 0; i < this.qsp.fromTables.length; i++) {
					if (this.qsp.fromTables[i] == node.raw.text) {
						return;
					}
				}
				this.qsp.fromTables.push(node.raw.text);

				var curT = 't' + this.qsp.fromTables.length;
				var rid = node.raw.id;
				if (this.qsp.fromTables.length == 1) {
					rs = 'select ';
					if (rid.substring(0, 2) == 'TB') {
						node.eachChild(function(item) {
							rs += curT + '.' + item.raw.text + ',';
						});
						rs = rs.substring(0, rs.length - 1);
						rs = rs + ' from ' + node.raw.text + ' ' + curT
						editor.setValue(rs);
					}
				} else {
					rs = oldValue;
					if (rid.substring(0, 2) == 'TB') {
						var ts = '';
						node.eachChild(function(item) {
							ts = ts + curT + '.' + item.raw.text + ',';
						});
						ts = ts.substring(0, ts.length - 1);
						rs = rs.replace('from', ',' + ts + ' from');
						rs = rs + ' left join ' + node.raw.text + ' ' + curT
								+ ' on t1.id=' + curT + '.id';
						editor.setValue(rs);
					}

				}
				return true;
			}
		});
	},
	createQueryParam : function() {
		var sql = this.sqlEditor.getForm().findField('QUERY_SQL').getValue();
		if (sql.indexOf(':') < 0) {
			return;
		} else {
			var ts = sql.split(':');
			var t = {};
			for ( var i = 1; i < ts.length; i++) {
				tsi = ts[i].indexOf(' ');
				if (tsi > 0) {
					t[ts[i].substring(0, tsi)] = '';
				} else {
					t[ts[i]] = '';
				}
			}
			this.queryParamPanel.setSource(t);
		}
	},
	clearQuery : function() {
		this.sqlEditor.getForm().findField('QUERY_SQL').setValue('');
	},
	executeQuery : function() {
		var sql = this.sqlEditor.getForm().findField('QUERY_SQL').getValue();
		var t = this.queryParamPanel.getSource();
		var params = {
			sql : sql
		};
		Ext.apply(params, t);

		var selects = sql.substring(7, sql.indexOf('from')).split(',');
		var fields = [];
		for ( var i = 0; i < selects.length; i++) {
			var s = selects[i].trim().toUpperCase();
			var si = s.indexOf(' ');
			if (si > 0) {
				fields.push(s.substring(si + 1));
			} else {
				fields.push(s.substring(s.indexOf('.') + 1));
			}
		}
		var newColumns = [ {
			xtype : 'rownumberer'
		} ];
		for ( var i = 0; i < fields.length; i++) {
			newColumns.push( {
				header : fields[i],
				sortable : true,
				dataIndex : fields[i]
			});
		}

		this.queryStore.fields = fields;
		this.queryStore.proxy.url = 'dmQuery.do?method=dynQuery';
		this.queryStore.proxy.extraParams = params;
		this.queryResultPanel.reconfigure(this.queryStore, newColumns);
		this.queryStore.load();
	},
	initComponent : function() {
		var dbId = this.extprop.dbId;
		var dbName = this.extprop.dbName;
		this.treePanel = Ext.create('Ext.tree.Panel', {
			title : '数据库对象',
			region : 'west',
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
			store : Ext.create('Ext.data.TreeStore', {
				proxy : {
					type : 'ajax',
					url : 'dmTable.do?method=tableTree',
					extraParams:{
						dbId:dbId
					}
				},
				root : {
					text : dbName,
					draggable : false,
					id : 'TC_1',
					//id : 'DB_' + dbId,
					expanded : true
				},
				folderSort : true,
				sorters : [ {
					property : 'text',
					direction : 'ASC'
				} ]
			}),
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
						console.log('item click');
					}
				}
			}
		});
		this.queryStore = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			fields : [],
			proxy : {
				type : 'ajax',
				url : '',
				reader : {
					type : 'json',
					totalProperty : 'totalCount',
					root : 'list'
				},
				listeners:{
					exception:function(proxy, response, operation, options ){
						var r = Ext.decode(response.responseText);
						Ext.Msg.alert('加载失败：', r.errors.msg);						
					}
				}
			}
		});
		this.queryResultPanel = Ext.create('Ext.grid.Panel', {
			title : '查询结果',
			border : false,
			autoScroll : true,
			store : this.queryStore,
			loadMask : {
				msg : '数据加载中，请稍等...'
			},
			viewConfig : {
				stripeRows : true
			},
			selModel : Ext.create('Ext.selection.CheckboxModel', {}),
			columns : [ {
				xtype : 'rownumberer'
			} ]
		});
		this.tabPanel = Ext.create('Ext.tab.Panel', {
			region : 'south',
			height : 200,
			border : false,
			resizable : {
				handles : 'n'
			},
			items : [ this.queryResultPanel ]
		});
		this.sqlEditor = Ext.create('Ext.form.Panel', {
			region : 'center',
			autoEl : true,
			padding : 5,
			border : false,
			items : [ {
				xtype : 'textarea',
				name : 'QUERY_SQL',
				border : false,
				margin : 0,
				anchor : '100% 100%'
			} ]
		});
		this.queryParamPanel = Ext.create('Ext.grid.property.Grid', {
			region : 'east',
			border : false,
			style : 'border-left: 1px solid #8db2e3;',
			width : 200,
			source : {}
		});
		this.sqlPanel = Ext.create('Ext.panel.Panel', {
			region : 'center',
			layout : 'border',
			border : false,
			style : 'border-left: 1px solid #8db2e3;',
			tbar : [ {
				text : '清空',
				handler : this.clearQuery,
				iconCls : 'icon-delete',
				scope : this
			}, '-', {
				text : '生成查询变量',
				handler : this.createQueryParam,
				iconCls : 'icon-add',
				scope : this
			}, '-', {
				text : '执行',
				handler : this.executeQuery,
				iconCls : 'icon-add',
				scope : this
			} ],
			items : [ this.sqlEditor, this.queryParamPanel, this.tabPanel ]
		});

		this.items = [ this.treePanel, this.sqlPanel ];
		this.callParent();
	}
});