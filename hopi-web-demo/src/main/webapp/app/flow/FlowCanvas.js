Ext.define('Ado.flow.FlowCanvas', {
	extend : 'Ext.draw.Component',
	width : 2000,
	height : 2000,
	autoSize : true,
	listeners : {
		render:function(p){				
			var me=this;						
			Ext.create('Ext.dd.DropTarget', me.el.dom, {
				ddGroup : this.ddGroup,
				notifyEnter : function(ddSource, e, data) {
					me.el.highlight();
				},
				notifyDrop : function(ddSource, e, data) {					
					var selectedRecord = ddSource.dragData.records[0];
					var nodeId=selectedRecord.raw.id;
					var node=selectedRecord.raw;	
					var pxy=me.el.getXY();
					var mx=e.getXY()[0]-pxy[0];
					var my=e.getXY()[1]-pxy[1];		
					me.addNode({
						nodeId:node.id,
						nodeName:node.text,
						nodeCode:node.code,
						x:mx,
						y:my,						
						width:node.width,
						height:node.height	
					});						
					return true;
				}
			});					
		},
		mousemove : function(e) {
			var surface = this.surface;
			if (surface.lineTag && surface.nodeTag && !surface.lineAt
					&& !surface.lineStart) {// 画线且点中开始节点
				var util = new Ado.flow.DrawUtil();
				if (!surface.linePoly) {
					util.drawSlineMouse(surface, e);
				} else {
					util.drawPlineMouse(surface, e);
				}
				e.stopEvent();
			}
		},
		click : function(e) {
			var surface = this.surface;
			if (surface.lineTag && surface.nodeTag && !surface.lineAt) {
				surface.curLine.remove();
				surface.nodeTag = false;
				e.stopEvent();
			}
		}
	},
	addNode:function(nodeConfig){
//		var node=Ext.create('Ado.flow.FlowNode',nodeConfig);
//		this.add(node);
		console.log(this);
		var newNode = Ext.create('Ado.flow.FlowNode', {
			type : 'rect',
			fill: '#ff0',
			width:80,
			height:40,
			zIndex : 10,
			x : nodeConfig.x,
			y : nodeConfig.y,									
			draggable : true,
			id : 'DrawNode_1',			
			surface : this.surface
		});		
		this.surface.add(newNode);
		newNode.redraw();
	}
});