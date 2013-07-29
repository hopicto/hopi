--特殊账户
drop table #temp_teshu;
create table #temp_teshu
(	
	zjzh varchar(128)	
	,constraint pk_skb_temp_teshu primary key (zjzh)
);

insert into #temp_teshu values('280004808');	--关联方账户
insert into #temp_teshu values('20035918');	 	--关联方账户
insert into #temp_teshu values('160024896');	--关联方账户
insert into #temp_teshu values('30077888');		--关联方账户（兴业慈善）
insert into #temp_teshu values('380038468');	--总部销售定向账户
insert into #temp_teshu values('380038588');	--总部销售定向账户

declare 
	--变量设置区域
	@nian varchar(4),		--本月_年份
	@yue varchar(2),		--本月_月份
	@nian_sx varchar(4),	--属性_年份
	@yue_sx varchar(2),		--属性_月份
	@nian_gx varchar(4),	--关系_年份
	@yue_gx varchar(2),		--关系_月份		
	
	--年月		
	@sy_nian varchar(4),	--上月_年份
	@sy_yue varchar(2),		--上月_月份	
	@snm_nian varchar(4),	--上年末_年份
	@snm_yue varchar(2),	--上年末_月份	
	@sntq_nian varchar(4),	--上年同期_年份
	@sntq_yue varchar(2),	--上年同期_月份
	
	--交易日
	@td_nc int,				--年初
	@td_nm int,				--年末
	@td_yc int,				--月初
	@td_ym int,				--月末
	@td_syc int,			--上月初
	@td_sym int,			--上月末
	@td_snc int,			--上年初
	@td_snm int,			--上年末
	--天数		
	@ts_m int,				--当前月自然日
	@ts_y int				--当前年自然日
set @nian='2013'
set @yue='05'
set @nian_sx='2013'
set @yue_sx='05'
set @nian_gx='2013'
set @yue_gx='05'

set @td_nc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@nian||'0101'))
set @td_nm=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@nian||'1231'))
set @td_yc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@nian||@yue||'01'))
set @td_ym=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@nian||@yue||'31'))
set @td_sym=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<@td_yc)
set @sy_nian=substring(convert(varchar,@td_sym),1,4)
set @sy_yue=substring(convert(varchar,@td_sym),5,7)
set @snm_nian=convert(varchar,convert(int,@nian)-1)
set @snm_yue='12'
set @sntq_nian=convert(varchar,convert(int,@nian)-1)
set @sntq_yue=@yue
set @td_syc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@sy_nian||@sy_yue||'01'))
set @td_snc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@snm_nian||'0101'))
set @td_snm=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@snm_nian||@snm_yue||'31'))
set @ts_m=(select ts_m from dba.t_ddw_d_rq_m where ny=convert(int,@nian||@yue))
set @ts_y=(select ts_y from dba.t_ddw_d_rq_m where ny=convert(int,@nian||@yue))
insert into #temp_teshu
(
	zjzh
)
(
	select 
		a.zjzh
	from dba.gt_ods_simu_trade_jour a
	left join #temp_teshu b on a.zjzh=b.zjzh
	where 
		a.ny <= convert(int,@nian||@yue)				 --发生日期在本月之前
		and a.yxq_end >=(convert(int,@nian||@yue)*100+31)  --当期仍有效！！
		and a.zjzh is not null
		and b.zjzh is null		
	group by a.zjzh
);


--大小非客户
drop table #temp_dxf;
create table #temp_dxf
(
	zjzh varchar(128)
	,constraint pk_skb_temp_dxf primary key (zjzh)
);
declare 
	--变量设置区域
	@nian varchar(4),		--本月_年份
	@yue varchar(2),		--本月_月份
	@nian_sx varchar(4),	--属性_年份
	@yue_sx varchar(2),		--属性_月份
	@nian_gx varchar(4),	--关系_年份
	@yue_gx varchar(2),		--关系_月份		
	
	--年月		
	@sy_nian varchar(4),	--上月_年份
	@sy_yue varchar(2),		--上月_月份	
	@snm_nian varchar(4),	--上年末_年份
	@snm_yue varchar(2),	--上年末_月份	
	@sntq_nian varchar(4),	--上年同期_年份
	@sntq_yue varchar(2),	--上年同期_月份
	
	--交易日
	@td_nc int,				--年初
	@td_nm int,				--年末
	@td_yc int,				--月初
	@td_ym int,				--月末
	@td_syc int,			--上月初
	@td_sym int,			--上月末
	@td_snc int,			--上年初
	@td_snm int,			--上年末
	--天数		
	@ts_m int,				--当前月自然日
	@ts_y int				--当前年自然日
set @nian='2013'
set @yue='05'
set @nian_sx='2013'
set @yue_sx='05'
set @nian_gx='2013'
set @yue_gx='05'

set @td_nc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@nian||'0101'))
set @td_nm=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@nian||'1231'))
set @td_yc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@nian||@yue||'01'))
set @td_ym=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@nian||@yue||'31'))
set @td_sym=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<@td_yc)
set @sy_nian=substring(convert(varchar,@td_sym),1,4)
set @sy_yue=substring(convert(varchar,@td_sym),5,7)
set @snm_nian=convert(varchar,convert(int,@nian)-1)
set @snm_yue='12'
set @sntq_nian=convert(varchar,convert(int,@nian)-1)
set @sntq_yue=@yue
set @td_syc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@sy_nian||@sy_yue||'01'))
set @td_snc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@snm_nian||'0101'))
set @td_snm=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@snm_nian||@snm_yue||'31'))
set @ts_m=(select ts_m from dba.t_ddw_d_rq_m where ny=convert(int,@nian||@yue))
set @ts_y=(select ts_y from dba.t_ddw_d_rq_m where ny=convert(int,@nian||@yue))

insert into #temp_dxf(
	zjzh
)
(	
	select zjzh
	from dba.t_edw_dxfkhmd t_dxf
	where t_dxf.nian=@nian and t_dxf.yue=@yue
	union 
	select zjzh
	from dba.t_ddw_yunying2012_kh 
	where nian=@nian and yue=@yue and zjzh in ('30083009','160041993','160042499','160042650')
	group by zjzh
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

insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('199015','兴证-龙溪股份-普通','万家基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343043','定增7号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343058','定增11号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343054','定增10号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('343050','定增9号普通','兴业基金','基金专户-股票型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347006','兴全睿贷2号','兴业基金','基金专户-货币型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347007','兴全睿质5号','兴业基金','基金专户-债券型');
insert into #temp_nbcscp(jjdm,jjmc,jjgs,jjlb) values('347002','兴全睿质3号','兴业基金','基金专户-债券型');

--财富中心对照
drop table #temp_cfzx;
create table #temp_cfzx
(
	ygh varchar(128),
	ygxm varchar(128),
	constraint pk_skb_temp_cfzx primary key (ygh)
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

--产品分类考核系数
drop table #temp_khxs;
create table #temp_khxs
(
	产品类型 					varchar(128)	not null,
	考核系数 					numeric(20,4),	
	责权关系类型					varchar(128),--对应责任权益关系业务类别	
	constraint pk_skb_temp_khxs primary key (产品类型)
);

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
