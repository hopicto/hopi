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
//	extend : 'Ext.Component',
	extend : 'Ext.panel.Panel',
	draggable:true,
	listeners:{		
		render:function(){
			var me=this;
			Ext.apply(me.dd,{
				ddGroup : me.ddGroup,
				onDrag:function(e){							
					var me = this,
		            comp = (me.proxy && !me.comp.liveDrag) ? me.proxy : me.comp,
		            offset = me.getOffset(me.constrain || me.constrainDelegate ? 'dragTarget' : null);
		        	comp.setPagePosition(me.startPosition[0] + offset[0], me.startPosition[1] + offset[1]);						        
				}
			});			
		},
		dblclick:function(e,a){
			e.stopEvent();										
			console.log('dblclick');
//			rightPanel.setSource({
//	        	name:nodeData.name,
//	        	code:nodeData.code,
//	        	width:nodeData.width,
//	        	height:nodeData.height
//	        });	
//			rightPanel.setTitle('模块设置：'+nodeData.name);						
		},
        contextmenu: function(e,a) {
            e.stopEvent();
            console.log('contextmenu');
//            var contextmenu = new Ext.menu.Menu( {
//				items : [ {
//					text : '模块设置',
//					iconCls : 'icon-edit',
//					handler : function(){
//						rightPanel.setSource({
//				        	name:nodeData.name,
//				        	code:nodeData.code,
//				        	width:nodeData.width,
//				        	height:nodeData.height
//				        });	
//						rightPanel.setTitle('模块设置：'+nodeData.name);	
//					},
//					scope : this
//				} ]
//			});
//            contextmenu.showAt(e.getXY());
        }
	},
	initComponent : function() {
		console.log('this.moduleId='+this.moduleId);
		console.log('this.moduleSeq='+this.moduleSeq);
		console.log('this.moduleName='+this.moduleName);
		console.log('this.moduleCode='+this.moduleCode);
		console.log('this.width='+this.width);
		console.log('this.height='+this.height);
		console.log('this.x='+this.x);
		console.log('this.y='+this.y);
		this.img=Ext.create('Ext.Img',{
			src:'xrModule.do?method=view&id='+this.moduleId,
			width:this.width,
			height:this.height
		});		
		this.items=[this.img];
		this.callParent();
	}
});