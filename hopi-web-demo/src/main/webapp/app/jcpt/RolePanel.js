Ext.define('Ado.jcpt.RolePanel', {
	extend : 'Ado.jcpt.CommonCrudPanel',
	title : '角色管理',
	baseUrl : 'role.do?method=',
	nameSuffix : '角色',
	storeMapping : [ 'ID','NAME','CODE','DESCRIPTION'],	
	createForm : function() {
		var formPanel = new Ext.form.FormPanel( {
			frame : true,
			labelWidth : 80,
			labelAlign : 'right',
			border : false,		
			method : 'post',
			defaultType : 'textfield',
			defaults : {
				width : 160
			},
			items : [ {
				name:'_EDIT_TAG',
				xtype :'hidden'
			},  {
				name:'ID',
				xtype :'hidden'
			}, {
				fieldLabel : '名称',
				name : 'NAME',				
				allowBlank : false
			},{
				fieldLabel : '编码',
				name : 'CODE',				
				allowBlank : false
			},{
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
	search:function(){
		var searchKey=this.searchField.getValue();
		this.store.on('beforeload', function() {
			this.baseParams = {
				searchKey:searchKey
			};
		}, this.store);
		this.store.load({
			params : {
				start : 0,
				searchKey:searchKey
			}
		});
	},
	highSearch:function(){
		if(this.searchPanel.hidden){
			this.searchPanel.show();
		}else{
			this.searchPanel.hide();
		}
		
	},
//	columns:[,],
	initComponent : function() {
//		this.sm = new Ext.grid.CheckboxSelectionModel();		
//		columns: [
//		          {header: '名称',  dataIndex: 'NAME'},
//		          {header: 'Email', dataIndex: 'email', flex:1},
//		          {header: 'Phone', dataIndex: 'phone'}
//		      ],
//
//		this.cm = new Ext.grid.ColumnModel( [ this.sm, ]);
//		this.sm=Ext.create('Ext.ux.CheckColumn', {			
//			width:20,
//	        dataIndex: 'ID',
//	        editor: {
//                xtype: 'checkbox',
//                cls: 'x-grid-checkheader-editor'
//            }
//		});
//		this.selModel=Ext.create('Ext.selection.CheckboxModel', {
//			width:20
//		});
		this.columns=[
		Ext.create('Ext.grid.RowNumberer'),
		{
			header : '名称',
			sortable : true,
			dataIndex : 'NAME'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		},{
			header : '编码',
			sortable : true,
			dataIndex : 'CODE'
		}, {
			header : '备注',
			sortable : false,			
			dataIndex : 'DESCRIPTION'
		}];
		this.searchField = new Ext.form.TextField( {
			emptyText : '请输入关键字',
			name : '_searchField'
		});				
		this.toolbar=[ {
			text : '新增',
			handler : this.create,
			iconCls : 'icon-add',
			scope : this
		}, '-', {
			text : '修改',
			handler : this.edit,
			iconCls : 'icon-edit',
			scope : this
		}, '-', {
			text : '删除',
			handler : this.removeData,
			iconCls : 'icon-delete',
			scope : this
		}, '-', {
			text : '刷新',
			handler : this.refresh,
			iconCls : 'icon-refresh',
			scope : this
		},'->',this.searchField,'-', {
			text : '查询',
			handler : this.search,
			iconCls : 'icon-search',
			scope : this
		},'-', {
			text : '高级查询',
			handler : this.highSearch,
			iconCls : 'icon-search',
			scope : this
		}];
		this.viewConfig = {
			forceFit : true
		};
		this.callParent();
	}
});