declare @nian varchar(4),@yue varchar(2),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'

select
	@nian||@yue as 年月
	,t_jg_yg.org_full_name as 营业部
	,t_jg_2.jgmc as 营业部_简称
	,t_jg_2.zxyybmc as 中心营业部
	,资产段
	------------------客户数----------------
	,sum(case when t_gx.ywlb='1' and t_kh.年初是否状态正常=1 then 1*jxbl else 0 end) as 年初客户数
	,sum(case when t_gx.ywlb='1' and t_kh.月初是否状态正常=1 then 1*jxbl else 0 end) as 月初客户数
	,sum(case when t_gx.ywlb='1' and t_kh.当前是否状态正常=1 then 1*jxbl else 0 end) as 期末客户数
	,sum(case when t_gx.ywlb='1' then 是否本年增加客户*jxbl else 0 end) as 本年增加客户数
	,sum(case when t_gx.ywlb='1' then 是否本月增加客户*jxbl else 0 end) as 本月增加客户数
	,-(期末客户数-年初客户数-本年增加客户数) as 本年流失客户数
	,-(期末客户数-月初客户数-本月增加客户数) as 本月流失客户数
	
	------------------有效户----------------
	,sum(case when t_gx.ywlb='1' and t_kh.年初是否有效户=1 then 1*jxbl else 0 end) as 年初有效户
	,sum(case when t_gx.ywlb='1' and t_kh.月初是否有效户=1 then 1*jxbl else 0 end) as 月初有效户
	,sum(case when t_gx.ywlb='1' and t_kh.当前是否有效户=1 then 1*jxbl else 0 end) as 期末有效户
	,sum(case when t_gx.ywlb='1' then 是否本年增加有效户*jxbl else 0 end) as 本年增加有效户
	,sum(case when t_gx.ywlb='1' then 是否本月增加有效户*jxbl else 0 end) as 本月增加有效户
	,-(期末有效户-年初有效户-本年增加有效户) as 本年流失有效户
	,-(期末有效户-月初有效户-本月增加有效户) as 本月流失有效户
	
	------------------资产增加情况_月度----------------
	,sum(case when t_gx.ywlb='1' and t_kh.是否本月增加客户=1 then (t_kh.本月市值流入+t_kh.本月资金流入)*jxbl else 0 end) as 本月新开户本月资产流入
	,sum(case when t_gx.ywlb='1' and t_kh.是否本月增加客户<>1 then t_kh.本月资金流入*jxbl else 0 end) as 本月存量户本月资金流入
	,sum(case when t_gx.ywlb='1' and t_kh.是否本月增加客户<>1 then t_kh.本月市值流入*jxbl else 0 end) as 本月存量户本月市值流入
	,-sum(case when t_gx.ywlb='1' and t_kh.是否本月流失客户=1 then (t_kh.本月市值流出+t_kh.本月资金流出)*jxbl else 0 end) as 本月流失客户本月资产流出
	,-sum(case when t_gx.ywlb='1' and t_kh.是否本月流失客户<>1 then t_kh.本月资金流出*jxbl else 0 end) as 本月非流失客户本月资金流出
	,-sum(case when t_gx.ywlb='1' and t_kh.是否本月流失客户<>1 then t_kh.本月市值流出*jxbl else 0 end) as 本月非流失客户本月市值流出
	
	------------------资产增加情况_年度----------------
	,sum(case when t_gx.ywlb='1' and t_kh.是否本年增加客户=1 then (t_kh.本年市值流入+t_kh.本年资金流入)*jxbl else 0 end) as 本年新开户本年资产流入
	,sum(case when t_gx.ywlb='1' and t_kh.是否本年增加客户<>1 then t_kh.本年资金流入*jxbl else 0 end) as 本年存量户本年资金流入
	,sum(case when t_gx.ywlb='1' and t_kh.是否本年增加客户<>1 then t_kh.本年市值流入*jxbl else 0 end) as 本年存量户本年市值流入
	
	,-sum(case when t_gx.ywlb='1' and t_kh.是否本年流失客户=1 then (t_kh.本年市值流出+t_kh.本年资金流出)*jxbl else 0 end) as 本年流失客户本年资产流出
	,-sum(case when t_gx.ywlb='1' and t_kh.是否本年流失客户<>1 then t_kh.本年资金流出*jxbl else 0 end) as 本年非流失客户本年资金流出
	,-sum(case when t_gx.ywlb='1' and t_kh.是否本年流失客户<>1 then t_kh.本年市值流出*jxbl else 0 end) as 本年非流失客户本年市值流出
	
from 
--dba.t_yunying2012_param_yg as t_yg
(
	select
		t1.ygh,		
		case when t2.ygh is null then t1.jgbh else '#CFZX' end as jgbh
	from dba.t_yunying2012_param_yg t1
		left join #temp_cfzx t2 on t1.ygh=t2.ygh
	where t1.nian=@nian_gx and t1.yue=@yue_gx
) as t_yg      

--------责任权益关系_取当前时点-------
left join dba.t_ddw_zrqygx as t_gx on t_gx.nian=@nian_gx and t_gx.yue=@yue_gx and t_gx.ygh=t_yg.ygh     

-----------------营业部---------------
--left join DBA.T_EDW_T06_ORGANIZATION as t_jg_yg on t_yg.jgbh=t_jg_yg.org_cd	
--left join dba.yybdz as t_jg_2 on t_jg_2.jgbh=t_yg.jgbh

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
) as t_jg_yg on t_yg.jgbh=t_jg_yg.org_cd
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



-----------------客户指标---------------
left join #temp_zcld as t_kh on t_kh.khbh_hs=t_gx.khbh_hs

--where t_yg.nian=@nian and t_yg.yue=@yue

group by t_jg_yg.org_full_name,t_jg_2.jgmc,t_jg_2.zxyybmc,资产段
order by t_jg_yg.org_full_name,t_jg_2.jgmc,t_jg_2.zxyybmc,资产段
;

output to "C:\ado_data\月报数据\201303_3_资产流量.xls" format excel
