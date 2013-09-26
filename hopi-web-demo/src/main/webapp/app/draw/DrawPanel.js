Ext.define('Hopi.draw.DrawPanel', {
	extend : 'Ext.panel.Panel',
	autoScroll : true,
	height:2000,
	width:2000,
	layout : 'absolute',
	addNode : function() {
		var newNode = Ext.create('Hopi.draw.DrawNode', {
			x:100,
			y:100,
			draggable : {
				constrain : true,
				constrainTo : this.getBody()
			},
			floating : {
				shadow : false
			},
			title:'卡卡'
//			draggable  : true,
//			surface:this.canvas.surface
		});
//		newNode.redraw();		
	},
	
	initComponent : function() {
		this.tbar = [ {
			text : '添加节点',
			iconCls : 'icon-create',
			scope : this,
			handler : this.addNode
		} ];		
		this.items = [];
		this.callParent();
	}
})