--存放客户分类属性
drop table #temp_khsx;
create table #temp_khsx
(
	nian						varchar(4)		not null,--年
	yue 						varchar(2)		not null,--月
	zjzh 						varchar(128)	not null,--资金帐号		
	khbh_hs						varchar(128)	not null,--资金帐号
	jgbh						varchar(128),
	客户状态						varchar(128),
	目标客户标准					numeric(20,4),
	资产段						varchar(128),
	资产段_上年末				varchar(128),
	总资产_月日均				numeric(20,4),
	总资产_月日均_上年末			numeric(20,4),
	账户性质						varchar(128),
	是否年新增					int,
	是否月新增					int,
	是否大小非客户				int,
	是否营业部目标客户			int,
	是否有效户					int,
	是否产品新客户				int,
	
	--期末
	期末公募基金保有 			numeric(20,4),
	期末核心公募基金保有 			numeric(20,4),
	期末定向保有 				numeric(20,4),
	期末集合理财保有		 		numeric(20,4),
	期末私募保有				 	numeric(20,4),
	
	期末公募基金保有_考核 		numeric(20,4),
	期末核心公募基金保有_考核		numeric(20,4),
	期末定向保有_考核 			numeric(20,4),
	期末集合理财保有_考核		 	numeric(20,4),
	期末私募保有_考核		 	numeric(20,4),
	
	期末有效二级资产		 		numeric(20,4),
	期末大小非折算市值		 	numeric(20,4),
	期末约定购回净资产			numeric(20,4),	
	
	期末股基市值					numeric(20,4),	
	期末债券市值					numeric(20,4),
	期末回购市值					numeric(20,4),
	
	期末保证金					numeric(20,4),
	期末其他资产					numeric(20,4),
	
	期末低风险_封顶待扣除			numeric(20,4),
	期末资产_大小非_封顶			numeric(20,4),
	
	--月日均
	月日均公募基金保有 			numeric(20,4),
	月日均核心公募基金保有 		numeric(20,4),
	月日均定向保有 				numeric(20,4),
	月日均集合理财保有			numeric(20,4),
	月日均私募保有			 	numeric(20,4),
	
	月日均公募基金保有_考核 		numeric(20,4),
	月日均核心公募基金保有_考核	numeric(20,4),
	月日均定向保有_考核 			numeric(20,4),
	月日均集合理财保有_考核	 	numeric(20,4),
	月日均私募保有_考核		 	numeric(20,4),
	
	月日均有效二级资产			numeric(20,4),
	月日均大小非折算市值		 	numeric(20,4),
	月日均约定购回净资产			numeric(20,4),	
	
	月日均股基市值				numeric(20,4),	
	月日均债券市值				numeric(20,4),
	月日均回购市值				numeric(20,4),
	
	月日均保证金					numeric(20,4),
	月日均其他资产				numeric(20,4),
	
	月日均低风险_封顶待扣除		numeric(20,4),
	月日均资产_大小非_封顶		numeric(20,4),
	
	年日均保证金_计算利差使用		numeric(20,4),
	
	--gj交易量
	gj交易量_月累计_含根网		numeric(20,4),
	gj交易量_月累计_扣根网		numeric(20,4),
	gj净佣金_月累计				numeric(20,4),
	gj交易量_年累计_含根网		numeric(20,4),
	gj交易量_年累计_扣根网		numeric(20,4),
	gj净佣金_年累计				numeric(20,4),
	
	--债券交易
	债券交易量_月累计			numeric(20,4),
	回购交易量_月累计			numeric(20,4),
	债券净佣金_月累计			numeric(20,4),
	回购净佣金_月累计			numeric(20,4),
	债券交易量_年累计			numeric(20,4),
	回购交易量_年累计			numeric(20,4),
	债券净佣金_年累计			numeric(20,4),
	回购净佣金_年累计			numeric(20,4),
	
	--月收入
	佣金收入_月累计				numeric(20,4),
	利差收入_月累计				numeric(20,4),
	融资融券信用交易净收入_月累计	numeric(20,4),
	融资融券利息收入_月累计		numeric(20,4),
	开放式基金手续费_月累计		numeric(20,4),
	定向产品手续费_月累计			numeric(20,4),
	资管产品手续费_月累计			numeric(20,4),
	公募基金分仓转移_月累计		numeric(20,4),
	
	--年收入
	佣金收入_年累计				numeric(20,4),
	利差收入_年累计				numeric(20,4),
	融资融券信用交易净收入_年累计	numeric(20,4),
	融资融券利息收入_年累计		numeric(20,4),
	开放式基金手续费_年累计		numeric(20,4),
	定向产品手续费_年累计			numeric(20,4),
	资管产品手续费_年累计			numeric(20,4),
	公募基金分仓转移_年累计		numeric(20,4),
	
	constraint pk_skb_temp_khsx primary key (nian,yue,zjzh,khbh_hs)
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

insert into #temp_khsx(
	nian
	,yue
	,zjzh
	,khbh_hs						
	,jgbh						
	,客户状态
	,目标客户标准			
	,资产段						
	,资产段_上年末				
	,总资产_月日均		
	,总资产_月日均_上年末	
	,账户性质						
	,是否年新增					
	,是否月新增					
	,是否大小非客户				
	,是否营业部目标客户			
	,是否有效户					
	,是否产品新客户				
	
	--期末
	,期末公募基金保有 	
	,期末核心公募基金保有 	
	,期末定向保有 		
	,期末集合理财保有		 
	,期末私募保有				 	
	
	,期末公募基金保有_考核 
	,期末核心公募基金保有_考核
	,期末定向保有_考核 	
	,期末集合理财保有_考核		 	
	,期末私募保有_考核		 	
	
	,期末有效二级资产		 
	,期末大小非折算市值		 	
	,期末约定购回净资产		
	
	,期末股基市值				
	,期末债券市值			
	,期末回购市值			
	
	,期末保证金			
	,期末其他资产			
	
	,期末低风险_封顶待扣除	
	,期末资产_大小非_封顶	
	
	--月日均
	,月日均公募基金保有 	
	,月日均核心公募基金保有 
	,月日均定向保有 		
	,月日均集合理财保有	
	,月日均私募保有			 	
	
	,月日均公募基金保有_考核 
	,月日均核心公募基金保有_考核	
	,月日均定向保有_考核 	
	,月日均集合理财保有_考核	 	
	,月日均私募保有_考核		 	
	
	,月日均有效二级资产	
	,月日均大小非折算市值		 	
	,月日均约定购回净资产		
	
	,月日均股基市值			
	,月日均债券市值		
	,月日均回购市值		
	
	,月日均保证金			
	,月日均其他资产		
	
	,月日均低风险_封顶待扣除
	,月日均资产_大小非_封顶
	
	,年日均保证金_计算利差使用
	
	--gj交易量
	,gj交易量_月累计_含根网
	,gj交易量_月累计_扣根网
	,gj净佣金_月累计		
	,gj交易量_年累计_含根网
	,gj交易量_年累计_扣根网
	,gj净佣金_年累计		
	
	--债券交易
	,债券交易量_月累计	
	,回购交易量_月累计	
	,债券净佣金_月累计	
	,回购净佣金_月累计	
	,债券交易量_年累计	
	,回购交易量_年累计	
	,债券净佣金_年累计	
	,回购净佣金_年累计	
	
	--月收入
	,佣金收入_月累计		
	,利差收入_月累计		
	,融资融券信用交易净收入_月累计	
	,融资融券利息收入_月累计
	,开放式基金手续费_月累计
	,定向产品手续费_月累计	
	,资管产品手续费_月累计	
	,公募基金分仓转移_月累计
	
	--年收入
	,佣金收入_年累计		
	,利差收入_年累计		
	,融资融券信用交易净收入_年累计	
	,融资融券利息收入_年累计
	,开放式基金手续费_年累计
	,定向产品手续费_年累计	
	,资管产品手续费_年累计	
	,公募基金分仓转移_年累计
)
(
	select
		@nian as nian
		,@yue as yue		
		,t_yue.zjzh
		,t_yue.khbh_hs
		,t_yue.jgbh
		,t_yue.khzt as 客户状态
		,yyb.mbkhzc as 目标客户标准
		,case when 总资产_月日均<=20*10000 then '1-小于20w'
			when 总资产_月日均 > 20*10000 and 总资产_月日均<=50*10000 then '2-20w_50w'
			when 总资产_月日均 > 50*10000 and 总资产_月日均<=100*10000 then '3-50w_100w'
			when 总资产_月日均 > 100*10000 and 总资产_月日均<=200*10000 then '4-100w_200w'
			when 总资产_月日均 > 200*10000 and 总资产_月日均<=300*10000 then '5-200w_300w'
			when 总资产_月日均 > 300*10000 and 总资产_月日均<=500*10000 then '6-300w_500w'
			when 总资产_月日均 > 500*10000 and 总资产_月日均<=1000*10000 then '7-500w_1000w'
			when 总资产_月日均 > 1000*10000 and 总资产_月日均<=3000*10000 then '8-1000w_3000w'
			when 总资产_月日均 > 3000*10000 then '9->3000w'
		else '1-小于20w' end as 资产段
		,case when 总资产_月日均_snm<=20*10000 then '1-小于20w'
			when 总资产_月日均_snm > 20*10000 and 总资产_月日均_snm<=50*10000 then '2-20w_50w'
			when 总资产_月日均_snm > 50*10000 and 总资产_月日均_snm<=100*10000 then '3-50w_100w'
			when 总资产_月日均_snm > 100*10000 and 总资产_月日均_snm<=200*10000 then '4-100w_200w'
			when 总资产_月日均_snm > 200*10000 and 总资产_月日均_snm<=300*10000 then '5-200w_300w'
			when 总资产_月日均_snm > 300*10000 and 总资产_月日均_snm<=500*10000 then '6-300w_500w'
			when 总资产_月日均_snm > 500*10000 and 总资产_月日均_snm<=1000*10000 then '7-500w_1000w'
			when 总资产_月日均_snm > 1000*10000 and 总资产_月日均_snm<=3000*10000 then '8-1000w_3000w'
			when 总资产_月日均_snm > 3000*10000 then '9->3000w'
		else '1-小于20w' end as 资产段_上年末
		,coalesce(t_yue_zh.日均资产,0) + coalesce(t_yue_2011.rzrq_rjzc_m,0)+coalesce(t_yue.ydghjzc_yrj,0) as 总资产_月日均
		,coalesce(t_yue_zh_snm.日均资产,0) + coalesce(t_yue_2011_snm.rzrq_rjzc_m,0)+coalesce(t_yue_snm.ydghjzc_yrj,0) as 总资产_月日均_上年末
		,t_yue_zh.帐户性质 as 账户性质
		,t_yue.sfxz_y as 是否年新增
		,t_yue.sfxz_m as 是否月新增
		,case when t_dxf.zjzh is not null then 1 else 0 end as 是否大小非客户
		,case when 总资产_月日均>= (yyb.mbkhzc*10000) then 1 else 0 end as 是否营业部目标客户		
		,t_yue.sfyxh as 是否有效户		
		,t_yue_cpxkh.是否产品新客户
		
		--期末
	,期末公募基金保有 	
	,期末核心公募基金保有 	
	,期末定向保有 		
	,期末集合理财保有		 
	,期末私募保有				 	
	
	,期末公募基金保有_考核 
	,期末核心公募基金保有_考核
	,期末定向保有_考核 	
	,期末集合理财保有_考核		 	
	,期末私募保有_考核		 	
	
	,期末有效二级资产		 
	,期末大小非折算市值		 	
	,期末约定购回净资产		
	
	,期末股基市值				
	,期末债券市值			
	,期末回购市值			
	
	,期末保证金			
	,期末其他资产			
	
	,期末低风险_封顶待扣除	
	,期末资产_大小非_封顶	
	
	
	from	
	(
		select
			t1.*			
		from dba.t_ddw_yunying2012_kh t1
		where t1.nian=@nian and t1.yue=@yue
	) t_yue
	left join
	(
		select 
			zjzh,
			case when sum(sfcpxkh)>0 then 1 else 0 end as 是否产品新客户
			from dba.t_ddw_yunying2012_kh
		where nian=@nian and yue<=@yue
		group by zjzh
	) t_yue_cpxkh on t_yue.zjzh=t_yue_cpxkh.zjzh
	left join #temp_dxf t_dxf on t_yue.zjzh = t_dxf.zjzh	
	left join
	(
		select
			t1.资金账户 as zjzh
			,t1.日均资产
			,t1.帐户性质
		from DBA.客户综合分析_月 t1
		where t1.年份=@nian and t1.月份=@yue
	) as t_yue_zh on t_yue.zjzh=t_yue_zh.zjzh	
	left join
	(
		select
			t1.zjzh
			,t1.rzrq_rjzc_m
		from dba.T_DDW_XYZQ_F00_KHZHFX_2011 t1
		where t1.nian=@nian and t1.yue=@yue
	) as t_yue_2011 on t_yue.zjzh=t_yue_2011.zjzh
	left join
	(
		select
			t1.zjzh
			,max(t1.rzrq_jzc_yrj) as rzrq_jzc_yrj
			,max(t1.ydghjzc_yrj) as ydghjzc_yrj
		from dba.t_ddw_yunying2012_kh t1
		where t1.nian=@snm_nian and t1.yue=@snm_yue
		group by t1.zjzh
	) t_yue_snm on t_yue.zjzh=t_yue_snm.zjzh
	left join
	(
		select
			t1.资金账户 as zjzh
			,t1.日均资产
			,t1.帐户性质
		from DBA.客户综合分析_月 t1
		where t1.年份=@snm_nian and t1.月份=@snm_yue
	) as t_yue_zh_snm on t_yue.zjzh=t_yue_zh_snm.zjzh	
	left join
	(
		select
			t1.zjzh
			,t1.rzrq_rjzc_m
		from dba.T_DDW_XYZQ_F00_KHZHFX_2011 t1
		where t1.nian=@nian and t1.yue=@yue
	) as t_yue_2011_snm on t_yue.zjzh=t_yue_2011_snm.zjzh	
	left join #temp_yybdz yyb on t_yue.jgbh=yyb.jgbh
	left join
	(	
		select
			t1.zjzh
			,sum(case when t1.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') then t1.期末市值_扣减后_原始 else 0 end) as 期末公募基金保有
			,sum(case when t1.产品类型='核心-公募-股票型' then t1.期末市值_扣减后_原始 else 0 end) as 期末核心公募基金保有
			,sum(case when t1.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then t1.期末市值_扣减后_原始 else 0 end) as 期末集合理财保有
			,sum(case when t1.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then t1.期末市值_扣减后_原始 else 0 end) as 期末定向保有
			,sum(case when t1.产品类型 in ('PE产品','固定收益','定向','股权质押','权益类私募信托') then t1.期末市值_扣减后_原始 else 0 end) as 期末私募保有
			
			,sum(case when t1.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') then t1.期末市值_扣减后_考核 else 0 end) as 期末公募基金保有_考核
			,sum(case when t1.产品类型='核心-公募-股票型' then t1.期末市值_扣减后_原始_考核 else 0 end) as 期末核心公募基金保有_考核
			,sum(case when t1.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then t1.期末市值_扣减后_原始_考核 else 0 end) as 期末集合理财保有_考核
			,sum(case when t1.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then t1.期末市值_扣减后_原始_考核 else 0 end) as 期末定向保有_考核
			,sum(case when t1.产品类型 in ('PE产品','固定收益','定向','股权质押','权益类私募信托') then t1.期末市值_扣减后_原始_考核 else 0 end) as 期末私募保有_考核
			
			,sum(case when t1.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') then t1.月日均市值_扣减后_原始 else 0 end) as 月日均公募基金保有
			,sum(case when t1.产品类型='核心-公募-股票型' then t1.月日均市值_扣减后_原始 else 0 end) as 月日均核心公募基金保有
			,sum(case when t1.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then t1.月日均市值_扣减后_原始 else 0 end) as 月日均集合理财保有
			,sum(case when t1.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then t1.月日均市值_扣减后_原始 else 0 end) as 月日均定向保有
			
			,sum(case when t1.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') then t1.月日均市值_扣减后_考核 else 0 end) as 月日均公募基金保有_考核
			,sum(case when t1.产品类型='核心-公募-股票型' then t1.月日均市值_扣减后_原始_考核 else 0 end) as 月日均核心公募基金保有_考核
			,sum(case when t1.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then t1.月日均市值_扣减后_原始_考核 else 0 end) as 月日均集合理财保有_考核
			,sum(case when t1.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then t1.月日均市值_扣减后_原始_考核 else 0 end) as 月日均定向保有_考核
			
		from #temp_khcp t1
		where t1.nian=@nian and t1.yue=@yue
		group by t1.zjzh
	) t_khcp on t_yue.zjzh=t_khcp.zjzh
);