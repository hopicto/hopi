/**
 * 数据表单-页签式
 */
Ext.define('Hopi.common.CrudDataFormPanel', {
	extend : 'Ext.form.FormPanel',
//	layout: 'hbox',
//	fieldDefaults: {
//        labelAlign: 'right',
//        msgTarget: 'side'
//    },
//    defaults: {
//        border: false,
//        xtype: 'panel',
//        flex: 1,
//        layout: 'anchor'
//    },
    frame:true,
    border:false,
    layout: {
        type: 'table',
        columns: 3
    },
    
//	border : false,
//	method : 'post',
//	layout : {
//		type : 'table',
//		columns : 4
//	},
//	defaultType : 'textfield',
	bodyStyle:'padding:5px',
    defaults : {		
		labelWidth:80,
		labelAlign : 'right'
	},
	loadData:function(id){
		this.form.load( {
			url : this.mainPanel.baseUrl + 'edit',
			params : {
				id : id
			},
			waitMsg : '数据加载中，请稍等...',
			failure : function(form, action) {
				Ext.Msg.alert('编辑失败：', action.result.msg);
				this.close();
			},
			scope : this
		})
	},
	saveData : function() {
		if (this.getForm().isValid()) {
			this.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.mainPanel.baseUrl + 'save',
				method : 'POST',
				success : function() {
					this.mainPanel.store.reload();
					this.close();
				},
				failure : function(form, action) {
					obj = Ext.decode(action.response.responseText);
					Ext.Msg.alert('保存失败：', obj.msg);
				},
				scope : this
			});
		}
	},
	resetData : function() {
		this.form.reset();		
	},
	initComponent : function() {
		this.mainPanel=this.extprop.mainPanel;
//		this.items=[ this.mainPanel.dataFormItems];
		this.items=[ {
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
			rowspan: 2,
			width : 200,
			height : 60
		}];	
		this.buttons =['->',{
			text : '保存',
			handler : this.saveData,
			scope : this
		}, {
			text : '清空',
			handler : this.resetData,
			scope : this
		}, {
			text : '取消',
			handler : this.close,
			scope : this
		} ]
		this.callParent();
	}
});