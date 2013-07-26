/**
 * 模板模块数据结构
 * {
 *  templateId:模板ID,
 *  moduleId:模块ID,
 *  moduleName:模块名称,
 *  moduleCode:模块编码,
 *  x:x,
 *  y:y,
 *  width:width,
 *  height:height
 *  }
 */
Ext.define('Ado.xr.XrTemplateSetModule', {
	extend : 'Ext.container.Container',	
	resizable:{
		handles: 'se',
		listeners:{			
			resize:function(r,w,h,e){
				var me=r.target;
				me.setModuleWidth(w);
				me.setModuleHeight(h);
				me.mainPanel.propertyPanel.loadData(me);
			}
		}
	},
	draggable : {
		ddGroup : this.ddGroup,		
		onDrag : function(e) {
			var me = this, comp = (me.proxy && !me.comp.liveDrag) ? me.proxy
					: me.comp, offset = me.getOffset(me.constrain
					|| me.constrainDelegate ? 'dragTarget' : null);
			comp.setPagePosition(me.startPosition[0] + offset[0],
					me.startPosition[1] + offset[1]);
		}
	},	
	setModuleWidth:function(width){		
		this.img.setWidth(width);
		this.setWidth(width);
	},
	setModuleHeight:function(height){
		this.img.setHeight(height);
		this.setHeight(height);		
	},
	unHighLight:function(){
		this.img.removeCls('xrTemplateModuleHighLight');
	},
	highLight:function(){
		this.img.addCls('xrTemplateModuleHighLight');
	},
	initComponent : function() {		
		var me=this;
		this.img = Ext.create('Ext.Img', {
			src : 'xrModule.do?method=view&id=' + this.moduleId,
			width : this.width,
			height : this.height,			
			listeners : {
				scope : this,
				el : {	
//					mouseover:function(e,a){
//						this.addCls('xrTemplateModuleHighLight');
//					},
//					mouseout:function(e,a){
//						this.removeCls('xrTemplateModuleHighLight');
//					},
					click:function(e,a){
//						this.addCls('xrTemplateModuleHighLight');
						me.mainPanel.changeFocus(me);
					},
//					dblclick : function(e, a) {
//						e.stopEvent();						
//						me.mainPanel.changeFocus(me);
//					},
					contextmenu : function(e, a) {
						e.stopEvent();						
						var contextmenu = new Ext.menu.Menu( {
							items : [ {
								text : '模块设置',
								iconCls : 'icon-edit',
								handler : function() {
									me.mainPanel.changeFocus(me);
								},
								scope : this
							} ]
						});
						contextmenu.showAt(e.getXY());
					}			
				}
			}
		});
		this.items = [ this.img ];
		this.callParent();
	}
});
