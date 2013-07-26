Ext.define('Ado.rup.PhotoViewPanel', {
	extend : 'Ext.panel.Panel',
	closable : true,
	border : false,
	layout : 'border',
	idProperty : 'ID',
	initComponent : function() {
		this.westPanel = Ext.create('Ext.tree.Panel', {
			title : '目录',
			region : 'west',
			width : 200,
			minSize : 120,
			maxSize : 360,
			lines : true,
			singleExpand : false,
			useArrows : false,
			collapsible : true,
			collapseMode : 'mini',
			split : true,
			autoScroll : true,
			margins : '0 0 5 5',
			rootVisible : false,
			store : Ext.create('Ext.data.TreeStore', {
				proxy : {
					type : 'ajax',
					url : 'photoView.do?method=tree'
				},
				root : {
					text : '目录',
					id : 1,
					expanded : true
				}
			}),
			listeners : {
				itemclick : function(view, node, item, index, e, o) {
					e.stopEvent();
					this.photoStore.proxy.extraParams = {
						path : node.raw.id
					};
					this.photoStore.load( {
						params : {
							start : 0
						}
					});
				},
				scope : this
			}
		});

		this.photoStore = Ext.create('Ext.data.Store', {
			idProperty : 'id',
			fields : [ 'id', 'name', 'url' ],
			proxy : {
				type : 'ajax',
				url : 'photoView.do?method=store',
				reader : {
					type : 'json',
					totalProperty : 'totalCount',
					root : 'list'
				}
			},
			listeners : {
				scope : this,
				load : function(s,rs) {					
					if(rs.length>0){
//						console.log(rs[0].data.url);
						this.photoView.setSrc(rs[0].data.url);
					}else{
						this.photoView.setSrc('/css/images/over.gif');
					}
				}
			}
		});

		this.minPhotoListView = Ext.create('Ext.view.View', {
			id : 'images-view',
			height : 200,
			store : this.photoStore,
			trackOver : true,
			overItemCls : 'x-item-over',
			itemSelector : 'div.thumb-wrap',
			tpl : Ext.create('Ext.XTemplate', '<tpl for=".">',
					'<div class="thumb-wrap">',
					'<img src="{url}" height=160 width=200/>', '</div>',
					'</tpl>'),
			listeners : {
				scope : this,
				itemclick : function(v, r, item) {
					console.log(r);
					console.log(item);
				}
			}
		});
		this.photoView = Ext.create('Ext.Img', {
			src : '/css/images/over.gif'
		});
		this.viewPanel = Ext.create('Ext.panel.Panel', {
			title : '图片查看',
			region : 'center',
			layout : 'border',
			items : [ {
				region : 'center',
				border : false,
				items : [ this.photoView ]
			}, {
				region : 'south',
				border : false,
				style : 'border-top: 1px solid #8db2e3;',
				items : [ this.minPhotoListView ],
				bbar : Ext.create('Ext.toolbar.Paging', {
					pageSize : 5,
					store : this.photoStore,
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
				})
			} ]
		});
		this.items = [ this.westPanel, this.viewPanel ];
		this.callParent();
		this.photoStore.load();
	}
});