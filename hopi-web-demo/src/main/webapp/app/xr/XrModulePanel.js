Ext.define('Ado.xr.XrModulePanel', {
	extend : 'Ext.panel.Panel',
	closable : true,
	autoScroll : true,
	border : false,
	layout : 'border',
	setModule:function(nodeData){
		var centerPanel=this.centerPanel;
		var rightPanel=this.rightPanel;
		this.selectModuleId=nodeData.nodeId;
		rightPanel.setSource({
        	name:nodeData.name,
        	code:nodeData.code,
        	width:nodeData.width,
        	height:nodeData.height
        });	
		rightPanel.setTitle('模块设置：'+nodeData.name);	
	},
	addNode:function(nodeData){		
		var centerPanel=this.centerPanel;
		var rightPanel=this.rightPanel;
		centerPanel.removeAll(true);				
		var image=Ext.create('Ext.Img',{
			src:'xrModule.do?method=view&id='+nodeData.nodeId,
			autoEl:'div',			
		    width: nodeData.width,
		    height: nodeData.height,		    
			nodeId:nodeData.nodeId,
			x : nodeData.x,
			y : nodeData.y,
			draggable:true
		});
		centerPanel.add(image);
		Ext.apply(image.dd,{
			ddGroup : 'xrmoduleDDGroup',
			onDrag:function(e){							
				var me = this,
	            comp = (me.proxy && !me.comp.liveDrag) ? me.proxy : me.comp,
	            offset = me.getOffset(me.constrain || me.constrainDelegate ? 'dragTarget' : null);
	        	comp.setPagePosition(me.startPosition[0] + offset[0], me.startPosition[1] + offset[1]);						        
			}
		});
		this.setModule(nodeData);
		rightPanel.setSource({
        	name:nodeData.name,
        	code:nodeData.code,
        	width:nodeData.width,
        	height:nodeData.height
        });
		rightPanel.setTitle('模块设置：'+nodeData.name);
		centerPanel.setTitle('模块预览：'+nodeData.name);
		this.selectModuleId=nodeData.nodeId;
		this.selectModule=image;
	},
	initComponent : function() {
		this.selectModuleId=null;
		this.selectModule=null;
		this.leftPanel = Ext.create('Ado.xr.XrModuleGridPanel', {
			title : '模块列表',
			region : 'west',
			collapsible : true,
			collapseMode : 'mini',
			style : 'border-right: 1px solid #8db2e3;',
			split : true,
			width:420,
			viewConfig : {
				plugins : {
					ptype : 'gridviewdragdrop',
					dragGroup : 'xrmoduleDDGroup',
					enableDrop : false
				}
			}
		});
		this.centerPanel = Ext.create('Ext.panel.Panel', {
			layout : 'absolute',
			region : 'center',
			autoScroll : true,
			style : 'border-left: 1px solid #8db2e3;border-right: 1px solid #8db2e3;',
			border : false,
			title : '模块预览',
			items : []
		});
		var me=this;
		this.centerPanel.on('render', function() {
			var centerPanel=this.centerPanel;
			this.moduleDDTarget = Ext.create('Ext.dd.DropTarget', centerPanel.body.dom, {
				ddGroup : 'xrmoduleDDGroup',
				notifyEnter : function(ddSource, e, data) {
					centerPanel.body.highlight();
				},
				notifyDrop : function(ddSource, e, data) {					
					var node = ddSource.dragData.records[0];					
					var nodeId=node.get('ID');								
					var pxy=centerPanel.body.getXY();
					var mx=e.getXY()[0]-pxy[0];
					var my=e.getXY()[1]-pxy[1];						
					me.addNode({
						nodeId:nodeId,
						name:node.get('NAME'),
						code:node.get('CODE'),
						x:mx,
						y:my,
						width:node.get('WIDTH'),
						height:node.get('HEIGHT')
					});
					return true;
				}
			});
		}, this);		
		this.rightPanel = Ext.create('Ext.grid.property.Grid', {			
			region : 'east',
			title : '模块设置',
			border : false,
			style : 'border-left: 1px solid #8db2e3;',
			collapsible : true,
			collapseMode : 'mini',
			split : true,			
			width:300,
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
	        	scope:this,
	        	propertychange:function(source,name,value,oldvalue){	        		
	        		if(this.selectModuleId!=null){	        			
	        			var id=this.selectModuleId;
		        		Ext.Ajax.request( {
							url : 'xrModule.do?method=updateProperty',
							params : {
		        				id:id,
								name : name,
								value :value
							},
							method : 'POST',
							success : function(response) {
								var r = Ext.decode(response.responseText);
								if (!r.success) {
									Ext.Msg.alert('提交失败：', r.errors.msg);
								} else {
									this.leftPanel.store.load();
									if(name=='width'){										
										this.selectModule.setWidth(value);										
									}else if(name=='height'){
										this.selectModule.setHeight(value);										
									}
								}
							},
							scope : this
						});	  
	        		}	        		      	
	        	}
	        }
		});
		this.items = [ this.leftPanel, this.centerPanel, this.rightPanel ];
		this.callParent();
	}
});