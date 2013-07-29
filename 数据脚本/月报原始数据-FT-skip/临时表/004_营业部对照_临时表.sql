--营业部对照表（增加财富中心）
drop table #temp_yybdz;
create table #temp_yybdz
(
	jgbh varchar(128) not null
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
--营业部对照表（增加财富中心）
insert into #temp_yybdz(
	jgbh
	,jgmc
	,zxyybbh
	,zxyybmc
	,fgs
	,jgfl
	,dqfl
	,mbkhzc
	,szcs
	,jgqc
)
(
	select
		t1.jgbh
		,t1.jgmc
		,t1.zxyybbh
		,t1.zxyybmc
		,t1.fgs
		,t1.jgfl
		,t1.dqfl
		,t1.mbkhzc
		,t1.szcs
		,t2.org_full_name as jgqc
	from dba.yybdz t1
	left join DBA.T_EDW_T06_ORGANIZATION t2 on t1.jgbh=t2.org_cd
	union
	select
		'#CFZX' as jgbh
		,'财富中心' as jgmc
		,'XYSHPT2700' as zxyybbh
		,'上海民生' as zxyybmc
		,'上海民生' as fgs
		,'D' as jgfl
		,'1' as dqfl
		,100.00 as mbkhzc
		,'上海' as szcs		
		,'财富中心' as jgqc
);