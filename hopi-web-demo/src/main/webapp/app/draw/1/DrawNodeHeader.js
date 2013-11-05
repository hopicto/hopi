Ext.define('Hopi.draw.DrawNodeHeader', {
	extend : 'Ext.draw.Sprite',
	group : 'drawNodeGroup',	
//	listeners : {
//		render : function(sprite,opts) {
////			console.log(sprite.getBBox());
//			var bbox=sprite.getBBox();
//			sprite.parent.fixBBox(bbox.width,bbox.height);
//		},		
//		scope : this
//	},
	constructor : function(config) {
		Ext.apply(config, {
			type : 'text',
			width:100,
			height:30,
			zIndex : 1000,
			fill: '#000',
			font : 'bold 14px/20px sans-serif',
		});
		this.callParent([ config ]);
	}
});