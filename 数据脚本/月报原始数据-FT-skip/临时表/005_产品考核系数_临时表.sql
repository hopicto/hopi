--产品分类考核系数
drop table #temp_khxs;
create table #temp_khxs
(
	产品类型 					varchar(128)	not null,
	考核系数 					numeric(20,4),	
	责权关系类型					varchar(128),--对应责任权益关系业务类别	
	constraint pk_skb_temp_khxs primary key (产品类型)
);
--产品分类考核系数
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('核心-公募-股票型',1.0,'4');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('非核心-公募-股票型',0.8,'4');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('公募-债券型-有手续费',0.4,'4');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('公募-债券型-无手续费',0.1,'4');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('公募-货币型',0.1,'4');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('集合理财-股票型',1.0,'6');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('集合理财-债券型',0.5,'6');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('集合理财-货币型',0.1,'6');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('基金专户-股票型',1.0,'5');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('基金专户-债券型',0.5,'5');
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('基金专户-货币型',0.1,'5');
--未设置类型，暂按1.0计算，责权关系按非核心基金股票型统计
insert into #temp_khxs(产品类型,考核系数,责权关系类型) values('未设置类型',1.0,'4');
