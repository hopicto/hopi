Ext.define('Ado.xr.XrTemplateSetPanel', {
	extend : 'Ext.panel.Panel',
	closable : true,
	autoScroll : true,
	border : false,
	layout : 'border',
	saveDrawData:function(){		
		Ext.Ajax.request( {
			url : 'xrTemplate.do?method=saveSetData',
			params : {
				id : this.extprop.templateId,
				data:this.genDrawData()
			},
			method : 'POST',
			success : function(response) {
				var r = Ext.decode(response.responseText);
				if (!r.success) {
					Ext.Msg.alert('保存失败：', r.errors.msg);
				} else {					
					Ext.Msg.alert('保存成功!');
				}
			},
			scope : this
		});
	},
	genDrawData:function(){
		var resultData='[';
		this.drawPanel.items.each(function(item){
			var nodeData="{'moduleId':"+item.moduleId+",'x':"+item.x+",'y':"+item.y+",'width':"+item.width+",'height':"+item.height+",'moduleName':'"+item.moduleName+"','moduleCode':'"+item.moduleCode+"'},";
			resultData+=nodeData;
		});
		if(resultData.length>1){
			resultData=resultData.substring(0,resultData.length-1)+']';
		}else{
			resultData='[]';
		}
		return resultData;
	},
	viewDrawData:function(){				
		console.log(this.genDrawData());
	},	
	removeDrawData:function(){
		if(this.selectedModule!=null){
			this.drawPanel.remove(this.selectedModule);			
			this.selectedModule=null;
			this.clearFocus();
		}		
	},
	removeAllDrawData:function(){
		this.drawPanel.removeAll(true);
		this.clearFocus();
	},
	changeFocus:function(module){
		if(this.selectedModule!=module){
			this.propertyPanel.loadData(module);	
			this.selectedModule=module;
			this.drawPanel.items.each(function(item){
				item.unHighLight();
			});
			module.highLight();
		}				
	},
	clearFocus:function(){
		this.selectedModule=null;
		this.propertyPanel.clearData();
	},
	initComponent : function() {
		var ddGroup='XrTemplateSetDraw';
		var templateId = this.extprop.templateId;
		this.treeStore = Ext.create('Ext.data.TreeStore', {
			proxy : {
				type : 'ajax',
				url : 'xrModule.do?method=tree'
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
			region : 'center',
			lines : true,
			border : false,
			style : 'border-bottom: 1px solid #8db2e3;',
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
		this.propertyPanel=Ext.create('Ext.grid.property.Grid', {			
			region : 'south',
			title : '模块设置',
			border : false,
			style : 'border-top: 1px solid #8db2e3;',
			collapsible : true,
			collapseMode : 'mini',
			split : true,			
			height:160,		
			currentModule:null,
			loadData:function(module){						
				this.setSource({
		        	name:module.moduleName,
		        	code:module.moduleCode,
		        	width:module.width,
		        	height:module.height
		        });	
				this.setTitle('模块设置：'+module.moduleName);	
				this.currentModule=module;
			},
			clearData:function(){
				this.currentModule=null;
				this.setSource({
		        	name:'',
		        	code:'',
		        	width:0,
		        	height:0
		        });	
			},
			propertyNames: {
	            name: '名称',
	            code: '编码',
	            width: '宽度',
	            height: '高度'
	        },
	        source: {
	        	name:'模块名称',
	        	code:'模块编码',
	        	width:0,
	        	height:0
	        },
	        listeners:{	        	
	        	propertychange:function(source,name,value,oldvalue){	        		  		
	        		if(this.currentModule!=null){
	        			if(name=='width'){
	        				this.currentModule.setModuleWidth(value);
	        			}else if(name=='height'){
	        				this.currentModule.setModuleHeight(value);
	        			}
	        		}
	        	}
	        }
		});
		this.drawDataStore = Ext.create('Ext.data.Store', {
			idProperty : 'ID',
			fields : [ 'ID', 'NAME','VIEW_DATA'],
			autoLoad : true,
			listeners : {
				scope : this,
				load : function(store, records, success) {					
					if (success && records.length > 0) {
						var data=records[0];
						var name=data.get('NAME');
						var viewData=data.get('VIEW_DATA');
						var vd=Ext.JSON.decode(viewData);
						for(var i=0;i<vd.length;i++){
//							this.addNode(vd[i]);							
							this.drawPanel.addModule({
								moduleId:vd[i].moduleId,
								x:vd[i].x,
								y:vd[i].y,
								moduleName:vd[i].moduleName,
								moduleCode:vd[i].moduleCode,
								width:vd[i].width,
								height:vd[i].height
							});
						}				
					}
				}
			},
			proxy : {
				type : 'ajax',
				url : 'xrTemplate.do?method=loadData',
				extraParams : {
					id : templateId
				},
				reader : {
					type : 'json',
					root : 'data'
				}
			}
		});
		this.drawPanel = Ext.create('Ado.xr.XrTemplateSetDrawPanel', {			
			border : false,
			autoScroll : true,
			style : 'border-left: 1px solid #8db2e3;',
			region : 'center',			
			ddGroup:ddGroup,
			templateId:templateId,
			height:2000,
			mainPanel:this,
			tbar:[ {
				text : '保存',
				iconCls : 'icon-save',
				scope : this,
				handler : this.saveDrawData
			}, '-',{
				text : '查看',
				iconCls : 'icon-view',
				scope : this,
				handler : this.viewDrawData
			}, '-',{
				text : '删除',
				iconCls : 'icon-delete',
				scope : this,
				handler : this.removeDrawData
			}, '-',{
				text : '清空',
				iconCls : 'icon-delete',
				scope : this,
				handler : this.removeAllDrawData
			}]
		});		
		this.items = [{
			layout:'border',
			region:'west',
			width:300,
			border:false,
			title : '组件',
			style : 'border-right: 1px solid #8db2e3;',
			collapsible : true,
			collapseMode : 'mini',
			split : true,
			items:[this.treePanel,this.propertyPanel]
		},this.drawPanel];
		this.callParent();
	}
});