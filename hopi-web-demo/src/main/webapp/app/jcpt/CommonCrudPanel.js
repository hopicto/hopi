Ext.define('Ado.jcpt.CommonCrudPanel', {
	extend : 'Ext.panel.Panel',
	autoEl : true,
	closable : true,
	border : false,
	layout:'border',
//	
//	autoScroll : true,
//	
//	forceFit : true,
//	idProperty : 'ID',
//	stripeRows: true,
//	refresh : function() {
//		this.store.removeAll();
//		this.store.load();
//	},
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
				text : '清空',
				handler : this.reset,
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
		if(this.fp.getForm().isValid()){
			this.fp.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.baseUrl + 'save',
				method : 'POST',
				success : function() {
					this.closeWin();
//					this.store.reload();
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
	closeWin : function() {
		if (this.win)
			this.win.close();
		this.win = null;
		this.fp = null;
	},
	edit : function() {
		var rs = this.selModel.selected;
		if(rs.length==0){
			Ext.Msg.alert('提示', '请先选择要编辑的行!');
			return;
		}else if(rs.length>1){
			Ext.Msg.alert('提示', '一次只能编辑一行数据!');
			return;
		}else{
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
//							this.store.reload();
							this.store.load();
						}
					},
					scope : this
				});
			}
		}, this);
	},
	initComponent : function() {
		this.store =Ext.create('Ext.data.Store', {	
			idProperty : this.idProperty || 'id',
		    fields : this.storeMapping,
		    proxy: {
		    	type: 'ajax',
		    	url : this.baseUrl + 'query',
		        reader: {
		            type: 'json',
		            root: 'list'
		        }
		    }
		});

		this.gridPanel=Ext.create('Ext.grid.Panel', {
			store:this.store,
			autoScroll : true,
			border:false,				
			columnLines:true,
//			forceFit : true,
			region:'center',
			viewConfig: {
		        stripeRows: true
		    },
		    selType:'checkboxmodel',
			multiSelect:true,
			columns:this.columns,
			loadMask : {
					msg : '数据加载中，请稍等...'
			},
			dockedItems:[Ext.create('Ext.toolbar.Paging', {
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
				dock: 'bottom'
			})]
		});
		this.viewPanel=Ext.create('Ext.panel.Panel', {
//			title:'查看',
			region:'south',
			border:false,
			style:'border-top: 1px solid #8db2e3;',			
//			cls:'x-docked-noborder-top',
//			cls: 'x-docked-noborder-top',
//			border: 'border-width:1px 0 0 0',
//			resizable:true,
//			hidden:true,
//			collapsible: true,
//			collapseMode: 'mini',
			height:120,
			html:''
		});
		this.searchPanel=Ext.create('Ext.panel.Panel', {			
			region:'east',
			border:false,
			style:'border-left: 1px solid #8db2e3;',	
//			border:'0 0 0 1',
			hidden:true,
//			collapsible: true,
//			collapseMode: 'mini',
			width:120,
			html:'123'
		});
		this.items=[this.gridPanel,this.viewPanel,this.searchPanel];
//		this.store = new Ext.data.JsonStore( {
//			idProperty : this.idProperty || 'id',
//			url : this.baseUrl + 'query',
//			root : 'list',
//			totalProperty : 'totalCount',
//			remoteSort : true,
//			baseParams : this.baseParams,
//			fields : this.storeMapping
//		});
//		this.store.paramNames.sort = 'orderBy';
//		this.store.paramNames.dir = 'orderType';
//		this.cm.defaultSortable = true;
//		if(this.skipbbar){
//			//skipbbar
//		}else{
//			this.pagingBar=Ext.create('Ext.toolbar.Paging', {
//				pageSize : 25,
//				store : this.store,
//				displayInfo : true,
//				beforePageText : '当前',
//				afterPageText : '页/共{0}页',
//				firstText : '首页',
//				lastText : '末页',
//				nextText : '下一页',
//				prevText : '上一页',
//				refreshText : '刷新',
//				displayMsg : '当前显示 {0} - {1}条记录 /共 {2}条记录',
//				emptyMsg : '未找到合适的记录！',
//				dock: 'bottom'
//			});
//			this.dockedItems=[this.pagingBar];
//				
//				
//				[{
//		           xtype: 'pagingtoolbar',
//		           store: store,   // same store GridPanel is using
//		           dock: 'bottom',
//		           displayInfo: true
//		       }],
//			this.bbar = new Ext.PagingToolbar( {
//				pageSize : 25,
//				store : this.store,
//				displayInfo : true,
//				beforePageText : '当前',
//				afterPageText : '页/共{0}页',
//				firstText : '首页',
//				lastText : '末页',
//				nextText : '下一页',
//				prevText : '上一页',
//				refreshText : '刷新',
//				displayMsg : '当前显示 {0} - {1}条记录 /共 {2}条记录',
//				emptyMsg : '未找到合适的记录！'
//			});
//		};		
		this.tbar = this.toolbar || [ {
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
		if(!this.skipLoad){
			this.store.load();
		}		
	}
});