/**
 * 主页面
 * 
 * @author:dongyl
 * @since:2010-03-24
 * 
 * 需先引入一下js: ExtEnsure.js:动态加载js
 * 
 * 需设置以下属性： welcomeMsg:欢迎词 rootId:菜单节点根节点 menuTitle:功能菜单标题
 */
TAB_PANEL_PREFIX = 'tab_';
Ext.define('Hopi.common.MainViewport', {
	extend : 'Ext.container.Viewport',
	layout : 'border',
	openTab : function(node) {
		var id = TAB_PANEL_PREFIX + node.raw.id;
		var tab = this.tabPanel.getComponent(id);
		if (tab) {
			this.tabPanel.setActiveTab(tab);
		} else {
			var code = node.raw.module;
			if (code == null) {
				var p = this.tabPanel.add( {
					id : id,
					title : node.raw.text,
					closable : true,
					bodyStyle : 'padding:10px',
					html : '该功能正在开发中……'
				});
				this.tabPanel.setActiveTab(p);
			} else {
				var extprop = Ext.decode(node.raw.extprop);
				var p = this.tabPanel.add(Ext.create(code, {
					title : node.raw.text,
					id : id,
					closable : true,
					extprop : extprop
				}));
				this.tabPanel.setActiveTab(p);
			}
		}
	},
	closeTab : function(tabId) {
		var tab = this.tabPanel.getComponent(tabId);
		if (tab) {
			this.tabPanel.remove(tab, true);
		}
	},
	changePass : function() {
		var passwin = Ext.create('Hopi.common.FormWindow', {
			title : '修改密码',
			postUrl : 'staff.do?method=changeSelfPass',
			width : 260,
			fp : new Ext.form.FormPanel( {
				frame : true,
				labelWidth : 80,
				border : false,
				method : 'post',
				defaultType : 'textfield',
				layout : 'anchor',
				defaults : {
					anchor : '100%',
					labelAlign : 'right'
				},
				items : [ {
					fieldLabel : '原密码',
					name : 'OLD_PASSWORD',
					inputType : 'password',
					allowBlank : false
				}, {
					fieldLabel : '新密码',
					name : 'NEW_PASSWORD',
					id : 'NEW_PASSWORD',
					inputType : 'password',
					vtype : 'password'
				}, {
					fieldLabel : '确认新密码',
					id : 'COMFIRM_PASSWORD',
					name : 'COMFIRM_PASSWORD',
					inputType : 'password',
					confirmTo : 'NEW_PASSWORD',
					vtype : 'confirmPassword',
					allowBlank : false
				} ]
			})
		});
		passwin.show();
	},
	queryData : function() {
		Ext.Msg.alert('未完成的功能', '全文检索待补充');
	},
	initComponent : function() {
		this.queryField = Ext.create('Ext.form.field.Text', {
			name : 'queryField',
			hideLabel : true,
			width : 200,
			listeners : {
				specialkey : function(field, event) {
					if (event.getCharCode() == Ext.EventObject.ENTER) {
						this.queryData();
					}
				},
				scope : this
			}
		});
		Ext.define('themes', {
			extend : 'Ext.data.Model',
			fields : [ {
				type : 'string',
				name : 'name'
			}, {
				type : 'string',
				name : 'value'
			}, {
				type : 'string',
				name : 'url'
			} ]
		});
		this.themeCombo = Ext.create('Ext.form.field.ComboBox', {
			displayField : 'name',
			fieldLabel : '主题',
			labelWidth : 40,
			width : 120,
			queryMode : 'local',
			value : 'classic',
			store : Ext.create('Ext.data.Store', {
				autoDestroy : true,
				model : 'themes',
				data : [ {
					name : 'classic',
					url : '/extjs/resources/css/ext-all.css'
				}, {
					name : 'gray',
					url : '/extjs/resources/css/ext-all-gray.css'
				}, {
					name : 'neptune',
					url : '/extjs/resources/css/ext-all-neptune.css'
				}, {
					name : 'access',
					url : '/extjs/resources/css/ext-all-access.css'
				} ]
			}),
			listeners : {
				change : function(cb, v,e) {
					console.log(v);
					console.log(e);
					console.log(cb);
//					Ext.util.CSS.swapStyleSheet('theme', v);
					// console.log(this);
			},
			scope : this
			}
		});
		this.northPanel = Ext.create('Ext.Toolbar', {
			region : 'north',
			margins : '0 0 5 0',
			items : [ this.headData.userName + '，欢迎进入Hopi工作平台', '-',
					this.queryField, '->', this.themeCombo, '-', {
						text : '修改密码',
						iconCls : 'icon-changepass',
						scope : this,
						handler : this.changePass
					}, '-', {
						text : '退出',
						iconCls : 'icon-logout',
						handler : function() {
							location.href = 'logout.do';
						}
					} ]
		});
		this.westPanel = Ext.create('Ext.tree.Panel', {
			preventHeader : true,
			// tbar : [ this.headData.userName, '->', {
			// text : '修改密码',
			// iconCls : 'icon-changepass',
			// scope : this,
			// handler : this.changePass
			// }, '-', {
			// text : '退出',
			// iconCls : 'icon-logout',
			// handler : function() {
			// location.href = 'logout.do';
			// }
			// } ],
			region : 'west',
			width : 200,
			minSize : 120,
			maxSize : 360,
			lines : true,
			singleExpand : false,
			useArrows : false,
			collapsible : true,
			collapseMode : 'mini',
			hideCollapseTool : true,
			split : true,
			autoScroll : true,
			// margins : '0 0 5 5',
			store : Ext.create('Ext.data.TreeStore', {
				proxy : {
					type : 'ajax',
					url : 'main.do?method=tree'
				},
				root : {
					text : '功能模块',
					draggable : false,
					id : this.rootId || '1',
					expanded : true
				},
				folderSort : true,
				sorters : [ {
					property : 'seq',
					direction : 'ASC'
				} ]
			}),
			listeners : {
				itemclick : function(view, node, item, index, e, o) {
					if (node.isLeaf()) {
						e.stopEvent();
						this.openTab(node);
					}
				},
				scope : this
			}

		});
		this.indexPanel = Ext.create('Ext.panel.Panel', {
			id : 'mainTab',
			title : '首页',
			closable : false,
			autoScroll : true,
			html : '首页功能待扩展'
		});
		this.tabPanel = Ext.create('Ext.tab.Panel', {
			id : 'tabPanel',
			region : 'center',
			// margins : '0 5 5 0',
			minTabWidth : 135,
			tabWidth : 135,
			scroll : 'true',
			activeTab : 0,
			items : [ this.indexPanel ]
		});
		this.items = [ this.northPanel, this.westPanel, this.tabPanel ];
		this.callParent();
	}
});
