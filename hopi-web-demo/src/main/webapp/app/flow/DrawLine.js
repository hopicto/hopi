Ext.define('Ado.flow.DrawLine', {
	extend : 'Ext.draw.Sprite',	
	group:'drawLineGroup',
	constructor : function(config) {
		this.callParent( [ config ]);
		var pbox = this.getBBox();
		this.textHeight = 10;				
		this.textSprite = this.surface.add( {
			type : 'text',
			text : '',
			zIndex : 10,			
			font : '12px sans-serif;',
			x : 0,
			y : 0
		});				
	},
	toJsonString:function(){
		console.log(this);
		return Ext.JSONView.encode(this);
	},
	edit:function(){
		if (!this.win) {
			if (!this.fp) {
				this.fp = Ext.create('Ext.form.Panel', {
					border : false,
					bodyPadding: 5,					
					buttonAlign:'center',
					defaultType : 'textfield',
					items : [ {
						fieldLabel : '名称',
						name : 'NAME'
					} ],					
					buttons : [ {
						text : '确定',							
						scope : this,
						handler : function(){
							var name=this.fp.getForm().findField('NAME').getValue();
							this.textSprite.text=name;							
							if(this.bside==4){//左侧，需调整文本开始位置								
								this.textSprite.setAttributes( {								
									text:name,
									x:this.startNode.getBBox().x-20-name.length*12
								}, true);
							}else{
								this.textSprite.setAttributes( {								
									text:name
								}, true);
							}																
							this.win.close();
						}
					} ]
				});
			}
			var pbox = this.getBBox();
			this.win = Ext.create('Ext.window.Window', {
				title : '设置流转',
				height : 100,
				width : 300,
				x:pbox.x+pbox.width+50,
				y:pbox.y+50,
				layout : 'fit',
				items : [ this.fp ]
			});
			this.win.on('close', function() {
				this.win = null;
				this.fp = null;
			}, this);			
		}		
		this.fp.getForm().findField('NAME').setValue(this.textSprite.text);	
		this.win.show();
	},
	equal:function(line){	
		if(this.linePoly && line.linePoly){
			return (this.startNode.id == line.startNode.id && this.endNode.id == line.endNode.id && this.linePoly == line.linePoly && this.eside==line.eside && this.bside==line.bside);
		}else{
			return (this.startNode.id == line.startNode.id && this.endNode.id == line.endNode.id && this.linePoly == line.linePoly);
		}
//		return (this.startNode == line.startNode && this.endNode == line.endNode && this.linePoly == line.linePoly && this.eside==line.eside && this.bside==line.bside);
	},
	updatePath:function(){
		var util=new Ado.flow.DrawUtil();
		if(this.linePoly){
			util.drawPlineNode(this,this.startNode.getFixBox(),this.endNode.getFixBox());
		}else{
			util.drawSlineNode(this,this.startNode.getFixBox(),this.endNode.getFixBox());
		}					
	},
	showPosition : function() {
		console.log('for debug cur line id:'+this.id);
		var slines=this.startNode.lines,
			elines=this.endNode.lines;
		for(var i=0;i<slines.length;i++){
			console.log('startNode line id:'+slines[i].id+' i:'+i);
		}
		for(var i=0;i<elines.length;i++){
			console.log('endNode line id:'+elines[i].id+' i:'+i);
		}
	},
	remove:function(){
		if (this.surface) { 
			this.textSprite.remove();
			if(this.endNode){
				var slines=this.startNode.lines,
					elines=this.endNode.lines;
				for(var i=0;i<slines.length;i++){
					if(this.id==slines[i].id){
						slines.splice(i,1);
						break;
					}					
				}
				for(var i=0;i<elines.length;i++){
					if(this.id==elines[i].id){
						elines.splice(i,1);
						break;
					}					
				}
			}			
            this.surface.remove(this);            
            return true;
        }
        return false;
	},
	listeners:{	
		mouseover:function(curLine,e){
			console.log(1);
			e.stopEvent();
			curLine.setAttributes({
				stroke : '#FF0000',
				fill:'#FF0000',
				zIndex : 100
			}, true);			
			var surface=curLine.surface;
			surface.isMouseOverItem=true;
			surface.mouseOverItem=curLine;
		},
		mouseout:function(curLine,e){
			e.stopEvent();
			curLine.setAttributes({
				stroke : '#000',
				fill:'#000',
				zIndex : 0
			}, true);
			var surface=curLine.surface;
			surface.isMouseOverItem=false;
		}
	}
});