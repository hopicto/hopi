--内部创设产品
drop table #temp_nbcscp;
create table #temp_nbcscp
(
	jjdm varchar(128) not null
	,jjmc varchar(128)
	,jjgs varchar(128)
	,jjlb varchar(128)
	,constraint pk_skb_temp_nbcscp primary key (jjdm)
);
--内部创设产品
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('199015','兴证-龙溪股份-普通','万家基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343043','定增7号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343058','定增11号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343054','定增10号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343050','定增9号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347006','兴全睿贷2号','兴业基金','基金专户-货币型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347007','兴全睿质5号','兴业基金','基金专户-债券型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347002','兴全睿质3号','兴业基金','基金专户-债券型');