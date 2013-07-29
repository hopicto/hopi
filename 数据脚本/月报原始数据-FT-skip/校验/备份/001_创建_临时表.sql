--特殊账户
drop table #temp_teshu;
create table #temp_teshu
(	
	zjzh varchar(128)	
	,constraint pk_skb_temp_teshu primary key (zjzh)
);

--大小非客户
drop table #temp_dxf;
create table #temp_dxf
(
	zjzh varchar(128)
	,constraint pk_skb_temp_dxf primary key (zjzh)
);

--内部创设产品
drop table #temp_nbcscp;
create table #temp_nbcscp
(
	jjdm varchar(128)
	,jjmc varchar(128)
	,jjgs varchar(128)
	,jjlb varchar(128)
	,constraint pk_skb_temp_nbcscp primary key (jjdm)
);

--财富中心对照
drop table #temp_cfzx;
create table #temp_cfzx
(
	ygh varchar(128),
	ygxm varchar(128),
	constraint pk_skb_temp_cfzx primary key (ygh)
);

--营业部对照表（增加财富中心）
drop table #temp_yybdz;
create table #temp_yybdz
(
	jgbh varchar(128)
	,jgmc varchar(128)
	,zxyybbh varchar(128)
	,zxyybmc varchar(128)
	,fgs varchar(128)
	,jgfl varchar(128)
	,dqfl varchar(128)
	,mbkhzc numeric(20,4)
	,szcs varchar(128)
	,jgqc varchar(128)
	,constraint pk_skb_temp_yybdz primary key (jgbh)
);

--产品分类考核系数
drop table #temp_khxs;
create table #temp_khxs
(
	产品类型 					varchar(128)	not null,
	考核系数 					numeric(20,4),	
	责权关系类型					varchar(128),--对应责任权益关系业务类别	
	constraint pk_skb_temp_khxs primary key (产品类型)
);