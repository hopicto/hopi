Ext.define('Ado.flow.FlowDrawPanel', {
	extend : 'Ext.panel.Panel',	
	autoScroll:true,
	addNode : function() {
		var node1=Ext.create('Ado.flow.FlowNode', {	       
	        x:50,
	        y:50,
	        surface:this.canvas.surface	       
		});	
//		var node1=Ext.create('Ext.draw.Sprite', {	       
//	        x:50,
//	        y:50,
//	        type : 'rect',		
//	    	width : 80,
//	    	height : 40,			
//	    	draggable : true,		
//	    	stroke:'#00F',
//	        fill:'#ff0'
//		});			
		this.canvas.surface.add(node1);	      
		node1.redraw();
	},
	initComponent : function() {
		this.tbar = [ {
			text : '节点',			
			scope : this,
			handler : this.addNode
		} ];
		this.canvas=Ext.create('Ext.draw.Component', {	
			id:'mycanvas',
	        width:2000,
	    	height:2000,
	    	autoSize: true
		});	
		this.items=[this.canvas];
		this.callParent();
	}
})