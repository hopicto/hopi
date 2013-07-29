
drop table #temp_khcp;
----------------------创建产品临时表---------------------
/*
--为生成客户属性表做准备
*/
create table #temp_khcp
(
	ny int,  --年月
	zjzh varchar(128),	--资金账号
	
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
);



-------------------------------------START-----------------------------------

declare @nian varchar(16),@yue varchar(16),@nian_sx varchar(16),@yue_sx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_sx='2013'   --产品属性
set @yue_sx='03'	  --产品属性

insert into #temp_khcp(ny,zjzh,公募手续费,核心公募销售金额,核心公募月日均保有,基金专户手续费
,基金专户销售金额,基金专户月日均保有,集合理财手续费,集合理财销售金额,集合理财月日均保有,月日均保有,期末保有
,月日均公募基金保有_考核,月日均定向保有_考核,月日均集合理财保有_考核,月日均产品有效市值
,期末公募基金保有_考核,期末定向保有_考核,期末集合理财保有_考核,期末产品有效市值
,期末货币型产品
,期末无手续费债券型产品
,期末集合理财货币型
,期末基金专户货币型
,月日均货币型产品
,月日均无手续费债券型产品,
,月日均集合理财货币型
,月日均基金专户货币型

	--完整明细	
	,核心公募股票型销售_月累计,
	非核心公募股票型销售_月累计,
	公募债券型有手续费销售_月累计,
	公募债券型无手续费销售_月累计,
	公募货币型销售_月累计,
	集合理财股票型销售_月累计,
	集合理财债券型销售_月累计,
	集合理财货币型销售_月累计,
--	基金专户销售_月累计,
	基金专户股票型销售_月累计,
	基金专户债券型销售_月累计,
	基金专户货币型销售_月累计,
	
	核心公募股票型销售_年累计,
	非核心公募股票型销售_年累计,
	公募债券型有手续费销售_年累计,
	公募债券型无手续费销售_年累计,
	公募货币型销售_年累计,
	集合理财股票型销售_年累计,
	集合理财债券型销售_年累计,
	集合理财货币型销售_年累计,
--	基金专户销售_年累计,
	基金专户股票型销售_年累计,
	基金专户债券型销售_年累计,
	基金专户货币型销售_年累计,
	
	核心公募股票型保有_月日均,
	非核心公募股票型保有_月日均,
	公募债券型有手续费保有_月日均,
	公募债券型无手续费保有_月日均,
	公募货币型保有_月日均,
	集合理财股票型保有_月日均,
	集合理财债券型保有_月日均,
	集合理财货币型保有_月日均,
--	基金专户保有_月日均,
	基金专户股票型保有_月日均,
	基金专户债券型保有_月日均,
	基金专户货币型保有_月日均,
	
	核心公募股票型保有_年日均,
	非核心公募股票型保有_年日均,
	公募债券型有手续费保有_年日均,
	公募债券型无手续费保有_年日均,
	公募货币型保有_年日均,
	集合理财股票型保有_年日均,
	集合理财债券型保有_年日均,	
	集合理财货币型保有_年日均,
--	基金专户保有_年日均,
	基金专户股票型保有_年日均,
	基金专户债券型保有_年日均,
	基金专户货币型保有_年日均,
	
	
	核心公募股票型手续费_月累计,
	非核心公募股票型手续费_月累计,
	公募债券型有手续费手续费_月累计,
	公募债券型无手续费手续费_月累计,
	公募货币型手续费_月累计,
	集合理财股票型手续费_月累计,
	集合理财债券型手续费_月累计,
	集合理财货币型手续费_月累计,
--	基金专户手续费_月累计,
	基金专户股票型手续费_月累计,
	基金专户债券型手续费_月累计,
	基金专户货币型手续费_月累计,
	
	核心公募股票型手续费_年累计,
	非核心公募股票型手续费_年累计,
	公募债券型有手续费手续费_年累计,
	公募债券型无手续费手续费_年累计,
	公募货币型手续费_年累计,
	集合理财股票型手续费_年累计,
	集合理财债券型手续费_年累计,
	集合理财货币型手续费_年累计,
--	基金专户手续费_年累计
	基金专户股票型手续费_年累计,
	基金专户债券型手续费_年累计
	,基金专户货币型手续费_年累计
	
--	,期末场外保有_扣减资管总部销售
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
SELECT 
	convert(int,t1.nian||t1.yue) as ny
	,t1.zjzh
	--核心公募、定向、资管
		
	,sum(case when t_cp.cplx in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') then 认申购手续费_年 else 0 end ) as 公募手续费
	,sum(case when t_cp.cplx in ('核心-公募-股票型') then 场外销售_年+场内销售_年 else 0 end ) as 核心公募销售金额
	,sum(case when t_cp.cplx in ('核心-公募-股票型') then 月日均场外保有 else 0 end ) as 核心公募月日均保有
	
--	,sum(case when t_cp.cplx in ('基金专户') then 认申购手续费_年 else 0 end ) as 基金专户手续费	
--	,sum(case when t_cp.cplx in ('基金专户') then 场外销售_年+场内销售_年 else 0 end ) as 基金专户销售金额
--	,sum(case when t_cp.cplx in ('基金专户') then 月日均场外保有 else 0 end ) as 基金专户月日均保有
	
	,sum(case when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then 认申购手续费_年 else 0 end ) as 基金专户手续费	
	,sum(case when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then 场外销售_年+场内销售_年 else 0 end ) as 基金专户销售金额
	,sum(case when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then 月日均场外保有 else 0 end ) as 基金专户月日均保有
	
	,sum(case when t_cp.cplx in ('集合理财-债券型','集合理财-股票型','集合理财-货币型') then 认申购手续费_年 else 0 end ) as 集合理财手续费
	,sum(case when t_cp.cplx in ('集合理财-债券型','集合理财-股票型','集合理财-货币型')  then 场外销售_年+场内销售_年 else 0 end ) as 集合理财销售金额
	,sum(case when t_cp.cplx in ('集合理财-债券型','集合理财-股票型','集合理财-货币型') then 月日均场外保有 else 0 end ) as 集合理财月日均保有

	
	,sum(月日均场外保有) as 月日均保有
	
	,sum(期末场外保有) as 期末保有
	
	-----------------------考核口径----------------------
	,sum(case when t_cp.cplx in ('核心-公募-股票型') then 月日均场外保有
			  when t_cp.cplx in ('非核心-公募-股票型') then 月日均场外保有*0.8
			  when t_cp.cplx in ('公募-债券型-有手续费') then 月日均场外保有*0.4
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') then 月日均场外保有*0.1
			  else 0 end ) as 月日均公募基金保有_考核
--	,sum(case when t_cp.cplx in ('基金专户') then 月日均场外保有
--			  else 0 end ) as 月日均定向保有_考核
--	,sum(case when t_cp.cplx in ('基金专户-股票型','基金专户-债券型') then 月日均场外保有
--			  else 0 end ) as 月日均定向保有_考核
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
--	,sum(case when t_cp.cplx in ('基金专户') then 期末场外保有
--			  else 0 end ) as 期末定向保有_考核
--	,sum(case when t_cp.cplx in ('基金专户-股票型','基金专户-债券型') then 期末场外保有
--			  else 0 end ) as 期末定向保有_考核
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
	
	,sum(case when t_cp.cplx='核心-公募-股票型' then 场外销售_年+场内销售_年 else 0 end) as 核心公募股票型销售_年累计
	,sum(case when t_cp.cplx='非核心-公募-股票型' then 场外销售_年+场内销售_年 else 0 end) as 非核心公募股票型销售_年累计
	,sum(case when t_cp.cplx='公募-债券型-有手续费' then 场外销售_年+场内销售_年 else 0 end) as 公募债券型有手续费销售_年累计
	,sum(case when t_cp.cplx='公募-债券型-无手续费' then 场外销售_年+场内销售_年 else 0 end) as 公募债券型无手续费销售_年累计
	,sum(case when t_cp.cplx='公募-货币型' then 场外销售_年+场内销售_年 else 0 end) as 公募货币型销售_年累计	
	,sum(case when t_cp.cplx='集合理财-股票型' then 场外销售_年+场内销售_年 else 0 end) as 集合理财股票型销售_年累计
	,sum(case when t_cp.cplx='集合理财-债券型' then 场外销售_年+场内销售_年 else 0 end) as 集合理财债券型销售_年累计	
	,sum(case when t_cp.cplx='集合理财-货币型' then 场外销售_年+场内销售_年 else 0 end) as 集合理财货币型销售_年累计
--	,sum(case when t_cp.cplx='基金专户' then 场外销售_年+场外销售_年 else 0 end) as 基金专户销售_年累计
	,sum(case when t_cp.cplx='基金专户-股票型' then 场外销售_年+场内销售_年 else 0 end) as 基金专户股票型销售_年累计
	,sum(case when t_cp.cplx='基金专户-债券型' then 场外销售_年+场内销售_年 else 0 end) as 基金专户债券型销售_年累计
	,sum(case when t_cp.cplx='基金专户-货币型' then 场外销售_年+场内销售_年 else 0 end) as 基金专户货币型销售_年累计
	
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
	
FROM 
(
	select 
		机构编号 as jgbh
		,资金账户 as zjzh
		,年份 as nian
		,月份 as yue
	from DBA.客户综合分析_月
	where 年份=@nian and 月份=@yue
) as t1 
--营业部
left join DBA.T_EDW_T06_ORGANIZATION as t_jg on t_jg.org_cd=t1.jgbh   --营业部表
left join dba.yybdz as t_jg_2 on t_jg_2.jgbh=t1.jgbh   --营业部表

left join 
(

	SELECT 
		a.nian,
		a.yue,
		a.zjzh,
        a.jjdm,
		case when b.jjlb in ('公募-股票型') and b.sfhx=1 then '核心-'||trim(b.jjlb)
		  when b.jjlb in ('公募-股票型') and (b.sfhx<>1 or b.sfhx is null) then '非核心-'||trim(b.jjlb)
		  when b.jjlb in ('公募-债券型') and sfsxf_zq =1 then trim(b.jjlb)||'-有手续费'
		  when b.jjlb in ('公募-债券型') and sfsxf_zq =0 then trim(b.jjlb)||'-无手续费'
		  when b.jjlb in ('公募-货币型') then trim(b.jjlb)
--		  when b.lx='基金专户' and jjzh.jjdm is null then '基金专户-股票型'
--		  when b.lx='基金专户' and jjzh.jjdm is not null then '基金专户-债券型'
		else trim(b.jjlb) end as cplx,
		SUM(cnsxf_rgqr_m+cnsxf_sgqr_m+cnsxf_dsdetzqr_m+cwsxf_rgqr_m+cwsxf_sgqr_m+cwsxf_dsdetzqr_m+cwsxf_zhrqr_m) as 认申购手续费_月,
		SUM(cnsxf_rgqr_y+cnsxf_sgqr_y+cnsxf_dsdetzqr_y+cwsxf_rgqr_y+cwsxf_sgqr_y+cwsxf_dsdetzqr_y+cwsxf_zhrqr_y) as 认申购手续费_年,
		 ------月度销售------
         SUM(a.cwje_rgqr_m + a.cwje_sgqr_m + a.cwje_dsdetzqr_m + a.cwje_zhrqr_m + a.ztgrqrje_m) AS 场外销售_月,    -- 场外销售金额_月累计(原始值)
         SUM(a.cnje_rgqr_m + COALESCE(a.hg_je_m, 0)) AS 场内销售_月,    -- 场内认购金额_月累计(原始值)
         SUM(a.cwje_shqr_m + a.ztgcqrje_m + a.cwje_cgpxzhc_m ) AS 赎回_月 ,    -- 场外赎回金额_月累计(原始)

		 ------年度销售------
         SUM(a.cwje_rgqr_y + a.cwje_sgqr_y + a.cwje_dsdetzqr_y + a.cwje_zhrqr_y + a.ztgrqrje_y) AS 场外销售_年,    -- 场外销售金额_年累计(原始值)
         SUM(a.cnje_rgqr_y + COALESCE(a.hg_je_y, 0)) AS 场内销售_年,    -- 场内认购金额_年累计(原始值)
         SUM(a.cwje_shqr_y + a.ztgcqrje_y+ a.cwje_cgpxzhc_y ) AS 赎回_年,    -- 场外赎回金额_年累计(原始)

		 /*-----------------------保有---------------------*/
         SUM(coalesce(a.qmsz_cw_m,0) ) AS 期末场外保有,      						-- 场外保有期末市值（原始）
         SUM(coalesce(a.qmsz_cw_m,0)-coalesce(t_zb.qmsz,0)) AS 期末场外保有_扣减资管总部销售,      	-- 场外保有期末市值（原始）
--         SUM(coalesce(a.qmsz_cw_m,0) - 1) AS 期末场外保有_扣减资管总部销售,
         
		 SUM(a.ljsz_cw_m) / max(t_rq.ts_m)   AS 月日均场外保有,     			 -- 场外保有市值_月日均（原始）		 
		 SUM(a.ljsz_cw_m) / max(t_rq.ts_m) - sum(coalesce(t_zb.qmsz, 0))  AS 月日均场外保有_扣减资管总部销售,
		 SUM(a.ljsz_cw_y) / max(t_rq.ts_y)  AS 年日均场外保有     			 -- 场外保有市值_年日均（原始）
         
    FROM 
	(
		select *
		from dba.t_ddw_xy_jjzb_m
		where nian=@nian and yue=@yue
	) as a
	
	-----------------当前年月----------------
	cross join 
	(
		select
			count(distinct 日期) as ts_y
			,count(distinct case when 月份=@yue then 日期 else null end) as ts_m
		from DBA.v_skb_d_rq
		where 年份=@nian 
	)as t_rq  
	-----------------当前基金属性----------------
    LEFT JOIN dba.t_ddw_d_jj b ON b.nian = @nian_sx
                              AND b.yue = @yue_sx
                              AND a.jjdm = b.jjdm
                             
	--资管总部销售
--	left join query_skb.wjh_temp_2 as t_zb on a.nian=t_zb.nian and a.yue=t_zb.yue and a.zjzh= t_zb.zjzh and a.jjdm= t_zb.zqdm
--	left join
--	(
--		select
--			nian,
--			yue,
--			zjzh,
--			zqdm,
--			max(qmsz) as qmsz
--		from query_skb.wjh_temp_2
--		where nian=@nian and yue=@yue
--		group by nian,yue,zjzh,zqdm	
--	) as t_zb on a.nian=t_zb.nian and a.yue=t_zb.yue and a.zjzh= t_zb.zjzh and a.jjdm= t_zb.zqdm
	
	left join
	(
		select
			t1.nian
			,t1.yue
			,t1.zjzh
			,t1.jjdm as zqdm
			,t1.期末市值_总部 as qmsz
			,t1.销售金额_月_总部 as xsje_m
			,t1.赎回金额_月_总部 as shje_m
			,t1.销售金额_年_总部 as xsje_y
			,t1.赎回金额_年_总部 as shje_y		
		from dba.t_tmp_ryhz t1
		where t1.nian=@nian and t1.yue=@yue
	) as t_zb on a.nian=t_zb.nian and a.yue=t_zb.yue and a.zjzh= t_zb.zjzh and a.jjdm= t_zb.zqdm
    --基金专户区分
--    left join #temp_jjzhyx jjzh on a.jjdm=jjzh.jjdm
   WHERE jjlb is not null
   GROUP BY a.nian,a.yue,a.zjzh, b.jjlb, b.sfhx, b.sfsxf_zq,a.jjdm
   --,jjzh.jjdm
)as t_cp on t_cp.zjzh=t1.zjzh


GROUP BY t1.nian,t1.yue,t1.zjzh
order by t1.nian,t1.yue,t1.zjzh

);
