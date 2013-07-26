Ext.define('Ado.jcpt.RolePanel', {
	extend : 'Ado.jcpt.CommonGridEditPanel',
	title : '角色管理',
	baseUrl : 'role.do?method=',
	storeMapping : [ 'ID', 'NAME', 'CODE', 'DESCRIPTION' ],
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
	create:function(){
		this.rowEditing.cancelEdit();
//        var r = Ext.ModelManager.create({            
//            NAME: '',
//            CODE:'',
//            DESCRIPTION:''
//        },'RoleModel');
//        this.store.insert(0, r);
        this.store.insert(0, {
        	NAME:'1',
        	CODE:'1',
        	DESCRIPTION:'2'
        });
        this.rowEditing.startEdit(0, 0);
	},
	initComponent : function() {		
		this.columns = [{
			header : '名称',
			sortable : true,
			dataIndex : 'NAME',			
            editor: {                
            	allowBlank: false
            }
		}, {
			header : '编码',
			sortable : true,
			dataIndex : 'CODE',
			editor: {                
            	allowBlank: false
            }
		}, {
			header : '备注',
			sortable : false,
			flex: 1,
			dataIndex : 'DESCRIPTION',
			editor: {
                xtype: 'textareafield',
                height:60,
				grow:true
            }
//			editor:{
//				xtype:'',
//				
//			}
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
		this.viewConfig = {
			forceFit : true
		};
		this.callParent();
		this.store.load();
	}
});