Ext.define('Hopi.draw.DrawPanel', {
	extend : 'Ext.panel.Panel',
	autoScroll : true,
	addNode : function() {
//		var newNode = Ext.create('Hopi.draw.DrawNode', {
//			x : 100,
//			y : 100,
////			draggable: {
////	            constrain: true,
////	            constrainTo: this.canvas.getBody()
////	        },
//	        floating: {
//	            shadow: false
//	        },
//			title : '卡卡'
//		});
		var newNode=Ext.create('Ext.draw.Component', {
			x:30,
			y:30,
			width: 100,
	        height: 100,
//	        renderTo: Ext.getBody(),
	        items: [{
	        	type : 'rect',
	    		width : 100,
	    		height : 50,
	    		radius : 10,
	    		zIndex : 1,
	    		opacity : 0.5,
	    		stroke : 'blue',
	    		'stroke-width' : 1
	        }]
		});
		this.canvas.add(newNode);
		newNode.surface.redraw();
	},

	initComponent : function() {
		this.tbar = [ {
			text : '添加节点',
			iconCls : 'icon-create',
			scope : this,
			handler : this.addNode
		} ];
		
		this.canvas = Ext.create('Ext.panel.Panel', {
			layout : 'absolute',
			border:false,
			bodyCls:'hopi-grid',
			height:2000,
			width:2000,
			items:[]
		});
		this.items = [this.canvas];
		this.callParent();
	}
})