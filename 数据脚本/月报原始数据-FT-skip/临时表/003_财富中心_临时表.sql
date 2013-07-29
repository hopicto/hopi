--财富中心对照
drop table #temp_cfzx;
create table #temp_cfzx
(
	ygh varchar(128) not null
	,ygxm varchar(128)
	,constraint pk_skb_temp_cfzx primary key (ygh)
);
--财富中心对照
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

