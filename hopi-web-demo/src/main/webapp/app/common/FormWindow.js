/**
 * 弹出输入表单
 */
Ext.define('Hopi.common.FormWindow', {
	extend : 'Ext.window.Window',
	width : 320,
	closable : false,
	resizable : false,
	autoHeight : true,
	modal : true,
	border : false,
	save : function() {
		this.fp.form.submit( {
			waitMsg : '数据正在保存，请稍等...',
			url : this.postUrl,
			method : 'POST',
			success : function(form, action) {
				this.closeWin();
			},
			failure : function(form, action) {
				Ext.Msg.alert('保存失败', action.result ? action.result.msg
						: '系统错误');
			},
			scope : this
		});
	},
	closeWin : function() {
		this.close();
	},
	initComponent : function() {
		this.items = [ this.fp ];
		this.buttons = [ {
			text : '保存',
			handler : this.save,
			scope : this
		}, {
			text : '取消',
			handler : this.closeWin,
			scope : this
		} ];
		this.callParent();
	}
});