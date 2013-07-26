Ext.define("Ado.jcpt.TreeSelector", {
	extend : 'Ext.form.field.Text',
	uses : [ 'Ext.button.Button' ],
	buttonText : '选择',
	buttonMargin : 3,
	fieldBodyCls : Ext.baseCSSPrefix + 'form-file-wrap',
	readOnly : true,
	componentLayout : 'filefield',
	onRender : function() {
		var me = this, inputEl;
		me.callParent(arguments);
		me.createButton();
		if (me.disabled) {
			me.disableItems();
		}
		inputEl = me.inputEl;
		inputEl.dom.removeAttribute('name');
	},
	selectTreeItem:function(){
		this.treePanel = Ext.create('Ext.tree.Panel', {			
			width : this.treeWidth,		
			height:this.treeHeight,
			lines : true,
			border : false,
			singleExpand : false,
			useArrows : false,
			autoScroll : true,			
			store:this.treeStore,			
			listeners : {
				scope : this,
				itemclick :this.onSelect											
			}
		});
		this.win = new Ext.Window( {	
			title:this.treeTitle,
			height:this.treeHeight,
			width : this.treeWidth,			
			plain : true,
			modal : true,
			shadow : true,
			border : false,
			maximizable : true,			
			items : [ this.treePanel ]			
		});
		this.win.show();
	},
	closeWin:function(){
		this.win.close();
	},
	createButton : function() {
		var me = this;
		me.button = Ext.widget('button', Ext.apply( {
			ui : me.ui,
			renderTo : me.bodyEl,
			text : me.buttonText,
			cls : Ext.baseCSSPrefix + 'form-file-btn',
			preventDefault : false,
			handler: this.selectTreeItem,
			scope:this,
			style : me.buttonOnly ? ''
					: 'margin-left:' + me.buttonMargin + 'px'
		}, me.buttonConfig));
	},
//	setValue : Ext.emptyFn,
	reset : function() {
		var me = this;
		if (me.rendered) {
			me.inputEl.dom.value = '';
		}
		me.callParent();
	},
	onDisable : function() {
		this.callParent();
		this.disableItems();
	},
	disableItems : function() {
		var button = this.button;
		if (button) {
			button.disable();
		}
	},
	onEnable : function() {
		var me = this;
		me.callParent();//me.fileInputEl.dom.disabled = false;		
		me.button.enable();
	},
	onDestroy : function() {
		Ext.destroyMembers(this, 'button');
		this.callParent();
	}
});