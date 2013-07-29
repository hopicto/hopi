--存放体外产品客户
drop table #temp_twcp_kh;
create table #temp_twcp_kh
(	
	cpmc	varchar(128),	
	jgbh	varchar(128),
	khxm	varchar(128),
	zjzh	varchar(128)
	constraint pk_skb_temp_twcp_kh primary key (cpmc,jgbh,khxm,zjzh)
);
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYRYSH1310','李素珍','110028217');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYLYYB1300','胡振安','110049317');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYJNSD2300','陈煜','120002007');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYJNSD2300','杨景芝','120003762');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYSHFB0100','丁尧娟','160036377');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZHL0400','陈励婷','20035097');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','#999999995','林红珍','20036053');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZHL0400','唐硕','20039329');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZHL0400','俞小思','20039331');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZHL0400','张驰','20070386');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYXMFS0700','李雯','210025254');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYXMFS0700','陈雪琦','210033842');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','#999999995','陈刚','280009423');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYSHPT2700','陶昕晔','280009611');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYSHGY0160','尹洁','280010638');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZZS0300','陈桂清','30066761');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZTJ0500','蔡玮绣','310009083');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZJH0600','林航','320011246');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZJH0600','林振兴','320036865');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYWHYB1600','王阁惠','380038432');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYNPYB1200','谢坚','38681');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYNJYB1700','黄志康','460012490');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYNJYB1700','骆冀云','460013410');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYNJYB1700','陈永财','460013426');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYXAJF1900','裴金泽','470032511');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYXAJF1900','徐冬梅','470049506');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYXAJF1900','吴实华','470050095');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYCDHX1800','唐功成','480047108');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYCDHX1800','吴月元','480048934');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYHBSY2200','王永洁','490028176');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYHNCS3000','王建湘','620005608');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYHBSJ3100','李丽娟','630006265');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYAHHF3200','许京水','640004137');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYAHHF3200','陈磊','640004148');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZST3500','福建信睿网络科技有限公司','660002866');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYSDQD2310','兰静静','760001820');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYSDQD2310','杨东芳','760003288');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYFZZS0300','陈建文','9000817');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYQZSS1030','洪于挺','90096018');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('享誉2号','XYQZYB1000','林婉珠','90102258');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','任卫平','280000038');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','陈磊','280012420');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','郭薇','280012415');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','孙若麑','280012319');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','杨海云','280012130');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','王江南','280012110');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','陈洋','280012082');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','沈晓峻','280012073');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','章玲芳','280011931');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','陆涵成','280011588');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','王飙','280011451');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','曹江','280011418');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','黄超俊','280011390');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','吴柏阳','280011273');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','顾薇','280011265');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','王爱臣','280010567');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','诸良达','280010502');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','陈静','280009912');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','远博','280009448');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','姚惠娣','280009207');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','王勇','280009070');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','薛炯','280008136');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','蒋宏','280008021');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','黄旭','280007446');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','叶建英','280007405');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','刘晓峰','280007371');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','陈雪凡','280007298');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','高峰','280007276');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','翁艇','280006903');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','戴涛','280006786');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','汤继东','280006702');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','王兵','280006211');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','董玉华','280004598');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','杨娜娜','280001695');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','周熹','280001528');
insert into #temp_twcp_kh(cpmc,jgbh,khxm,zjzh) values('淘利跨期套利','XYSHPT2700','顾鹏程','280000081');