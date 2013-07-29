drop table #temp_mbkhsrjg;
create table #temp_mbkhsrjg
(
	ny varchar(30),  --年月
	营业部 varchar(128),
	营业部_简称 varchar(128),
	中心营业部 varchar(128),
	分公司 varchar(128),
	
	是否年新增 int,
	是否月新增 int,
	是否营业部目标客户 int,
	是否100万以上 int,
	
	回购净佣金_月累计 numeric(38,10), 
	回购净佣金_年累计 numeric(38,10), 
	
	佣金收入_月累计 numeric(38,10), 
	利差收入_月累计 numeric(38,10), 
	
	融资融券信用交易佣金_月累计 numeric(38,10), 
	融资融券利息收入_月累计 numeric(38,10), 
	
	佣金收入_年累计 numeric(38,10), 
	利差收入_年累计 numeric(38,10), 
	融资融券信用交易佣金_年累计 numeric(38,10), 
	融资融券利息收入_年累计 numeric(38,10), 	
	
	核心公募股票型手续费_月累计 numeric(38,10), 
	核心公募股票型手续费_年累计 numeric(38,10),
	
	核心公募股票型销售_月累计 numeric(38,10),
	核心公募股票型销售_年累计 numeric(38,10),
	
	核心公募股票型保有_月日均 numeric(38,10),
	核心公募股票型保有_年日均 numeric(38,10),
			
	集合理财股票型销售_月累计 numeric(38,10),
	集合理财股票型销售_年累计 numeric(38,10),
	
	集合理财股票型保有_月日均 numeric(38,10),
	集合理财股票型保有_年日均 numeric(38,10),
	基金专户债券型保有_月日均 numeric(38,10),
	基金专户债券型保有_年日均 numeric(38,10),
	公募债券型有手续费手续费_月累计 numeric(38,10),
	公募债券型有手续费手续费_年累计 numeric(38,10),
	集合理财债券型销售_月累计 numeric(38,10),
	集合理财债券型销售_年累计 numeric(38,10),
	集合理财债券型保有_月日均 numeric(38,10),
	集合理财债券型保有_年日均 numeric(38,10),
	报价回购规模_月日均 numeric(38,10),
	报价回购规模_年日均 numeric(38,10),
	公募货币型保有_月日均 numeric(38,10),
	公募货币型保有_年日均 numeric(38,10),
	约定购回净佣金_月累计 numeric(38,10),
	约定购回净佣金_年累计 numeric(38,10),
	约定购回实收利息_月累计 numeric(38,10),
	约定购回实收利息_年累计 numeric(38,10)
	
	,集合理财货币型保有_月日均 numeric(38,10)
	,集合理财货币型保有_年日均 numeric(38,10)
			
	,内部创收产品销售_月累计 numeric(38,10)
	,内部创收产品销售_年累计 numeric(38,10)
	
--	融资融券信用交易佣金_月累计 numeric(38,10),
--	融资融券信用交易佣金_年累计 numeric(38,10),
--	融资融券利息收入_月累计 numeric(38,10),
--	融资融券利息收入_年累计 numeric(38,10)
);

declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'

insert into #temp_mbkhsrjg(
	ny,
	营业部,
	营业部_简称,
	中心营业部,
	分公司,
	
	是否年新增,
	是否月新增,
	是否营业部目标客户,
	是否100万以上,
	
	回购净佣金_月累计, 
	回购净佣金_年累计, 
	
	佣金收入_月累计, 
	利差收入_月累计, 
	融资融券信用交易佣金_月累计,
	融资融券利息收入_月累计,
	
	佣金收入_年累计, 
	利差收入_年累计, 
	融资融券信用交易佣金_年累计,	
	融资融券利息收入_年累计,
	
	核心公募股票型手续费_月累计, 
	核心公募股票型手续费_年累计,
	核心公募股票型销售_月累计,
	核心公募股票型销售_年累计,
	核心公募股票型保有_月日均,
	核心公募股票型保有_年日均,
	集合理财股票型销售_月累计,
	集合理财股票型销售_年累计,
	集合理财股票型保有_月日均,
	集合理财股票型保有_年日均,
	基金专户债券型保有_月日均,
	基金专户债券型保有_年日均,
	公募债券型有手续费手续费_月累计,
	公募债券型有手续费手续费_年累计,
	集合理财债券型销售_月累计,
	集合理财债券型销售_年累计,
	集合理财债券型保有_月日均,
	集合理财债券型保有_年日均,
	报价回购规模_月日均,
	报价回购规模_年日均,
	公募货币型保有_月日均,
	公募货币型保有_年日均,
	约定购回净佣金_月累计,
	约定购回净佣金_年累计,
	约定购回实收利息_月累计,
	约定购回实收利息_年累计	
	
	,集合理财货币型保有_月日均
	,集合理财货币型保有_年日均
	
	,内部创收产品销售_月累计
	,内部创收产品销售_年累计
)
(

	select
		@nian||@yue as ny
		,t_ygjg_1.org_full_name as 营业部
		,t_ygjg_2.jgmc as 营业部_简称
		,t_ygjg_2.zxyybmc as 中心营业部
		,t_ygjg_2.fgs as 分公司
--		,t1.账户性质 as 账户性质
		,t1.sfxz_y as 是否年新增
		,t1.sfxz_m as 是否月新增
--		,t1.sfdxfkh as 是否大小非客户	
--		,t1.目标客户标准 as 营业部目标客户门槛
		,t1.是否目标客户 as 是否营业部目标客户
		,case when t1.资产段_2013_细>='4-100w_200w' then 1 else 0 end as 是否100万以上
--		,t1.资产段_2012_细 as 资产段_201212_细分
--		,t1.资产段_2013_细 as 资产段_当前月份_细分
--		,sum(case when t_gx.ywlb='1' and t1.khzt='正常' then 1*jxbl else 0 end) as 客户数
--		,sum(case when t_gx.ywlb='1' then (t1.sfyxh)*jxbl else 0 end) as 有效户数
--		
--		----------期末资产(有效)----------
--		,期末产品有效市值 + 期末有效二级资产 as  期末有效总资产
--		,sum(case when t_gx.ywlb='4' then t1.期末公募基金保有_考核*jxbl 
--				  when t_gx.ywlb='5' then t1.期末定向保有_考核*jxbl  
--				  when t_gx.ywlb='6' then t1.期末集合理财保有_考核*jxbl 
--				  when t_gx.ywlb='私募' then t1.期末公募基金保有_考核*jxbl 
--				  else 0 end) as 期末产品有效市值
--		,sum(case when t_gx.ywlb in ('1','港股','IB') then t1.期末有效二级资产*jxbl else 0 end) as 期末有效二级资产
--		,sum(case when t_gx.ywlb ='1' then t1.期末大小非折算市值*jxbl else 0 end) as 期末大小非折算市值
--		,sum(case when t_gx.ywlb ='1' then t1.期末约定购回净资产*jxbl else 0 end) as 期末约定购回资产
--		,sum(case when t_gx.ywlb='1' then t1.年日均保证金_计算利差使用*jxbl else 0 end)*1.4658 as 期末保证金_折算市值
--		,sum(case when t_gx.ywlb='1' then t1.期末债券市值*jxbl else 0 end)*0.2194 as 期末债券折算市值
--		,sum(case when t_gx.ywlb='1' then t1.期末回购市值*jxbl else 0 end)*0.2564 as 期末回购折算市值
--		
--		----------期末资产(折算方法二)----------
--		--,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.期末折算资产_方法二*jxbl else 0 end) as 期末资产（折算方法二） 	
--		--注意：折算方法二资产，若先按照账户算出，再按照业务类型1划分；与先按照业务类型划分，再汇总结果不同。
--		,sum(case when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.期末股基市值
--															+coalesce(t1.期末约定购回净资产,0)
--															+t1.期末保证金
--															+t1.期末债券市值 + t1.期末回购市值
--															+t1.期末其他资产
--															)*jxbl else 0 end) --期末股基市值
--			--不含大小非期末产品市值
--			+ sum(case when t_gx.ywlb='4' and t1.sfdxfkh<>1 then t1.期末公募基金保有*jxbl 
--				  when t_gx.ywlb='5' and t1.sfdxfkh<>1 then t1.期末定向保有*jxbl  
--				  when t_gx.ywlb='6' and t1.sfdxfkh<>1 then t1.期末集合理财保有*jxbl 
--				  when t_gx.ywlb='私募' then t1.期末公募基金保有*jxbl 
--				  else 0 end)
--			+sum(case when t_gx.ywlb in('IB') then t1.期末资产*jxbl else 0 end)
--			+sum(case when t_gx.ywlb in('港股') then t1.期末资产*jxbl else 0 end)
--			-期末其中低风险扣减
--			+"期末其中大小非资产（单户3000万封顶）"
--			
--		as 期末资产（折算方法二）
--			
--		,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.期末低风险_封顶待扣除*jxbl else 0 end) as 期末其中低风险扣减 	 
--		,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.期末资产_大小非_封顶*jxbl else 0 end) as "期末其中大小非资产（单户3000万封顶）"
--	
--		
--		----------期末资产(无折算)----------
--		,期末股基市值_不含大小非 + 期末产品市值 + 期末保证金 
--				+ 期末债券市值 + 期末回购市值 + 期末IB资产 + 期末港股资产 + 期末其他资产 as 期末资产_不含大小非股基市值
--		,sum(case when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.期末股基市值+coalesce(t1.期末约定购回净资产,0))*jxbl else 0 end) as 期末股基市值_不含大小非
--		,sum(case when t_gx.ywlb='1' and t1.sfdxfkh=1 then t1.期末股基市值*jxbl else 0 end) as 期末股基市值_大小非
--		,sum(case when t_gx.ywlb='4' then t1.期末公募基金保有*jxbl 
--				  when t_gx.ywlb='5' then t1.期末定向保有*jxbl  
--				  when t_gx.ywlb='6' then t1.期末集合理财保有*jxbl 
--				  when t_gx.ywlb='私募' then t1.期末公募基金保有*jxbl 
--				  else 0 end) as 期末产品市值
--		,sum(case when t_gx.ywlb='4' then t1.期末核心公募基金保有*jxbl else 0 end) as 期末核心公募市值 	 
--		,sum(case when t_gx.ywlb='6' then t1.期末集合理财保有*jxbl else 0 end) as 期末资管产品市值 
--		,sum(case when t_gx.ywlb='1' then t1.期末保证金*jxbl else 0 end) as 期末保证金
--		,sum(case when t_gx.ywlb='1' then t1.期末债券市值*jxbl else 0 end) as 期末债券市值    
--		,sum(case when t_gx.ywlb='1' then t1.期末回购市值*jxbl else 0 end) as 期末回购市值
--		,sum(case when t_gx.ywlb in('IB') then t1.期末资产*jxbl else 0 end) as 期末IB资产
--		,sum(case when t_gx.ywlb in('港股') then t1.期末资产*jxbl else 0 end)  as 期末港股资产
--		,sum(case when t_gx.ywlb='1' then t1.期末其他资产*jxbl else 0 end) 期末其他资产
--		
--		----------月日均资产(有效)----------
--		,月日均产品有效市值 + 月日均有效二级资产 as 月日均有效总资产
--		,sum(case when t_gx.ywlb='4' then t1.月日均公募基金保有_考核*jxbl 
--				  when t_gx.ywlb='5' then t1.月日均定向保有_考核*jxbl  
--				  when t_gx.ywlb='6' then t1.月日均集合理财保有_考核*jxbl 
--				  when t_gx.ywlb='私募' then t1.月日均公募基金保有_考核*jxbl 
--				  else 0 end) as 月日均产品有效市值
--		,sum(case when t_gx.ywlb in ('1','港股','IB') then t1.月日均有效二级资产*jxbl else 0 end) as 月日均有效二级资产
--		,sum(case when t_gx.ywlb ='1' then t1.月日均大小非折算市值*jxbl else 0 end) as 月日均大小非折算市值
--		,sum(case when t_gx.ywlb ='1' then t1.月日均约定购回净资产*jxbl else 0 end) as 月日均约定购回资产
--		,sum(case when t_gx.ywlb='1' then t1.年日均保证金_计算利差使用*jxbl else 0 end)*1.4658 as 月日均保证金_折算市值
--		,sum(case when t_gx.ywlb='1' then t1.月日均债券市值*jxbl else 0 end)*0.2194 as 月日均债券折算市值
--		,sum(case when t_gx.ywlb='1' then t1.月日均回购市值*jxbl else 0 end)*0.2564 as 月日均回购折算市值
--	
--		----------日均资产(折算方法二)----------
--		--,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.月日均折算资产_方法二*jxbl else 0 end) as 月日均资产（折算方法二）
--		--注意：折算方法二资产，若先按照账户算出，再按照业务类型1划分；与先按照业务类型划分，再汇总结果不同。
--		,sum(case when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.月日均股基市值
--															+coalesce(t1.月日均约定购回净资产,0)
--															+t1.月日均保证金
--															+t1.月日均债券市值 + t1.月日均回购市值
--															+t1.月日均其他资产
--															)*jxbl else 0 end) --期末股基市值
--			--不含大小非期末产品市值
--			+ sum(case when t_gx.ywlb='4' and t1.sfdxfkh<>1 then t1.月日均公募基金保有*jxbl 
--				  when t_gx.ywlb='5' and t1.sfdxfkh<>1 then t1.月日均定向保有*jxbl  
--				  when t_gx.ywlb='6' and t1.sfdxfkh<>1 then t1.月日均集合理财保有*jxbl 
--				  when t_gx.ywlb='私募' then t1.月日均公募基金保有*jxbl 
--				  else 0 end)
--			+sum(case when t_gx.ywlb in('IB') then t1.月日均资产*jxbl else 0 end)
--			+sum(case when t_gx.ywlb in('港股') then t1.月日均资产*jxbl else 0 end)
--			-月日均其中低风险扣减
--			+"月日均其中大小非资产（单户3000万封顶）"
--			
--		as 月日均资产（折算方法二）
--		
--		,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.月日均低风险_封顶待扣除*jxbl else 0 end) as 月日均其中低风险扣减 	 
--		,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.月日均资产_大小非_封顶*jxbl else 0 end) as "月日均其中大小非资产（单户3000万封顶）"
--	
--		
--		----------月日均资产(无折算)----------
--		,月日均股基市值_不含大小非 + 月日均产品市值 + 月日均保证金 
--			+ 月日均债券市值 + 月日均回购市值 + 月日均IB资产 + 月日均港股资产 + 月日均其他资产 as 月日均资产_不含大小非股基市值
--		,sum(case when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.月日均股基市值+coalesce(t1.月日均约定购回净资产,0))*jxbl else 0 end) as 月日均股基市值_不含大小非
--		,sum(case when t_gx.ywlb='1' and t1.sfdxfkh=1 then t1.月日均股基市值*jxbl else 0 end) as 月日均股基市值_大小非
--		,sum(case when t_gx.ywlb='4' then t1.月日均公募基金保有*jxbl 
--				  when t_gx.ywlb='5' then t1.月日均定向保有*jxbl  
--				  when t_gx.ywlb='6' then t1.月日均集合理财保有*jxbl 
--				  when t_gx.ywlb='私募' then t1.月日均公募基金保有*jxbl 
--				  else 0 end) as 月日均产品市值
--		,sum(case when t_gx.ywlb='4' then t1.月日均核心公募基金保有*jxbl else 0 end) as 月日均核心公募市值
--		,sum(case when t_gx.ywlb='6' then t1.月日均集合理财保有*jxbl else 0 end) as 月日均资管产品市值	  
--		,sum(case when t_gx.ywlb='1' then t1.月日均保证金*jxbl else 0 end) as 月日均保证金
--		,sum(case when t_gx.ywlb='1' then t1.月日均债券市值*jxbl else 0 end) as 月日均债券市值
--		,sum(case when t_gx.ywlb='1' then t1.月日均回购市值*jxbl else 0 end) as 月日均回购市值
--		,sum(case when t_gx.ywlb in('IB') then t1.月日均资产*jxbl else 0 end) as 月日均IB资产
--		,sum(case when t_gx.ywlb in('港股') then t1.月日均资产*jxbl else 0 end)  as 月日均港股资产
--		,sum(case when t_gx.ywlb='1' then t1.月日均其他资产*jxbl else 0 end) 月日均其他资产
--		
--		----------月度交易----------
--		,sum(case when t_gx.ywlb in ('私募','1') then (t1.gj交易量_月累计_含根网+coalesce(t_rzrq.xy_jyl_m,0))*jxbl else 0 end) as 本月股基交易量_含根网ETF
--		,sum(case when t_gx.ywlb in ('私募','1') then (t1.gj交易量_月累计_扣根网+coalesce(t_rzrq.xy_jyl_m,0))*jxbl else 0 end) as 本月股基交易量_扣根网ETF
--		,sum(case when t_gx.ywlb in ('私募','1') then (t1.gj净佣金_月累计+coalesce(t_rzrq.xy_jyj_m+t_rzrq.xy_ghf_m/2,0))*jxbl else 0 end) as 本月股基净佣金_含过户费一半
--		,sum(case when t_gx.ywlb in ('私募','1') then t1.二级收入_月累计*jxbl else 0 end) as 本月二级创收
--		
--		----------年度交易----------
--		,sum(case when t_gx.ywlb in ('私募','1') then (t1.gj交易量_年累计_含根网+coalesce(t_rzrq.xy_jyl_y,0))*jxbl else 0 end) as 本年股基交易量_含根网ETF
--		,sum(case when t_gx.ywlb in ('私募','1') then (t1.gj交易量_年累计_扣根网+coalesce(t_rzrq.xy_jyl_y,0))*jxbl else 0 end) as 本年股基交易量_扣根网ETF
--		,sum(case when t_gx.ywlb in ('私募','1') then (t1.gj净佣金_年累计+coalesce(t_rzrq.xy_jyj_y+t_rzrq.xy_ghf_y/2,0))*jxbl else 0 end) as 本年股基净佣金_含过户费一半
--		,sum(case when t_gx.ywlb in ('私募','1') then t1.二级收入_年累计*jxbl else 0 end) as 本年二级创收
		
			
		----------债券交易_月度----------	
--		,sum(case when t_gx.ywlb='1' then t1.债券交易量_月累计*jxbl else 0 end) as 债券交易量_月累计
--		,sum(case when t_gx.ywlb='1' then t1.回购交易量_月累计*jxbl else 0 end) as 回购交易量_月累计
--		,sum(case when t_gx.ywlb='2' then t1.债券净佣金_月累计*jxbl else 0 end) as 债券净佣金_月累计
		,sum(case when t_gx.ywlb='2' then t1.回购净佣金_月累计*jxbl else 0 end) as 回购净佣金_月累计
	
		----------债券交易_年度----------
--		,sum(case when t_gx.ywlb='1' then t1.债券交易量_年累计*jxbl else 0 end) as 债券交易量_年累计
--		,sum(case when t_gx.ywlb='1' then t1.回购交易量_年累计*jxbl else 0 end) as 回购交易量_年累计
--		,sum(case when t_gx.ywlb='2' then t1.债券净佣金_年累计*jxbl else 0 end) as 债券净佣金_年累计
		,sum(case when t_gx.ywlb='2' then t1.回购净佣金_年累计*jxbl else 0 end) as 回购净佣金_年累计
	
		----------月度收入----------
		,sum(case when t_gx.ywlb in ('私募','2') then t1.佣金收入_月累计*jxbl else 0 end) as  佣金收入_月累计
		,sum(case when t_gx.ywlb='2' then t1.利差收入_月累计*jxbl else 0 end) as  利差收入_月累计
		,sum(case when t_gx.ywlb='9' then t1.融资融券信用交易净收入_月累计*jxbl else 0 end) as  融资融券信用交易佣金收入_月累计
		,sum(case when t_gx.ywlb='9' then t1.融资融券利息收入_月累计*jxbl else 0 end)*(1-0.3760947)*0.35 as  融资融券利息收入_月累计
--		,sum(case when t_gx.ywlb='4' then t1.开放式基金手续费_月累计*jxbl else 0 end) as  开放式基金手续费_月累计
--		,sum(case when t_gx.ywlb='5' then t1.定向产品手续费_月累计*jxbl else 0 end) as  定向产品手续费_月累计
--		,sum(case when t_gx.ywlb='6' then t1.资管产品手续费_月累计*jxbl else 0 end) as  资管产品手续费_月累计
--		,sum(case when t_gx.ywlb='1' then t1.公募基金分仓转移_月累计*jxbl else 0 end) as  公募基金分仓转移_月累计
--		,佣金收入_月累计+利差收入_月累计+融资融券信用交易佣金收入_月累计+融资融券利息收入_月累计
--			+开放式基金手续费_月累计+定向产品手续费_月累计+资管产品手续费_月累计+公募基金分仓转移_月累计 as 月度系统估算收入总计
		
		----------年度收入----------
		,sum(case when t_gx.ywlb in ('私募','2') then t1.佣金收入_年累计*jxbl else 0 end) as  佣金收入_年累计
		,sum(case when t_gx.ywlb='2' then t1.利差收入_年累计*jxbl else 0 end) as  利差收入_年累计
		,sum(case when t_gx.ywlb='9' then t1.融资融券信用交易净收入_年累计*jxbl else 0 end) as  融资融券信用交易佣金收入_年累计
		,sum(case when t_gx.ywlb='9' then t1.融资融券利息收入_年累计*jxbl else 0 end)*(1-0.3760947)*0.35 as  融资融券利息收入_年累计
--		,sum(case when t_gx.ywlb='4' then t1.开放式基金手续费_年累计*jxbl else 0 end) as  开放式基金手续费_年累计
--		,sum(case when t_gx.ywlb='5' then t1.定向产品手续费_年累计*jxbl else 0 end) as  定向产品手续费_年累计
--		,sum(case when t_gx.ywlb='6' then t1.资管产品手续费_年累计*jxbl else 0 end) as  资管产品手续费_年累计
--		,sum(case when t_gx.ywlb='1' then t1.公募基金分仓转移_年累计*jxbl else 0 end) as  公募基金分仓转移_年累计
--		,佣金收入_年累计+利差收入_年累计+融资融券信用交易佣金收入_年累计+融资融券利息收入_年累计
--			+开放式基金手续费_年累计+定向产品手续费_年累计+资管产品手续费_年累计+公募基金分仓转移_年累计  as 年度系统估算收入总计
	
		--权益类		
		,sum(case when t_gx.ywlb='4' then t1.核心公募股票型手续费_月累计*jxbl else 0 end) as 核心公募股票型手续费_月累计
		,sum(case when t_gx.ywlb='4' then t1.核心公募股票型手续费_年累计*jxbl else 0 end) as 核心公募股票型手续费_年累计
		
		,sum(case when t_gx.ywlb='4' then t1.核心公募股票型销售_月累计*jxbl else 0 end) as 核心公募股票型销售_月累计
		,sum(case when t_gx.ywlb='4' then t1.核心公募股票型销售_年累计*jxbl else 0 end) as 核心公募股票型销售_年累计
		
		,sum(case when t_gx.ywlb='4' then t1.核心公募股票型保有_月日均*jxbl else 0 end) as 核心公募股票型保有_月日均
		,sum(case when t_gx.ywlb='4' then t1.核心公募股票型保有_年日均*jxbl else 0 end) as 核心公募股票型保有_年日均
		
		,sum(case when t_gx.ywlb='6' then t1.集合理财股票型销售_月累计*jxbl else 0 end) as 集合理财股票型销售_月累计
		,sum(case when t_gx.ywlb='6' then t1.集合理财股票型销售_年累计*jxbl else 0 end) as 集合理财股票型销售_年累计
		
		,sum(case when t_gx.ywlb='6' then t1.集合理财股票型保有_月日均*jxbl else 0 end) as 集合理财股票型保有_月日均
		,sum(case when t_gx.ywlb='6' then t1.集合理财股票型保有_年日均*jxbl else 0 end) as 集合理财股票型保有_年日均
		
		,sum(case when t_gx.ywlb='5' then t1.基金专户债券型保有_月日均*jxbl else 0 end) as 基金专户债券型保有_月日均
		,sum(case when t_gx.ywlb='5' then t1.基金专户债券型保有_年日均*jxbl else 0 end) as 基金专户债券型保有_年日均
				
		,sum(case when t_gx.ywlb='4' then t1.公募债券型有手续费手续费_月累计*jxbl else 0 end) as 公募债券型有手续费手续费_月累计
		,sum(case when t_gx.ywlb='4' then t1.公募债券型有手续费手续费_年累计*jxbl else 0 end) as 公募债券型有手续费手续费_年累计
		
		,sum(case when t_gx.ywlb='6' then t1.集合理财债券型销售_月累计*jxbl else 0 end) as 集合理财债券型销售_月累计
		,sum(case when t_gx.ywlb='6' then t1.集合理财债券型销售_年累计*jxbl else 0 end) as 集合理财债券型销售_年累计
		
		,sum(case when t_gx.ywlb='6' then t1.集合理财债券型保有_月日均*jxbl else 0 end) as 集合理财债券型保有_月日均
		,sum(case when t_gx.ywlb='6' then t1.集合理财债券型保有_年日均*jxbl else 0 end) as 集合理财债券型保有_年日均
		
		--报价回购
		,sum(case when t_gx.ywlb='1' then t_bjhg.月日均规模*jxbl else 0 end) as 报价回购规模_月日均
		,sum(case when t_gx.ywlb='1' then t_bjhg.年日均规模*jxbl else 0 end) as 报价回购规模_年日均
		
		--债券回购，见上面 回购净佣金_月累计
		
		,sum(case when t_gx.ywlb='4' then t1.公募货币型保有_月日均*jxbl else 0 end) as 公募货币型保有_月日均
		,sum(case when t_gx.ywlb='4' then t1.公募货币型保有_年日均*jxbl else 0 end) as 公募货币型保有_年日均
		
		--约定购回		
		,sum(case when t_gx.ywlb='9' then t_ydgh.本月购回净佣金*jxbl else 0 end) as 约定购回净佣金_月累计
		,sum(case when t_gx.ywlb='9' then t_ydgh.本年购回净佣金*jxbl else 0 end) as 约定购回净佣金_年累计
		
		,sum(case when t_gx.ywlb='9' then t_ydgh.本月购回实收利息*jxbl else 0 end) as 约定购回实收利息_月累计
		,sum(case when t_gx.ywlb='9' then t_ydgh.本年购回实收利息*jxbl else 0 end) as 约定购回实收利息_年累计
		
		,sum(case when t_gx.ywlb='6' then t1.集合理财货币型保有_月日均*jxbl else 0 end) as 集合理财货币型保有_月日均
		,sum(case when t_gx.ywlb='6' then t1.集合理财货币型保有_年日均*jxbl else 0 end) as 集合理财货币型保有_年日均
		
		--内部创设产品销售		
		,sum(case when t_gx.ywlb='5' and t_nbcscp.zjzh is not null then t_nbcscp.内部创收产品销售_月累计*jxbl else 0 end) as 内部创收产品销售_月累计
		,sum(case when t_gx.ywlb='5' and t_nbcscp.zjzh is not null then t_nbcscp.内部创收产品销售_年累计*jxbl else 0 end) as 内部创收产品销售_年累计
	from 
	
	/*------------------①_客户指标----------------*/
	(
		select 
			t1.*
			,t2.dxfzssz_qm as 期末大小非折算市值
			,t2.dxfzssz_yrj as 月日均大小非折算市值			

		from #temp_khsx as t1
		left join dba.t_ddw_yunying2012_kh as t2 on t1.zjzh=t2.zjzh and t1.nian=t2.nian and t1.yue=t2.yue  
		
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
					ny <= convert(int,@nian||@yue)				 --发生日期在本月之前
					and yxq_end >=(convert(int,@nian||@yue)*100+31)  --当期仍有效！！
					and zjzh is not null
				group by zjzh
			)
	)as t1 
	
	--内部创收产品销售
	left join
	(
		select
			t1.zjzh
			,sum(t1.场外销售_月+t1.场内销售_月) as 内部创收产品销售_月累计
			,sum(t1.场外销售_年+t1.场内销售_年) as 内部创收产品销售_年累计
		from 
		(
			SELECT 
				a.nian,
				a.yue,
				a.zjzh,
		        a.jjdm,				
				 ------月度销售------
		         SUM(a.cwje_rgqr_m + a.cwje_sgqr_m + a.cwje_dsdetzqr_m + a.cwje_zhrqr_m + a.ztgrqrje_m) AS 场外销售_月,    -- 场外销售金额_月累计(原始值)
		         SUM(a.cnje_rgqr_m + COALESCE(a.hg_je_m, 0)) AS 场内销售_月,    -- 场内认购金额_月累计(原始值)
		         SUM(a.cwje_shqr_m + a.ztgcqrje_m + a.cwje_cgpxzhc_m ) AS 赎回_月 ,    -- 场外赎回金额_月累计(原始)
		
				 ------年度销售------
		         SUM(a.cwje_rgqr_y + a.cwje_sgqr_y + a.cwje_dsdetzqr_y + a.cwje_zhrqr_y + a.ztgrqrje_y) AS 场外销售_年,    -- 场外销售金额_年累计(原始值)
		         SUM(a.cnje_rgqr_y + COALESCE(a.hg_je_y, 0)) AS 场内销售_年,    -- 场内认购金额_年累计(原始值)
		         SUM(a.cwje_shqr_y + a.ztgcqrje_y+ a.cwje_cgpxzhc_y ) AS 赎回_年    -- 场外赎回金额_年累计(原始)						         
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
		                             
			--资管总部销售					
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
		   GROUP BY a.nian,a.yue,a.zjzh,a.jjdm
		) t1
		left join #temp_nbcscp t2 on t1.jjdm=t2.jjdm				
		where t2.jjdm is not null
		group by t1.zjzh
	) t_nbcscp on t1.zjzh=t_nbcscp.zjzh
	----------报价回购------------
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
	left join
	(--约定购回	
		select
			t_ydgh.zjzh 
			,max(case when t_ydgh.rq=day_end then t_ydgh.sfktqx else 0 end) as 是否期末开通权限
			,(case when min(case when t_ydgh.sfktqx=1 then t_ydgh.rq else 99999999 end)>max(day_qc_yue) then 1 else 0 end)*是否期末开通权限 as 是否本月开通权限
			,(case when min(case when t_ydgh.sfktqx=1 then t_ydgh.rq else 99999999 end)>max(day_qc_nian) then 1 else 0 end)*是否期末开通权限 as 是否本年开通权限
			
			,sum(case when t_ydgh.rq=day_end then t_ydgh_ye.ye else 0 end) as 约定购回期末余额
			,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh_ye.ye else 0 end)/max(gzr_m) as 约定购回月日均余额
			,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh_ye.ye else 0 end)/max(gzr_y) as 约定购回年日均余额
			
--			,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.csjyje else 0 end) as 本月初始交易量
--			,count(distinct case when t_ydgh.rq between day_start_yue and day_end and t_ydgh.csjyje>0 then t_ydgh.zjzh else null end) as 本月初始交易客户数
--			,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.csjyje else 0 end) as 本年初始交易量
--			,count(distinct case when t_ydgh.rq between day_start_nian and day_end and t_ydgh.csjyje>0 then t_ydgh.zjzh else null end) as 本年初始交易客户数
--			
--			,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.ghjyje else 0 end) as 本月购回交易量
--			,count(distinct case when t_ydgh.rq between day_start_yue and day_end and t_ydgh.ghjyje>0 then t_ydgh.zjzh else null end) as 本月购回交易客户数
--			,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.ghjyje else 0 end) as 本年购回交易量
--			,count(distinct case when t_ydgh.rq between day_start_nian and day_end and t_ydgh.ghjyje>0 then t_ydgh.zjzh else null end) as 本年购回交易客户数
			,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.sslx else 0 end) as 本月购回实收利息
			,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.sslx else 0 end) as 本年购回实收利息
	
			,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.jzc else 0 end)/max(zrr_m) as 约定购回月日均资产
			,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.jzc else 0 end)/max(zrr_y) as 约定购回年日均资产
			
			,sum(case when t_ydgh.rq between day_start_yue and day_end then t_ydgh.jyj else 0 end) as 本月购回净佣金
			,sum(case when t_ydgh.rq between day_start_nian and day_end then t_ydgh.jyj else 0 end) as 本年购回净佣金
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
					,max(日期) as day_end
					,count(distinct case when 是否工作日='1' and 月份=@yue then 日期 else null end) as gzr_m  --本月工作日天数
					,count(distinct case when 是否工作日='1' then 日期 else null end) as gzr_y  --本月工作日天数
					
					,count(distinct case when 月份=@yue then 日期 else null end) as zrr_m  --本月自然日天数
					,count(distinct 日期) as zrr_y  --本年自然日天数
				from DBA.v_skb_d_rq 
				where 年份=@nian and 月份<=@yue 
					--and 是否工作日='1' 
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

	-----------②_融资融券--------------
	left join dba.t_ddw_f00_khzhfx_rzrq as t_rzrq on t1.nian=t_rzrq.nian and t1.yue=t_rzrq.yue and t1.khbh_hs=t_rzrq.client_id  --融资融券
	
	-----------------绩效关系_增加体外虚拟关系-----------------
	left join 
	(
		
		select *
			from 
			dba.t_ddw_zrqygx as t_gx
			where t_gx.nian=@nian and t_gx.yue=@yue
	
		union all 
		
			select
				@nian_gx as nian
				,@yue_gx yue
				,'' as jgbh_hs
	  
			   ,case when xh=1 and sfxz_y=1 and sfxz_m=0 then '港股_年新增_'||trim(t_yyb.jgbh)
				  when xh=2 and sfxz_y=1 and sfxz_m=0 then 'IB_年新增_'||trim(t_yyb.jgbh)
				  when xh=3 and sfxz_y=1 and sfxz_m=0 then '私募_年新增_'||trim(t_yyb.jgbh)
				  
				  when xh=1 and sfxz_m=1 and sfxz_m=1 then '港股_月新增_'||trim(t_yyb.jgbh)
				  when xh=2 and sfxz_m=1 and sfxz_m=1 then 'IB_月新增_'||trim(t_yyb.jgbh)
				  when xh=3 and sfxz_m=1 and sfxz_m=1 then '私募_月新增_'||trim(t_yyb.jgbh)
				  
				  when xh=1 and sfxz_y<>1 then '港股_存量_'||trim(t_yyb.jgbh)
				  when xh=2 and sfxz_y<>1 then 'IB_存量_'||trim(t_yyb.jgbh)
				  when xh=3 and sfxz_y<>1 then '私募_存量_'||trim(t_yyb.jgbh)
				  else null end as khbh_hs
				  
				,case when xh=1 then '港股'  
					  when xh=2 then 'IB'
					  when xh=3 then '私募'
					  else null end as ywlb
				,t_yyb.jgbh as ygh
				,1 as jxbl
				,'虚拟关系' bz
				,t_yyb.jgbh as jgbh
				
				
			from 
			(
				select *,1 as xh,0 as sfxz_y,0 as sfxz_m from dba.yybdz
				union all
				select *,2 as xh,0 as sfxz_y,0 as sfxz_m from dba.yybdz
				union all
				select *,3 as xh,0 as sfxz_y,0 as sfxz_m from dba.yybdz
				union all
				select *,1 as xh,1 as sfxz_y,0 as sfxz_m from dba.yybdz
				union all
				select *,2 as xh,1 as sfxz_y,0 as sfxz_m from dba.yybdz
				union all
				select *,3 as xh,1 as sfxz_y,0 as sfxz_m from dba.yybdz
				union all
				select *,1 as xh,1 as sfxz_y,1 as sfxz_m from dba.yybdz
				union all
				select *,2 as xh,1 as sfxz_y,1 as sfxz_m from dba.yybdz
				union all
				select *,3 as xh,1 as sfxz_y,1 as sfxz_m from dba.yybdz
			)as t_yyb
	
	)as t_gx on t_gx.khbh_hs = t1.khbh_hs      --客户映射
	
	--员工
	left join 
	(
		select *
		from dba.t_yunying2012_param_yg 
		where nian=@nian_gx and yue=@yue_gx
	)as t_yg on t_gx.ygh=t_yg.ygh
	
	--营业部
	left join DBA.T_EDW_T06_ORGANIZATION as t_ygjg_1 on t_ygjg_1.org_cd=t_yg.jgbh   --营业部表
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
	) as t_ygjg_2 on t_ygjg_2.jgbh=t_yg.jgbh
--	left join dba.yybdz as t_ygjg_2 on t_ygjg_2.jgbh=t_yg.jgbh   --营业部表
	
	
	group by t_ygjg_1.org_full_name,t_ygjg_2.jgmc,t_ygjg_2.zxyybmc,t_ygjg_2.fgs,
		--t1.账户性质,
		t1.sfxz_y,t1.sfxz_m,t1.sfdxfkh
		,t1.目标客户标准,t1.是否目标客户
		--,t1.资产段_2012_细
		,t1.资产段_2013_细
);