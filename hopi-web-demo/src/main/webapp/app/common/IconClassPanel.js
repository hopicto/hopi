/**
 * 增删改查面板
 */
Ext.define('Hopi.common.IconClassPanel', {
	extend : 'Hopi.common.CrudMainPanel',
	title : '图标类别管理',
	baseUrl : 'iconClass.do?method=',
	nameSuffix : '图标类别',
	storeMapping : [ 'ID', 'NAME', 'CODE', 'ICON_NAME' ],
	columns : [
			{
				xtype : 'rownumberer'
			},
			{
				header : '名称',
				sortable : true,
				dataIndex : 'NAME'
			},
			{
				header : '编码',
				sortable : true,
				dataIndex : 'CODE'
			},
			{
				header : '图标名称',
				sortable : true,
				dataIndex : 'ICON_NAME'
			},
			{
				header : '图标',
				dataIndex : 'ICON_NAME',
				sortable : false,
				renderer : function(value, metaData, record, rowIndex,
						colIndex, store) {
					var iconSrc = '/images/icon/' + value;
					return '<img src="' + iconSrc + '"/>';
				}
			} ],
	createForm : function() {
		var iconStore = Ext.create('Ext.data.Store', {
			idProperty : 'ICON_NAME',
			fields : [ 'ICON_NAME' ],
			autoLoad : true,
			proxy : {
				type : 'ajax',
				url : this.baseUrl + 'iconComboAll',
				reader : {
					type : 'json',
					root : 'data'
				}
			}
		});
		var iconCombo = Ext.create('Ext.form.ComboBox', {
			name : 'ICON_NAME',
			fieldLabel : '选择图标',
			labelWidth : 80,
			labelAlign : 'right',
			store : iconStore,
			queryMode : 'remote',
			valueField : 'ICON_NAME',
			tpl : Ext.create('Ext.XTemplate', '<tpl for=".">',
					'<div class="x-boundlist-item">',					
					'<img src="',HOPI_GLOBAL.ICON_PATH,'{ICON_NAME}"/>', '{ICON_NAME}',					
					'</div>', '</tpl>'),
			displayTpl : Ext.create('Ext.XTemplate', '<tpl for=".">',
					'{ICON_NAME}', '</tpl>')
		})
		var fp = Ext.create('Ext.form.FormPanel', {
			frame : true,
			border : false,
			method : 'post',			
			layout : 'anchor',
			defaults : {
				xtype:'textfield',
				anchor : '100%',
				labelWidth : 80,
				labelAlign : 'right'
			},
			items : [ {
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
			}, iconCombo ]
		});
		return fp;
	},
	initComponent : function() {
		this.highQueryForm = Ext.create('Hopi.common.CrudHighQueryForm', {
			crudMainPanel : this,
			items : [ {
				fieldLabel : '名称',
				name : 'NAME'
			}, {
				fieldLabel : '编码',
				name : 'CODE'
			}, {
				fieldLabel : '图标名称',
				name : 'ICON_NAME'
			} ]
		});
		this.dataFormSetting = {
			type : 1,
			width : 300
		};
		this.toolBar = Ext.create("Hopi.common.CrudToolBar", {
			crudMainPanel : this,
			items : []
		});
		this.callParent();
	}
});