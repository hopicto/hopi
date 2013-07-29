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

select 
	@nian||@yue as 年月
	,yyb.jgqc as 营业部
	,yyb.jgmc as 营业部_简称
	,yyb.zxyybmc as 中心营业部
	,yyb.fgs as 分公司
	,t_cp.是否产品新客户
	,t_cp.资产段
	,t_cp.产品类型
	
	,sum(t_cp.销售金额_月累计_原始) as 销售金额_月累计_原始
	,sum(t_cp.销售金额_月累计_考核) as 销售金额_月累计_考核
	,sum(t_cp.赎回金额_月累计_原始) as 赎回金额_月累计_原始
	,sum(t_cp.赎回金额_月累计_考核) as 赎回金额_月累计_考核
	,sum(t_cp.销售金额_年累计_原始) as 销售金额_年累计_原始
	,sum(t_cp.销售金额_年累计_考核) as 销售金额_年累计_考核
	,sum(t_cp.赎回金额_年累计_原始) as 赎回金额_年累计_原始
	,sum(t_cp.赎回金额_年累计_考核) as 赎回金额_年累计_考核
	,sum(t_cp.期初市值_原始) as 期初市值_原始
	,sum(t_cp.期初市值_考核) as 期初市值_考核
	,sum(t_cp.期末市值_原始) as 期末市值_原始
	,sum(t_cp.期末市值_考核) as 期末市值_考核
	,sum(t_cp.月日均市值_原始) as 月日均市值_原始
	,sum(t_cp.月日均市值_考核) as 月日均市值_考核
	,sum(t_cp.年日均市值_原始) as 年日均市值_原始
	,sum(t_cp.年日均市值_考核) as 年日均市值_考核
	
	,sum(t_cp.销售金额_月累计_首发_原始) as 月首发
	,sum(t_cp.销售金额_年累计_首发_原始) as 年首发
	
	--手续费
	,sum(t_cp.手续费_月累计) as 手续费_月累计
	,sum(t_cp.手续费_年累计) as 手续费_年累计
	
	,sum(t_cp.手续费_月累计_首发) as 首发手续费_月累计
	,sum(t_cp.手续费_年累计_首发) as 首发手续费_年累计
	
	,sum(t_cp.销售金额_月累计_首发_考核) as 月首发_考核
	,sum(t_cp.销售金额_年累计_首发_考核) as 年首发_考核		
from #temp_ygcp as t_cp
left join
(
	select
		t1.ygh,		
		case when t2.ygh is null then t1.jgbh else '#CFZX' end as jgbh
	from dba.t_yunying2012_param_yg t1
		left join #temp_cfzx t2 on t1.ygh=t2.ygh
	where t1.nian=@nian_gx and t1.yue=@yue_gx
) as t_yg on t_cp.ygh=t_yg.ygh
left join #temp_yybdz yyb on t_yg.jgbh=yyb.jgbh
where t_cp.nian=@nian and t_cp.yue=@yue
group by yyb.jgqc,yyb.jgmc,yyb.zxyybmc,yyb.fgs,t_cp.是否产品新客户,t_cp.资产段,t_cp.产品类型
order by yyb.jgqc,yyb.jgmc,yyb.zxyybmc,yyb.fgs,t_cp.是否产品新客户,t_cp.资产段,t_cp.产品类型
;
output to "C:\ado_data\月报数据\201305_1_产品.xls" format excel