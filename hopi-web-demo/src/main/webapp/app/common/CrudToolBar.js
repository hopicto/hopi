/**
 * 延迟加载工具栏
 */
Ext.define('Hopi.common.CrudToolBar', {
	extend : 'Ext.Toolbar',
	border : false,
	addItem : function(data, scope, itemTag) {
		switch (data.type) {
		case 1:
			if (itemTag > 0) {
				this.add('-');
			}
			this.add( {
				text : data.text,
				handler : scope.createData,
				iconCls : data.iconCls,
				scope : scope
			});
			break;
		case 2:
			if (itemTag > 0) {
				this.add('-');
			}
			this.add( {
				text : data.text,
				handler : scope.modifyData,
				iconCls : data.iconCls,
				scope : scope
			});
			break;
		case 3:
			if (itemTag > 0) {
				this.add('-');
			}
			this.add( {
				text : data.text,
				handler : scope.removeData,
				iconCls : data.iconCls,
				scope : scope
			});
			break;
		case 4:
			if (itemTag > 0) {
				this.add('-');
			}
			this.add( {
				text : data.text,
				handler : scope.exportData,
				iconCls : data.iconCls,
				scope : scope
			});
			break;
		case 8:
			if (itemTag > 0) {
				this.add('-');
			}
			this.add( {
				text : data.text,
				handler : scope.importData,
				iconCls : data.iconCls,
				scope : scope
			});
			break;
		case 5:
			if (itemTag > 0) {
				this.add('-');
			}
			this.add( {
				text : data.text,
				handler : scope.refreshData,
				iconCls : data.iconCls,
				scope : scope
			});
			break;
		case 6:
			this.add('->');
			scope.queryField = Ext.create('Ext.form.field.Text', {
				name : 'queryField',
				hideLabel : true,
				width : 200,
				listeners:{
					specialkey:function(field, event){
						if (event.getCharCode() == Ext.EventObject.ENTER) {
							this.queryData();
						}
					},
					scope:this.crudMainPanel
				}
			});
			this.add(scope.queryField);
			this.add('-');
			this.add( {
				text : data.text,
				handler : scope.queryData,
				iconCls : data.iconCls,
				scope : scope
			});
			break;
		case 7:
			if (itemTag > 0) {
				this.add('-');
			}
			scope.highQueryButton = Ext.create('Ext.Button', {
				text : data.text,
				handler : scope.switchHighQuery,
				iconCls : data.iconCls,
				scope : scope
			});
			this.add(scope.highQueryButton);
			break;
		default:
			this.add('-');
		}
	},
	initComponent : function() {
		var crudMainPanel = this.crudMainPanel;
		this.menuStore = Ext.create('Ext.data.Store', {
			idProperty : 'type',
			fields : [ 'type', 'text', 'iconCls' ],
			autoLoad : true,
			listeners : {
				scope : this,
				load : function(store, records, success) {
					if (success && records.length > 0) {
						var tb = this;
						var itemTag = 0;
						store.each(function(record) {
							tb.addItem(record.data, crudMainPanel, itemTag++);
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
		this.callParent();
	}
});