Ext.define('Ado.demo.DynamicMenuPanel', {
	extend : 'Ext.panel.Panel',
	closable : true,
	autoScroll : true,
	border : false,
	initComponent : function() {
		this.callParent();
		this.toolbar=Ext.create('Ext.toolbar.Toolbar', {
			floating: false,
			id: 'menuToolbar',
			cls: 'appMenu',
			height: 30,
			items: [],
			listeners: {
				beforerender: function() {
					var navStore = Ext.create('Ext.data.Store', {
						fields: ['text'],
						proxy: {
							type: 'ajax',
							url: '/dem/to/navigation-output',
							reader: {
								type: 'json',
								root: 'navigation'
							}
						},
						autoLoad: true,
						listeners: {
							load: function(store,records,success,operation,opts) {
								var toolbar = Ext.getCmp('menuToolbar');
								store.each(function(record) {
									var menu = Ext.create('Ext.menu.Menu');
									Ext.each(record.raw.menu, function(item){
										menu.add({
											text: item.text
										})
									})
									toolbar.add({
										xtype: 'button',
										text: record.data.text,
										menu: menu
									});																
								}
							}
						}
					}
				}
			}
		});
	}
});