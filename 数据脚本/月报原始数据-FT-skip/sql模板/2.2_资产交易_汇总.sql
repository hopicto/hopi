
-------------------------------------START-----------------------------------
declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'

--*******************************************************************--
---资产交易
--注意gx表需更新到当前
--注意2011年使用实发数，当前根据预发和实发进度择选
--*******************************************************************--
select
	@nian||@yue as 年月
	,t_ygjg_1.org_full_name as 营业部
	,t_ygjg_2.jgmc as 营业部_简称
	,t_ygjg_2.zxyybmc as 中心营业部
	,t_ygjg_2.fgs as 分公司
	,t1.账户性质 as 账户性质
	,t1.sfxz_y as 是否年新增
	,t1.sfxz_m as 是否月新增
	,t1.sfdxfkh as 是否大小非客户	
	,t1.目标客户标准 as 营业部目标客户门槛
	,t1.是否目标客户 as 是否营业部目标客户
	,t1.资产段_2012_细 as 资产段_201212_细分
	,t1.资产段_2013_细 as 资产段_当前月份_细分
	,sum(case when t_gx.ywlb='1' and t1.khzt='正常' then 1*jxbl else 0 end) as 客户数
	,sum(case when t_gx.ywlb='1' then (t1.sfyxh)*jxbl else 0 end) as 有效户数
	
	----------期末资产(有效)----------
	,期末产品有效市值 + 期末有效二级资产 as  期末有效总资产
	,sum(case when t_gx.ywlb='4' then t1.期末公募基金保有_考核*jxbl 
			  when t_gx.ywlb='5' then t1.期末定向保有_考核*jxbl  
			  when t_gx.ywlb='6' then t1.期末集合理财保有_考核*jxbl 
			  when t_gx.ywlb='私募' then t1.期末公募基金保有_考核*jxbl 
			  else 0 end) as 期末产品有效市值
	,sum(case when t_gx.ywlb in ('1','港股','IB') then t1.期末有效二级资产*jxbl else 0 end) as 期末有效二级资产
	,sum(case when t_gx.ywlb ='1' then t1.期末大小非折算市值*jxbl else 0 end) as 期末大小非折算市值
	,sum(case when t_gx.ywlb ='1' then t1.期末约定购回净资产*jxbl else 0 end) as 期末约定购回资产
	,sum(case when t_gx.ywlb='1' then t1.年日均保证金_计算利差使用*jxbl else 0 end)*1.4658 as 期末保证金_折算市值
	,sum(case when t_gx.ywlb='1' then t1.期末债券市值*jxbl else 0 end)*0.2194 as 期末债券折算市值
	,sum(case when t_gx.ywlb='1' then t1.期末回购市值*jxbl else 0 end)*0.2564 as 期末回购折算市值
	
	----------期末资产(折算方法二)----------
	--,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.期末折算资产_方法二*jxbl else 0 end) as 期末资产（折算方法二） 	
	--注意：折算方法二资产，若先按照账户算出，再按照业务类型1划分；与先按照业务类型划分，再汇总结果不同。
	,sum(case when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.期末股基市值
														+coalesce(t1.期末约定购回净资产,0)
														+t1.期末保证金
														+t1.期末债券市值 + t1.期末回购市值
														+t1.期末其他资产
														)*jxbl else 0 end) --期末股基市值
		--不含大小非期末产品市值
		+ sum(case when t_gx.ywlb='4' and t1.sfdxfkh<>1 then t1.期末公募基金保有*jxbl 
			  when t_gx.ywlb='5' and t1.sfdxfkh<>1 then t1.期末定向保有*jxbl  
			  when t_gx.ywlb='6' and t1.sfdxfkh<>1 then t1.期末集合理财保有*jxbl 
			  when t_gx.ywlb='私募' then t1.期末公募基金保有*jxbl 
			  else 0 end)
		+sum(case when t_gx.ywlb in('IB') then t1.期末资产*jxbl else 0 end)
		+sum(case when t_gx.ywlb in('港股') then t1.期末资产*jxbl else 0 end)
		-期末其中低风险扣减
		+"期末其中大小非资产（单户3000万封顶）"
		
	as 期末资产（折算方法二）
		
	,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.期末低风险_封顶待扣除*jxbl else 0 end) as 期末其中低风险扣减 	 
	,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.期末资产_大小非_封顶*jxbl else 0 end) as "期末其中大小非资产（单户3000万封顶）"

	
	----------期末资产(无折算)----------
	,期末股基市值_不含大小非 + 期末产品市值 + 期末保证金 
			+ 期末债券市值 + 期末回购市值 + 期末IB资产 + 期末港股资产 + 期末其他资产 as 期末资产_不含大小非股基市值
	,sum(case when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.期末股基市值+coalesce(t1.期末约定购回净资产,0))*jxbl else 0 end) as 期末股基市值_不含大小非
	,sum(case when t_gx.ywlb='1' and t1.sfdxfkh=1 then (t1.期末股基市值+coalesce(t1.期末约定购回净资产,0))*jxbl else 0 end) as 期末股基市值_大小非
	,sum(case when t_gx.ywlb='4' then t1.期末公募基金保有*jxbl 
			  when t_gx.ywlb='5' then t1.期末定向保有*jxbl  
			  when t_gx.ywlb='6' then t1.期末集合理财保有*jxbl 
			  when t_gx.ywlb='私募' then t1.期末公募基金保有*jxbl 
			  else 0 end) as 期末产品市值
	,sum(case when t_gx.ywlb='4' then t1.期末核心公募基金保有*jxbl else 0 end) as 期末核心公募市值 	 
	,sum(case when t_gx.ywlb='6' then t1.期末集合理财保有*jxbl else 0 end) as 期末资管产品市值 
	,sum(case when t_gx.ywlb='1' then t1.期末保证金*jxbl else 0 end) as 期末保证金
	,sum(case when t_gx.ywlb='1' then t1.期末债券市值*jxbl else 0 end) as 期末债券市值    
	,sum(case when t_gx.ywlb='1' then t1.期末回购市值*jxbl else 0 end) as 期末回购市值
	,sum(case when t_gx.ywlb in('IB') then t1.期末资产*jxbl else 0 end) as 期末IB资产
	,sum(case when t_gx.ywlb in('港股') then t1.期末资产*jxbl else 0 end)  as 期末港股资产
	,sum(case when t_gx.ywlb='1' then t1.期末其他资产*jxbl else 0 end) 期末其他资产
	
	----------月日均资产(有效)----------
	,月日均产品有效市值 + 月日均有效二级资产 as 月日均有效总资产
	,sum(case when t_gx.ywlb='4' then t1.月日均公募基金保有_考核*jxbl 
			  when t_gx.ywlb='5' then t1.月日均定向保有_考核*jxbl  
			  when t_gx.ywlb='6' then t1.月日均集合理财保有_考核*jxbl 
			  when t_gx.ywlb='私募' then t1.月日均公募基金保有_考核*jxbl 
			  else 0 end) as 月日均产品有效市值
	,sum(case when t_gx.ywlb in ('1','港股','IB') then t1.月日均有效二级资产*jxbl else 0 end) as 月日均有效二级资产
	,sum(case when t_gx.ywlb ='1' then t1.月日均大小非折算市值*jxbl else 0 end) as 月日均大小非折算市值
	,sum(case when t_gx.ywlb ='1' then t1.月日均约定购回净资产*jxbl else 0 end) as 月日均约定购回资产
	,sum(case when t_gx.ywlb='1' then t1.年日均保证金_计算利差使用*jxbl else 0 end)*1.4658 as 月日均保证金_折算市值
	,sum(case when t_gx.ywlb='1' then t1.月日均债券市值*jxbl else 0 end)*0.2194 as 月日均债券折算市值
	,sum(case when t_gx.ywlb='1' then t1.月日均回购市值*jxbl else 0 end)*0.2564 as 月日均回购折算市值

	----------日均资产(折算方法二)----------
	--,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.月日均折算资产_方法二*jxbl else 0 end) as 月日均资产（折算方法二）
	--注意：折算方法二资产，若先按照账户算出，再按照业务类型1划分；与先按照业务类型划分，再汇总结果不同。
	,sum(case when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.月日均股基市值
														+coalesce(t1.月日均约定购回净资产,0)
														+t1.月日均保证金
														+t1.月日均债券市值 + t1.月日均回购市值
														+t1.月日均其他资产
														)*jxbl else 0 end) --期末股基市值
		--不含大小非期末产品市值
		+ sum(case when t_gx.ywlb='4' and t1.sfdxfkh<>1 then t1.月日均公募基金保有*jxbl 
			  when t_gx.ywlb='5' and t1.sfdxfkh<>1 then t1.月日均定向保有*jxbl  
			  when t_gx.ywlb='6' and t1.sfdxfkh<>1 then t1.月日均集合理财保有*jxbl 
			  when t_gx.ywlb='私募' then t1.月日均公募基金保有*jxbl 
			  else 0 end)
		+sum(case when t_gx.ywlb in('IB') then t1.月日均资产*jxbl else 0 end)
		+sum(case when t_gx.ywlb in('港股') then t1.月日均资产*jxbl else 0 end)
		-月日均其中低风险扣减
		+"月日均其中大小非资产（单户3000万封顶）"
		
	as 月日均资产（折算方法二）	
	
	,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.月日均低风险_封顶待扣除*jxbl else 0 end) as 月日均其中低风险扣减 	 
	,sum(case when t_gx.ywlb in ('1','IB','港股','私募') then t1.月日均资产_大小非_封顶*jxbl else 0 end) as "月日均其中大小非资产（单户3000万封顶）"

	
	----------月日均资产(无折算)----------
	,月日均股基市值_不含大小非 + 月日均产品市值 + 月日均保证金 
		+ 月日均债券市值 + 月日均回购市值 + 月日均IB资产 + 月日均港股资产 + 月日均其他资产 as 月日均资产_不含大小非股基市值
	,sum(case when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.月日均股基市值+coalesce(t1.月日均约定购回净资产,0))*jxbl else 0 end) as 月日均股基市值_不含大小非
	,sum(case when t_gx.ywlb='1' and t1.sfdxfkh=1 then (t1.月日均股基市值+coalesce(t1.月日均约定购回净资产,0))*jxbl else 0 end) as 月日均股基市值_大小非
	,sum(case when t_gx.ywlb='4' then t1.月日均公募基金保有*jxbl 
			  when t_gx.ywlb='5' then t1.月日均定向保有*jxbl  
			  when t_gx.ywlb='6' then t1.月日均集合理财保有*jxbl 
			  when t_gx.ywlb='私募' then t1.月日均公募基金保有*jxbl 
			  else 0 end) as 月日均产品市值
	,sum(case when t_gx.ywlb='4' then t1.月日均核心公募基金保有*jxbl else 0 end) as 月日均核心公募市值
	,sum(case when t_gx.ywlb='6' then t1.月日均集合理财保有*jxbl else 0 end) as 月日均资管产品市值	  
	,sum(case when t_gx.ywlb='1' then t1.月日均保证金*jxbl else 0 end) as 月日均保证金
	,sum(case when t_gx.ywlb='1' then t1.月日均债券市值*jxbl else 0 end) as 月日均债券市值
	,sum(case when t_gx.ywlb='1' then t1.月日均回购市值*jxbl else 0 end) as 月日均回购市值
	,sum(case when t_gx.ywlb in('IB') then t1.月日均资产*jxbl else 0 end) as 月日均IB资产
	,sum(case when t_gx.ywlb in('港股') then t1.月日均资产*jxbl else 0 end)  as 月日均港股资产
	,sum(case when t_gx.ywlb='1' then t1.月日均其他资产*jxbl else 0 end) 月日均其他资产
	
	----------月度交易----------
	,sum(case when t_gx.ywlb in ('私募','2') then (t1.gj交易量_月累计_含根网+coalesce(t_rzrq.xy_jyl_m,0))*jxbl else 0 end) as 本月股基交易量_含根网ETF
	,sum(case when t_gx.ywlb in ('私募','2') then (t1.gj交易量_月累计_扣根网+coalesce(t_rzrq.xy_jyl_m,0))*jxbl else 0 end) as 本月股基交易量_扣根网ETF
	,sum(case when t_gx.ywlb in ('私募','2') then (t1.gj净佣金_月累计+coalesce(t_rzrq.xy_jyj_m+t_rzrq.xy_ghf_m/2,0))*jxbl else 0 end) as 本月股基净佣金_含过户费一半
	,sum(case when t_gx.ywlb in ('私募','2') then t1.二级收入_月累计*jxbl else 0 end) as 本月二级创收
	
	----------年度交易----------
	,sum(case when t_gx.ywlb in ('私募','2') then (t1.gj交易量_年累计_含根网+coalesce(t_rzrq.xy_jyl_y,0))*jxbl else 0 end) as 本年股基交易量_含根网ETF
	,sum(case when t_gx.ywlb in ('私募','2') then (t1.gj交易量_年累计_扣根网+coalesce(t_rzrq.xy_jyl_y,0))*jxbl else 0 end) as 本年股基交易量_扣根网ETF
	,sum(case when t_gx.ywlb in ('私募','2') then (t1.gj净佣金_年累计+coalesce(t_rzrq.xy_jyj_y+t_rzrq.xy_ghf_y/2,0))*jxbl else 0 end) as 本年股基净佣金_含过户费一半
	,sum(case when t_gx.ywlb in ('私募','2') then t1.二级收入_年累计*jxbl else 0 end) as 本年二级创收
	
		
	----------债券交易_月度----------	
	,sum(case when t_gx.ywlb='2' then t1.债券交易量_月累计*jxbl else 0 end) as 债券交易量_月累计
	,sum(case when t_gx.ywlb='2' then t1.回购交易量_月累计*jxbl else 0 end) as 回购交易量_月累计
	,sum(case when t_gx.ywlb='2' then t1.债券净佣金_月累计*jxbl else 0 end) as 债券净佣金_月累计
	,sum(case when t_gx.ywlb='2' then t1.回购净佣金_月累计*jxbl else 0 end) as 回购净佣金_月累计

	----------债券交易_年度----------
	,sum(case when t_gx.ywlb='2' then t1.债券交易量_年累计*jxbl else 0 end) as 债券交易量_年累计
	,sum(case when t_gx.ywlb='2' then t1.回购交易量_年累计*jxbl else 0 end) as 回购交易量_年累计
	,sum(case when t_gx.ywlb='2' then t1.债券净佣金_年累计*jxbl else 0 end) as 债券净佣金_年累计
	,sum(case when t_gx.ywlb='2' then t1.回购净佣金_年累计*jxbl else 0 end) as 回购净佣金_年累计

	----------月度收入----------
	,sum(case when t_gx.ywlb in ('私募','2') then t1.佣金收入_月累计*jxbl else 0 end) as  佣金收入_月累计
	,sum(case when t_gx.ywlb='2' then t1.利差收入_月累计*jxbl else 0 end) as  利差收入_月累计
	,sum(case when t_gx.ywlb='9' then t1.融资融券信用交易净收入_月累计*jxbl else 0 end) as  融资融券信用交易佣金收入_月累计
	,sum(case when t_gx.ywlb='9' then t1.融资融券利息收入_月累计*jxbl else 0 end)*(1-0.3760947)*0.35 as  融资融券利息收入_月累计
	,sum(case when t_gx.ywlb='4' then t1.开放式基金手续费_月累计*jxbl else 0 end) as  开放式基金手续费_月累计
	,sum(case when t_gx.ywlb='5' then t1.定向产品手续费_月累计*jxbl else 0 end) as  定向产品手续费_月累计
	,sum(case when t_gx.ywlb='6' then t1.资管产品手续费_月累计*jxbl else 0 end) as  资管产品手续费_月累计
	,sum(case when t_gx.ywlb='4' then t1.公募基金分仓转移_月累计*jxbl else 0 end) as  公募基金分仓转移_月累计
	,佣金收入_月累计+利差收入_月累计+融资融券信用交易佣金收入_月累计+融资融券利息收入_月累计
		+开放式基金手续费_月累计+定向产品手续费_月累计+资管产品手续费_月累计+公募基金分仓转移_月累计 as 月度系统估算收入总计
	
	----------年度收入----------
	,sum(case when t_gx.ywlb in ('私募','2') then t1.佣金收入_年累计*jxbl else 0 end) as  佣金收入_年累计
	,sum(case when t_gx.ywlb='2' then t1.利差收入_年累计*jxbl else 0 end) as  利差收入_年累计
	,sum(case when t_gx.ywlb='9' then t1.融资融券信用交易净收入_年累计*jxbl else 0 end) as  融资融券信用交易佣金收入_年累计
	,sum(case when t_gx.ywlb='9' then t1.融资融券利息收入_年累计*jxbl else 0 end)*(1-0.3760947)*0.35 as  融资融券利息收入_年累计
	,sum(case when t_gx.ywlb='4' then t1.开放式基金手续费_年累计*jxbl else 0 end) as  开放式基金手续费_年累计
	,sum(case when t_gx.ywlb='5' then t1.定向产品手续费_年累计*jxbl else 0 end) as  定向产品手续费_年累计
	,sum(case when t_gx.ywlb='6' then t1.资管产品手续费_年累计*jxbl else 0 end) as  资管产品手续费_年累计
	,sum(case when t_gx.ywlb='4' then t1.公募基金分仓转移_年累计*jxbl else 0 end) as  公募基金分仓转移_年累计
	,佣金收入_年累计+利差收入_年累计+融资融券信用交易佣金收入_年累计+融资融券利息收入_年累计
		+开放式基金手续费_年累计+定向产品手续费_年累计+资管产品手续费_年累计+公募基金分仓转移_年累计  as 年度系统估算收入总计

	
	--增加融资融券
	,sum(case when t_gx.ywlb='9' then t1.融资融券净资产_月日均*jxbl else 0 end) as 融资融券净资产_月日均
	,sum(case when t_gx.ywlb='9' then t1.融资融券净资产_期末*jxbl else 0 end) as 融资融券净资产_期末
	
	,sum(case when t_gx.ywlb='1' then (--t1.期末股基市值
--														coalesce(t1.期末约定购回净资产,0)
														t1.期末保证金
														+t1.期末债券市值 + t1.期末回购市值
														+t1.期末其他资产
														)*jxbl else 0 end) --期末股基市值
		--不含大小非期末产品市值
		+ sum(case when t_gx.ywlb='4' then t1.期末公募基金保有*jxbl 
			  when t_gx.ywlb='5' then t1.期末定向保有*jxbl  
			  when t_gx.ywlb='6' then t1.期末集合理财保有*jxbl 
			  when t_gx.ywlb='私募' then t1.期末公募基金保有*jxbl 
			  else 0 end)
		+sum(case when t_gx.ywlb in('IB') then t1.期末资产*jxbl else 0 end)
		+sum(case when t_gx.ywlb in('港股') then t1.期末资产*jxbl else 0 end)
		-期末其中低风险扣减
	+sum(case when t_gx.ywlb='1' and t1.sfdxfkh=1 then t1.股基市值_期末_大小非三千万封顶_创收*jxbl
			  when t_gx.ywlb='1' and t1.sfdxfkh<>1 then t1.期末股基市值*jxbl
			  else 0 end)	--期末股基市值3000万封顶再根据创收能力取大值
--		+"期末其中大小非资产（单户3000万封顶）"		
	as 期末资产（折算方法三）
	,sum(case when t_gx.ywlb in ('1','IB','港股','私募') and t1.sfdxfkh=1 then t1.股基市值_期末_大小非三千万封顶_创收*jxbl else 0 end) as 股基市值_期末_大小非三千万封顶_创收_方法三
	
	,sum(case when t_gx.ywlb='1' then (	--t1.月日均股基市值										
--														coalesce(t1.月日均约定购回净资产,0)
														t1.月日均保证金
														+t1.月日均债券市值 + t1.月日均回购市值
														+t1.月日均其他资产
														)*jxbl else 0 end) 
		--不含大小非期末产品市值
		+ sum(case when t_gx.ywlb='4' then t1.月日均公募基金保有*jxbl 
			  when t_gx.ywlb='5' then t1.月日均定向保有*jxbl  
			  when t_gx.ywlb='6' then t1.月日均集合理财保有*jxbl 
			  when t_gx.ywlb='私募' then t1.月日均公募基金保有*jxbl 
			  else 0 end)
		+sum(case when t_gx.ywlb in('IB') then t1.月日均资产*jxbl else 0 end)
		+sum(case when t_gx.ywlb in('港股') then t1.月日均资产*jxbl else 0 end)
		-月日均其中低风险扣减	
	+sum(case when t_gx.ywlb='1' and t1.sfdxfkh=1 then t1.股基市值_月日均_大小非三千万封顶_创收*jxbl
			  when t_gx.ywlb='1' and t1.sfdxfkh<>1 then t1.月日均股基市值*jxbl
			  else 0 end)	--月日均股基市值3000万封顶再根据创收能力取大值
--		+"月日均其中大小非资产（单户3000万封顶）"		
	as 月日均资产（折算方法三）
	,sum(case when t_gx.ywlb in ('1','IB','港股','私募') and t1.sfdxfkh=1 then t1.股基市值_月日均_大小非三千万封顶_创收*jxbl else 0 end) as 股基市值_月日均_大小非三千万封顶_创收_方法三

	,sum(case when t_gx.ywlb='1' then (--t1.期末股基市值
--														coalesce(t1.期末约定购回净资产,0)
														t1.期末保证金
														+t1.期末债券市值 + t1.期末回购市值
--														+t1.期末其他资产
														)*jxbl else 0 end) --期末股基市值
		--不含大小非期末产品市值
		+ sum(case when t_gx.ywlb='4' then t1.期末公募基金保有*jxbl 
			  when t_gx.ywlb='5' then t1.期末定向保有*jxbl  
			  when t_gx.ywlb='6' then t1.期末集合理财保有*jxbl 
			  when t_gx.ywlb='私募' then t1.期末公募基金保有*jxbl 
			  else 0 end)
		+sum(case when t_gx.ywlb in('IB') then t1.期末资产*jxbl else 0 end)
		+sum(case when t_gx.ywlb in('港股') then t1.期末资产*jxbl else 0 end)
		-期末其中低风险扣减
	+sum(case when t_gx.ywlb='1' and t1.sfdxfkh=1 then (t1.股基市值加其他资产_期末_大小非三千万封顶_创收+coalesce(t1.期末约定购回净资产,0))*jxbl
			  when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.期末股基市值+t1.期末其他资产+coalesce(t1.期末约定购回净资产,0))*jxbl
			  else 0 end)	--股基市值加其他资产_期末_大小非三千万封顶_创收
	as 期末资产（折算方法四）
	,sum(case when t_gx.ywlb in ('1','IB','港股','私募') and t1.sfdxfkh=1 then (t1.股基市值加其他资产_期末_大小非三千万封顶_创收+coalesce(t1.期末约定购回净资产,0))*jxbl else 0 end) as 股基市值加其他资产_期末_大小非三千万封顶_创收_方法四
	
	
	
	,sum(case when t_gx.ywlb='1' then (	--t1.月日均股基市值										
--														coalesce(t1.月日均约定购回净资产,0)
														t1.月日均保证金
														+t1.月日均债券市值 + t1.月日均回购市值
--														+t1.月日均其他资产
														)*jxbl else 0 end) 
		--不含大小非期末产品市值
		+ sum(case when t_gx.ywlb='4' then t1.月日均公募基金保有*jxbl 
			  when t_gx.ywlb='5' then t1.月日均定向保有*jxbl  
			  when t_gx.ywlb='6' then t1.月日均集合理财保有*jxbl 
			  when t_gx.ywlb='私募' then t1.月日均公募基金保有*jxbl 
			  else 0 end)
		+sum(case when t_gx.ywlb in('IB') then t1.月日均资产*jxbl else 0 end)
		+sum(case when t_gx.ywlb in('港股') then t1.月日均资产*jxbl else 0 end)
		-月日均其中低风险扣减	
	+sum(case when t_gx.ywlb='1' and t1.sfdxfkh=1 then (t1.股基市值加其他资产_月日均_大小非三千万封顶_创收+coalesce(t1.月日均约定购回净资产,0))*jxbl
			  when t_gx.ywlb='1' and t1.sfdxfkh<>1 then (t1.月日均股基市值+t1.月日均其他资产+coalesce(t1.月日均约定购回净资产,0))*jxbl
			  else 0 end)	--月日均股基市值3000万封顶再根据创收能力取大值
	as 月日均资产（折算方法四）
	,sum(case when t_gx.ywlb in ('1','IB','港股','私募') and t1.sfdxfkh=1 then (t1.股基市值加其他资产_月日均_大小非三千万封顶_创收+coalesce(t1.月日均约定购回净资产,0))*jxbl else 0 end) as 股基市值加其他资产_月日均_大小非三千万封顶_创收_方法四	
from 

/*------------------①_客户指标----------------*/
(
	select 
		t1.*
		,t2.dxfzssz_qm as 期末大小非折算市值
		,t2.dxfzssz_yrj as 月日均大小非折算市值

		--融资融券净资产		
		,t2.rzrq_jzc_yrj as 融资融券净资产_月日均
		,t2.rzrq_qmjzc as 融资融券净资产_期末
		
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

----员工
--left join 
--(
--	select *
--	from dba.t_yunying2012_param_yg 
--	where nian=@nian_gx and yue=@yue_gx
--)as t_yg on t_gx.ygh=t_yg.ygh
--
----营业部
--left join DBA.T_EDW_T06_ORGANIZATION as t_ygjg_1 on t_ygjg_1.org_cd=t_yg.jgbh   --营业部表
--left join dba.yybdz as t_ygjg_2 on t_ygjg_2.jgbh=t_yg.jgbh   --营业部表

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
		t1.org_cd,
		t1.org_full_name
	from DBA.T_EDW_T06_ORGANIZATION t1
	union
	select
		'#CFZX' as org_cd,
		'财富中心' as org_full_name
	from #temp_cfzx
) as t_ygjg_1 on t_ygjg_1.org_cd=t_yg.jgbh
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

group by t_ygjg_1.org_full_name,t_ygjg_2.jgmc,t_ygjg_2.zxyybmc,t_ygjg_2.fgs,t1.账户性质,t1.sfxz_y,t1.sfxz_m,t1.sfdxfkh
	,t1.目标客户标准,t1.是否目标客户,t1.资产段_2012_细,t1.资产段_2013_细
order by t_ygjg_1.org_full_name,t_ygjg_2.jgmc,t_ygjg_2.zxyybmc,t_ygjg_2.fgs,t1.账户性质,t1.sfxz_y,t1.sfxz_m,t1.sfdxfkh
	,t1.目标客户标准,t1.是否目标客户,t1.资产段_2012_细,t1.资产段_2013_细
;

output to "C:\ado_data\月报数据\201303_2_资产交易.xls" format excel

---------------------------------------------END------------------------------------------------
