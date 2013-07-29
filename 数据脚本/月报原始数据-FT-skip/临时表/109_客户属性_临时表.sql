--客户属性（全属性）
drop table #temp_khsx;
create table #temp_khsx
(
	nian 						varchar(4)		not null
	,yue						varchar(2)		not null
	,zjzh 						varchar(128)	not null	
	,khbh_hs					varchar(128)
	,sfxz_y						int
	,sfxz_m						int
	,sfyxh						int
	,sfdxfkh					int
	,khzt						int
	,账户性质					varchar(128)	
	,目标客户标准				numeric(20,4)
	,是否目标客户				int
	,是否产品新客户				int
	,资产段_上年					varchar(128)
	,资产段_本年					varchar(128)
	
	--期末资产
	,
	
	--月日均资产
	
	
	--销售
	
	--收入
	
	,constraint pk_skb_temp_khsx primary key (nian,yue,zjzh)	
);

insert into #temp_khsx
(
	nian
	,yue
	,zjzh		
)
(
	select
		t1.nian
		,t1.yue
		,t1.zjzh	
		
	from
	(
		select
			t1.*
		from dba.t_ddw_yunying2012_kh t1
		where t1.nian=@nian and t1.yue=@yue
	) t_yue	
	left join DBA.客户综合分析_月 as t_yue_zh on t_yue.zjzh=t_yue_zh.资金账户 
		and t_yue_zh.年份=@nian and t_yue_zh.月份=@yue
	left join DBA.客户综合分析_年 as t_nian_zh on t_yue.zjzh=t_nian_zh.资金账户 
		and t_nian_zh.年份=@nian and t_nian_zh.月份=@yue and t_nian_zh.账户状态 is not null	
	left join dba.T_DDW_XYZQ_F00_KHZHFX_2011 as t_yue_2011 on t_yue.zjzh=t_yue_2011.zjzh 
		and t_yue_2011.nian=@nian and t_yue_2011.yue=@yue
	left join #temp_dxf t_dxf on t_yue.zjzh=t_dxf.zjzh
	left join 
	(--2012月日均资产
		select 
			t1.资金账户 as zjzh
			,t1.日均资产+t2.rzrq_rjzc_m as 月日均资产_2012
		from 
		(
			t1.年份
			,t1.月份
			,t1.资金账户
			,t1.日均资产
			from DBA.客户综合分析_月 t1
			where t1.年份='2012' and t1.月份='12'
		) t1
		left join dba.T_DDW_XYZQ_F00_KHZHFX_2011 as t2 on t1.资金账户=t2.zjzh and t1.年份=t2.nian and t1.月份=t2.yue		
	)as t_2012 on t_yue.zjzh=t_2013.zjzh
	left join
	(
		select
			t1.zjzh
			,sum()
		from #temp_khjjfl t1
		group by t1.zjzh
	) t_cp on t_yue.zjzh=t_cp.zjzh
	left join 
	(--年度累计_收入_产品
		select
			zjzh
			,khbh_hs
			,sum(ejcs_m-lcsr_m) as 佣金收入_年累计
			,sum(lcsr_m) as 利差收入_年累计
			,sum(ejcs_m) as 二级收入_年累计
			
			,sum(rzrq_xyjyjsr_m) as 融资融券信用交易净收入_年累计
			,sum(rzrq_lxsr_m) as 融资融券利息收入_年累计
			
			,sum(kfsjj_cwsxf_m+kfsjj_cnrgsxf_m) as 开放式基金手续费_年累计
			,sum(dxcp_cwsxf_m+dxcp_cnrgsxf_m) as 定向产品手续费_年累计
			,sum(zgcp_cwsxf_m+zgcp_cnrgsxf_m) as 资管产品手续费_年累计

			,sum(kfsjj_cwxsje_m + kfsjj_cnrgje_m) as 开放式基金销售金额_年累计
			,sum(kfsjj_cwxsje_hx_m + kfsjj_cnrgje_hx_m) as 开放式基金销售金额_其中核心基金_年累计
			
			,sum(case when yue='12' then kfsjj_cwbysz_yrj else 0 end) as 开放式基金场外保有市值_月日均
			,sum(case when yue='12' then kfsjj_cwbysz_hx_yrj else 0 end) as 开放式基金场外保有市值_核心基金_月日均     
			,sum(dxcp_cwxsje_m + dxcp_cnrgje_m) as 定向产品销售金额_年累计         
			,sum(case when yue='12' then dxcp_cwbysz_yrj else 0 end) as 定向产品场外保有市值_月日均 
			,sum(zgcp_cwxsje_m  + zgcp_cnrgje_m) as 资管产品销售金额_年累计       
			,sum(case when yue='12' then zgcp_cwbysz_yrj else 0 end) as 资管产品场外保有市值_月日均
			
			,开放式基金销售金额_其中核心基金_年累计 * 20 * 8/10000 +   	--销售分仓
				+ sum(kfsjj_cwbysz_hx_yrj * 4 * 8 /(10000*12) )		--保有分仓
			as 公募基金分仓转移_年累计

			------------月度------------
			,sum(case when yue=@yue then
					gpjjjyl_m   	--gj交易量_剔除根网
					+ gw_gpjyl_m	--根网股票交易量_月累计
					+ gw_jjjyl_m	--根网基金交易量_月累计
				 else 0 end 
				) as gj交易量_月累计_含根网
			,sum(case when yue=@yue then gpjjjyl_m else 0 end) as gj交易量_月累计_扣根网
			,sum(case when yue=@yue then gjjyj_m+gjghf_m/2 else 0 end) as gj净佣金_月累计
			
			------------年度------------
			,sum(
					gpjjjyl_m   	--gj交易量_剔除根网
					+ gw_gpjyl_m	--根网股票交易量_月累计
					+ gw_jjjyl_m	--根网基金交易量_月累计
				) as gj交易量_年累计_含根网
			,sum(gpjjjyl_m) as gj交易量_年累计_扣根网
			,sum(gjjyj_m+gjghf_m/2) as gj净佣金_年累计

			--------------债券年度---------------
			,sum(zqjyl_m) as 债券交易量_年累计
			,sum(zhgjyl_m+nhgjyl_m) as 回购交易量_年累计
			
		from dba.t_ddw_yunying2012_kh as kh
		where nian=@nian and yue<=@yue
		group by zjzh,khbh_hs
	) t_nian on t_yue.zjzh=t_nian.zjzh 	
)