/**
 * 增删改查面板
 */
Ext.define('Hopi.common.IconClassPanel', {
	extend : 'Hopi.common.CrudMainPanel',
	title : '图标类别管理',
	baseUrl : 'iconClass.do?method=',
	nameSuffix : '图标类别',
	storeMapping : [ 'ID', 'NAME', 'CODE'],
	columns : [ {
		xtype : 'rownumberer'
	}, {
		header : '名称',
		sortable : true,
		dataIndex : 'NAME'
	}, {
		header : '编码',
		sortable : true,
		dataIndex : 'CODE'
	},{
		header:'图标',
		dataIndex : 'CODE',
		xtype:'actioncolumn',		
//		iconCls:'icon-add',
		renderer:function (value, metadata, record){
//			console.log(value);
//			console.log(metadata);
//			console.log(record);
			console.log(metadata.iconCls);
			metadata.iconCls=value;
		}
//		renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
//			
//		}
	}],
	initComponent : function() {
		this.highQueryForm = Ext.create('Hopi.common.CrudHighQueryForm', {
			crudMainPanel : this,
			items : [ {
				fieldLabel : '名称',
				name : 'NAME'
			}, {
				fieldLabel : '编码',
				name : 'CODE'
			} ]
		});
		//弹出窗口
		this.dataFormSetting={
			type:1,
			width:360			
		};
//		//页签式		
//		this.dataFormSetting={
//			type:2,
//			panelName:this.self.getName()		
//		};
		this.dataFormItems = [ {
			name : '_EDIT_TAG',
			xtype : 'hidden'
		}, {
			name : 'ID',
			xtype : 'hidden'
		}, {
			fieldLabel : '名称',
			name : 'NAME',
			allowBlank : false
		}, {
			fieldLabel : '编码',
			name : 'CODE',
			allowBlank : false
		}];
		this.toolBar = Ext.create("Hopi.common.CrudToolBar", {
			crudMainPanel : this,
			items : []
		});
		this.callParent();

	}
});