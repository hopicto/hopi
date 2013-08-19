/**
 * 增删改查面板
 */
Ext.define('Hopi.common.DictTypePanel', {
	extend : 'Hopi.common.CrudMainPanel',
	title : '类型字典管理',
	baseUrl : 'dictType.do?method=',
	nameSuffix : '类型字典',
	storeMapping : [ 'ID', 'TYPE', 'TYPE_CODE', 'ITEM', 'ITEM_CODE', 'SEQ',
			'DESCRIPTION' ],
	columns : [ {
		xtype : 'rownumberer'
	}, {
		header : '类别名称',
		sortable : true,
		dataIndex : 'TYPE'
	}, {
		header : '类别编码',
		sortable : true,
		dataIndex : 'TYPE_CODE'
	}, {
		header : '元素名称',
		sortable : true,
		dataIndex : 'ITEM'
	}, {
		header : '元素编码',
		sortable : true,
		dataIndex : 'ITEM_CODE'
	}, {
		header : '显示序号',
		sortable : true,
		dataIndex : 'SEQ'
	}, {
		header : '备注',
		sortable : false,
		dataIndex : 'DESCRIPTION'
	} ],
	initComponent : function() {
		this.highQueryForm = Ext.create('Hopi.common.CrudHighQueryForm', {
			crudMainPanel : this,
			items : [ {
				fieldLabel : '类别名称',
				name : 'TYPE'
			}, {
				fieldLabel : '类别编码',
				name : 'TYPE_CODE'
			}, {
				fieldLabel : '元素名称',
				name : 'ITEM'
			}, {
				fieldLabel : '元素编码',
				name : 'ITEM_CODE'
			}, {
				fieldLabel : '显示序号',
				name : 'SEQ'
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
			fieldLabel : '类别名称',
			name : 'TYPE',
			allowBlank : false
		}, {
			fieldLabel : '类别编码',
			name : 'TYPE_CODE',
			allowBlank : false
		}, {
			fieldLabel : '元素名称',
			name : 'ITEM',
			allowBlank : false
		}, {
			fieldLabel : '元素编码',
			name : 'ITEM_CODE',
			allowBlank : false
		}, {
			fieldLabel : '显示序号',
			name : 'SEQ',
			allowBlank : false
		}, {
			fieldLabel : '描述',
			name : 'DESCRIPTION',
			xtype : 'textarea',
			width : 200,
			height : 60
		} ];
		this.toolBar = Ext.create("Hopi.common.CrudToolBar", {
			crudMainPanel : this,
			items : []
		});
		this.callParent();

	}
});