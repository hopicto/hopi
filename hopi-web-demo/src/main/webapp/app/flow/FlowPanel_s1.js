Ext.define('Ado.flow.FlowPanel', {
	extend : 'Ext.panel.Panel',	
	layout:'border',
//	bodyStyle : 'background-image: url(/images/flow/grid.png)',
	requires : [ 'Ado.flow.DrawNode', 'Ado.flow.DrawLine',
			'Ado.flow.DrawCanvas'],
	initFlow:function(){
		this.addDrawNode(1,50,50);
		this.addDrawNode(2,200,200);		
	},
	addDrawNode:function(type,x,y){
		// 停止画线
		this.canvas.surface.lineTag = false;// 是否画线状态
		this.canvas.surface.nodeTag = false;// 是否已经点中画线的开始节点
		this.canvas.surface.lineAt = false;// 是否已经点中画线的开始节点，且鼠标停留在合适的结束节点上
		if(this.canvas.surface.curLine&&!this.canvas.surface.curLine.endNode){
			this.canvas.surface.curLine.remove();
		}
			
		// 解锁
		this.canvas.surface.items.each(function(item) {
			if (item instanceof Ado.flow.DrawNode) {
				item.dd.unlock();
			}
		});
		
		this.canvas.surface.spriteCount=this.canvas.surface.spriteCount+1;

		var imgSrc,text;
		switch(type){
		case 1:
			imgSrc='images/flow/start.png';
			text='开始';
			break;
		case 2:
			imgSrc='images/flow/end.png';
			text='结束';
			break;
		default:
			imgSrc='images/flow/7.png';
			text='处理环节';			
		}

		var newNode = Ext.create('Ado.flow.DrawNode', {
			type : 'image',
			zIndex : 10,
			x : x,
			y : y,
			width : 42,
			height : 42,
			src : imgSrc,
			text:text,			
			draggable : true,
			id : 'DrawNode_' + this.canvas.surface.spriteCount,
			lines : [],
			surface : this.canvas.surface,
			canvas : this.canvas
		});

		this.canvas.surface.add(newNode);
		newNode.redraw();
				
		var me=this;
		Ext.apply(newNode.dd, {					
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
	addNode : function() {		
		this.addDrawNode(0,100,100);
	},
	save:function(){
		var json='';
		this.canvas.surface.items.each(function(item) {
			if (item instanceof Ado.flow.DrawNode) {
				console.log(item.toJsonString());
			}
		});
		console.log(json);
//		var svg='<?xml version="1.0"?><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"';
//		svg+='"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">'
//		svg+='<svg xmlns="http://www.w3.org/2000/svg" version="1.1" ';						 
//		this.canvas.surface.items.each(function(item) {
//			svg+=item.getSvgString();
//		});
//		svg+='</svg>';
//		console.log(svg);
//		var data=Ext.draw.Surface.save({type:'Svg'},this.canvas.surface);
//		console.log(data);
	},
	addSline : function(item, e) {
		this.canvas.surface.items.each(function(item) {
			if (item instanceof Ado.flow.DrawNode) {
				item.dd.lock();
			}
		});
		this.canvas.surface.lineTag = true;
		this.canvas.surface.linePoly = false;// 非折线
	},
	addPline : function(item, e) {
		this.canvas.surface.items.each(function(item) {
			if (item instanceof Ado.flow.DrawNode) {
				item.dd.lock();
			}
		});
		this.canvas.surface.lineTag = true;
		this.canvas.surface.linePoly = true;
	},
	allowMove : function(item, e) {
		this.canvas.surface.items.each(function(item) {
			if (item instanceof Ado.flow.DrawNode) {
				item.dd.unlock();
			}
		});
		this.canvas.surface.lineTag = false;// 是否画线状态
		this.canvas.surface.nodeTag = false;// 是否已经点中画线的开始节点
		this.canvas.surface.lineAt = false;// 是否已经点中画线的开始节点，且鼠标停留在合适的结束节点上
		
		//清除正在画的线条
		if(this.canvas.surface.curLine&&!this.canvas.surface.curLine.endNode){
			this.canvas.surface.curLine.remove();
		}
	},
	showPosition : function() {
		this.canvas.surface.items.each(function(item) {
			if (item instanceof Ado.flow.DrawNode) {
				console.log('p:' + item.getBBox().x + ',' + item.getBBox().y
						+ ' lines:' + item.lines.length);
				for ( var i = 0; i < item.lines.length; i++) {
					var s = item.lines[i].startNode.getFixBox();
					var e = item.lines[i].endNode.getFixBox();
					console.log('node:'+item.id+' line:' +item.lines[i].id+' i:'+ i + ' s:' + s.x + ' ' + s.y + ' e:'
							+ e.x + ' ' + e.y);
				}
			} else if (item instanceof Ado.flow.DrawLine) {
				var s = item.startNode.getFixBox();
				var e = item.endNode.getFixBox();
				console.log('line:'+item.id + ' s:' + s.x + ' ' + s.y + ' e:' + e.x
						+ ' ' + e.y+' item linePoly='+item.linePoly+' bside='+item.bside+' eside='+item.eside);
			}
		});
		console.log(this.canvas);
	},	
	afterRender:function(){		
//		var keyMap = new Ext.util.KeyMap(this.el, {
//	        key: Ext.EventObject.DELETE,	
//	        scope:this,
//	        fn: function (key,e) {				
//				console.log('delete key pressed');
//			}            
//	    });
		
		this.callParent();	
		this.canvas.surface.spriteCount=0;
//		this.initFlow();
		
	},
	
	initComponent : function() {
		this.spriteCount = 0;
		this.xtbar = [ {
			text : '节点',
			iconCls : 'icon-node',
			scope : this,
			handler : this.addNode
		}, {
			text : '直线',
			iconCls : 'icon-line',
			scope : this,
			handler : this.addSline
		}, {
			text : '折线',
			iconCls : 'icon-line',
			scope : this,
			handler : this.addPline
		}, {
			text : '移动',
			iconCls : 'icon-line',
			scope : this,
			handler : this.allowMove
		}, {
			text : '新建',
			iconCls : 'icon-save',
			scope : this,
			handler : this.initFlow
		},{
			text : '保存',
			iconCls : 'icon-save',
			scope : this,
			handler : this.save
		}, {
			text : '显示信息',
			iconCls : 'icon-line',
			scope : this,
			handler : this.showPosition
		} ];
		this.canvasStore = [];
		var ddGroup='xflowDDGroup';
		this.canvas = Ext.create('Ado.flow.FlowCanvas', {	
			id:'mycanvas',
			ddGroup:ddGroup,
			store : this.canvasStore
		});
		
		this.treeStore = Ext.create('Ext.data.TreeStore', {
			proxy : {
				type : 'ajax',
				url : 'xfFlow.do?method=tree'
			},
			root : {
				text : '根节点',
				draggable : false,
				id : 'TC_1',
				expanded : true
			},
			folderSort : true,
			sorters : [ {
				property : 'text',
				direction : 'ASC'
			} ]
		});
		this.treePanel = Ext.create('Ext.tree.Panel', {			
			region : 'west',
			width:200,
			lines : true,
			border : false,
			style : 'border-right: 1px solid #8db2e3;',
			singleExpand : false,
			useArrows : false,
			autoScroll : true,
			store : this.treeStore,
			viewConfig : {
				plugins : {
					ptype : 'treeviewdragdrop',
					dragGroup : ddGroup,
					enableDrop : false
				}
			}
		});
		this.items = [this.treePanel,{
			region : 'center',
			border : false,
			style : 'border-left: 1px solid #8db2e3;',
			autoScroll : true,
			tbar:this.xtbar,
			items:[this.canvas ]
		} ];
		this.callParent();		
	}
})