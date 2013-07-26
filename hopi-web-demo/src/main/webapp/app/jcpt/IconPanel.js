Ext.define('Ado.jcpt.IconPanel', {
	extend : 'Ado.jcpt.CommonGridEditPanel',
	title : '图标管理',
	baseUrl : 'icon.do?method=',
	storeMapping : [ 'ID', 'NAME', 'CODE', 'IMAGE' ],	
	search : function() {
		var searchKey = this.searchField.getValue();
		this.store.on('beforeload', function() {
			this.baseParams = {
				searchKey : searchKey
			};
		}, this.store);
		this.store.load( {
			params : {
				start : 0,
				searchKey : searchKey
			}
		});
	},
	create : function() {
		this.editing.cancelEdit();
		this.store.insert(0, {
			NAME : 'a',
			CODE : 'a',
			IMAGE : 'a'
		});
//		this.editing.startEdit(0,0);
		this.editing.startEditByPosition({row: 0, column: 0});		
	},
	initComponent : function() {
		this.columns = [ Ext.create('Ext.grid.RowNumberer'), {
			header : '名称',
			sortable : true,
			dataIndex : 'NAME',
			editor : {
				xtype : 'textfield',
				allowBlank : false
			}
		}, {
			header : '编码',
			sortable : true,
			dataIndex : 'CODE',
			editor : {
				xtype : 'textfield',
				allowBlank : false
			}
		}, {
			header : '图标文件',
			sortable : true,
			dataIndex : 'IMAGE',
			editor : {
				xtype : 'textfield',
				allowBlank : false
			}
		}, {
			header : '图标展示',			
			dataIndex : 'IMAGE',
			renderer: function(value){		        
		        return "<image src='../images/'"+value+".gif/>";
		    }
		} ];
		this.searchField = new Ext.form.TextField( {
			emptyText : '请输入关键字',
			name : '_searchField'
		});
		this.toolbar = [ {
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
		}, '->', this.searchField, '-', {
			text : '查询',
			handler : this.search,
			iconCls : 'icon-search',
			scope : this
		} ];
		this.callParent();
	}
});