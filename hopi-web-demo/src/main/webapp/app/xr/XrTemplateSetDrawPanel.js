/**
 * 模板设置面板
 * 数据结构
 * {
 * 	ddGroup:'XrTemplateSetDraw',
 *  templateId:templateId
 * }
 */
Ext.define('Ado.xr.XrTemplateSetDrawPanel', {
	extend : 'Ext.panel.Panel',	
//	autoScroll : true,
	border : false,
	layout : 'absolute',	
	addModule:function(module){		
		this.moduleSeq++;
		var me=this;
		var addModule=Ext.create('Ado.xr.XrTemplateSetModule',{
			moduleSeq:this.moduleSeq,
			ddGroup:this.ddGroup,
			mainPanel:me.mainPanel,
			moduleId:module.moduleId,
			x:module.x,
			y:module.y,
			moduleName:module.moduleName,
			moduleCode:module.moduleCode,
			width:module.width,
			height:module.height
		});
//		Ext.apply(addModule,module);
		me.add(addModule);		
		me.mainPanel.changeFocus(addModule);
	},
	listeners:{		
		render:function(panel){
			var me=this;						
			Ext.create('Ext.dd.DropTarget', me.body.dom, {
				ddGroup : this.ddGroup,
				notifyEnter : function(ddSource, e, data) {
					me.body.highlight();
				},
				notifyDrop : function(ddSource, e, data) {					
					var selectedRecord = ddSource.dragData.records[0];
					var nodeId=selectedRecord.raw.id;
					var node=selectedRecord.raw;	
					var pxy=me.body.getXY();
					var mx=e.getXY()[0]-pxy[0];
					var my=e.getXY()[1]-pxy[1];		
					me.addModule({
						moduleId:node.id,
						x:mx,
						y:my,
						moduleName:node.text,
						moduleCode:node.code,
						width:node.width,
						height:node.height						
					});					
					return true;
				}
			});				
		}
	},
	initComponent : function() {
		this.ddGroup=this.ddGroup||'XrTemplateSetDraw';
		this.moduleSeq=this.moduleSeq||0;
		this.callParent();
	}
});