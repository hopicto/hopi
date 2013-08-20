/**
 * 数据表单-弹出式
 */
Ext.define('Hopi.common.CrudDataFormPopup', {
	extend : 'Ext.window.Window',
	autoHeight : true,
	buttonAlign : 'center',
	plain : true,
	modal : true,
	shadow : true,
	border : false,
	maximizable : true,
	closeAction : 'destroy',
	loadData:function(id){
		this.fp.form.load( {
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
		if (this.fp.getForm().isValid()) {
			this.fp.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.mainPanel.baseUrl + 'save',
				method : 'POST',
				success : function() {
					this.mainPanel.store.reload();
					this.close();
				},
				failure : function(form, action) {
					obj = Ext.util.JSON.decode(action.response.responseText);
					Ext.Msg.alert('保存失败：', obj.msg);
				},
				scope : this
			});
		}
	},
	resetData : function() {
		if (this.fp)
			this.fp.form.reset();
	},
	initComponent : function() {		
		this.fp=this.mainPanel.createForm();
//		this.fp=Ext.create('Ext.form.FormPanel', {
//			frame : true,
//			labelWidth : 80,
//			labelAlign : 'right',
//			border : false,
//			method : 'post',
//			defaultType : 'textfield',
//			layout : 'anchor',
//			defaults : {
//				anchor : '100%'
//			},
//			items:mainPanel.dataFormItems
//		});
		this.items=[this.fp];
		this.buttons =[ {
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