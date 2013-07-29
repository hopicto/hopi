-------------------------------------START-----------------------------------
declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'


select
	--t_yg.nian||t_yg.yue as 年月
	@nian||@yue as 年月
	,t_jg.jgmc as 营业部_简称
	--,t_jg.zxyybbh as 中心营业部_机构编号
	,t_jg.zxyybmc as 中心营业部
	--,t_jg.jgfl as 机构分类
	--,t_jg.dqfl as 地区分类
	,t_jg.fgs as 分公司
	,sum(case when t_yg.yue=@yue then ibywrjzc else 0 end) as IB业务日均资产
	,sum(case when t_yg.yue=@yue then yxzkh_ibywqmzc else 0 end) as 月新增客户_IB业务期末资产
	,sum(case when t_yg.yue=@yue then yxzkh_ibywrjzc else 0 end) as 月新增客户_IB业务日均资产
	,sum(case when t_yg.yue=@yue then nxzkh_ibywqmzc else 0 end) as 年新增客户_IB业务期末资产
	,sum(case when t_yg.yue=@yue then nxzkh_ibywrjzc else 0 end) as 年新增客户_IB业务日均资产
	,sum(case when t_yg.yue=@yue then ibywsr_m else 0 end) as IB业务收入_月累计
	,sum(ibywsr_m) as IB业务收入_年累计
from dba.t_ddw_yunying2012_yg t_yg
--营业部
left join dba.yybdz as t_jg on t_jg.jgbh=t_yg.jgbh   --营业部表
where t_yg.nian=@nian and t_yg.yue<=@yue	
	and t_yg.jxlx='预发'
group by t_jg.jgmc,t_jg.zxyybbh,t_jg.zxyybmc,t_jg.jgfl,t_jg.dqfl,t_jg.fgs
order by t_jg.jgmc,t_jg.zxyybbh,t_jg.zxyybmc,t_jg.jgfl,t_jg.dqfl,t_jg.fgs

;

output to "C:\ado_data\月报数据\201303_7_期货IB业务.xls" format excel