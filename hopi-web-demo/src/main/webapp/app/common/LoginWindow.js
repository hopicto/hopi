Ext.define('Hopi.common.LoginWindow', {
	extend : 'Ext.window.Window',
	title : 'HopiWebDemo',
	width : 320,
	closable : false,
	resizable : false,
	autoHeight : true,
	modal : true,
	border : false,
	login : function() {
		if(this.loginFormPanel.getForm().isValid()){
			this.loginFormPanel.getForm().submit( {
				method : 'POST',
				waitTitle : '与服务器连接中...',
				waitMsg : '发送数据...',			
				success : function() {
					var redirect = 'main.do?method=main';
					window.location = redirect;
				},
				failure : function(form, action) {
					Ext.Msg.alert('登录失败：', action.result.errors.msg);				
				}
			});
		}		
	},
	initComponent : function() {
		this.captchaImg = Ext.create('Ext.Img', {
			width : 80,
			height : 24,
			margin : '0 0 0 3',
			src : 'captcha.do'
		});
		this.captchaImgBtn = Ext.create('Ext.Button', {
			text : '刷新',
			width : 50,
			margin : '0 0 0 3',
			scope : this,
			handler : function() {
				this.captchaImg.setSrc('captcha.do?r=' + Math.random());
			}
		});
		this.loginFormPanel = Ext.create('Ext.form.Panel', {
			labelWidth : 30,
			url : 'login.do',
			frame : true,
			border : false,
			header : false,
			buttonAlign : 'center',
			layout : {
				type : 'table',
				columns : 3
			},
			defaultType : 'textfield',
			defaults : {
				labelAlign : 'right',
				width : 250
			},
			items : [ {
				fieldLabel : '帐号',
				id : 'loginName',
				name : 'loginName',
				allowBlank : false,
				blankText : '帐号不能为空',
				colspan : 3
			}, {
				fieldLabel : '密码',
				id : 'password',
				name : 'password',
				inputType : 'password',
				allowBlank : false,
				blankText : '密码不能为空',
				colspan : 3
			}, {
				fieldLabel : '验证码',
				id : 'jcaptchaCode',
				name : 'jcaptchaCode',
				allowBlank : false,
				blankText : '验证码不能为空',
				width : 160
			}, this.captchaImg, this.captchaImgBtn, {
				fieldLabel : '自动登录',
				name : 'dozeRememberMe',
				xtype : 'checkbox',
				boxLabel : '两周之内自动登录',
				colspan : 3
			}, {
				xtype : 'displayfield',
				padding : '0 0 0 20',
				value : '<font color=blue>推荐使用IE8或更高版本的浏览器访问本系统！</font>',
				colspan : 3
			} ],
			listeners:{		
				scope:this,
	            render:function(panel){
	                panel.el.on('keypress',function(e){
	                	var key = e.getKey();
	    	        	if( key === e.ENTER ){
	    	        		this.login();
	    	            }
	                },this);
	            }
	        },	       
			buttons : [ {
				text : '登录',
				formBind : true,
				scope : this,
				handler : function() {
					this.login();
				}
			}, {
				text : '重置',
				formBind : false,
				scope : this,
				handler : function() {
					this.loginFormPanel.getForm().reset();
				}
			} ]
		});
		this.items = [ this.loginFormPanel ];
		this.callParent();
	}
});