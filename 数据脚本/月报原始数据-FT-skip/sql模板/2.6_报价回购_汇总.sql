-------------------------------------START-----------------------------------
declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'


select
	t1.nian||t1.yue as 年月
	,t_jg.jgmc as 营业部_简称
	,t_jg.zxyybbh as 中心营业部_机构编号
	,t_jg.zxyybmc as 中心营业部_机构名称
	,t_jg.jgfl as 机构分类
	,t_jg.dqfl as 地区分类
	,t_jg.fgs as 分公司
	,t_fenduan.资产段_2013_粗 as 当前资产段
	,sum(是否期末开通权限*jxbl) as 期末开通权限客户
	,sum(是否本月开通权限*jxbl) as 本月开通权限客户数
	,sum(是否本年开通权限*jxbl) as 本年开通权限客户数
	,sum(期末规模*jxbl) as 期末报价回购规模
	,sum(月日均规模*jxbl) as 月日均报价回购规模
	,sum(年日均规模*jxbl) as 年日均报价回购规模
	,sum(本月实付利息*jxbl) as 本月实付利息
	,sum(本年实付利息*jxbl) as 本年实付利息
	
	
from dba.t_ddw_yunying2012_kh as t1 
left join #temp_khsx as t_fenduan on t1.zjzh=t_fenduan.zjzh and t1.nian=t_fenduan.nian and t1.yue=t_fenduan.yue

/*----------报价回购------------*/
left join
(

	select
		t_bjhg.zjzh 
		,max(case when t_bjhg.rq=day_end then t_bjhg.sfktqx else 0 end) as 是否期末开通权限
		,(case when min(case when t_bjhg.sfktqx=1 then t_bjhg.rq else 99999999 end)>max(day_qc_yue) then 1 else 0 end)*是否期末开通权限 as 是否本月开通权限
		,(case when min(case when t_bjhg.sfktqx=1 then t_bjhg.rq else 99999999 end)>max(day_qc_nian) then 1 else 0 end)*是否期末开通权限 as 是否本年开通权限
		,max(case when t_bjhg.rq=day_end then cyje_br else 0 end) as 期末规模
		,sum(case when t_bjhg.rq between day_start_yue and day_end then cyje_br else 0 end)/max(gzr_m) as 月日均规模
		,sum(case when t_bjhg.rq between day_start_nian and day_end then cyje_br else 0 end)/max(gzr_y) as 年日均规模
		,sum(case when t_bjhg.rq between day_start_yue and day_end then t_bjhg.sflx_br else 0 end) as 本月实付利息
		,sum(case when t_bjhg.rq between day_start_nian and day_end then t_bjhg.sflx_br else 0 end) as 本年实付利息
	from 
	(
		select 
			t1.日期 as rq
			,t1.年份 as nian
			,t1.月份 as yue
			,t2.day_start_yue 	--本月开始日期
			,t2.day_start_nian 	--本年开始日期
			,t2.day_end 		--结束日期
			,t2.gzr_m			--本月工作日天数
			,t2.gzr_y			--本年工作日天数
			
		from DBA.v_skb_d_rq as t1
		cross join 
		(
			select 
				年份 as nian
				,min(case when 月份=@yue then 日期 else 99999999 end) as day_start_yue
				,convert(int,@nian||'0101') as day_start_nian
				,max(日期) as day_end
				,count(distinct case when 月份=@yue then 日期 else null end) as gzr_m  --本月工作日天数
				,count(distinct 日期) as gzr_y  --本月工作日天数
			from DBA.v_skb_d_rq 
			where 年份=@nian and 月份<=@yue and 是否工作日='1' 
			group by 年份
		)as t2 
		where convert(int,t1.年份||t1.月份) <= convert(int,@nian||@yue)
	)as t_rq
	left join 
	(
		select 
			t2.日期 as day_qc_nian
			,t1.日期 as xygzr --下一工作日
		from DBA.v_skb_d_rq as t1
		left join DBA.v_skb_d_rq as t2 on t1.syggzr=t2.日期
	) as t_rq_last_nian on t_rq.day_start_nian = t_rq_last_nian.xygzr
	left join 
	(
		select 
			t2.日期 as day_qc_yue
			,t1.日期 as xygzr --下一工作日
		from DBA.v_skb_d_rq as t1
		left join DBA.v_skb_d_rq as t2 on t1.syggzr=t2.日期
	) as t_rq_last_yue on t_rq.day_start_yue = t_rq_last_yue.xygzr
	
	left join dba.t_ddw_bjhg_d as t_bjhg on t_bjhg.rq=t_rq.rq
	group by zjzh
	
)as t_bjhg on t1.zjzh=t_bjhg.zjzh

-----------------绩效关系-----------------
--责权关系
left join dba.t_ddw_zrqygx as t_gx on t_gx.nian=@nian_gx and t_gx.yue=@yue_gx and t1.khbh_hs=t_gx.khbh_hs and t_gx.ywlb='1'     --客户映射
----理财顾问
--left join dba.t_yunying2012_param_yg as t_yg on t_yg.nian=@nian_gx and t_yg.yue=@yue_gx and t_gx.ygh=t_yg.ygh   --员工映射
----营业部
--left join dba.yybdz as t_jg on t_jg.jgbh=t_yg.jgbh   --营业部表

--增加财富中心特殊处理
left join
(
	select
		t1.ygh,		
		case when t2.ygh is null then t1.jgbh else '#CFZX' end as jgbh
	from dba.t_yunying2012_param_yg t1
		left join #temp_cfzx t2 on t1.ygh=t2.ygh
	where t1.nian=@nian_gx and t1.yue=@yue_gx
) as t_yg on t_gx.ygh=t_yg.ygh
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
) as t_jg on t_jg.jgbh=t_yg.jgbh


where 
	t1.nian=@nian and t1.yue=@yue
	and t1.zjzh not in --不含关联方以及总部销售定向
		(
			select zjzh from #temp_teshu where lx in ('剔除')
		)
	and t1.zjzh not in --不含特殊账户
		(
			select zjzh
			from dba.gt_ods_simu_trade_jour a
			where 
				cplx in ('权益类私募信托','定向') 
				and ny <= convert(int,@nian||@yue)				 --发生日期在本月之前
				and yxq_end >=(convert(int,@nian||@yue)*100+31)  --当期仍有效！！
				and zjzh is not null
			group by zjzh
		)

group by t1.nian,t1.yue,t_jg.jgmc,t_jg.zxyybbh,t_jg.zxyybmc,t_jg.jgfl,t_jg.dqfl,t_jg.fgs,t_fenduan.资产段_2013_粗
order by t1.nian,t1.yue,t_jg.jgmc,t_jg.zxyybbh,t_jg.zxyybmc,t_jg.jgfl,t_jg.dqfl,t_jg.fgs,t_fenduan.资产段_2013_粗

;

output to "C:\ado_data\月报数据\201303_6_报价回购.xls" format excel