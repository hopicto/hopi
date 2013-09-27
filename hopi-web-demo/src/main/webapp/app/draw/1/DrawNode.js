Ext.define('Hopi.draw.DrawNode', {
	extend : 'Ext.draw.Sprite',
	group : 'drawNodeGroup',	
	className:'icon-edit',
//	initDraggable: function() {
//        var me = this;
//        if (!me.el) {
//            me.surface.createSpriteElement(me);
//        }
//        me.dd = new Ext.draw.SpriteDD(me, Ext.isBoolean(me.draggable) ? null : me.draggable);
//        me.on('beforedestroy', me.dd.destroy, me.dd);
//    },
	fixBBox:function(width,height){
		if(height>this.height-this.header.height){
			this.setAttributes({
				height:height+this.header.height
			},true);
		}
	},
	redraw : function() {
		this.callParent();
		this.header.redraw();
		this.content.redraw();		
	},
	showWin : function(title) {
		this.win = Ext.create('Hopi.common.PopupFormWindow', {
			mainPanel : this,
			width : 320,
			title : title
		});
		this.win.show();
	},
	editProps:function(){
		
	},
	listeners : {
		render:function(comp){
//			console.log('render');
			
//			Ext.apply(comp.dd, {					
//				onDrag: function(e) {
//					var xy = e.getXY(),
//		            me = this,
//		            sprite = me.sprite,
//		            attr = sprite.attr, dx, dy;
//			        xy = me.sprite.surface.transformToViewBox(xy[0], xy[1]);
//			        dx = xy[0] - me.prev[0];
//			        dy = xy[1] - me.prev[1];
//			        sprite.setAttributes({
//			            translate: {
//			                x: attr.translation.x + dx,
//			                y: attr.translation.y + dy
//			            }
//			        }, true);
//			        me.prev = xy;
//			    },
//				onEndDrag : function(data, e) {
//					var sprite = data.sprite;				
////					sprite.updateLine();
////					sprite.updateItemsLocation();				
//				}
//			});	
		},
//		click : function(curNode, e) {
//			e.stopEvent();
//			console.log(111);
//			this.setAttributes({
//				stroke : 'red',
//				'stroke-width' : 1.5
//			},true);
//		},		
		scope : this
	},
	constructor : function(config) {
		Ext.apply(config, {
//			draggable  : true,
			type : 'rect',
			width : 100,
			height : 50,
			radius : 10,
			zIndex :100,
			fill : 'white',
			opacity : 0.5,
			stroke : 'blue',
			'stroke-width' : 1
		});
		this.callParent([ config ]);

		var bbox = this.getBBox();
		this.header= Ext.create('Hopi.draw.DrawNodeHeader', {
			surface:this.surface,
			parent:this,
			text:this.title,
			x : bbox.x + 10,
			y : bbox.y + 10
			
		});
		this.content= Ext.create('Hopi.draw.DrawNodeContent', {
			surface:this.surface,
			parent:this,
			x : bbox.x + 5,
			y : bbox.y + 30,
			data:[ {
				name : 'test1',
				type : 'kaka',
				key : ''
			}, {
				name : 'test2',
				type : 'kaka',
				key : ''
			} ]
		});
		
		
	}
});