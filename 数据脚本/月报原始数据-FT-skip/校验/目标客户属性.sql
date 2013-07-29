declare	@nian varchar(4),@yue varchar(2),@zjzh varchar(128)
set @nian='2013'
set @yue='05'
set @zjzh='abc'
select t1.zjzh,t_yue.,t_yue.khrq		
	,coalesce(t_yue_zh.日均资产,0) + coalesce(t_yue_2011.rzrq_rjzc_m,0)+coalesce(t_yue.ydghjzc_yrj,0) as 总资产_月日均
from (select t1.* from dba.t_ddw_yunying2012_kh t1 where t1.nian=@nian and t1.yue=@yue) t_yue
left join (select t1.资金账户 as zjzh,t1.日均资产,t1.帐户性质 from DBA.客户综合分析_月 t1	where t1.年份=@nian and t1.月份=@yue	) as t_yue_zh on t_yue.zjzh=t_yue_zh.zjzh
left join (select t1.zjzh,t1.rzrq_rjzc_m from dba.T_DDW_XYZQ_F00_KHZHFX_2011 t1	where t1.nian=@nian and t1.yue=@yue) as t_yue_2011 on t_yue.zjzh=t_yue_2011.zjzh
where t_yue.zjzh=@zjzh