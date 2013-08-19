/**
 * 增删改查面板
 */
Ext.define('Hopi.common.DictTypePanel', {
	extend : 'Hopi.common.CrudPanel',
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
	createForm : function() {
		var formPanel = new Ext.form.FormPanel( {
			frame : true,
			labelWidth : 80,
			labelAlign : 'right',
			border : false,
			method : 'post',
			defaultType : 'textfield',
			layout : 'anchor',
			defaults : {
				anchor : '100%'
			},
			items : [ {
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
			} ]
		});
		return formPanel;
	},
	createWin : function() {
		return this.initWin(360);
	},
	initComponent : function() {
		this.queryForm = Ext.create('Hopi.common.SearchFormPanel', {
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
		this.menuStore = Ext.create('Ext.data.Store', {
			idProperty : 'text',
			fields : [ 'text', 'iconCls','handler'],
			autoLoad : true,
			listeners : {
				scope : this,
				load : function(store, records, success) {
					if (success && records.length > 0) {	
						var tb=this.menuBar;						
						store.each(function(record) {
							tb.add({		                        	
								text: record.data.text,
	                            handler: eval(record.data.handler),
	                            iconCls: record.data.iconCls,
	                            scope : this
	                        });														                        	                      
	                    });
					}
				}
			},
			proxy : {
				type : 'ajax',
				url : '/demo.do?method=menuItem',
				reader : {
					type : 'json',
					root : 'data'
				}
			}
		});
		this.toolBar=Ext.create("Ext.Toolbar", {	
			xtype : 'container',
			layout : 'anchor',
			defaults : {
				anchor : '0'
			},
			defaultType : 'toolbar',
			items:[this.menuBar,this.queryForm]
		});
		this.menuBar=Ext.create("Ext.Toolbar", {			
			items:[]
		});
		this.callParent();
	}
});