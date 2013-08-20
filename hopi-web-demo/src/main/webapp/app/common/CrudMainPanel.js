/**
 * 增删改查面板
 */
Ext.define('Hopi.common.CrudMainPanel', {
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
	refreshData : function() {
		this.store.removeAll();
		this.store.reload();
	},
	showWin : function(title,id) {		
		if(this.dataFormSetting.dataFormType=1){		
			this.win = Ext.create('Hopi.common.CrudDataFormPopup', {
				mainPanel:this,
				width:this.dataFormSetting.width,
				title:title
			});
			this.win.show();
		}else{						
			this.win=openTab({
				type : this.dataFormSetting.panelName,
				id : id,
				title : title,
				code : 'Hopi.common.CrudDataFormPanel'
			}, {
				mainPanel : this
			});
		}		
	},
	createData : function() {		
		this.showWin('新增' + this.nameSuffix,'new');
	},
	modifyData : function() {
		var records = this.getSelectionModel().getSelection();
		if (records.length > 1) {
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		} else if (records.length < 1) {
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		}		
		var id=records[0].get(this.idProperty);
		this.showWin('修改' + this.nameSuffix,id);
		this.win.loadData(id);
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
	queryData : function() {
		var sv = this.queryField.getValue();
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
	switchHighQuery : function() {
		if (this.highQueryForm.hidden) {
			this.highQueryButton.setText('收起高级查询');
			this.highQueryButton.setIconCls('icon-closehighquery');
			this.highQueryForm.show();
			this.syncFx();
		} else {
			this.highQueryButton.setText('展开高级查询');
			this.highQueryButton.setIconCls('icon-openhighquery');
			this.highQueryForm.hide();
			this.syncFx();
		}
	},
	highQueryData : function() {
		var fieldValues = this.highQueryForm.form.getFieldValues();
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
	importData:function(){
		
	},
	exportData:function(){
		location.href=this.baseUrl+'exportData';
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
		this.tbar = Ext.create('Ext.container.Container', {
			items : [ this.toolBar, this.highQueryForm ]
		});		
		this.callParent();
	}
});