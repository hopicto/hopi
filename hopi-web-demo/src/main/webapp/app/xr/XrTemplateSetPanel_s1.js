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
			var nodeData="{'nodeId':"+item.nodeId+",'x':"+item.x+",'y':"+item.y+"},";
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
	addNode:function(nodeData){
		var drawPanel=this.drawPanel;
		var rightPanel=this.propertyPanel;
		var image=Ext.create('Ext.Img',{
			src:'xrModule.do?method=view&id='+nodeData.nodeId,
			autoEl:'div',
//			constrain: true,
//			floating:true,
			nodeId:nodeData.nodeId,
			x : nodeData.x,
			y : nodeData.y,
			draggable:true,
			listeners: {
				scope:this,
		        el: {
					dblclick:function(e,a){
						e.stopEvent();												
						rightPanel.setSource({
				        	name:nodeData.name,
				        	code:nodeData.code,
				        	width:nodeData.width,
				        	height:nodeData.height
				        });	
						rightPanel.setTitle('模块设置：'+nodeData.name);						
					},
		            contextmenu: function(e,a,b,c) {
		                e.stopEvent();
		                var contextmenu = new Ext.menu.Menu( {
							items : [ {
								text : '模块设置',
								iconCls : 'icon-edit',
								handler : function(){
									rightPanel.setSource({
							        	name:nodeData.name,
							        	code:nodeData.code,
							        	width:nodeData.width,
							        	height:nodeData.height
							        });	
									rightPanel.setTitle('模块设置：'+nodeData.name);	
								},
								scope : this
							} ]
						});
		                contextmenu.showAt(e.getXY());
		            }
		        }
	    	}
		});
		drawPanel.add(image);
		Ext.apply(image.dd,{
			ddGroup : 'xrtemplatesetDDGroup',
			onDrag:function(e){							
				var me = this,
	            comp = (me.proxy && !me.comp.liveDrag) ? me.proxy : me.comp,
	            offset = me.getOffset(me.constrain || me.constrainDelegate ? 'dragTarget' : null);
	        	comp.setPagePosition(me.startPosition[0] + offset[0], me.startPosition[1] + offset[1]);						        
			}
		});
	},
	removeDrawData:function(){
		this.drawPanel.removeAll(true);
	},
	initComponent : function() {
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
					dragGroup : 'xrtemplatesetDDGroup',
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
	        		console.log('property change');
//	        		if(this.selectModuleId!=null){	        			
//	        			var id=this.selectModuleId;
//		        		Ext.Ajax.request( {
//							url : 'xrModule.do?method=updateProperty',
//							params : {
//		        				id:id,
//								name : name,
//								value :value
//							},
//							method : 'POST',
//							success : function(response) {
//								var r = Ext.decode(response.responseText);
//								if (!r.success) {
//									Ext.Msg.alert('提交失败：', r.errors.msg);
//								} else {
//									this.leftPanel.store.load();
//									if(name=='width'){										
//										this.selectModule.setWidth(value);										
//									}else if(name=='height'){
//										this.selectModule.setHeight(value);										
//									}
//								}
//							},
//							scope : this
//						});	  
//	        		}	        		      	
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
							this.addNode(vd[i]);
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
		this.drawPanel = Ext.create('Ext.panel.Panel', {			
			border : false,
			autoScroll : true,
			style : 'border-left: 1px solid #8db2e3;',
			region : 'center',
			layout:'absolute',
			items:[],
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
				text : '清空',
				iconCls : 'icon-delete',
				scope : this,
				handler : this.removeDrawData
			}]
		});
		var me=this;
		this.drawPanel.on('render', function() {
			var drawPanel=this.drawPanel;
			this.drawDDTarget = Ext.create('Ext.dd.DropTarget', drawPanel.body.dom, {
				ddGroup : 'xrtemplatesetDDGroup',
				notifyEnter : function(ddSource, e, data) {
					drawPanel.body.highlight();
				},
				notifyDrop : function(ddSource, e, data) {					
					var selectedRecord = ddSource.dragData.records[0];
					var nodeId=selectedRecord.raw.id;
					var node=selectedRecord.raw;	
					var pxy=drawPanel.body.getXY();
					var mx=e.getXY()[0]-pxy[0];
					var my=e.getXY()[1]-pxy[1];			
					me.addNode({
						nodeId:node.id,
						x:mx,
						y:my,
						name:node.text,
						code:node.code,
						width:node.width,
						height:node.height
					});
					return true;
				}
			});
		}, this);
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
		},this.drawPanel ];
		this.callParent();
	}
});