Ext.define('Hopi.common.DepartmentPanel', {
	extend : 'Ext.tree.Panel',
	title : '部门管理',
	baseUrl : 'department.do?method=',
	nameSuffix : '部门',
	collapsible : true,
	loadMask : true,
	useArrows : true,
	rootVisible : false,
	animate : false,	
	listeners: {
		itemcontextmenu : function(grid,record,node,index,e,eopts) {
			e.stopEvent();			
			this.selectNode={
				id:record.data.id,
				name:record.data.text
			};
			var contextmenu;						
			if (record.data.id == '1') {
				contextmenu = Ext.create('Ext.menu.Menu', {
					items : [ {
						text : '新增部门',
						iconCls : 'icon-create',
						handler : this.createDepartment,
						scope : this
					} ]
				})
			} else {
				contextmenu = Ext.create('Ext.menu.Menu', {
					items : [ {
						text : '新增部门',
						iconCls : 'icon-create',
						handler : this.createDepartment,
						scope : this
					}, {
						text : '修改部门',
						iconCls : 'icon-edit',
						handler : this.editDepartment,
						scope : this
					}, {
						text : '删除部门',
						iconCls : 'icon-delete',
						handler : this.deleteDepartment,
						scope : this
					} ]
				})
			}
			contextmenu.showAt(e.getXY());
		},
		scope:this
    },
    showWin : function(title) {		
    	this.win = Ext.create('Hopi.common.CrudDataFormPopup', {
			mainPanel:this,
			width:320,
			title:title
		});
		this.win.show();
	},
	createForm:function(){
		var fp=Ext.create('Ext.form.FormPanel', {
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
			items:[ {
				name : '_EDIT_TAG',
				xtype : 'hidden'
			}, {
				name : 'ID',
				xtype : 'hidden'
			}, {
				name : 'PARENT_ID',
				xtype : 'hidden'
			},  {
				name : 'PARENT_NAME',
				xtype : 'displayfield'
			}, {
				fieldLabel : '名称',
				name : 'NAME',
				allowBlank : false
			}, {
				fieldLabel : '编码',
				name : 'CODE',
				allowBlank : false
			},{
				fieldLabel : '序号',
				name : 'SEQ',
				allowBlank : false
			}]
		});
		return fp;
	},
	createDepartment : function() {		
		this.showWin('新增' + this.nameSuffix);
		this.win.fp.form.findField('PARENT_ID').setValue(this.selectNode.id);
		this.win.fp.form.findField('PARENT_NAME').setValue(this.selectNode.name);
	},
	modifyDepartment : function() {		
		this.showWin('修改' + this.nameSuffix);
		this.win.form.load( {
			url : this.baseUrl + 'edit',
			params : {
				id : this.selectNode.id
			},
			waitMsg : 'Loading'
		});		
	},
	initComponent : function() {
		this.store = Ext.create('Ext.data.TreeStore', {
			proxy : {
				type : 'ajax',
				reader : 'json',
				url : this.baseUrl + 'tree'
			},
			fields : [ 'id', 'text', 'code', 'seq', 'leaf' ],
			autoLoad : true,
			lazyFill : true
		});
		this.columns = [ {
			xtype : 'treecolumn',
			text : '名称',
			flex : 2.5,
			sortable : true,
			dataIndex : 'text'
		}, {
			text : '编码',
			flex : 1,
			dataIndex : 'code',
			sortable : true
		}, {
			text : '序号',
			flex : 1,
			dataIndex : 'seq'
		} ];
		this.callParent();
	}
});
