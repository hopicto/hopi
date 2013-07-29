--特殊账户
--drop table #temp_teshu;
create table #temp_teshu
(
lx varchar(128),
zjzh varchar(128),
cpmc varchar(128)
);

insert into #temp_teshu values('剔除','280004808',null);		--关联方账户
insert into #temp_teshu values('剔除','20035918',null);	 	--关联方账户
insert into #temp_teshu values('剔除','160024896',null);		--关联方账户
insert into #temp_teshu values('剔除','30077888',null);		--关联方账户（兴业慈善）
insert into #temp_teshu values('剔除','380038468',null);		--总部销售定向账户
insert into #temp_teshu values('剔除','380038588',null);		--总部销售定向账户

--财富中心对照
--drop table #temp_cfzx;
create table #temp_cfzx
(
	ygh varchar(128),
	ygxm varchar(128)
);
insert into #temp_cfzx values('999912064','陈晓栋');
insert into #temp_cfzx values('999915169','迟睿峰');
insert into #temp_cfzx values('999912090','康珊');
insert into #temp_cfzx values('999915172','连宇航');
insert into #temp_cfzx values('999912066','汪翀');
insert into #temp_cfzx values('999912078','王轩涛');
insert into #temp_cfzx values('999912043','余加达');

--陈晓栋、迟睿峰、康珊、连宇航、汪翀、王轩涛、余加达

--insert into #temp_cfzx values('2800307','王轩涛');
--insert into #temp_cfzx values('2800306','汪翀');
--insert into #temp_cfzx values('2800308','连宇航');
--insert into #temp_cfzx values('2800291','迟睿峰');
--insert into #temp_cfzx values('2800295','陈晓栋');

--select t1.ygh,t1.ygxm from dba.t_ddw_yunying2012_yg t1
--where
----t1.nian='2013' 
----and t1.yue='03'
----t1.jgbh='XYSHPT2700'
--t1.jxlx='实发'
--and t1.ygxm in
--(
--'陈晓栋',
--'康珊',
--'汪翀',
--'王轩涛',
--'连宇航',
--'迟睿峰',
--'余加达'
--)
--group by t1.ygxm,t1.ygh
--order by t1.ygxm;
--output to "C:\ado_data\财富中心.xls" format excel


----基金专户优先级
----drop table #temp_jjzhyx;
--create table #temp_jjzhyx
--(
--	jjdm varchar(128),
--	jjmc varchar(128)
--);
--insert into #temp_jjzhyx values('343042','兴全定增7号-优先级1');
--insert into #temp_jjzhyx values('343048','兴全定增9号-优先级1');
--insert into #temp_jjzhyx values('343049','兴全定增9号-优先级2');
--insert into #temp_jjzhyx values('343052','兴全定增10号-优先级1');
--insert into #temp_jjzhyx values('343053','兴全定增10号-优先级2');
--insert into #temp_jjzhyx values('347002','万家兴证-股权质押');
----add 20130508
--insert into #temp_jjzhyx values('199014','兴证-龙溪股份-优先');

--内部创设产品
--drop table #temp_nbcscp;
create table #temp_nbcscp
(
	jjdm varchar(128)
	,jjmc varchar(128)
	,jjgs varchar(128)
	,jjlb varchar(128)
);
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('199015','兴证-龙溪股份-普通','万家基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343043','定增7号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343058','定增11号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343054','定增10号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343050','定增9号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347006','兴全睿贷2号','兴业基金','基金专户-货币型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347007','兴全睿质5号','兴业基金','基金专户-债券型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347002','兴全睿质3号','兴业基金','基金专户-债券型');
