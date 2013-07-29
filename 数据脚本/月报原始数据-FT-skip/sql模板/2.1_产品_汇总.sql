

declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'

select 
	@nian||@yue as 年月
	,t_jg.org_full_name as 营业部
	,t_jg_2.jgmc as 营业部_简称
	,t_jg_2.zxyybmc as 中心营业部
	,t_jg_2.fgs as 分公司
	,sfcpxkh as 是否产品新客户
	,zcd as 资产段
	,cplx as 产品类型
	,sum(xsje_m_ys) as 销售金额_月累计_原始
	,sum(xsje_m_kh) as 销售金额_月累计_考核
	,sum(shje_m_ys) as 赎回金额_月累计_原始
	,sum(shje_m_kh) as 赎回金额_月累计_考核
	,sum(xsje_y_ys) as 销售金额_年累计_原始
	,sum(xsje_y_kh) as 销售金额_年累计_考核
	,sum(shje_y_ys) as 赎回金额_年累计_原始
	,sum(shje_y_kh) as 赎回金额_年累计_考核
	,sum(qcsz_ys) as 期初市值_原始
	,sum(qcsz_kh) as 期初市值_考核
	,sum(qmsz_ys) as 期末市值_原始
	,sum(qmsz_kh) as 期末市值_考核
	,sum(rjsz_m_ys) as 月日均市值_原始
	,sum(rjsz_m_kh) as 月日均市值_考核
	,sum(rjsz_y_ys) as 年日均市值_原始
	,sum(rjsz_y_kh) as 年日均市值_考核
	
	,sum(xsje_m_sf) as 月首发
	,sum(xsje_y_sf) as 年首发
	
	--手续费
	,sum(t_cp.sxf_m) as 手续费_月累计
	,sum(t_cp.sxf_y) as 手续费_年累计
	
	,sum(t_cp.sf_sxf_m) as 首发手续费_月累计
	,sum(t_cp.sf_sxf_y) as 首发手续费_年累计
	
	,sum(xsje_m_sf_kh) as 月首发_考核
	,sum(xsje_y_sf_kh) as 年首发_考核
from #temp_cp_yg as t_cp
--left join dba.t_yunying2012_param_yg as t_yg on t_cp.ygh=t_yg.ygh and t_yg.nian=@nian_gx and t_yg.yue=@yue_gx   --当前年月
--left join DBA.T_EDW_T06_ORGANIZATION as t_jg on t_jg.org_cd=t_yg.jgbh   --营业部表
--left join dba.yybdz as t_jg_2 on t_jg_2.jgbh=t_yg.jgbh   --营业部表

--增加财富中心特殊处理
left join
(
	select
		t1.ygh,		
		case when t2.ygh is null then t1.jgbh else '#CFZX' end as jgbh
	from dba.t_yunying2012_param_yg t1
		left join #temp_cfzx t2 on t1.ygh=t2.ygh
	where t1.nian=@nian_gx and t1.yue=@yue_gx
) as t_yg on t_cp.ygh=t_yg.ygh
left join
(
	select
		t1.org_cd,
		t1.org_full_name
	from DBA.T_EDW_T06_ORGANIZATION t1
	union
	select
		'#CFZX' as org_cd,
		'财富中心' as org_full_name
	from #temp_cfzx
) as t_jg on t_jg.org_cd=t_yg.jgbh
left join
(
	select
		t1.jgbh,
		t1.jgmc,
		t1.zxyybmc,
		t1.fgs,
		t1.jgfl,
		t1.dqfl,
		t1.zxyybbh
	from dba.yybdz t1
	union
	select
		'#CFZX' as jgbh,
		'财富中心' as jgmc,
		'上海民生' as zxyybmc,
		'上海民生' as fgs,
		'D' as jgfl,
		'1' as dqfl,
		'XYSHPT2700' as zxyybbh
	from #temp_cfzx
) as t_jg_2 on t_jg_2.jgbh=t_yg.jgbh  


where t_cp.ny=convert(int,@nian||@yue)
group by t_cp.ny,t_jg.org_full_name,t_jg_2.jgmc,t_jg_2.zxyybmc,t_jg_2.fgs,sfcpxkh,cplx,zcd
order by t_cp.ny,t_jg.org_full_name,t_jg_2.jgmc,t_jg_2.zxyybmc,t_jg_2.fgs,sfcpxkh,cplx,zcd
;
output to "C:\ado_data\月报数据\201303_1_产品.xls" format excel

