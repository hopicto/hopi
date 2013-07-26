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
Ext
		.define(
				'Ado.jcpt.MainViewport',
				{
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
						var passwin = new Ext.ux.FormWindow( {
							title : '修改密码',
							postUrl : 'user.do?method=changeSelfPass',
							width : 260,
							fp : new Ext.form.FormPanel( {
								frame : true,
								labelWidth : 80,
								labelAlign : 'right',
								border : false,
								method : 'post',
								defaultType : 'textfield',
								defaults : {
									width : 140
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
					openRelease : function() {
						var win = new Ext.Window(
								{
									title : '投资顾问工作平台-版本信息',
									autoScroll : true,
									height : 300,
									width : 480,
									maximizable : true,
									bodyStyle : 'background:#FFFFFF;padding:5px;line-height:18px;',
									autoLoad : 'release.html'
								});
						win.show();
					},
					initComponent : function() {
						this.northPanel = Ext
								.create(
										'Ext.panel.Panel',
										{
											region : 'north',
											margins : '0 5 5 5',
											border : '2 0 0 2',
											bodyStyle : 'background:#dfe8f6;',
											tpl : new Ext.XTemplate(
													"<div id='main-viewport'>",
													"<div id='main-viewport-logo'><img src='images/logo.png' width=48 height=48></div>",
													"<div id='main-viewport-title'>{headMsg}</div>",
													"<div id='main-viewport-version'>",
													"{welcomeMsg}<br/>",
													"上次登录时间：{lastLoginDate}<br/>",
													"上次登录地址：{lastLoginIp}<br/>",
													"</div></div>"),
											data : this.headData,
											height : 90,
											bbar : [
													{
														text : '首页',
														iconCls : 'icon-home',
														scope : this,
														handler : function() {
															var tab = this.tabPanel
																	.getComponent('mainTab');
															this.tabPanel
																	.setActiveTab(tab);
														}
													},
													'-',
													{
														text : '信息提醒',
														iconCls : 'icon-message',
														scope : this,
														handler : function() {
															openTab( {
																type : 'MessagePanel',
																id : '1',
																title : '信息提醒管理',
																code : 'MessagePanel'
															});
														}
													},
													'-',
													{
														text : '报告模版测试',
														iconCls : 'icon-message',
														scope : this,
														handler : function() {
															var id=101;
															openTab( {
																type : 'TAB_XR_TEMPLATE_',
																id : id,
																title : '设置模板:' + name,
																code : 'Ado.xr.XrTemplateSetPanel'
																}, {
																templateId : id
															});
														}
													},
													'-',
													{
														text : '流程图测试',
														iconCls : 'icon-message',
														scope : this,
														handler : function() {
															var id=101;
															openTab( {
																type : 'TAB_XF_FLOW_',
																id : id,
																title : '设置模板:' + name,
																code : 'Ado.flow.FlowPanel'
																}, {
																flow : id
															});
														}
													},
													'->',
													{
														text : '访问统计',
														iconCls : 'icon-chart-column',
														scope : this,
														handler : function() {
															openTab( {
																type : 'AccessChartPanel',
																id : '1',
																title : '访问统计',
																code : 'AccessChartPanel'
															});
														}
													},
													'-',
													{
														text : '个人设置',
														iconCls : 'icon-setting',
														scope : this,
														handler : this.ownerSetting
													},
													'-',
													{
														text : '修改密码',
														iconCls : 'icon-changepass',
														scope : this,
														handler : this.changePass
													},
													'-',
													{
														text : '退出',
														iconCls : 'icon-logout',
														handler : function() {
															location.href = 'logout.do';
														}
													} ]
										});
						this.westPanel = Ext.create('Ext.tree.Panel', {
							title : this.menuTitle || '功能菜单',
							region : 'west',
							width : 200,
							minSize : 120,
							maxSize : 360,
							lines : true,
							singleExpand : false,
							useArrows : false,
							collapsible : true,
							collapseMode : 'mini',
							split : true,
							autoScroll : true,
							margins : '0 0 5 5',
							store : Ext.create('Ext.data.TreeStore', {
								proxy : {
									type : 'ajax',
									url : 'main.do?method=tree'
								},
								root : {
									text : '系统管理',
									draggable : false,
									id : this.rootId || 1,
									expanded : true
								},
								folderSort : true,
								sorters : [ {
									property : 'seq',
									direction : 'ASC'
								} ]
							}),
							listeners : {
								itemclick : function(view, node, item, index,
										e, o) {
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
							html : '123'
						});
						this.tabPanel = Ext.create('Ext.tab.Panel', {
							id : 'tabPanel',
							region : 'center',
							margins : '0 5 5 0',
							minTabWidth : 135,
							tabWidth : 135,
							scroll : 'true',
							activeTab : 0,
							items : [ this.indexPanel ]
						});
						this.items = [ this.northPanel, this.westPanel,
								this.tabPanel ];
						this.callParent();
					}
				});
