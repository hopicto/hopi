Ext.define('Hopi.draw.DrawNode', {
	extend : 'Ext.draw.Component',
	items:[{
		type : 'rect',
		width : 100,
		height : 50,
		radius : 10,
		zIndex : 1,
		opacity : 0.5,
		stroke : 'blue',
		'stroke-width' : 1
	}],
	contentTpl : new Ext.XTemplate('<tpl for="props">',
			'{name}\t{type}\t{key}\n', '</tpl>'),
	caculateHeight : function() {

	},
	redraw : function() {
		this.callParent();
		this.headSprite.redraw();
		this.contentSprite.redraw();
	},
	listeners : {
		contextmenu : function(a, b, c) {
			console.log(a);
		},
		scope : this
	},
	initComponent : function() {
		this.callParent();
//		console.log(this);
//		this.surface.add({
//			type : 'rect',
//			width : 100,
//			height : 50,
//			radius : 10,
//			zIndex : 1,
//			opacity : 0.5,
//			stroke : 'blue',
//			'stroke-width' : 1
//		});
	}
// constructor : function(config) {
// Ext.apply(config, {
// type : 'rect',
// width : 100,
// height : 50,
// radius : 10,
// zIndex :1,
// // fill : 'yellow',
// opacity : 0.5,
// stroke : 'blue',
// 'stroke-width' : 1
// });
// this.callParent([ config ]);
//		
// var bbox = this.getBBox();
// this.headSprite = this.surface.add({
// type : 'text',
// text : this.title,
// width:100,
// zIndex : 1000,
// fill: '#000',
// font : 'bold 14px/20px sans-serif',
// x : bbox.x + this.width/3,
// y : bbox.y + 5
// });
//		
// var content = this.contentTpl.apply({
// props : [ {
// name : 'test1',
// type : 'kaka',
// key : ''
// }, {
// name : 'test2',
// type : 'kaka',
// key : ''
// } ]
// });
// this.contentSprite = this.surface.add({
// type : 'text',
// text : content,
// zIndex : 1,
// font : '14px/20px sans-serif',
// x : bbox.x + 5,
// y : bbox.y + 30
// });
// }
});