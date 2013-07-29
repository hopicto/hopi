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

insert into #temp_ygcp(
	nian
	,yue
	,ygh
	,是否产品新客户
	,资产段		
	
	,资产段_上年末
	,账户性质
	,是否年新增
	,是否月新增
	,是否大小非客户
	,是否营业部目标客户
	,是否有效户		
	
	,产品类型	
	,销售金额_月累计_原始
	,销售金额_月累计_考核	
	,赎回金额_月累计_原始
	,赎回金额_月累计_考核	
	,销售金额_年累计_原始	
	,销售金额_年累计_考核	
	,赎回金额_年累计_原始	
	,赎回金额_年累计_考核	
	,期初市值_原始
	,期初市值_考核
	,期末市值_原始
	,期末市值_考核
	,月日均市值_原始
	,月日均市值_考核
	,年日均市值_原始
	,年日均市值_考核
	,手续费_月累计
	,手续费_年累计	
	,销售金额_月累计_首发_原始
	,销售金额_月累计_首发_考核
	,销售金额_年累计_首发_原始
	,销售金额_年累计_首发_考核
	,手续费_月累计_首发
	,手续费_年累计_首发
)
(
	select
		@nian as nian
		,@yue as yue
		,t_yg.ygh
		,t_khsx.是否产品新客户 
		,t_khsx.资产段
		
		,t_khsx.资产段_上年末
		,t_khsx.账户性质
		,t_khsx.是否年新增
		,t_khsx.是否月新增
		,t_khsx.是否大小非客户		
		,t_khsx.是否营业部目标客户
		,t_khsx.是否有效户
		
		,t_cp.产品类型
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.销售金额_月累计_扣减后_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.销售金额_月累计_扣减后_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.销售金额_月累计_扣减后_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 销售金额_月累计_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.销售金额_月累计_扣减后_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.销售金额_月累计_扣减后_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.销售金额_月累计_扣减后_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 销售金额_月累计_考核
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.赎回金额_月累计_扣减后_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.赎回金额_月累计_扣减后_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.赎回金额_月累计_扣减后_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 赎回金额_月累计_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.赎回金额_月累计_扣减后_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.赎回金额_月累计_扣减后_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.赎回金额_月累计_扣减后_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 赎回金额_月累计_考核				
		
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.销售金额_年累计_扣减后_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.销售金额_年累计_扣减后_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.销售金额_年累计_扣减后_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 销售金额_年累计_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.销售金额_年累计_扣减后_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.销售金额_年累计_扣减后_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.销售金额_年累计_扣减后_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 销售金额_年累计_考核
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.赎回金额_年累计_扣减后_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.赎回金额_年累计_扣减后_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.赎回金额_年累计_扣减后_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 赎回金额_年累计_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.赎回金额_年累计_扣减后_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.赎回金额_年累计_扣减后_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.赎回金额_年累计_扣减后_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 赎回金额_年累计_考核
		
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.期初市值_扣减后_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.期初市值_扣减后_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.期初市值_扣减后_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 期初市值_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.期初市值_扣减后_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.期初市值_扣减后_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.期初市值_扣减后_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 期初市值_考核
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.期末市值_扣减后_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.期末市值_扣减后_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.期末市值_扣减后_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 期末市值_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.期末市值_扣减后_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.期末市值_扣减后_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.期末市值_扣减后_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 期末市值_考核		
		
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.月日均市值_扣减后_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.月日均市值_扣减后_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.月日均市值_扣减后_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 月日均市值_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.月日均市值_扣减后_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.月日均市值_扣减后_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.月日均市值_扣减后_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 月日均市值_考核
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.年日均市值_扣减后_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.年日均市值_扣减后_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.年日均市值_扣减后_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 年日均市值_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.年日均市值_扣减后_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.年日均市值_扣减后_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.年日均市值_扣减后_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 年日均市值_考核
		
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.认申购手续费_月累计,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.认申购手续费_月累计,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.认申购手续费_月累计,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 手续费_月累计
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.认申购手续费_年累计,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.认申购手续费_年累计,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.认申购手续费_年累计,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 手续费_年累计		
				
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.销售金额_月累计_首发_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.销售金额_月累计_首发_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.销售金额_月累计_首发_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 销售金额_月累计_首发_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.销售金额_月累计_首发_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.销售金额_月累计_首发_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.销售金额_月累计_首发_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 销售金额_月累计_首发_考核
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.销售金额_年累计_首发_原始,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.销售金额_年累计_首发_原始,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.销售金额_年累计_首发_原始,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 销售金额_年累计_首发_原始
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.销售金额_年累计_首发_考核,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.销售金额_年累计_首发_考核,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.销售金额_年累计_首发_考核,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 销售金额_年累计_首发_考核
		
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.认申购手续费_月累计_首发,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.认申购手续费_月累计_首发,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.认申购手续费_月累计_首发,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 手续费_月累计_首发
		,sum(case when t_cp.产品类型 in ('核心-公募-股票型','非核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型','未设置类型') then coalesce(t_cp.认申购手续费_年累计_首发,0)*coalesce(t_gx.jxbl_4,0)
				when t_cp.产品类型 in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') then coalesce(t_cp.认申购手续费_年累计_首发,0)*coalesce(t_gx.jxbl_6,0)
				when t_cp.产品类型 in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') then coalesce(t_cp.认申购手续费_年累计_首发,0)*coalesce(t_gx.jxbl_5,0)
				else 0 end) as 手续费_年累计_首发						
	from
	(
		select
			*
		from #temp_khcp t1
		where t1.nian=@nian and t1.yue=@yue		
	) t_cp
	left join
	(
		select
			t1.zjzh
			,t1.khbh_hs
		from dba.t_ddw_yunying2012_kh t1
		where t1.nian=@nian and t1.yue=@yue
	) t_kh on t_kh.zjzh=t_cp.zjzh
	left join #temp_gx t_gx on t_kh.khbh_hs=t_gx.khbh_hs and t_gx.nian=@nian_gx and t_gx.yue=@yue_gx
	left join 
	(
		select 
			*
		from dba.t_yunying2012_param_yg t1
		where t1.nian=@nian and t1.yue=@yue		
	) t_yg on t_gx.ygh=t_yg.ygh
	left join #temp_khsx t_khsx on t_khsx.zjzh=t_kh.zjzh and t_khsx.nian=@nian and t_khsx.yue=@yue	
	left join #temp_teshu teshu on t_cp.zjzh=teshu.zjzh	
	where t_gx.ygh is not null and t_cp.zjzh is not null
		and teshu.zjzh is null
	group by t_yg.ygh,是否产品新客户,资产段,资产段_上年末,账户性质,是否年新增,是否月新增,是否大小非客户,是否营业部目标客户,是否有效户,产品类型
	
	--体外产品
	union
	select
		@nian as nian
		,@yue as yue
		,t_all.ygh
		,0 as 是否产品新客户
		,'体外产品' as 资产段
		
		,'体外产品' as 资产段_上年末
		,'个人' as 账户性质
		,0 as 是否年新增
		,0 as 是否月新增
		,0 as 是否大小非客户
		,0 as 是否营业部目标客户
		,0 as 是否有效户
		
		,t_all.cplx as 产品类型
		,sum(coalesce(t1.xsje_m_ys,0)) as 销售金额_月累计_原始
		,sum(coalesce(t1.xsje_m_kh,0)) as 销售金额_月累计_考核
		,sum(coalesce(t1.shje_m_ys,0)) as 赎回金额_月累计_原始
		,sum(coalesce(t1.shje_m_kh,0)) as 赎回金额_月累计_考核
		
		,sum(coalesce(t1.xsje_y_ys,0)) as 销售金额_年累计_原始
		,sum(coalesce(t1.xsje_y_kh,0)) as 销售金额_年累计_考核
		,sum(coalesce(t1.shje_y_ys,0)) as 赎回金额_年累计_原始
		,sum(coalesce(t1.shje_y_kh,0)) as 赎回金额_年累计_考核
		
		,sum(coalesce(t2.qmbyje_ys,0)) as 期初市值_原始
		,sum(coalesce(t2.qmbyje_kh,0)) as 期初市值_考核
		,sum(coalesce(t1.qmbyje_ys,0)) as 期末市值_原始
		,sum(coalesce(t1.qmbyje_kh,0)) as 期末市值_考核
		
		,sum(coalesce(t1.byje_yrj_ys,0)) as 月日均市值_原始
		,sum(coalesce(t1.byje_yrj_kh,0)) as 月日均市值_考核
		,sum(coalesce(t1.byje_nrj_ys,0)) as 年日均市值_原始
		,sum(coalesce(t1.byje_nrj_kh,0)) as 年日均市值_考核
		
		,0 as 手续费_月累计
		,0 as 手续费_年累计
		,0 as 销售金额_月累计_首发_原始
		,0 as 销售金额_月累计_首发_考核
		,0 as 销售金额_年累计_首发_原始
		,0 as 销售金额_年累计_首发_考核
		,0 as 手续费_月累计_首发
		,0 as 手续费_年累计_首发		
	from 
	(
		select
			ygh,cplx
		from dba.tmp_ddw_twcp_m t1
		where t1.nian=@nian and t1.yue=@yue or t1.nian=@snm_nian and t1.yue=@snm_yue
		group by ygh,cplx
	) t_all
	left join
	(
		select 
			ygh
			,cplx
			--原始
			,sum(xsje_m) as xsje_m_ys
			,sum(shje_m) as shje_m_ys
			,sum(xsje_y) as xsje_y_ys
			,sum(shje_y) as shje_y_ys
			,sum(qmbyje) as qmbyje_ys
			,sum(byje_yrj) as byje_yrj_ys
			,sum(byje_nrj) as byje_nrj_ys
			--考核
			,sum(case when cplx in ('固定收益','债券类私募信托') then xsje_m*0.5 else xsje_m end) as xsje_m_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then shje_m*0.5 else shje_m end) as shje_m_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then xsje_y*0.5 else xsje_y end) as xsje_y_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then shje_y*0.5 else shje_y end) as shje_y_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then qmbyje*0.5 else qmbyje end) as qmbyje_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then byje_yrj*0.5 else byje_yrj end) as byje_yrj_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then byje_nrj*0.5 else byje_yrj end) as byje_nrj_kh
			
		from dba.tmp_ddw_twcp_m t1
		where t1.nian=@nian and t1.yue=@yue
		group by ygh,nian,yue,cplx
	) t1 on t_all.ygh=t1.ygh and t_all.cplx=t1.cplx
	left join
	(--上年末
		select 
			ygh
			,cplx
			--原始
			,sum(xsje_m) as xsje_m_ys
			,sum(shje_m) as shje_m_ys
			,sum(xsje_y) as xsje_y_ys
			,sum(shje_y) as shje_y_ys
			,sum(qmbyje) as qmbyje_ys
			,sum(byje_yrj) as byje_yrj_ys
			,sum(byje_nrj) as byje_nrj_ys
			--考核
			,sum(case when cplx in ('固定收益','债券类私募信托') then xsje_m*0.5 else xsje_m end) as xsje_m_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then shje_m*0.5 else shje_m end) as shje_m_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then xsje_y*0.5 else xsje_y end) as xsje_y_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then shje_y*0.5 else shje_y end) as shje_y_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then qmbyje*0.5 else qmbyje end) as qmbyje_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then byje_yrj*0.5 else byje_yrj end) as byje_yrj_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then byje_nrj*0.5 else byje_yrj end) as byje_nrj_kh
			
		from dba.tmp_ddw_twcp_m t1
		where t1.nian=@snm_nian and t1.yue=@snm_yue
		group by ygh,nian,yue,cplx
	) t2 on t_all.ygh=t2.ygh and t_all.cplx=t2.cplx
	group by t_all.ygh,是否产品新客户,资产段,资产段_上年末,账户性质,是否年新增,是否月新增,是否大小非客户,是否营业部目标客户,是否有效户,产品类型
);
