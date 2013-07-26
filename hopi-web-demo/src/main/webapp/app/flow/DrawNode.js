Ext.define('Ado.flow.DrawNode', {
	extend : 'Ext.draw.Sprite',
	group : 'drawNodeGroup',	
	constructor : function(config) {
		this.callParent( [ config ]);
		var pbox = this.getBBox();
		this.textHeight = 10;
//		this.defaultText='分管领导审批';
		var text=this.text||'分管领导审批'
		var fx=pbox.x-text.length*6+21;
		this.textSprite = this.surface.add( {
			type : 'text',
			text : text,
//			"text-anchor": "middle",			
			zIndex : 10,			
			font : '12px sans-serif',
			x : fx,
			y : pbox.y + pbox.height + this.textHeight
		});		
	},	
	toJsonString:function(){		
		return Ext.JSONView.encode(this.textSprite);
	},
	remove: function() {
        if (this.surface) {
        	this.textSprite.remove();        	
    		for ( var i = 0; i < this.lines.length; i++) {		
    			var li=this.lines[i];    			
    			if(li.startNode==this){ 
    				for(var j=0;j<li.endNode.lines.length;j++){
    					if(li.id==li.endNode.lines[j].id){
    						li.endNode.lines.splice(j,1);
    						break;
    					}
    				}
    			}else{    				
    				for(var j=0;j<li.startNode.lines.length;j++){
    					if(li.id==li.startNode.lines[j].id){
    						li.startNode.lines.splice(j,1);
    						break;
    					}
    				}
    			}    
    			li.textSprite.remove();
    			this.surface.remove(li);     			
    		}	
            this.surface.remove(this);            
            return true;
        }
        return false;
    },
	edit : function(e) {
		if (!this.win) {
			if (!this.fp) {
				this.fp = Ext.create('Ext.form.Panel', {
					border : false,
					bodyPadding: 5,
					layout: 'anchor',
					buttonAlign:'center',
					defaultType : 'textfield',
					items : [ {
						fieldLabel : '节点名称',
						name : 'NAME'
					} ],					
					buttons : [ {
						text : '确定',							
						scope : this,
						handler : function(){
//							console.log(this.textSprite.getBBox().height);
							var name=this.fp.getForm().findField('NAME').getValue();
							var pbox = this.getBBox();							
							var fx=pbox.x-name.length*6+21;
							this.textSprite.text=name;
							this.textSprite.setAttributes( {								
								x : fx,
								y : pbox.y + pbox.height + this.textHeight,
								text:name
							}, true);							
							
							this.win.close();							
						}
					} ]
				});
			}
			var pbox = this.getBBox();
			this.win = Ext.create('Ext.window.Window', {
				title : '设置节点',
				height : 100,
				width : 300,
				x:pbox.x+pbox.width+50,
				y:pbox.y+50,
				layout : 'fit',
				items : [ this.fp ]
			});
			this.win.on('close', function() {
				this.win = null;
				this.fp = null;
			}, this);			
		}		
		this.fp.getForm().findField('NAME').setValue(this.textSprite.text);	
		this.win.show();
	},
	getFixBox : function() {
		var pbox = this.getBBox();
		return {
			x : pbox.x,
			y : pbox.y,
			width : pbox.width,
			height : pbox.height + this.textHeight+5
		};
	},
	updateItemsLocation : function() {// 更新内部元素位置
		var pbox = this.getBBox();		
		var fx=pbox.x-this.textSprite.text.length*6+21;	
		this.textSprite.setAttributes( {								
			x : fx,
			y : pbox.y + pbox.height + this.textHeight
		}, true);
	},
	redrawItems : function() {// 重画内部元素
		this.textSprite.redraw();
	},
	redraw : function() {
		this.callParent();
		this.redrawItems();
	},
	haveLine : function(line) {
		for ( var i = 0; i < this.lines.length; i++) {
			if (this.lines[i].equal(line)) {
				return true;
			}
		}
		return false;
	},
	updateLine : function() {
		for ( var i = 0; i < this.lines.length; i++) {
			this.lines[i].updatePath();
		}
	},
	listeners : {
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