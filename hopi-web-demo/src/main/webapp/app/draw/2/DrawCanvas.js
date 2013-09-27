Ext.define('Hopi.draw.DrawCanvas', {
	extend : 'Ext.draw.Component',	
	requires: ['Hopi.draw.DrawUtil'],
	width:2000,
	height:2000,
//	autoScroll:true,
	autoSize: true,
	listeners:{			
		mousemove:function(e){					
			var surface=this.surface;			
			if(surface.lineTag && surface.nodeTag && !surface.lineAt && !surface.lineStart){// 画线且点中开始节点
				var util=new Hopi.draw.DrawUtil();
				if(!surface.linePoly){					
					util.drawSlineMouse(surface,e);
				}else{
					util.drawPlineMouse(surface,e);
				}
				e.stopEvent();
			}						
		},
		click:function(e){
			var surface=this.surface;			
			if(surface.lineTag && surface.nodeTag && !surface.lineAt){
				surface.curLine.remove();
				surface.nodeTag=false;
				e.stopEvent();
			}			
		},			
		contextmenu:{	
			element: 'el',			
			fn:function(e){//bug：此处会运行3次
				e.stopEvent();				
				var me=Ext.getCmp(this.id);										
				if(me.surface.isMouseOverItem){
					var item=me.surface.mouseOverItem;
					var cm = new Ext.menu.Menu( {
						items : [ {
							text : '设置',
							iconCls : 'icon-edit',
							handler : item.edit,
							scope : item
						},{
							text : '删除',
							iconCls : 'icon-delete',
							handler : item.remove,
							scope : item
						}]
					});
					cm.showAt(e.getXY());
				}								
			}						
		}
	}	
});