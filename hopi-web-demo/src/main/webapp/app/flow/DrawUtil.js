Ext.define('Ado.flow.DrawUtil', {
	arrowSide:10,//箭头边长
	polySide:24,//拐边长
	stroke:'#000',
	fill:'#000',
	drawSlineMouse:function(surface,e){//从开始节点到鼠标结束位置的直线
		var bxy=surface.startNode.getFixBox();
		var x=surface.getRegion().left;
		var y=surface.getRegion().top;		
		var x1=bxy.x+bxy.width/2;
		var y1=bxy.y+bxy.height/2;
		var x2=e.getX()-x;
		var y2=e.getY()-y;
		if(x1==x2){
			y1=y2>y1?(y1+bxy.height/2):(y1-bxy.height/2);
		}else{															
			var z=Math.abs((y2-y1)/(x2-x1));
			if(z<1){						
				x1=x2>x1?(x1+bxy.width/2):(x1-bxy.width/2);
				y1=y2>y1?(y1+bxy.width/2*z):(y1-bxy.width/2*z);	
			}else{
				y1=y2>y1?(y1+bxy.height/2):(y1-bxy.height/2)							
				x1=x2>x1?x1+bxy.height/(2*z):x1-bxy.height/(2*z);											
			}											
		}
					
		var a=Math.atan((y2-y1)/(x2-x1));
		var b=a-Math.PI/6;
		var c=Math.PI/3-a;		
		if(x2>x1){
			x3=x2-this.arrowSide*Math.cos(b);
			y3=y2-this.arrowSide*Math.sin(b);				
			x4=x2-this.arrowSide*Math.sin(c);
			y4=y2-this.arrowSide*Math.cos(c);
		}else{
			x3=x2+this.arrowSide*Math.cos(b);
			y3=y2+this.arrowSide*Math.sin(b);				
			x4=x2+this.arrowSide*Math.sin(c);
			y4=y2+this.arrowSide*Math.cos(c);
		}
		
		surface.curLine.setAttributes({
			path:'M' + x1+ ' ' + y1+ 'L' + x2 + ' ' + y2+ 'L'+x3 +' '+y3+'L'+x4+' '+y4+'L'+x2+' '+y2+' Z',
			stroke: this.stroke,
			fill:this.fill
			}, true);	
		surface.curLine.show();
	},
	drawPlineMouse:function(surface,e){//从开始节点到鼠标结束位置的折线
		var bxy=surface.startNode.getFixBox();
		var x=surface.getRegion().left;
		var y=surface.getRegion().top;		
		
		var x2=e.getX()-x;
		var y2=e.getY()-y;
		
		var x1=bxy.x+bxy.width/2;
		var y1=bxy.y+bxy.height/2;
		
		var path;
		var d=this.polySide;	
		switch(surface.curLine.bside)
		{
		case 1:			
			y1=bxy.y;	
			if(y2>y1){						
				path='M' + x1+ ' ' + y1+'V'+(y1-d)+'H'+x2+'V'+y2+'V'+(y1-d)+'H'+x1+'Z';					
			}else{
				path='M' + x1+ ' ' + y1+'V'+y2+'H'+x2+'H'+x1+'Z';
			}
			break;
		case 2:
			x1=bxy.x+bxy.width;
			if(x2>x1){						
				path='M' + x1+ ' ' + y1+'H'+x2+'V'+y2+'V'+y1+'Z';					
			}else{
				path='M' + x1+ ' ' + y1+'H'+(x1+d)+'V'+y2+'H'+x2+'H'+(x1+d)+'V'+y1+'Z';
			}
			break;
		case 3:
			y1=bxy.y+bxy.height;
			if(y1>y2){						
				path='M' + x1+ ' ' + y1+'V'+(y1+d)+'H'+x2+'V'+y2+'V'+(y1+d)+'H'+x1+'Z';					
			}else{
				path='M' + x1+ ' ' + y1+'V'+y2+'H'+x2+'H'+x1+'Z';
			}
			break;
		default:
			x1=bxy.x;
			if(x1>x2){						
				path='M' + x1+ ' ' + y1+'H'+x2+'V'+y2+'V'+y1+'Z';					
			}else{
				path='M' + x1+ ' ' + y1+'H'+(x1-d)+'V'+y2+'H'+x2+'H'+(x1-d)+'V'+y1+'Z';
			}
		}								
		surface.curLine.setAttributes({
			path:path,
			stroke: this.stroke,
			fill:this.fill
			}, true);	
		surface.curLine.show();
	},
	drawSlineNode:function(line,bnode,enode){//从开始节点到鼠标结束位置的直线				
		var x1=bnode.x+bnode.width/2;
		var y1=bnode.y+bnode.height/2;
		var x2=enode.x+enode.width/2;
		var y2=enode.y+enode.height/2;
		if(x1==x2){
			y1=y2>y1?(y1+bnode.height/2):(y1-bnode.height/2);
		}else{															
			var z=Math.abs((y2-y1)/(x2-x1));
			if(z<1){						
				x1=x2>x1?(x1+bnode.width/2):(x1-bnode.width/2);
				y1=y2>y1?(y1+bnode.width/2*z):(y1-bnode.width/2*z);
				
				x2=x2>x1?(x2-enode.width/2):(x2+enode.width/2);
				y2=y2>y1?(y2-enode.width/2*z):(y2+enode.width/2*z);
			}else{
				x1=x2>x1?x1+bnode.height/(2*z):x1-bnode.height/(2*z);
				y1=y2>y1?(y1+bnode.height/2):(y1-bnode.height/2)							
										
				x2=x2>x1?(x2-enode.height/(2*z)):(x2+enode.height/(2*z));
				y2=y2>y1?(y2-enode.height/2):(y2+enode.height/2);
			}			
		}				
		
		var a=Math.atan((y2-y1)/(x2-x1));
		var b=a-Math.PI/6;
		var c=Math.PI/3-a;		
		if(x2>x1){
			x3=x2-this.arrowSide*Math.cos(b);
			y3=y2-this.arrowSide*Math.sin(b);				
			x4=x2-this.arrowSide*Math.sin(c);
			y4=y2-this.arrowSide*Math.cos(c);
		}else{
			x3=x2+this.arrowSide*Math.cos(b);
			y3=y2+this.arrowSide*Math.sin(b);				
			x4=x2+this.arrowSide*Math.sin(c);
			y4=y2+this.arrowSide*Math.cos(c);
		}
		
		line.setAttributes({
			path:'M' + x1+ ' ' + y1+ 'L' + x2 + ' ' + y2+ 'L'+x3 +' '+y3+'L'+x4+' '+y4+'L'+x2+' '+y2+'Z',
			stroke: this.stroke,
			fill:this.fill
			}, true);		
	},
	getPolyArrowPath:function(type,x,y){//按照type获取折线的箭头		
		var a=this.arrowSide;
		var a1=a*Math.sqrt(3)/2;
		var arrowPath;
		switch(type)
		{
		case 1:	//上下			
			arrowPath='L'+(x-a/2)+' '+(y-a1)+'h'+a+'L'+x+' '+y;			
			break;
		case 2:	//右左				
			arrowPath='L'+(x+a1)+' '+(y-a/2)+'v'+a+'L'+x+' '+y;
			break;
		case 3://下上									
			arrowPath='L'+(x-a/2)+' '+(y+a1)+'h'+a+'L'+x+' '+y;
			break;
		default://左右			
			arrowPath='L'+(x-a1)+' '+(y-a/2)+'v'+a+'L'+x+' '+y;
		}		
		return arrowPath;
	},
	getPolyStartPath:function(line,x,y){//按照type获取折线的起点		
		var type=line.bside,
			a=this.arrowSide,
			a1=a*Math.sqrt(3),
			startPath,
			tx,ty;
		//set textSprite
		if(line.textSprite.text==''){
			line.textSprite.text='通过';
		}
		
		switch(type)
		{
		case 1:	//上下			
			startPath='h'+(-a/2)+'v'+(-a)+'h'+a+'v'+a+'h'+(-a/2);	
			tx=x+10;
			ty=y-10;
//			startPath='L'+(x-a/2)+' '+(y-a1/2)+'L'+x+' '+(y-a1)+'L'+(x+a/2)+' '+(y-a1/2)+'L'+x+' '+y;			
			break;
		case 2:	//右左				
			startPath='v'+(-a/2)+'h'+a+'v'+a+'h'+(-a)+'v'+(-a/2);
			tx=x+15;
			ty=y-10;
//			startPath='L'+(x+a1/2)+' '+(y-a/2)+'L'+(x+a1)+' '+y+'L'+(x+a1/2)+' '+(y+a/2)+'L'+x+' '+y;			
			break;
		case 3://下上									
			startPath='h'+(-a/2)+'v'+a+'h'+a+'v'+(-a)+'h'+(-a/2);
			tx=x+10;
			ty=y+10;
//			startPath='L'+(x-a/2)+' '+(y+a1/2)+'L'+x+' '+(y+a1)+'L'+(x+a/2)+' '+(y+a1/2)+'L'+x+' '+y;			
			break;
		default://左右
			startPath='v'+(-a/2)+'h'+(-a)+'v'+a+'h'+a+'v'+(-a/2);
//			line.textSprite.text.length;
			tx=x-20-line.textSprite.text.length*12;
			ty=y-10;
//			startPath='L'+(x-a1/2)+' '+(y-a/2)+'L'+(x-a1)+' '+y+'L'+(x-a1/2)+' '+(y+a/2)+'L'+x+' '+y;			
		}	
		
		line.textSprite.setAttributes( {								
			x : tx,
			y : ty,
			text:line.textSprite.text
		}, true);
		
		return startPath;
	},
	drawPlineNode:function(line,bnode,enode){//根据两节点及折线的接入位置画折线							
		var x1=bnode.x+bnode.width/2;
		var y1=bnode.y+bnode.height/2;		
		var x2=enode.x+enode.width/2;
		var y2=enode.y+enode.height/2;		
		
		var path,p1,p2,p3,ap,sp;
		var d=this.polySide;	
			
		switch(line.bside)
		{
		case 1:			
			y1=bnode.y;	
			sp=this.getPolyStartPath(line,x1,y1);	
			switch(line.eside)
			{
			case 1:			
				y2=enode.y;						
				ap=this.getPolyArrowPath(line.eside,x2,y2);						
				if(y2>y1){	
					p1=y1-d;					
					if(Math.abs(x2-x1)>bnode.width/2){
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 + 'H' + x2+ 'V'+y2+ap+'V'+p1+'H'+x1+'Z';
					}else{
						p2=x2>x1?x2+enode.width/2+d:x2-enode.width/2-d;
						p3=y2-(y2-y1-bnode.height)/2;
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+p2+'V'+p3+'H'+x2+'V'+y2+ap+ 'V'+p3+'H'+p2+'V'+p1+'H'+x1+'Z';						
					}
				}else{		
					p1=y2-d;
					if(Math.abs(x2-x1)>enode.width/2){
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 + 'H' + x2+ 'V'+y2 +ap+ 'V'+p1+'H'+x1+'Z';
					}else{
						p1=y1-(y1-y2-enode.height)/2;
						p2=x2>x1?x2-enode.width/2-d:x2+enode.width/2+d;
						p3=y2-d;												
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+p2+'V'+p3+'H'+x2+'V'+y2+ap+ 'V'+p3+'H'+p2+'V'+p1+'H'+x1+'Z';
					}
				}				
				break;
			case 2:
				x2=enode.x+enode.width;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(y1-y2>enode.height/2){//bc
					if(x1-x2>=d){//c
						path='M' + x1+ ' ' + y1+sp+ 'V' + y2+'H'+x2+ap+'H'+x1+'Z';						
					}else{//b
						p1=y1-(y1-y2-enode.height/2)/2;
						p2=x2+d;						
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 + 'H' + p2+ 'V'+y2 +'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
					}
				}else{//ad
					if(x1-x2>bnode.width/2+d){//d
						p1=y1-d;
						p2=x2+(x1-x2-bnode.width/2)/2;
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 + 'H' + p2+ 'V'+y2 +'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
					}else{//a
						p1=y1-d<y2-enode.height/2?y1-d:y2-enode.height/2-d;
						p2=x2+d>x1+bnode.width/2?x2+d:x1+bnode.width/2+d;
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 + 'H' + p2+ 'V'+y2 +'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
					}
				}				
				break;
			case 3:
				y2=enode.y+enode.height;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(y2>y1-d*2){//上
					p1=y1-d;//V
					p3=y2+d;//V
					var pa=Math.abs(x2-x1)-bnode.width/2-enode.width/2;
					if(pa>2*d){
						p2=x1>x2?x2+enode.width/2+pa/2:x1+bnode.width/2+pa/2;
					}else{
						//
						p1=(y1-d<y2-enode.height||x1>x2)?y1-d:y2-enode.height-d;
						p2=Math.max(x1+bnode.width/2,x2+enode.width/2)+d;
						p3=(y1+bnode.height<y2+d||x2>x1)?y2+d:y1+bnode.height+d;
					}										
					path='M' + x1+ ' ' + y1+sp+ 'V' + p1 + 'H' + p2+ 'V'+p3+'H'+x2+'V'+y2 +ap+'V'+p3+'H'+p2+'V'+p1+'H'+x1+'Z';
				}else{//下
					p1=(y1+y2)/2;
					path='M' + x1+ ' ' + y1+sp+ 'V' + p1 + 'H' + x2+'V'+y2+ ap+'V'+p1 +'H'+x1+'Z';					
				}				
				break;
			default:
				x2=enode.x;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(y2+enode.height/2>y1-d){//上					
					if(x1+bnode.width/2<x2-d){//左
						if(y1-d>=y2){
							path='M' + x1+ ' ' + y1+sp+ 'V' + y2+'H'+x2+ap+'H'+x1+'Z';							
						}else{
							p1=y1-d;
							p2=x1+(x2-x1-bnode.width/2)/2+bnode.width/2;
							path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+p2+'V'+y2+'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';							
						}				
					}else{//右
						if(x2>=x1+this.arrowSide*Math.sqrt(3)/2 && y2<=y1){
							path='M' + x1+ ' ' + y1+sp+ 'V' + y2+'H'+x2+ap+'H'+x1+'Z';	
						}else{
							p1=y1-d<y2-enode.height/2?y1-d:y2-enode.height/2-d;
							p2=x1-bnode.width/2<x2-d?x1-bnode.width/2-d:x2-d;
							path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+p2+'V'+y2+'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
						}						
					}					
				}else{//下
					if(x1<x2-d){//左
						path='M' + x1+ ' ' + y1+sp+ 'V' + y2+'H'+x2+ap+'H'+x1+'Z';
					}else{//右
						p1=y1-(y1-y2-enode.height/2)/2;
						p2=x2-d;
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+p2+'V'+y2+'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
					}					
				}								
			}
			break;
		case 2:
			x1=bnode.x+bnode.width;			
			sp=this.getPolyStartPath(line,x1,y1);	
			switch(line.eside)
			{
			case 1:	
				y2=enode.y;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1>x2){//dc
					if(y1+bnode.height/2<y2-d){//d
						p1=x1+d;
						p2=y2-(y2-y1-bnode.height/2)/2;						
					}else{//c
						p1=x2+enode.width/2>x1+d?x2+enode.width/2+d:x1+d;
						p2=y1-bnode.height/2>y2-d?y2-d:y1-bnode.height/2-d;
					}
					path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+p2+'H'+x2+'V'+y2+ap+'V'+p2+'H'+p1+'V'+y1+'Z';
				}else{//ab
					if(y1<=y2-d){//a
						path='M' + x1+ ' ' + y1+sp+ 'H' + x2+'V'+y2+ap+'V'+y1+'Z';
					}else{//b
						p1=x2>x1+enode.width/2?x1+(x2-x1-enode.width/2)/2:x2+enode.width/2+d;
						p2=y2-d;
						path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+p2+'H'+x2+'V'+y2+ap+'V'+p2+'H'+p1+'V'+y1+'Z';
					}
				}
				break;
			case 2:	
				x2=enode.x+enode.width;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1+enode.width<x2 && Math.abs(y1-y2)<enode.height/2){
					p1=x1+(x2-x1-enode.width)/2;
					p2=Math.min(y1,y2)-enode.height/2-d;
					p3=x2+d;
					path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+p2+'H'+p3+'V'+y2+'H'+x2+ap+'H'+p3+'V'+p2+'H'+p1+'V'+y1+'Z';
				}else if(x2+bnode.width<x1 && Math.abs(y1-y2)<enode.height/2){
					p1=x1+d;
					p2=y1-bnode.height/2-d;
					p3=x2+(x1-x2-bnode.width)/2;
					path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+p2+'H'+p3+'V'+y2+'H'+x2+ap+'H'+p3+'V'+p2+'H'+p1+'V'+y1+'Z';
				}else{
					p1=x1>x2?x1+d:x2+d;
					path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+y2+'H'+x2+ap+'H'+p1+'V'+y1+'Z';
				}
				break;
			case 3:	
				y2=enode.y+enode.height;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1<x2-enode.width/2){//左
					if(y1<y2+d){//上	
						p1=x1+(x2-x1-enode.width/2)/2;
						p2=y2+d;
						path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+p2+'H'+x2+'V'+y2+ap+'V'+p2+'H'+p1+'V'+y1+'Z';						
					}else{//下
						path='M' + x1+ ' ' + y1+sp+ 'H' + x2 +'V'+y2+ap+'V'+y1+'Z';
					}
				}else{//右
					if(y1-bnode.height/2<y2+d){//上
						if(y1>y2&&x1<x2){
							path='M' + x1+ ' ' + y1+sp+ 'H' + x2 +'V'+y2+ap+'V'+y1+'Z';
						}else{
							p1=x1+d>x2+enode.width/2?x1+d:x2+enode.width/2+d;
							p2=y2+d>y1+bnode.height/2?y2+d:y1+bnode.height/2+d;
							path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+p2+'H'+x2+'V'+y2+ap+'V'+p2+'H'+p1+'V'+y1+'Z';
						}
																
					}else{//下
						if(y1>y2&&x1<x2){
							path='M' + x1+ ' ' + y1+sp+ 'H' + x2 +'V'+y2+ap+'V'+y1+'Z';
						}else{
							p1=x1+d;
							p2=y2+(y1-y2-bnode.height/2)/2;
							path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+p2+'H'+x2+'V'+y2+ap+'V'+p2+'H'+p1+'V'+y1+'Z';
						}						
					}
				}
				break;
			default:	
				x2=enode.x;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1<=x2-d){//左
					p1=x1+(x2-x1)/2;
					path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+y2+'H'+x2+ap+'H'+p1+'V'+y1+'Z';
				}else{//右					
					var pa=Math.abs(y1-y2)-bnode.height/2-enode.height/2;
					if(pa>0){
						p1=x1+d;
						p2=y1>y2?y1-pa/2-bnode.height/2:y2-pa/2-enode.height/2;
						p3=x2-d;
					}else{
						p1=Math.max(x1+d,x2+enode.width+d);
						p2=Math.max(y1+bnode.height/2,y2+enode.height/2)+d;						
						p3=y1<y2?x2-d:Math.min(x1-bnode.width-d,x2-d);
					}					
					path='M' + x1+ ' ' + y1+sp+ 'H' + p1 +'V'+p2+'H'+p3+'V'+y2+'H'+x2+ap+'H'+p3+'V'+p2+'H'+p1+'V'+y1+'Z';
				}
			}
			break;
		case 3:
			y1=bnode.y+bnode.height;		
			sp=this.getPolyStartPath(line,x1,y1);	
			switch(line.eside)
			{
			case 1:	
				y2=enode.y;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(y1<=y2-d){
					p1=(y2+y1)/2;					
					path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+x2+'V'+y2+ap+'V'+p1+'H'+x1+'V'+y1+'Z';
				}else{
					if(x2-x1-bnode.width/2-enode.width/2>0){
						p1=y1+d;
						p2=x1+(x2-x1-bnode.width/2-enode.width/2)/2+bnode.width/2;
						p3=y2-d;
					}else if(x1-x2-bnode.width/2-enode.width/2<0){
						p1=y1+d>y2+enode.height?y1+d:y2+enode.height+d;
						p2=Math.max(x1+bnode.width/2,x2+enode.width/2)+d;
						if(x1>x2){
							p3=y2-d<y1-bnode.height?y2-d:y1-bnode.height-d;
						}else{
							p3=y2-d;
						}
					}else{
						p1=y1+d;
						p2=x2+(x1-x2-bnode.width/2-enode.width/2)/2+enode.width/2;
						p3=y2-d;
					}
					path='M' + x1+ ' ' + y1+sp+'V'+p1+'H'+p2+'V'+p3+'H'+x2+'V'+y2+ap+'V'+p3+'H'+p2+'V'+p1+'H'+x1+'V'+y1+'Z';
				}
				break;
			case 2:	
				x2=enode.x+enode.width;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1<x2+d){//左
					if(y1<y2-enode.height/2){//上
						p1=y1+(y2-y1-enode.height/2)/2;
						p2=x2+d;
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+p2+'V'+y2+'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
					}else{//下
						p1=Math.max(y1,y2+enode.height/2)+d;
						p2=x1+bnode.width/2>x2+d?x1+bnode.width/2+d:x2+d;
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+p2+'V'+y2+'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
					}
				}else{//右
					if(y1<y2){//上
						path='M' + x1+ ' ' + y1+sp+ 'V' + y2 +'H'+x2+ap+'H'+x1+'Z';						
					}else{//下
						if(x2+d>x1-bnode.width/2){//同左下
							p1=y1+d>y2+enode.height/2?y1+d:y2+enode.height/2+d;
							p2=x1+bnode.width/2>x2+d?x1+bnode.width/2+d:x2+d;							
						}else{//
							p1=y1+d;
							p2=x2+(x1-x2-bnode.width/2)/2;							
						}
						path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+p2+'V'+y2+'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
					}					
				}
				break;
			case 3:	
				y2=enode.y+enode.height;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				p1=y1>y2?y1+d:y2+d;
				path='M' + x1+ ' ' + y1+sp+ 'V' + p1 +'H'+x2+'V'+y2+ap+'V'+p1+'H'+x1+'Z';				
				break;
			default:	
				x2=enode.x;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1<=x2){//左
					if(y1<y2){//上
						path='M' + x1+ ' ' + y1+sp+ 'V' + y2 +'H'+x2+ap+'H'+x1+'Z';
					}else{//下
						if(x1+bnode.width/2<x2-d){//偏左
							p1=y1+d;
							p2=x2-(x2-x1-bnode.width/2)/2;							
						}else{//偏右..
							p1=y1+d>y2+enode.height/2?y1+d:y2+enode.height/2+d;
							p2=x1-bnode.width/2<x2-d?x1-bnode.width/2-d:x2-d;
						}
						path='M' + x1+ ' ' + y1+sp+'V'+p1+'H'+p2+'V'+y2+'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
					}
				}else{//右
					if(y1+d<y2-enode.height/2){
						p1=y1+(y2-enode.height/2-y1)/2;
						p2=x2-d;						
					}else{
						p1=y1+d>y2+enode.height/2?y1+d:y2+enode.height/2+d;
						p2=x2-d<x1-bnode.width/2?x2-d:x1-bnode.width/2-d;
					}
					path='M' + x1+ ' ' + y1+sp+'V'+p1+'H'+p2+'V'+y2+'H'+x2+ap+'H'+p2+'V'+p1+'H'+x1+'Z';
				}				
			}
			break;
		default:			
			x1=bnode.x;
			sp=this.getPolyStartPath(line,x1,y1);	
			switch(line.eside)
			{
			case 1:	
				y2=enode.y;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1<=x2){//左
					if(y2-d>y1+bnode.height/2){//上
						p1=x1-d;
						p2=y2-(y2-y1-bnode.height/2)/2;						
					}else{//下
						p1=x1-d<x2-enode.width/2?x1-d:x2-enode.width/2-d;
						p2=y1-bnode.height/2<y2-d?y1-bnode.height/2-d:y2-d;
					}	
					path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+p2+'H'+x2+'V'+y2+ap+'V'+p2+'H'+p1+'V'+y1+'Z';
				}else{//右
					if(y1<=y2){//上
						path='M' + x1+ ' ' + y1+sp+'H'+x2+'V'+y2+ap+'V'+y1+'Z';
					}else{//下
						if(x1>x2+enode.width/2){//右
							p1=x1-(x1-x2-enode.width/2)/2;
							p2=y2-d;
						}else{//左
							p1=x2-enode.width/2<x1-d?x2-enode.width/2-d:x1-d;
							p2=y1-bnode.height/2<y2-d?y1-bnode.height/2-d:y2-d;
						}
						path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+p2+'H'+x2+'V'+y2+ap+'V'+p2+'H'+p1+'V'+y1+'Z';
					}
				}
				break;
			case 2:	
				x2=enode.x+enode.width;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1<x2){//左
					var pa=Math.abs(y1-y2)-bnode.height/2-enode.height/2;
					if(pa>0){
						p1=x1-d;
						p2=y1<y2?y1+bnode.height/2+pa/2:y2+enode.height/2+pa/2;
						p3=x2+d;
					}else{												
						p2=Math.max(y1+bnode.height/2,y2+enode.height/2)+d;
						if(y1<y2){
							p1=x1-d<x2-enode.width?x1-d:x2-enode.width-d;
							p3=x2+d;							
						}else{
							p1=x1-d;
							p3=x2+d>x1+bnode.width?x2+d:x1+bnode.width+d;
						}																		
					}
					path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+p2+'H'+p3+'V'+y2+'H'+x2+ap+'H'+p3+'V'+p2+'H'+p1+'V'+y1+'Z';					
				}else{//右
					p1=(x2+x1)/2;
					path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+y2+'H'+x2+ap+'H'+p1+'V'+y1+'Z';
				}
				break;
			case 3:	
				y2=enode.y+enode.height;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1>x2 && y1>y2){
					path='M' + x1+ ' ' + y1+sp+'H'+x2+'V'+y2+ap+'V'+y1+'Z';
				}else{
					if(x1-bnode.width/2<=x2+enode.width/2){//左
						if(y1-bnode.height/2-d<=y2){//上
							p1=Math.min(x1,x2-enode.width/2)-d;
							p2=Math.max(y1+bnode.height/2,y2)+d;							
						}else{//下						
							p1=x1-d;
							p2=y2+(y1-y2-bnode.height/2)/2;																	
						}					
					}else{//右
						p1=x1-(x1-x2-enode.width/2)/2;
						p2=y2+d;														
					}
					path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+p2+'H'+x2+'V'+y2+ap+'V'+p2+'H'+p1+'V'+y1+'Z';	
				} 				
				break;
			default:	
				x2=enode.x;
				ap=this.getPolyArrowPath(line.eside,x2,y2);
				if(x1>x2+enode.width && Math.abs(y1-y2)<enode.height/2){//正后面
					p1=x1-(x1-x2-enode.width)/2;
					p2=y2-enode.height/2-d;
					p3=x2-d;
					path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+p2+'H'+p3+'V'+y2+'H'+x2+ap+'H'+p3+'V'+p2+'H'+p1+'V'+y1+'Z';	
				}else if(x1+bnode.width<x2 && Math.abs(y1-y2)<enode.height/2){//正前面
					p1=x1-d;
					p2=Math.max(y1+bnode.height/2,y2)+d;
					p3=x2-(x2-x1-bnode.width)/2;
					path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+p2+'H'+p3+'V'+y2+'H'+x2+ap+'H'+p3+'V'+p2+'H'+p1+'V'+y1+'Z';
				}else{
					p1=Math.min(x1,x2)-d;
					path='M' + x1+ ' ' + y1+sp+'H'+p1+'V'+y2+'H'+x2+ap+'H'+p1+'V'+y1+'Z';
				}
			}
		}
		
		line.setAttributes({
			path:path,
			stroke: this.stroke,
			fill:this.fill
			}, true);		
	}
});