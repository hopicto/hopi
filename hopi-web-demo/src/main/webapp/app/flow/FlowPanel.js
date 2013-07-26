Ext.define('Ado.flow.FlowPanel', {
	extend : 'Ext.panel.Panel',	
	layout:'border',
//	bodyStyle : 'background-image: url(/images/flow/grid.png)',	
	initComponent : function() {
		this.spriteCount = 0;
		this.xtbar = [ {
			text : '节点',
			iconCls : 'icon-node',
			scope : this,
			handler : this.addNode
		}, {
			text : '直线',
			iconCls : 'icon-line',
			scope : this,
			handler : this.addSline
		}, {
			text : '折线',
			iconCls : 'icon-line',
			scope : this,
			handler : this.addPline
		}, {
			text : '移动',
			iconCls : 'icon-line',
			scope : this,
			handler : this.allowMove
		}, {
			text : '新建',
			iconCls : 'icon-save',
			scope : this,
			handler : this.initFlow
		},{
			text : '保存',
			iconCls : 'icon-save',
			scope : this,
			handler : this.save
		}, {
			text : '显示信息',
			iconCls : 'icon-line',
			scope : this,
			handler : this.showPosition
		} ];
		this.canvasStore = [];
		var ddGroup='xflowDDGroup';
		this.canvas = Ext.create('Ado.flow.FlowCanvas', {	
			id:'mycanvas',
			ddGroup:ddGroup,
			store : this.canvasStore
		});
		
		this.treeStore = Ext.create('Ext.data.TreeStore', {
			proxy : {
				type : 'ajax',
				url : 'xfFlow.do?method=tree'
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
			region : 'west',
			width:200,
			lines : true,
			border : false,
			style : 'border-right: 1px solid #8db2e3;',
			singleExpand : false,
			useArrows : false,
			autoScroll : true,
			store : this.treeStore,
			viewConfig : {
				plugins : {
					ptype : 'treeviewdragdrop',
					dragGroup : ddGroup,
					enableDrop : false
				}
			}
		});
		this.flowDrawPanel=Ext.create('Ado.flow.FlowDrawPanel', {			
			region : 'center'
		});
		this.items = [this.treePanel,this.flowDrawPanel];
		this.callParent();		
	}
})