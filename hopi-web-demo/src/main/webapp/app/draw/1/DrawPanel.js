Ext.define('Hopi.draw.DrawPanel', {
	extend : 'Ext.panel.Panel',
	autoScroll : true,
	layout : 'absolute',
	// listeners : {
	// afterrender : function(panel, width, height, oldWidth,
	// oldHeight, eOpts)
	// {
	// console.log(panel.canvas.surface.items);
	// panel.canvas.surface.items.each(function(item){
	// // console.log(item);
	// item.redraw();
	// console.log(12);
	// });
	// // redraw();
	// },
	// scope : this
	// },
	addNode : function() {
		var newNode = Ext.create('Hopi.draw.DrawNode', {
			x : 30,
			y : 30,
			title : '卡卡',
			draggable : true,
			// draggable : {
			// onDrag : function(e) {
			// console.log(12);
			// }
			// },
			surface : this.canvas.surface
		});
		newNode.redraw();
		newNode.el.on('contextmenu', function(event, target, opts) {
			event.stopEvent();
			var contextmenu = Ext.create('Ext.menu.Menu', {
				items : [ {
					text : '设置属性',
					iconCls : 'icon-edit',
					handler : this.editProps,
					scope : newNode
				} ]
			});
			contextmenu.showAt(event.getXY());
		});
		newNode.dd = new Ext.draw.SpriteDD(newNode, {
			
		});
		newNode.on('beforedestroy', newNode.dd.destroy, newNode.dd);
//		newNode.dd = Ext.create('Hopi.draw.DrawNodeDD', {
//
//		});
		// Ext
		// .apply(
		// newNode.dd,
		// {
		// onDrag: function(e) {
		// console.log(e);
		// var xy = e.getXY(),
		// me = this,
		// sprite = me.sprite,
		// attr = sprite.attr, dx, dy;
		// xy = me.sprite.surface.transformToViewBox(xy[0], xy[1]);
		// dx = xy[0] - me.prev[0];
		// dy = xy[1] - me.prev[1];
		// sprite.setAttributes({
		// translate: {
		// x: attr.translation.x + dx,
		// y: attr.translation.y + dy
		// }
		// }, true);
		// me.prev = xy;
		// },
		// onEndDrag : function(data, e) {
		// var sprite = data.sprite;
		// // sprite.updateLine();
		// // sprite.updateItemsLocation();
		// }
		// });
	},

	initComponent : function() {
		this.tbar = [ {
			text : '添加节点',
			iconCls : 'icon-create',
			scope : this,
			handler : this.addNode
		} ];
		this.canvas = Ext.create('Ext.draw.Component', {
			width : 2000,
			height : 2000,
			autoSize : true,
			items : []
		});

		this.items = [ this.canvas ];
		this.callParent();
	}
})