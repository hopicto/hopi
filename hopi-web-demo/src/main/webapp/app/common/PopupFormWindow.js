/**
 * 弹出窗口
 */
Ext.define('Hopi.common.PopupFormWindow', {
	extend : 'Ext.window.Window',
	autoHeight : true,
	buttonAlign : 'center',
	plain : true,
	modal : true,
	shadow : true,
	border : false,
	maximizable : true,
	closeAction : 'destroy',
	loadData : function(id) {
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
		});
	},
	saveData : function() {
		if (this.fp.getForm().isValid()) {
			this.fp.getForm().submit( {
				waitMsg : '数据正在保存，请稍等...',
				url : this.mainPanel.baseUrl + 'save',
				method : 'POST',
				success : function() {
//					this.mainPanel.store.reload();
					this.mainPanel.reloadData();
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
		if (this.fp)
			this.fp.form.reset();
	},
	initComponent : function() {
		this.fp = this.mainPanel.createForm();
		this.items = [ this.fp ];
		this.buttons = [{
			text : '保存',
			iconCls:'icon-save',
			handler : this.saveData,
			scope : this
		}, {
			text : '重置',
			iconCls:'icon-reset',
			handler : this.resetData,
			scope : this
		}, {
			text : '取消',
			iconCls:'icon-cancel',
			handler : this.close,
			scope : this
		} ]
		this.callParent();
	}
});