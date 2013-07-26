/**
 * 表单验证 password:密码验证
 * 
 */
Ext.apply(Ext.form.field.VTypes, {
	// 密码验证
	password : function(val, field) {
		return /^\w{6,16}$/.test(val);
	},
	passwordText : '密码必须是6-16个字母、数字、下划线组合',
	passwordMask : /[\w]/i,
	// 确认密码验证
	confirmPassword : function(val, field) {
		if (field.confirmTo) {
			var pwd = Ext.getCmp(field.confirmTo);			
			return (val == pwd.getValue());
		}
		return true;
	},
	confirmPasswordText : '两次密码输入不一致',
	confirmPasswordMask : /[\w]/i,
	// 国内电话号码
	phone : function(val, field) {
		return /^\d{3}-\d{8}|\d{4}-\d{7,8}$/.test(val);
	},
	phoneText : '固定电话号码不合法，例如：021-12345678',
	phoneMask : /[\d-]/i,
	// 移动电话号码
	mobile : function(val, field) {
		return /^1\d{10}$/.test(val);
	},
	mobileText : '移动电话号码不合法',
	mobileMask : /[\d]/i,
	// QQ
	qq : function(val, field) {
		return /^[1-9][0-9]{4,}$/.test(val);
	},
	qqText : 'QQ号码不合法',
	qqMask : /[\d]/i,
	// 中国邮政编码
	zipcode : function(val, field) {
		return /^[1-9]\d{5}(?!\d)$/.test(val);
	},
	zipcodeText : '邮政编码不合法',
	zipcodeMask : /[\d]/i,
	// 身份证
	cid : function(val, field) {
		return /^(\d{6})(18|19|20)?(\d{2})([01]\d)([0123]\d)(\d{3})(\d|X)?$/.test(val);
	},
	cidText : '身份证不合法',
	cidMask : /[\da-zA-Z]/i,
	// 中文
	cnword : function(val, field) {
		return /^[\u4e00-\u9fa5]+$/.test(val);
	},
	cnwordText : '中文输入不合法',
	// IP地址确认
	ip : function(v) {
		return /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(v);
	},
	ipText : 'IP地址不合法',
	ipMask : /[\d\.]/i
});