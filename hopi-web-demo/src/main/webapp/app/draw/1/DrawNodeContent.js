Ext.define('Hopi.draw.DrawNodeContent', {
	extend : 'Ext.draw.Sprite',
	group : 'drawNodeGroup',
	contentTpl : new Ext.XTemplate('<tpl for=".">',
			'{name}\t{type}\t{key}\n', '</tpl>'),
	listeners : {
		render : function(sprite,opts) {
//			console.log(sprite.getBBox());
			var bbox=sprite.getBBox();
			sprite.parent.fixBBox(bbox.width,bbox.height);
		},		
		scope : this
	},
	caculateHeight:function(){
		return this.data.length*20;
	},
	constructor : function(config) {
		var contentData=this.contentTpl.apply(config.data);
		Ext.apply(config, {
			type : 'text',
			text :contentData,
			width:100,
			fill: '#000',
			font : '12px/18px sans-serif',
		});
		this.callParent([ config ]);
	}
});