Ext.define('Ado.flow.FlowMixSprite', {
	extend : 'Ext.draw.Sprite',	
	type : 'rect',		
	zIndex : 10,			
	font : '12px sans-serif',
	x : fx,
	y : pbox.y + pbox.height + this.textHeight
	initComponent : function() {
		
		this.callParent();
	},	
	listeners : {
		render:function(comp){
			Ext.apply(comp.dd, {					
				onDrag: function(e) {
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
					sprite.updateLine();
					sprite.updateItemsLocation();				
				}
			});	
		},
		mouseover : function(curNode, e) {
			var surface = curNode.surface;
			surface.isMouseOverItem = true;
			surface.mouseOverItem = curNode;
			if (surface.lineAt || surface.lineStart) {
				return;
			}
			if (surface.lineTag && surface.nodeTag
					&& surface.startNode.id == curNode.id) {
				surface.lineStart = true;
				surface.curLine.hide(true);
			}

			if (surface.lineTag && surface.nodeTag
					&& surface.startNode != curNode && !surface.lineAt) {
				surface.lineAt = true;
				var line = surface.curLine;
				line.endNode = curNode;
				var util = new Ado.flow.DrawUtil();
				if (surface.linePoly) {// 确定终点的边
					var x2 = e.getX() - surface.getRegion().left;
					var y2 = e.getY() - surface.getRegion().top;
					var bxy = curNode.getBBox();
					var x1 = bxy.x + bxy.width / 2;
					var y1 = bxy.y + bxy.height / 2;
					var yy = y2 - y1;
					var xx = x2 - x1;
					var h = Math.abs(yy) - Math.abs(xx);
					var side = 0;
					if (h > 0) {// 靠近上下边
						side = yy > 0 ? 3 : 1;
					} else {// 靠近左右边
						side = xx > 0 ? 2 : 4;
					}
					line.eside = side;
					util.drawPlineNode(line, line.startNode.getFixBox(),
							curNode.getFixBox());
					line.show();
				} else {
					util.drawSlineNode(line, line.startNode.getFixBox(),
							curNode.getFixBox());
					line.show();
				}
			}
		},
		mouseout : function(curNode, e) {
			var surface = curNode.surface;
			surface.isMouseOverItem = false;
			if (surface.lineAt) {
				surface.lineAt = false;
			}

			if (surface.lineStart) {
				surface.lineStart = false;
			}

			if (surface.linePoly && surface.nodeTag
					&& surface.startNode.id == curNode.id) {// 折线切点中起点
				var x = surface.getRegion().left;
				var y = surface.getRegion().top;
				var bxy = curNode.getFixBox();
				var x1 = bxy.x + bxy.width / 2;
				var y1 = bxy.y + bxy.height / 2;
				var x2 = e.getX() - x;
				var y2 = e.getY() - y;

				var abx = Math.abs(x2 - x1);
				var aby = Math.abs(y2 - y1);

				var side = 0;
				if (abx >= bxy.width / 2) {
					side = x2 > x1 ? 2 : 4;
				} else {
					side = y2 > y1 ? 3 : 1;
				}
				surface.curLine.bside = side;// 确定离开起始节点的边，按顺时间方向1、2、3、4
			}
			e.stopEvent();
		},
		click : function(curNode, e) {
			if (curNode.surface.lineTag) {// 画线状态
			var surface = curNode.surface;
			if (!surface.nodeTag) {// 未点中开始节点
				var bxy = curNode.getBBox();
				surface.startNode = curNode;
				surface.spriteCount=surface.spriteCount+1;				
				var newLine = Ext.create('Ado.flow.DrawLine', {
					id:'DrawLine_'+surface.spriteCount,
					type : 'path',
					stroke : '#555',
					"stroke-width" : 1,
					path : 'M0 0L0 0',
					surface : surface
				});

				newLine.startNode = curNode;
				surface.curLine = newLine;
				surface.curLine.linePoly = surface.linePoly;
				surface.nodeTag = true;
				e.stopEvent();
			} else if (curNode.surface.lineTag && curNode.surface.nodeTag) {
				var surface = curNode.surface;
				var line = surface.curLine;
				if (surface.startNode.id != curNode.id) {
					if (curNode.haveLine(line)) {
						line.remove();
					} else {						
						curNode.lines.push(line);
						line.startNode.lines.push(line);
					}

					// 清楚状态标志
					surface.nodeTag = false;
					surface.lineAt = false;
					surface.lineStart = false;
				}
			}
		}
	}
	}
});