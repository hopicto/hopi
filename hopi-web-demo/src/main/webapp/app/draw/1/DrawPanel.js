Ext.define('Hopi.draw.DrawPanel', {
	extend : 'Ext.panel.Panel',
	autoScroll : true,
	layout : 'absolute',
	addNode : function() {
		var newNode = Ext.create('Hopi.draw.DrawNode', {
			x:100,
			y:100,
			title:'卡卡',
			draggable  : true,
			surface:this.canvas.surface
		});
		newNode.redraw();
		Ext.apply(newNode.dd, {					
			onDrag: function(e) {
				console.log(12);
				var xy = e.getXY(),
	            me = this,
	            sprite = me.sprite,
	            attr = sprite.attr, dx, dy;
		        xy = me.sprite.surface.transformToViewBox(xy[0], xy[1]);
		        dx = xy[0] - me.prev[0];
		        dy = xy[1] - me.prev[1];
		        sprite.setAttributes({
		            translate: {
		                x: attr.translation.x + dx,
		                y: attr.translation.y + dy
		            }
		        }, true);
		        me.prev = xy;
		    },
			onEndDrag : function(data, e) {
				var sprite = data.sprite;				
//				sprite.updateLine();
//				sprite.updateItemsLocation();				
			}
		});		
	},
	
	initComponent : function() {
		this.tbar = [ {
			text : '添加节点',
			iconCls : 'icon-create',
			scope : this,
			handler : this.addNode
		} ];
		this.canvas = Ext.create('Ext.draw.Component', {
			width:2000,
			height:2000,
			autoSize: true,
			items:[]
		});
		
		this.items = [this.canvas];
		this.callParent();
	}
})