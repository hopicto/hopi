-------------------------------------START-----------------------------------
declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'


select
	t1.nian||t1.yue as 年月
	,t_jg.jgmc as 营业部_简称
	,t_jg.zxyybmc as 中心营业部_机构名称
	,t_jg.fgs as 分公司
	
--	,t_fenduan.资产段_2013_粗 as 当前资产段
	,t_fenduan.资产段_2013_细 as 当前资产段
	
	-------------------本月新增-------------------
	,sum(t1.rzrq_sfxz_m*jxbl) as 本月新增融资融券客户   --是否本月新增融资融券帐户
	,sum(t1.rzrq_sfxzyxh_m*jxbl) as 本月新增融资融券有效户   --是否本月新增融资融券有效户
	,sum(case when t1.rzrq_sfxz_m=1 then t1.rzrq_qmjzc*jxbl else 0 end) as  本月新增资产 --融资融券期末净资产
	,sum(case when t1.rzrq_sfxz_m=1 then t1.rzrq_qmzfz*jxbl else 0 end) as 本月新增余额 --融资融券期末总负债
	
	-------------------本年新增-------------------
	,sum(case when convert(int,rzrq_khrq/10000)=convert(int,@nian) then 1*jxbl else 0 end) as 本年新增融资融券客户   --是否本月新增融资融券帐户
	,sum(case when convert(int,rzrq_khrq/10000)=convert(int,@nian) then t1.rzrq_sfyxh*jxbl else 0 end) as 本年新增融资融券有效户   --是否本月新增融资融券有效户
	,sum(case when convert(int,rzrq_khrq/10000)=convert(int,@nian) then t1.rzrq_qmjzc*jxbl else 0 end) as  本年新增资产 --融资融券期末净资产
	,sum(case when convert(int,rzrq_khrq/10000)=convert(int,@nian) then t1.rzrq_qmzfz*jxbl else 0 end) as 本年新增余额 --融资融券期末总负债
	

	-------------------期末情况-------------------
	,sum(t1.sfrzrqkh*jxbl) as 月末融资融券客户   --是否融资融券客户
	,sum(t1.rzrq_sfyxh*jxbl) as 月末融资融券有效户数   --是否融资融券有效户
	,sum(t1.rzrq_qmjzc*jxbl) as  月末融资融券资产 --融资融券期末净资产
	,sum(t1.rzrq_qmzfz*jxbl) as 月末融资融券余额 --融资融券期末总负债
	
	,sum(t_rzrq_rj.月日均余额*jxbl) as 融资融券月日均余额 --融资融券月日均余额
	,sum(t_rzrq_rj.年日均余额*jxbl) as 融资融券年日均余额 --融资融券年日均余额	
	
	-------------------收入情况-------------------
	,sum(pt_jyl_m*jxbl) as 融资融券月交易量_普通
	,sum(pt_jyj_m*jxbl) as 融资融券月股基净佣金_普通
	,sum(pt_ghf_m*jxbl) as 融资融券月股基过户费_普通
		
	,sum(xy_jyl_m*jxbl) as 融资融券月交易量_信用
	,sum(xy_jyj_m*jxbl) as 融资融券月股基净佣金_信用
	,sum(xy_ghf_m*jxbl) as 融资融券月股基过户费_信用
	
	,sum(本月净利息收入*jxbl) as 融资融券月利息收入  --融资融券利息收入_月累计
	
	,sum(pt_jyl_y*jxbl) as 融资融券年交易量_普通
	,sum(pt_jyj_y*jxbl) as 融资融券年股基净佣金_普通
	,sum(pt_ghf_y*jxbl) as 融资融券年股基过户费_普通
		
	,sum(xy_jyl_y*jxbl) as 融资融券年交易量_信用
	,sum(xy_jyj_y*jxbl) as 融资融券年股基净佣金_信用
	,sum(xy_ghf_y*jxbl) as 融资融券年股基过户费_信用
	,sum(本年净利息收入*jxbl) as 本年利息收入
	
	,sum(t1.rzrq_zzc_yrj*jxbl) as 融资融券总资产_月日均
	,sum(t1.rzrq_zfz_yrj*jxbl) as 融资融券总负债_月日均
	,sum(t1.rzrq_jzc_yrj*jxbl) as 融资融券净资产_月日均
	
	,sum(case when t1.rzrq_sfxz_m=1 then t1.rzrq_zzc_yrj*jxbl else 0 end) as 本月新增融资融券总资产_月日均
	,sum(case when t_nian.是否本年新增=1 then t1.rzrq_zzc_yrj*jxbl else 0 end) as 本年新增融资融券总资产_月日均
	
	,sum(case when t1.rzrq_sfxz_m=1 then t1.rzrq_zfz_yrj*jxbl else 0 end) as 本月新增融资融券总负债_月日均
	,sum(case when t_nian.是否本年新增=1 then t1.rzrq_zfz_yrj*jxbl else 0 end) as 本年新增融资融券总负债_月日均
	
	,sum(case when t1.rzrq_sfxz_m=1 then t1.rzrq_jzc_yrj*jxbl else 0 end) as 本月新增融资融券净资产_月日均
	,sum(case when t_nian.是否本年新增=1 then t1.rzrq_jzc_yrj*jxbl else 0 end) as 本年新增融资融券净资产_月日均
	
	
	/*-------------------约定购回-------------------*/
	
	,sum(是否期末开通权限*jxbl) as 期末已开通权限客户
	,sum(是否本月开通权限*jxbl) as 本月开通权限客户
	,sum(是否本年开通权限*jxbl) as 本年开通权限客户
	,sum(约定购回期末余额*jxbl) as 约定购回期末余额
	,sum(约定购回月日均余额*jxbl) as 约定购回月日均余额
	,sum(约定购回年日均余额*jxbl) as 约定购回年日均余额
	
	,sum(本月初始交易客户数*jxbl) as 本月初始交易客户数
	,sum(本月初始交易量*jxbl) as 本月初始交易量
	,sum(本年初始交易客户数*jxbl) as 本年初始交易客户数
	,sum(本年初始交易量*jxbl) as 本年初始交易量
	,sum(本月购回交易客户数*jxbl) as 本月购回交易客户数
	,sum(本月购回交易量*jxbl) as 本月购回交易量
	,sum(本年购回交易客户数*jxbl) as 本年购回交易客户数
	,sum(本年购回交易量*jxbl) as 本年购回交易量
	,sum(本月购回实收利息*jxbl) as 本月购回实收利息
	,sum(本年购回实收利息*jxbl) as 本年购回实收利息
	
--	,sum(t1.ydghjzc_yrj*jxbl) as 约定购回月日均资产_lc
	,sum(约定购回月日均资产*jxbl) as 约定购回月日均资产
	,sum(约定购回年日均资产*jxbl) as 约定购回年日均资产
	
	-------------------月日均-------------------
	,sum(case when t_ydgh.是否本月开通权限=1 then t_ydgh.约定购回月日均余额*jxbl else 0 end) as 约定购回月日均余额_本月新增
	,sum(case when t_ydgh.是否本年开通权限=1 then t_ydgh.约定购回年日均余额*jxbl else 0 end) as 约定购回月日均余额_本年新增		
	
			
	,sum(case when t_ydgh.是否本年开通权限=1 then t_ydgh.约定购回期末余额*jxbl else 0 end) as 约定购回期末余额_本年新增
	,sum(case when t_ydgh.是否本年开通权限=1 then t_ydgh.约定购回年日均余额*jxbl else 0 end) as 约定购回年日均余额_本年新增
	
	,sum(case when t_nian.是否本年新增=1 then t_rzrq_rj.年日均余额*jxbl else 0 end) as 融资融券年日均余额_本年新增 --融资融券年日均余额_本年新增
	,sum(case when t1.rzrq_sfxz_m=1 then t_rzrq_rj.月日均余额*jxbl else 0 end) as 融资融券月日均余额_本月新增
	
from dba.t_ddw_yunying2012_kh as t1 
left join #temp_khsx as t_fenduan on t1.zjzh=t_fenduan.zjzh and t1.nian=t_fenduan.nian and t1.yue=t_fenduan.yue
left join
(
	select 
		zjzh
		,sum((rzrq_lxsr_m)*(1-0.3760947)*0.35) as 本年净利息收入
		,sum(case when yue=@yue then (rzrq_lxsr_m)*(1-0.3760947)*0.35 else 0 end) as 本月净利息收入
		,sum(rzrq_sfxz_m) as 是否本年新增
	from dba.t_ddw_yunying2012_kh
	where nian=@nian and yue<=@yue 
	group by zjzh 
) as t_nian on t1.zjzh = t_nian.zjzh
-----------------融资融券主题-----------------------
left join dba.t_ddw_f00_khzhfx_rzrq as t_rzrq on t1.nian=t_rzrq.nian and t1.yue=t_rzrq.yue and t1.khbh_hs=t_rzrq.client_id  
left join
(
	select 
		nian
--		,@yue as yue	--20130509 bug 会导致年日均余额多算
		,client_id
		,sum(finance_close_balance_m + shortsell_close_balance_m)/max(ts_y) as 年日均余额
		,sum(case when a.yue=@yue then finance_close_balance_m + shortsell_close_balance_m else 0 end)/max(ts_m) as 月日均余额		

	from dba.t_ddw_f00_khzhfx_rzrq as a
	left join 
	(
		select 
			年份
			,count(distinct 日期) as ts_y
			,count(distinct case when 月份=@yue then 日期 else null end) as ts_m
		from DBA.v_skb_d_rq
		where 年份=@nian and 月份<=@yue 
		group by 年份
	)as b on a.nian =b.年份
	 
	where nian=@nian and yue<=@yue
	group by nian,client_id
) as t_rzrq_rj on t1.nian=t_rzrq_rj.nian 
--	and t1.yue=t_rzrq_rj.yue 
	and t1.khbh_hs=t_rzrq_rj.client_id 


/*----------约定购回------------*/
left join
(

	select
		t_ydgh.zjzh 
		,max(case when t_ydgh.rq=day_end then t_ydgh.sfktqx else 0 end) as 是否期末开通权限
		,(case when min(case when t_ydgh.sfktqx=1 then t_ydgh.rq else 99999999 end)>max(day_qc_yue) then 1 else 0 end)*是否期末开通权限 as 是否本月开通权限
		,(case when min(case when t_ydgh.sfktqx=1 then t_ydgh.rq else 99999999 end)>max(day_qc_nian) then 1 else 0 end)*是否期末开通权限 as 是否本年开通权限
		
		,sum(case when t_ydgh.rq=day_end then t_ydgh_ye.ye else 0 end) as 约定购回期末余额
		,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh_ye.ye else 0 end)/max(gzr_m) as 约定购回月日均余额
		,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh_ye.ye else 0 end)/max(gzr_y) as 约定购回年日均余额
		
		,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.csjyje else 0 end) as 本月初始交易量
		,count(distinct case when t_ydgh.rq between day_start_yue and day_end and t_ydgh.csjyje>0 then t_ydgh.zjzh else null end) as 本月初始交易客户数
		,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.csjyje else 0 end) as 本年初始交易量
		,count(distinct case when t_ydgh.rq between day_start_nian and day_end and t_ydgh.csjyje>0 then t_ydgh.zjzh else null end) as 本年初始交易客户数
		
		,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.ghjyje else 0 end) as 本月购回交易量
		,count(distinct case when t_ydgh.rq between day_start_yue and day_end and t_ydgh.ghjyje>0 then t_ydgh.zjzh else null end) as 本月购回交易客户数
		,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.ghjyje else 0 end) as 本年购回交易量
		,count(distinct case when t_ydgh.rq between day_start_nian and day_end and t_ydgh.ghjyje>0 then t_ydgh.zjzh else null end) as 本年购回交易客户数
		,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.sslx else 0 end) as 本月购回实收利息
		,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.sslx else 0 end) as 本年购回实收利息

		,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.jzc else 0 end)/max(zrr_m) as 约定购回月日均资产
		,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.jzc else 0 end)/max(zrr_y) as 约定购回年日均资产
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
			,t2.zrr_m			--本月自然日天数
			,t2.zrr_y			--本年自然日天数
		from DBA.v_skb_d_rq as t1
		cross join 
		(
			select 
				年份 as nian
				,min(case when 月份=@yue then 日期 else 99999999 end) as day_start_yue
				,convert(int,@nian||'0101') as day_start_nian
				,max(case when 是否工作日='1' then 日期 else null end) as day_end
				,count(distinct case when 是否工作日='1' and 月份=@yue then 日期 else null end) as gzr_m  --本月工作日天数
				,count(distinct case when 是否工作日='1' then 日期 else null end) as gzr_y  --本月工作日天数
				
				,count(distinct case when 月份=@yue then 日期 else null end) as zrr_m  --本月自然日天数
				,count(distinct 日期) as zrr_y  --本年自然日天数
			from DBA.v_skb_d_rq 
			where 年份=@nian and 月份<=@yue 
				--and 是否工作日='1' 
			group by 年份
		)as t2 
		--where convert(int,t1.年份||t1.月份) <= convert(int,@nian||@yue)
		where t1.年份=@nian and t1.月份<=@yue 
		--convert(int,t1.年份||t1.月份) <= convert(int,@nian||@yue)
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
	
	----------------一个rq一个zjzh一条记录---------------
	left join dba.t_ddw_ydsgh_d as t_ydgh on t_ydgh.rq=t_rq.rq
	left join 
	(--约定购回余额
		select
			a.rq
			,a.zjzh
			,sum(lj.csjyje-lj.ghjyje+lj.sslx) as ye --余额
		from dba.t_ddw_ydsgh_d as a
		left join dba.t_ddw_ydsgh_d as lj on a.zjzh=lj.zjzh and a.rq>=lj.rq
		group by a.rq,a.zjzh
	)as t_ydgh_ye on t_ydgh_ye.rq=t_rq.rq and t_ydgh.zjzh=t_ydgh_ye.zjzh

	group by t_ydgh.zjzh

)as t_ydgh on t1.zjzh=t_ydgh.zjzh

-----------------绩效关系-----------------
--责权关系
left join dba.t_ddw_zrqygx as t_gx on t_gx.nian=@nian_gx and t_gx.yue=@yue_gx and t1.khbh_hs=t_gx.khbh_hs and t_gx.ywlb='9'     --客户映射
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
) as t_jg on t_jg.jgbh=t_yg.jgbh   --营业部表


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

group by t1.nian,t1.yue,t_jg.jgmc,t_jg.zxyybbh,t_jg.zxyybmc,t_jg.jgfl,t_jg.dqfl,t_jg.fgs,t_fenduan.资产段_2013_细
order by t1.nian,t1.yue,t_jg.jgmc,t_jg.zxyybbh,t_jg.zxyybmc,t_jg.jgfl,t_jg.dqfl,t_jg.fgs,t_fenduan.资产段_2013_细
;

output to "C:\ado_data\月报数据\201303_4_融资融券.xls" format excel
