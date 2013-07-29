drop table #temp_khcp;

create table #temp_khcp
(
	ny int	not null,  --年月
	zjzh varchar(128)	not null,	--资金账号
	
	公募手续费 numeric(38,10), 
	核心公募销售金额 numeric(38,10), 
	核心公募月日均保有 numeric(38,10), 
	基金专户手续费 numeric(38,10), 
	基金专户销售金额 numeric(38,10), 
	基金专户月日均保有 numeric(38,10), 
	集合理财手续费 numeric(38,10), 
	集合理财销售金额 numeric(38,10), 
	集合理财月日均保有  numeric(38,10),
	月日均保有  numeric(38,10),
	期末保有 numeric(38,10),
	
	---------------考核保有_月日均-----------------
	月日均公募基金保有_考核  numeric(38,10),
	月日均定向保有_考核  numeric(38,10),
	月日均集合理财保有_考核  numeric(38,10),
	月日均产品有效市值 numeric(38,10),
	
	---------------考核保有_期末-----------------
	期末公募基金保有_考核  numeric(38,10),
	期末定向保有_考核  numeric(38,10),
	期末集合理财保有_考核  numeric(38,10),
	期末产品有效市值 numeric(38,10),
	
	---------------现金类-----------------
	期末货币型产品 numeric(38,10),
	期末无手续费债券型产品 numeric(38,10),
	期末集合理财货币型 numeric(38,10),
	期末基金专户货币型 numeric(38,10),
	
	月日均货币型产品 numeric(38,10),
	月日均无手续费债券型产品 numeric(38,10),
	月日均集合理财货币型 numeric(38,10),
	月日均基金专户货币型 numeric(38,10),
	
	--完整明细	
	核心公募股票型销售_月累计 numeric(38,10),
	非核心公募股票型销售_月累计 numeric(38,10),
	公募债券型有手续费销售_月累计 numeric(38,10),
	公募债券型无手续费销售_月累计 numeric(38,10),
	公募货币型销售_月累计 numeric(38,10),
	集合理财股票型销售_月累计 numeric(38,10),
	集合理财债券型销售_月累计 numeric(38,10),
	集合理财货币型销售_月累计 numeric(38,10),
--	基金专户销售_月累计 numeric(38,10),
	基金专户股票型销售_月累计 numeric(38,10),
	基金专户债券型销售_月累计 numeric(38,10),
	基金专户货币型销售_月累计 numeric(38,10),
	
	核心公募股票型销售_年累计 numeric(38,10),
	非核心公募股票型销售_年累计 numeric(38,10),
	公募债券型有手续费销售_年累计 numeric(38,10),
	公募债券型无手续费销售_年累计 numeric(38,10),
	公募货币型销售_年累计 numeric(38,10),
	集合理财股票型销售_年累计 numeric(38,10),
	集合理财债券型销售_年累计 numeric(38,10),
	集合理财货币型销售_年累计 numeric(38,10),
--	基金专户销售_年累计 numeric(38,10),
	基金专户股票型销售_年累计 numeric(38,10),
	基金专户债券型销售_年累计 numeric(38,10),
	基金专户货币型销售_年累计 numeric(38,10),
	
	核心公募股票型保有_月日均 numeric(38,10),
	非核心公募股票型保有_月日均 numeric(38,10),
	公募债券型有手续费保有_月日均 numeric(38,10),
	公募债券型无手续费保有_月日均 numeric(38,10),
	公募货币型保有_月日均 numeric(38,10),
	集合理财股票型保有_月日均 numeric(38,10),
	集合理财债券型保有_月日均 numeric(38,10),
	集合理财货币型保有_月日均 numeric(38,10),
--	基金专户保有_月日均 numeric(38,10),
	基金专户股票型保有_月日均 numeric(38,10),
	基金专户债券型保有_月日均 numeric(38,10),
	基金专户货币型保有_月日均 numeric(38,10),
	
	核心公募股票型保有_年日均 numeric(38,10),
	非核心公募股票型保有_年日均 numeric(38,10),
	公募债券型有手续费保有_年日均 numeric(38,10),
	公募债券型无手续费保有_年日均 numeric(38,10),
	公募货币型保有_年日均 numeric(38,10),
	集合理财股票型保有_年日均 numeric(38,10),
	集合理财债券型保有_年日均 numeric(38,10),	
	集合理财货币型保有_年日均 numeric(38,10),
--	基金专户保有_年日均 numeric(38,10),
	基金专户股票型保有_年日均 numeric(38,10),
	基金专户债券型保有_年日均 numeric(38,10),
	基金专户货币型保有_年日均 numeric(38,10),
	
	
	核心公募股票型手续费_月累计 numeric(38,10),
	非核心公募股票型手续费_月累计 numeric(38,10),
	公募债券型有手续费手续费_月累计 numeric(38,10),
	公募债券型无手续费手续费_月累计 numeric(38,10),
	公募货币型手续费_月累计 numeric(38,10),
	集合理财股票型手续费_月累计 numeric(38,10),
	集合理财债券型手续费_月累计 numeric(38,10),
	集合理财货币型手续费_月累计 numeric(38,10),
--	基金专户手续费_月累计 numeric(38,10),
	基金专户股票型手续费_月累计 numeric(38,10),
	基金专户债券型手续费_月累计 numeric(38,10),
	基金专户货币型手续费_月累计 numeric(38,10),
	
	核心公募股票型手续费_年累计 numeric(38,10),
	非核心公募股票型手续费_年累计 numeric(38,10),
	公募债券型有手续费手续费_年累计 numeric(38,10),
	公募债券型无手续费手续费_年累计 numeric(38,10),
	公募货币型手续费_年累计 numeric(38,10),
	集合理财股票型手续费_年累计 numeric(38,10),
	集合理财债券型手续费_年累计 numeric(38,10),
	集合理财货币型手续费_年累计 numeric(38,10),
--	基金专户手续费_年累计 numeric(38,10)
	基金专户股票型手续费_年累计 numeric(38,10),
	基金专户债券型手续费_年累计 numeric(38,10)
	,基金专户货币型手续费_年累计 numeric(38,10)
		
	,期末公募基金保有_扣减资管总部销售	numeric(38,10)
	,期末核心公募基金保有_扣减资管总部销售		numeric(38,10)
	,期末定向保有_扣减资管总部销售		numeric(38,10)
	,期末集合理财保有_扣减资管总部销售	numeric(38,10)
	
	,月日均公募基金保有_扣减资管总部销售	numeric(38,10)
	,月日均核心公募基金保有_扣减资管总部销售		numeric(38,10)
	,月日均定向保有_扣减资管总部销售		numeric(38,10)
	,月日均集合理财保有_扣减资管总部销售	numeric(38,10)	
	,constraint pk_skb_temp_khcp primary key (ny,zjzh)
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
set @yue='06'
set @nian_sx='2013'
set @yue_sx='06'
set @nian_gx='2013'
set @yue_gx='06'

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

insert into #temp_khcp
(
	ny
	,zjzh
	
	,公募手续费 
	,核心公募销售金额 
	,核心公募月日均保有 
	,基金专户手续费 
	,基金专户销售金额 
	,基金专户月日均保有 
	,集合理财手续费 
	,集合理财销售金额 
	,集合理财月日均保有
	,月日均保有
	,期末保有
	
	---------------考核保有_月日均-----------------
	,月日均公募基金保有_考核
	,月日均定向保有_考核
	,月日均集合理财保有_考核
	,月日均产品有效市值
	
	---------------考核保有_期末-----------------
	,期末公募基金保有_考核
	,期末定向保有_考核
	,期末集合理财保有_考核
	,期末产品有效市值
	
	---------------现金类-----------------
	,期末货币型产品
	,期末无手续费债券型产品
	,期末集合理财货币型
	,期末基金专户货币型
	
	,月日均货币型产品
	,月日均无手续费债券型产品
	,月日均集合理财货币型
	,月日均基金专户货币型
	
	--完整明细	
	,核心公募股票型销售_月累计
	,非核心公募股票型销售_月累计
	,公募债券型有手续费销售_月累计
	,公募债券型无手续费销售_月累计
	,公募货币型销售_月累计
	,集合理财股票型销售_月累计
	,集合理财债券型销售_月累计
	,集合理财货币型销售_月累计
--	基金专户销售_月累计 numeric(38,10),
	,基金专户股票型销售_月累计
	,基金专户债券型销售_月累计
	,基金专户货币型销售_月累计
	
	,核心公募股票型销售_年累计
	,非核心公募股票型销售_年累计
	,公募债券型有手续费销售_年累计
	,公募债券型无手续费销售_年累计
	,公募货币型销售_年累计
	,集合理财股票型销售_年累计
	,集合理财债券型销售_年累计
	,集合理财货币型销售_年累计
--	基金专户销售_年累计 numeric(38,10),
	,基金专户股票型销售_年累计
	,基金专户债券型销售_年累计
	,基金专户货币型销售_年累计
	
	,核心公募股票型保有_月日均
	,非核心公募股票型保有_月日均
	,公募债券型有手续费保有_月日均
	,公募债券型无手续费保有_月日均
	,公募货币型保有_月日均
	,集合理财股票型保有_月日均
	,集合理财债券型保有_月日均
	,集合理财货币型保有_月日均
--	基金专户保有_月日均 numeric(38,10),
	,基金专户股票型保有_月日均
	,基金专户债券型保有_月日均
	,基金专户货币型保有_月日均
	
	,核心公募股票型保有_年日均
	,非核心公募股票型保有_年日均
	,公募债券型有手续费保有_年日均
	,公募债券型无手续费保有_年日均
	,公募货币型保有_年日均
	,集合理财股票型保有_年日均
	,集合理财债券型保有_年日均	
	,集合理财货币型保有_年日均
--	基金专户保有_年日均 numeric(38,10),
	,基金专户股票型保有_年日均
	,基金专户债券型保有_年日均
	,基金专户货币型保有_年日均
	
	,核心公募股票型手续费_月累计
	,非核心公募股票型手续费_月累计
	,公募债券型有手续费手续费_月累计
	,公募债券型无手续费手续费_月累计
	,公募货币型手续费_月累计
	,集合理财股票型手续费_月累计
	,集合理财债券型手续费_月累计
	,集合理财货币型手续费_月累计
--	基金专户手续费_月累计 numeric(38,10),
	,基金专户股票型手续费_月累计
	,基金专户债券型手续费_月累计
	,基金专户货币型手续费_月累计
	
	,核心公募股票型手续费_年累计
	,非核心公募股票型手续费_年累计
	,公募债券型有手续费手续费_年累计
	,公募债券型无手续费手续费_年累计
	,公募货币型手续费_年累计
	,集合理财股票型手续费_年累计
	,集合理财债券型手续费_年累计
	,集合理财货币型手续费_年累计
--	基金专户手续费_年累计 numeric(38,10)
	,基金专户股票型手续费_年累计
	,基金专户债券型手续费_年累计
	,基金专户货币型手续费_年累计
		
	,期末公募基金保有_扣减资管总部销售
	,期末核心公募基金保有_扣减资管总部销售
	,期末定向保有_扣减资管总部销售
	,期末集合理财保有_扣减资管总部销售
	
	,月日均公募基金保有_扣减资管总部销售
	,月日均核心公募基金保有_扣减资管总部销售
	,月日均定向保有_扣减资管总部销售
	,月日均集合理财保有_扣减资管总部销售	
)
(
	select 
		convert(int,@nian||@yue) as ny
		,t1.zjzh
		
		,sum(case when t_cp.cplx in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') then t_cp.认申购手续费_年累计 else 0 end ) as 公募手续费
		,sum(case when t_cp.cplx='核心-公募-股票型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end ) as 核心公募销售金额
		,sum(case when t_cp.cplx='核心-公募-股票型' then t_cp.月日均市值_扣减后_原始 else 0 end ) as 核心公募月日均保有
		
		,sum(case when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then t_cp.认申购手续费_年累计 else 0 end ) as 基金专户手续费	
		,sum(case when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then t_cp.销售金额_年累计_扣减后_原始 else 0 end ) as 基金专户销售金额
		,sum(case when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then 月日均场外保有 else 0 end ) as 基金专户月日均保有
		
		,sum(case when t_cp.cplx in ('集合理财-债券型','集合理财-股票型','集合理财-货币型') then t_cp.认申购手续费_年 else 0 end ) as 集合理财手续费
		,sum(case when t_cp.cplx in ('集合理财-债券型','集合理财-股票型','集合理财-货币型')  then t_cp.销售金额_年累计_扣减后_原始 else 0 end ) as 集合理财销售金额
		,sum(case when t_cp.cplx in ('集合理财-债券型','集合理财-股票型','集合理财-货币型') then 月日均场外保有 else 0 end ) as 集合理财月日均保有
	
		
		,sum(月日均场外保有) as 月日均保有
		
		,sum(期末场外保有) as 期末保有
		
		-----------------------考核口径----------------------
		,sum(case when t_cp.cplx in ('核心-公募-股票型') then 月日均场外保有
				  when t_cp.cplx in ('非核心-公募-股票型') then 月日均场外保有*0.8
				  when t_cp.cplx in ('公募-债券型-有手续费') then 月日均场外保有*0.4
				  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') then 月日均场外保有*0.1
				  else 0 end ) as 月日均公募基金保有_考核
	
		,sum(case when t_cp.cplx='基金专户-股票型' then 月日均场外保有
				  when t_cp.cplx='基金专户-债券型' then 月日均场外保有*0.5
				  when t_cp.cplx='基金专户-货币型' then 月日均场外保有*0.1
				  else 0 end ) as 月日均定向保有_考核
		,sum(case when t_cp.cplx in ('集合理财-股票型') then 月日均场外保有
			      when t_cp.cplx in ('集合理财-债券型') then 月日均场外保有*0.5
			      when t_cp.cplx in ('集合理财-货币型') then 月日均场外保有*0.1
				  else 0 end ) as 月日均集合理财保有_考核
		,月日均公募基金保有_考核+月日均定向保有_考核+月日均集合理财保有_考核 as 月日均产品有效市值
				  
		-----------------------考核口径----------------------  
		
		,sum(case when t_cp.cplx in ('核心-公募-股票型') then 期末场外保有
				  when t_cp.cplx in ('非核心-公募-股票型') then 期末场外保有*0.8
				  when t_cp.cplx in ('公募-债券型-有手续费') then 期末场外保有*0.4
				  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') then 期末场外保有*0.1
				  else 0 end ) as 期末公募基金保有_考核	
		,sum(case when t_cp.cplx='基金专户-股票型' then 期末场外保有
				  when t_cp.cplx='基金专户-债券型' then 期末场外保有*0.5
				  when t_cp.cplx='基金专户-货币型' then 期末场外保有*0.1
				  else 0 end ) as 期末定向保有_考核
		,sum(case when t_cp.cplx in ('集合理财-股票型') then 期末场外保有
			      when t_cp.cplx in ('集合理财-债券型') then 期末场外保有*0.5
			      when t_cp.cplx in ('集合理财-货币型') then 期末场外保有*0.1
				  else 0 end ) as 期末集合理财保有_考核
		,期末公募基金保有_考核+期末定向保有_考核+期末集合理财保有_考核 as 期末产品有效市值
	
		-----------------------现金类----------------------  
		,sum(case when t_cp.cplx in ('公募-货币型') then 期末场外保有 else 0 end) as 期末货币型产品
		,sum(case when t_cp.cplx in ('公募-债券型-无手续费') then 期末场外保有 else 0 end) as 期末无手续费债券型产品
		,sum(case when t_cp.cplx='集合理财-货币型' then 期末场外保有 else 0 end) as 期末集合理财货币型
		,sum(case when t_cp.cplx='基金专户-货币型' then 期末场外保有 else 0 end) as 期末基金专户货币型
		
		,sum(case when t_cp.cplx='公募-货币型' then 月日均场外保有 else 0 end)  as 月日均货币型产品
		,sum(case when t_cp.cplx='公募-债券型-无手续费' then 月日均场外保有 else 0 end) as 月日均无手续费债券型产品
		,sum(case when t_cp.cplx='集合理财-货币型' then 月日均场外保有 else 0 end) as 月日均集合理财货币型
		,sum(case when t_cp.cplx='基金专户-货币型' then 月日均场外保有 else 0 end) as 月日均基金专户货币型
		
		--完整明细		
		,sum(case when t_cp.cplx='核心-公募-股票型' then 场外销售_月+场内销售_月 else 0 end) as 核心公募股票型销售_月累计
		,sum(case when t_cp.cplx='非核心-公募-股票型' then 场外销售_月+场内销售_月 else 0 end) as 非核心公募股票型销售_月累计
		,sum(case when t_cp.cplx='公募-债券型-有手续费' then 场外销售_月+场内销售_月 else 0 end) as 公募债券型有手续费销售_月累计
		,sum(case when t_cp.cplx='公募-债券型-无手续费' then 场外销售_月+场内销售_月 else 0 end) as 公募债券型无手续费销售_月累计
		,sum(case when t_cp.cplx='公募-货币型' then 场外销售_月+场内销售_月 else 0 end) as 公募货币型销售_月累计	
		,sum(case when t_cp.cplx='集合理财-股票型' then 场外销售_月+场内销售_月 else 0 end) as 集合理财股票型销售_月累计
		,sum(case when t_cp.cplx='集合理财-债券型' then 场外销售_月+场内销售_月 else 0 end) as 集合理财债券型销售_月累计
		,sum(case when t_cp.cplx='集合理财-货币型' then 场外销售_月+场内销售_月 else 0 end) as 集合理财货币型销售_月累计
	--	,sum(case when t_cp.cplx='基金专户' then 场外销售_月+场内销售_月 else 0 end) as 基金专户销售_月累计
		,sum(case when t_cp.cplx='基金专户-股票型' then 场外销售_月+场内销售_月 else 0 end) as 基金专户股票型销售_月累计
		,sum(case when t_cp.cplx='基金专户-债券型' then 场外销售_月+场内销售_月 else 0 end) as 基金专户债券型销售_月累计
		,sum(case when t_cp.cplx='基金专户-货币型' then 场外销售_月+场内销售_月 else 0 end) as 基金专户货币型销售_月累计
		
		,sum(case when t_cp.cplx='核心-公募-股票型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 核心公募股票型销售_年累计
		,sum(case when t_cp.cplx='非核心-公募-股票型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 非核心公募股票型销售_年累计
		,sum(case when t_cp.cplx='公募-债券型-有手续费' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 公募债券型有手续费销售_年累计
		,sum(case when t_cp.cplx='公募-债券型-无手续费' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 公募债券型无手续费销售_年累计
		,sum(case when t_cp.cplx='公募-货币型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 公募货币型销售_年累计	
		,sum(case when t_cp.cplx='集合理财-股票型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 集合理财股票型销售_年累计
		,sum(case when t_cp.cplx='集合理财-债券型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 集合理财债券型销售_年累计	
		,sum(case when t_cp.cplx='集合理财-货币型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 集合理财货币型销售_年累计
	--	,sum(case when t_cp.cplx='基金专户' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 基金专户销售_年累计
		,sum(case when t_cp.cplx='基金专户-股票型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 基金专户股票型销售_年累计
		,sum(case when t_cp.cplx='基金专户-债券型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 基金专户债券型销售_年累计
		,sum(case when t_cp.cplx='基金专户-货币型' then t_cp.销售金额_年累计_扣减后_原始 else 0 end) as 基金专户货币型销售_年累计
		
		,sum(case when t_cp.cplx='核心-公募-股票型' then 月日均场外保有 else 0 end) as 核心公募股票型保有_月日均
		,sum(case when t_cp.cplx='非核心-公募-股票型' then 月日均场外保有 else 0 end) as 非核心公募股票型保有_月日均
		,sum(case when t_cp.cplx='公募-债券型-有手续费' then 月日均场外保有 else 0 end) as 公募债券型有手续费保有_月日均
		,sum(case when t_cp.cplx='公募-债券型-无手续费' then 月日均场外保有 else 0 end) as 公募债券型无手续费保有_月日均
		,sum(case when t_cp.cplx='公募-货币型' then 月日均场外保有 else 0 end) as 公募货币型保有_月日均	
		,sum(case when t_cp.cplx='集合理财-股票型' then 月日均场外保有 else 0 end) as 集合理财股票型保有_月日均
		,sum(case when t_cp.cplx='集合理财-债券型' then 月日均场外保有 else 0 end) as 集合理财债券型保有_月日均
		,sum(case when t_cp.cplx='集合理财-货币型' then 月日均场外保有 else 0 end) as 集合理财货币型保有_月日均
	--	,sum(case when t_cp.cplx='基金专户' then 月日均场外保有 else 0 end) as 基金专户保有_月日均
		,sum(case when t_cp.cplx='基金专户-股票型' then 月日均场外保有 else 0 end) as 基金专户股票型保有_月日均
		,sum(case when t_cp.cplx='基金专户-债券型' then 月日均场外保有 else 0 end) as 基金专户债券型保有_月日均
		,sum(case when t_cp.cplx='基金专户-货币型' then 月日均场外保有 else 0 end) as 基金专户货币型保有_月日均
		
		,sum(case when t_cp.cplx='核心-公募-股票型' then 年日均场外保有 else 0 end) as 核心公募股票型保有_年日均
		,sum(case when t_cp.cplx='非核心-公募-股票型' then 年日均场外保有 else 0 end) as 非核心公募股票型保有_年日均
		,sum(case when t_cp.cplx='公募-债券型-有手续费' then 年日均场外保有 else 0 end) as 公募债券型有手续费保有_年日均
		,sum(case when t_cp.cplx='公募-债券型-无手续费' then 年日均场外保有 else 0 end) as 公募债券型无手续费保有_年日均
		,sum(case when t_cp.cplx='公募-货币型' then 年日均场外保有 else 0 end) as 公募货币型保有_年日均	
		,sum(case when t_cp.cplx='集合理财-股票型' then 年日均场外保有 else 0 end) as 集合理财股票型保有_年日均
		,sum(case when t_cp.cplx='集合理财-债券型' then 年日均场外保有 else 0 end) as 集合理财债券型保有_年日均
		,sum(case when t_cp.cplx='集合理财-货币型' then 年日均场外保有 else 0 end) as 集合理财货币型保有_年日均
	--	,sum(case when t_cp.cplx='基金专户' then 年日均场外保有 else 0 end) as 基金专户保有_年日均
		,sum(case when t_cp.cplx='基金专户-股票型' then 年日均场外保有 else 0 end) as 基金专户股票型保有_年日均
		,sum(case when t_cp.cplx='基金专户-债券型' then 年日均场外保有 else 0 end) as 基金专户债券型保有_年日均
		,sum(case when t_cp.cplx='基金专户-货币型' then 年日均场外保有 else 0 end) as 基金专户货币型保有_年日均
		
		,sum(case when t_cp.cplx='核心-公募-股票型' then 认申购手续费_月 else 0 end) as 核心公募股票型手续费_月累计
		,sum(case when t_cp.cplx='非核心-公募-股票型' then 认申购手续费_月 else 0 end) as 非核心公募股票型手续费_月累计
		,sum(case when t_cp.cplx='公募-债券型-有手续费' then 认申购手续费_月 else 0 end) as 公募债券型有手续费手续费_月累计
		,sum(case when t_cp.cplx='公募-债券型-无手续费' then 认申购手续费_月 else 0 end) as 公募债券型无手续费手续费_月累计
		,sum(case when t_cp.cplx='公募-货币型' then 认申购手续费_月 else 0 end) as 公募货币型手续费_月累计
		,sum(case when t_cp.cplx='集合理财-股票型' then 认申购手续费_月 else 0 end) as 集合理财股票型手续费_月累计
		,sum(case when t_cp.cplx='集合理财-债券型' then 认申购手续费_月 else 0 end) as 集合理财债券型手续费_月累计
		,sum(case when t_cp.cplx='集合理财-货币型' then 认申购手续费_月 else 0 end) as 集合理财货币型手续费_月累计
	--	,sum(case when t_cp.cplx='基金专户' then 认申购手续费_月 else 0 end) as 基金专户手续费_月累计
		,sum(case when t_cp.cplx='基金专户-股票型' then 认申购手续费_月 else 0 end) as 基金专户股票型手续费_月累计
		,sum(case when t_cp.cplx='基金专户-债券型' then 认申购手续费_月 else 0 end) as 基金专户债券型手续费_月累计
		,sum(case when t_cp.cplx='基金专户-货币型' then 认申购手续费_月 else 0 end) as 基金专户货币型手续费_月累计
		
		,sum(case when t_cp.cplx='核心-公募-股票型' then 认申购手续费_年 else 0 end) as 核心公募股票型手续费_年累计
		,sum(case when t_cp.cplx='非核心-公募-股票型' then 认申购手续费_年 else 0 end) as 非核心公募股票型手续费_年累计
		,sum(case when t_cp.cplx='公募-债券型-有手续费' then 认申购手续费_年 else 0 end) as 公募债券型有手续费手续费_年累计
		,sum(case when t_cp.cplx='公募-债券型-无手续费' then 认申购手续费_年 else 0 end) as 公募债券型无手续费手续费_年累计
		,sum(case when t_cp.cplx='公募-货币型' then 认申购手续费_年 else 0 end) as 公募货币型手续费_年累计
		,sum(case when t_cp.cplx='集合理财-股票型' then 认申购手续费_年 else 0 end) as 集合理财股票型手续费_年累计
		,sum(case when t_cp.cplx='集合理财-债券型' then 认申购手续费_年 else 0 end) as 集合理财债券型手续费_年累计
		,sum(case when t_cp.cplx='集合理财-货币型' then 认申购手续费_年 else 0 end) as 集合理财货币型手续费_年累计
	--	,sum(case when t_cp.cplx='基金专户' then 认申购手续费_年 else 0 end) as 基金专户手续费_年累计
		,sum(case when t_cp.cplx='基金专户-股票型' then 认申购手续费_年 else 0 end) as 基金专户股票型手续费_年累计
		,sum(case when t_cp.cplx='基金专户-债券型' then 认申购手续费_年 else 0 end) as 基金专户债券型手续费_年累计
		,sum(case when t_cp.cplx='基金专户-货币型' then 认申购手续费_年 else 0 end) as 基金专户货币型手续费_年累计
	
	--	,sum(t_cp.期末场外保有_扣减资管总部销售) as 期末场外保有_扣减资管总部销售		
		,sum(case when t_cp.cplx like '%公募%' then t_cp.期末场外保有_扣减资管总部销售 else 0 end) as 期末公募基金保有_扣减资管总部销售
		,sum(case when t_cp.cplx like '核心%' then t_cp.期末场外保有_扣减资管总部销售 else 0 end) as 期末核心公募基金保有_扣减资管总部销售
		,sum(case when t_cp.cplx like '基金专户%' then t_cp.期末场外保有_扣减资管总部销售 else 0 end ) as 期末定向保有_扣减资管总部销售
		,sum(case when t_cp.cplx like '集合理财%' then t_cp.期末场外保有_扣减资管总部销售 else 0 end ) as 期末集合理财保有_扣减资管总部销售
		
		,sum(case when t_cp.cplx like '%公募%' then t_cp.月日均场外保有_扣减资管总部销售 else 0 end) as 月日均公募基金保有_扣减资管总部销售
		,sum(case when t_cp.cplx like '核心%' then t_cp.月日均场外保有_扣减资管总部销售 else 0 end) as 月日均核心公募基金保有_扣减资管总部销售
		,sum(case when t_cp.cplx like '基金专户%' then t_cp.月日均场外保有_扣减资管总部销售 else 0 end ) as 月日均定向保有_扣减资管总部销售
		,sum(case when t_cp.cplx like '集合理财%' then t_cp.月日均场外保有_扣减资管总部销售 else 0 end ) as 月日均集合理财保有_扣减资管总部销售		
	from 
	(
		select 
			机构编号 as jgbh
			,资金账户 as zjzh			
		from DBA.客户综合分析_月
		where 年份=@nian and 月份=@yue
	) as t1 
	left join #temp_khjjfl t_cp on t1.zjzh=t_cp.zjzh
	group by t1.zjzh
)