/**
 * common rowedit grid panel
 * usage:
 * 
 */
Ext.define('Ado.jcpt.CommonGridEditPanel', {
	extend : 'Ext.grid.Panel',
	autoEl : true,
	closable : true,
	autoScroll : true,
	border : false,	
	idProperty : 'ID',	
	viewConfig: {
        stripeRows: true
    },
	selModel: {
//    	selType: 'cellmodel'
    	selType: 'rowmodel'
    },
	refresh : function() {
		this.store.removeAll();
		this.store.load();
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
					obj = Ext.util.JSON.decode(action.response.responseText);
					Ext.Msg.alert('保存失败：', obj.msg);
				},
				scope : this
			});
		}
	},
	reset : function() {
		if (this.win)
			this.fp.form.reset();
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
					Ext.Msg.alert('编辑失败：', action.result.msg);
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
						if (!r.success)
							Ext.Msg.alert('提示信息',
									'数据删除失败，由以下原因所致：<br/>' + (r.msg ? r.msg
											: '未知原因'));
						else {
							// this.store.reload();
							this.store.load();
						}
					},
					scope : this
				});
			}
		}, this);
	},
	listeners: {
        'selectionchange': function(view, records) {
//            grid.down('#removeEmployee').setDisabled(!records.length);
        }
    },
	initComponent : function() {		
    	this.editing=Ext.create('Ext.grid.plugin.CellEditing', {
            clicksToEdit: 1,
            listeners:{
    			scope:this,
    			edit:function(e){
    				console.log(e);
//    				e.record.commit();
//    				console.log(e);
//    				console.log(this);
//    				Ext.Ajax.request( {
//    					url : this.baseUrl + 'save',
//    					params : e,
//    					method : 'POST',
//    					success : function(response) {
//    						var r = Ext.decode(response.responseText);
//    						if (!r.success)
//    							Ext.Msg.alert('提示信息',
//    									'数据删除失败，由以下原因所致：<br/>' + (r.msg ? r.msg
//    											: '未知原因'));
//    						else {
//    							// this.store.reload();
//    							this.store.load();
//    						}
//    					},
//    					scope : this
//    				});
    			}
    		}
        });
    	this.plugins=[this.editing];
		this.store = Ext.create('Ext.data.Store', {
			autoDestroy: true,
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
		this.pagingBar = Ext.create('Ext.toolbar.Paging', {
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
			emptyMsg : '未找到合适的记录！',
			dock : 'bottom'
		});
		this.dockedItems = [ this.pagingBar ];
		this.tbar = this.toolbar || [ {
			text : '新增',
			handler : this.create,
			iconCls : 'icon-add',
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
		this.loadMask = {
			msg : '数据加载中，请稍等...'
		};
		this.callParent();
	}
});