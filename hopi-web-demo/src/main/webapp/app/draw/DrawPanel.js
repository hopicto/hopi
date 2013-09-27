Ext.define('Hopi.draw.DrawPanel', {
	extend : 'Ext.panel.Panel',
	autoScroll : true,
	layout : 'absolute',	
	addNode : function() {		
		var graph = new joint.dia.Graph();
//		console.log(this.canvas.getEl().id);
		var paper = new joint.dia.Paper({
		    el: $('joint-paper'),
		    width: 2000,
		    height:2000,
		    model: graph
		});
		
		var rect = new joint.shapes.basic.Rect({
		    position: { x: 100, y: 30 },
		    size: { width: 100, height: 30 },
		    attrs: { rect: { fill: 'blue' }, text: { text: 'my box', fill: 'white' } }
		});
		
		var rect2 = rect.clone();
		rect2.translate(300);

		var link = new joint.dia.Link({
		    source: { id: rect.id },
		    target: { id: rect2.id }
		});
		graph.addCells([rect, rect2, link]);
	},
//	render:function(){
////		this.graph = new joint.dia.Graph;
//		this.paper = new joint.dia.Paper({
//		    el: this.canvas.el,
//		    width: 600,
//		    height: 200,
//		    model: this.graph
//		});
//		this.callParent();
//	},
	initComponent : function() {
		this.tbar = [ {
			text : '添加节点',
			iconCls : 'icon-create',
			scope : this,
			handler : this.addNode
		} ];
//		this.canvas = Ext.create('Ext.panel.Panel', {
//			width : 2000,
//			height : 2000,
//			layout : 'absolute',
//			border:false,
//			items : []
//		});
		
//		this.items = [ this.canvas ];
//		this.items=[{
//			id:'joint-paper'				
//		}];
		this.html='<div id="joint-paper"></div>';
		this.callParent();
		
	}
})