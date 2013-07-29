
/*------------------①_增加私募、IB虚拟客户------------------*/
declare @nian varchar(16),@yue varchar(16)
set @nian='2013'
set @yue='03'

insert into #temp_khsx (分公司,中心营业部,营业部,zjzh,khbh_hs,nian,yue,sfxz_y,sfxz_m,sfyxh,sfdxfkh,khzt,账户性质
						,资产段_2012_细,资产段_2013_细,资产段_2012_粗,资产段_2013_粗,目标客户标准,是否目标客户,sfcpxkh
						,月日均有效二级资产
						,月日均公募基金保有_考核,月日均定向保有_考核,月日均集合理财保有_考核,产品月日均有效市值 --月日均产品_考核
						,月日均有效总资产,月日均资产,月日均资产_大小非,月日均资产_不含大小非,月日均保证金
						,月日均股基市值,月日均债券市值,月日均回购市值
						,月日均公募基金保有,月日均定向保有,月日均集合理财保有,月日均产品保有								--月日均产品_原始
						,月日均约定购回净资产,月日均其他资产,月日均标准资产
						-------折算资产_方法二------
						,月日均货币型基金,月日均无手续费债券型基金,月日均低风险_原始,月日均低风险_封顶待扣除,月日均资产_大小非_三千万封顶,月日均资产_大小非_封顶,月日均折算资产_方法二 		
						
						,期末有效二级资产,期末公募基金保有_考核,期末定向保有_考核,期末集合理财保有_考核,产品期末有效市值		   	--期末产品_考核
						,期末有效总资产,期末资产,期末资产_大小非,期末资产_不含大小非,期末保证金
						,期末股基市值,期末债券市值,期末回购市值
						,期末公募基金保有,期末定向保有,期末集合理财保有,期末产品保有											--期末产品_原始
						,期末约定购回净资产,期末其他资产,期末标准资产
						-------折算资产_方法二------
						,期末货币型基金,期末无手续费债券型基金,期末低风险_原始,期末低风险_封顶待扣除,期末资产_大小非_三千万封顶,期末资产_大小非_封顶,期末折算资产_方法二		
						
						,年日均保证金_计算利差使用
						-------收入_月累计------
						,佣金收入_月累计,利差收入_月累计,二级收入_月累计,融资融券信用交易净收入_月累计,融资融券利息收入_月累计
						,开放式基金手续费_月累计,定向产品手续费_月累计,资管产品手续费_月累计,公募基金分仓转移_月累计
						-------收入_年累计------
						,佣金收入_年累计,利差收入_年累计,二级收入_年累计,融资融券信用交易净收入_年累计,融资融券利息收入_年累计
						,开放式基金手续费_年累计,定向产品手续费_年累计,资管产品手续费_年累计,公募基金分仓转移_年累计
						-------产品销售_月累计------
						,开放式基金销售金额_月累计,开放式基金销售金额_其中核心基金_月累计,资管产品销售金额_月累计,定向产品销售金额_月累计
						-------产品销售_年累计------
						,开放式基金销售金额_年累计,开放式基金销售金额_其中核心基金_年累计,资管产品销售金额_年累计,定向产品销售金额_年累计
						-------产品保有------
						,开放式基金场外保有市值_月日均,开放式基金场外保有市值_核心基金_月日均,资管产品场外保有市值_月日均,定向产品场外保有市值_月日均
						
						,gj交易量_月累计_含根网,gj交易量_月累计_扣根网,gj净佣金_月累计
						,gj交易量_年累计_含根网,gj交易量_年累计_扣根网,gj净佣金_年累计
						
						-------债券交易------
						,债券交易量_月累计,回购交易量_月累计,债券净佣金_月累计,回购净佣金_月累计
						,债券交易量_年累计,回购交易量_年累计,债券净佣金_年累计,回购净佣金_年累计)
(
	select
		t_yyb.fgs
		,t_yyb.zxyybmc
		,t_yyb.jgmc
		-------------注意zjzh,khbh_hs均为唯一编码------------
		,case when xh=1 and sfxz_y=1 and sfxz_m=0 then '港股_年新增_'||trim(t_yyb.jgbh)
			  when xh=2 and sfxz_y=1 and sfxz_m=0 then 'IB_年新增_'||trim(t_yyb.jgbh)
			  when xh=3 and sfxz_y=1 and sfxz_m=0 then '私募_年新增_'||trim(t_yyb.jgbh)
			  
			  when xh=1 and sfxz_m=1 and sfxz_m=1 then '港股_月新增_'||trim(t_yyb.jgbh)
			  when xh=2 and sfxz_m=1 and sfxz_m=1 then 'IB_月新增_'||trim(t_yyb.jgbh)
			  when xh=3 and sfxz_m=1 and sfxz_m=1 then '私募_月新增_'||trim(t_yyb.jgbh)
			  
			  when xh=1 and sfxz_y<>1 then '港股_存量_'||trim(t_yyb.jgbh)
			  when xh=2 and sfxz_y<>1 then 'IB_存量_'||trim(t_yyb.jgbh)
			  when xh=3 and sfxz_y<>1 then '私募_存量_'||trim(t_yyb.jgbh)
			  else null end as zjzh
			  
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
			  
		,@nian as nian
		,@yue as yue
		,sfxz_y
		,sfxz_m
		,0 as sfyxh
		,0 as sfdxfkh
		,'体外' as khzt
		,case when xh=1 then '港股' 
			  when xh=2 then 'IB' 
			  when xh=3 then '私募' 
			  else null end as 账户性质
			  
		,case when xh=1 then '港股' 
			  when xh=2 then 'IB' 
			  when xh=3 then '私募' 
			  else null end as 资产段_2012_细
		,case when xh=1 then '港股' 
			  when xh=2 then 'IB' 
			  when xh=3 then '私募' 
			  else null end as 资产段_2013_细
		,'3->100w' as 资产段_2012_粗
		,'3->100w' as 资产段_2013_粗
		,100 as 目标客户标准
		,1 as 是否目标客户
		,0 as sfcpxkh
		,0 as	月日均有效二级资产, 0 as 月日均公募基金保有_考核, 0 as 月日均定向保有_考核, 0 as 月日均集合理财保有_考核
		, 0 as 产品月日均有效市值, 0 as 月日均有效总资产, 0 as 月日均资产, 0 as 月日均资产_大小非, 0 as 月日均资产_不含大小非
		, 0 as 月日均保证金, 0 as 月日均股基市值, 0 as 月日均债券市值, 0 as 月日均回购市值, 0 as 月日均公募基金保有
		, 0 as 月日均定向保有, 0 as 月日均集合理财保有, 0 as 月日均产品保有, 0 as 月日均约定购回净资产, 0 as 月日均其他资产
		, 0 as 月日均标准资产, 0 as 月日均货币型基金, 0 as 月日均无手续费债券型基金, 0 as 月日均低风险_原始, 0 as 月日均低风险_封顶待扣除
		, 0 as 月日均资产_大小非_三千万封顶, 0 as 月日均资产_大小非_封顶, 0 as 月日均折算资产_方法二 		
		, 0 as 期末有效二级资产, 0 as 期末公募基金保有_考核, 0 as 期末定向保有_考核
		, 0 as 期末集合理财保有_考核, 0 as 产品期末有效市值, 0 as 期末有效总资产, 0 as 期末资产, 0 as 期末资产_大小非
		, 0 as 期末资产_不含大小非, 0 as 期末保证金, 0 as 期末股基市值, 0 as 期末债券市值, 0 as 期末回购市值
		, 0 as 期末公募基金保有, 0 as 期末定向保有, 0 as 期末集合理财保有, 0 as 期末产品保有, 0 as 期末约定购回净资产
		, 0 as 期末其他资产, 0 as 期末标准资产
		, 0 as 期末货币型基金, 0 as 期末无手续费债券型基金, 0 as 期末低风险_原始, 0 as 期末低风险_封顶待扣除, 0 as 期末资产_大小非_三千万封顶
		, 0 as 期末资产_大小非_封顶, 0 as 期末折算资产_方法二		
		, 0 as 年日均保证金_计算利差使用, 0 as 佣金收入_月累计, 0 as 利差收入_月累计
		, 0 as 二级收入_月累计, 0 as 融资融券信用交易净收入_月累计, 0 as 融资融券利息收入_月累计, 0 as 开放式基金手续费_月累计
		, 0 as 定向产品手续费_月累计, 0 as 资管产品手续费_月累计, 0 as 公募基金分仓转移_月累计, 0 as 佣金收入_年累计
		, 0 as 利差收入_年累计, 0 as 二级收入_年累计, 0 as 融资融券信用交易净收入_年累计, 0 as 融资融券利息收入_年累计
		, 0 as 开放式基金手续费_年累计, 0 as 定向产品手续费_年累计, 0 as 资管产品手续费_年累计, 0 as 公募基金分仓转移_年累计
		, 0 as 开放式基金销售金额_月累计, 0 as 开放式基金销售金额_其中核心基金_月累计, 0 as 资管产品销售金额_月累计
		, 0 as 定向产品销售金额_月累计, 0 as 开放式基金销售金额_年累计, 0 as 开放式基金销售金额_其中核心基金_年累计
		, 0 as 资管产品销售金额_年累计, 0 as 定向产品销售金额_年累计, 0 as 开放式基金场外保有市值_月日均
		, 0 as 开放式基金场外保有市值_核心基金_月日均, 0 as 资管产品场外保有市值_月日均, 0 as 定向产品场外保有市值_月日均
		, 0 as gj交易量_月累计_含根网, 0 as gj交易量_月累计_扣根网, 0 as gj净佣金_月累计, 0 as gj交易量_年累计_含根网
		, 0 as gj交易量_年累计_扣根网, 0 as gj净佣金_年累计
		,0 as 债券交易量_月累计,0 as 回购交易量_月累计,0 as 债券净佣金_月累计,0 as 回购净佣金_月累计
		,0 as 债券交易量_年累计,0 as 回购交易量_年累计,0 as 债券净佣金_年累计,0 as 回购净佣金_年累计

		
	from 
	--虚拟客户，拆分出9条记录，sfxz_m是否月新增，sfxz_y是否年新增；xh-1:港股,xh-2:IB,xh-3:私募
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
	
);

/*------------------②_更新港股指标------------------*/
/*
港股、期货IB资产包含在有效二级资产中，在原始资产中单列于股基市值
*/
declare @nian varchar(16),@yue varchar(16)
set @nian='2013'
set @yue='03'

update #temp_khsx as t1
	set t1.期末有效二级资产 = t_gg.期末港股资产,
		 t1.期末资产 = t_gg.期末港股资产,
		 t1.期末资产_不含大小非 = t_gg.期末港股资产,
		 t1.期末折算资产_方法二 = t_gg.期末港股资产,
		 t1.期末股基市值 = 0,
		 
		 t1.月日均有效二级资产 = t_gg.港股资产月日均,
		 t1.月日均资产 = t_gg.港股资产月日均,
		 t1.月日均资产_不含大小非 = t_gg.港股资产月日均,
		 t1.月日均折算资产_方法二 = t_gg.港股资产月日均,
		 t1.月日均股基市值 = 0

from
(
	select 
		*
	from 
	--------港股存量---------
	(
		select 
			jgbh,nian,yue
			,0 as sfxz_m
			,0 as sfxz_y
			,'港股_存量_'||trim(jgbh)  as khbh_hs
			,sum(ggqmzc-coalesce(nxzkh_ggqmzc,0)) as 期末港股资产
			,sum(ggzc_yrj-coalesce(nxzkh_ggzc_yrj,0)) as 港股资产月日均
		from dba.t_ddw_yunying2012_yg as t1
		where 
			((nian='2011' and yue=@yue and jxlx='实发')
			or (nian='2012' and yue=@yue and jxlx='实发')
			or (nian='2013' and yue=@yue and jxlx='预发'))
			and nian=@nian and yue=@yue
		group by jgbh,nian,yue
	) as t_ggcl  
	
	--------港股年新增---------
	union all
	
		select 
			jgbh,nian,yue
			,0 as sfxz_m
			,1 as sfxz_y
			,'港股_年新增_'||trim(jgbh)  as khbh_hs
			,sum(coalesce(nxzkh_ggqmzc,0)-coalesce(yxzkh_ggqmzc,0)) as 期末港股资产
			,sum(coalesce(nxzkh_ggzc_yrj,0)-coalesce(yxzkh_ggzc_yrj,0)) as 港股资产月日均
		from dba.t_ddw_yunying2012_yg as t1
		where 
			((nian='2011' and yue=@yue and jxlx='实发')
			or (nian='2012' and yue=@yue and jxlx='实发')
			or (nian='2013' and yue=@yue and jxlx='预发'))
			and nian=@nian and yue=@yue
		group by jgbh,nian,yue
		
	
	--------港股月新增---------
	union all
	
		select 
			jgbh,nian,yue
			,1 as sfxz_m
			,1 as sfxz_y
			,'港股_月新增_'||trim(jgbh)  as khbh_hs
			,sum(coalesce(yxzkh_ggqmzc,0)) as 期末港股资产
			,sum(coalesce(yxzkh_ggzc_yrj,0)) as 港股资产月日均
		from dba.t_ddw_yunying2012_yg as t1
		where 
			((nian='2011' and yue=@yue and jxlx='实发')
			or (nian='2012' and yue=@yue and jxlx='实发')
			or (nian='2013' and yue=@yue and jxlx='预发'))
			and nian=@nian and yue=@yue
		group by jgbh,nian,yue
		
)as t_gg 
where t_gg.khbh_hs = t1.khbh_hs;



/*------------------③_更新期货IB指标------------------*/
/*
港股、期货IB资产包含在有效二级资产中，在原始资产中单列于股基市值
*/
declare @nian varchar(16),@yue varchar(16)
set @nian='2013'
set @yue='03'

update #temp_khsx as t1
	set t1.期末有效二级资产 = t_IB.IB业务期末资产,
		 t1.期末资产 = t_IB.IB业务期末资产,
		 t1.期末资产_不含大小非 = t_IB.IB业务期末资产,
		 t1.期末股基市值 = 0,
		 t1.期末折算资产_方法二 = t_IB.IB业务期末资产,
		 
		 t1.月日均有效二级资产 = t_IB.IB业务日均资产,
		 t1.月日均资产 = t_IB.IB业务日均资产,
		 t1.月日均资产_不含大小非 = t_IB.IB业务日均资产,
		 t1.月日均股基市值 = 0,
		 t1.月日均折算资产_方法二 = t_IB.IB业务日均资产
from
(
	select 
		*
	from 
	--------港股存量---------
	(
		select 
			jgbh,nian,yue
			,0 as sfxz_y
			,0 as sfxz_m
			,'IB_存量_'||trim(jgbh)  as khbh_hs
			,sum(ibywqmzc-coalesce(nxzkh_ibywqmzc,0)) as IB业务期末资产  
			,sum(ibywrjzc-coalesce(nxzkh_ibywrjzc,0)) as IB业务日均资产
		from dba.t_ddw_yunying2012_yg as t1
		where 
			((nian='2011' and yue=@yue and jxlx='实发')
			or (nian='2012' and yue=@yue and jxlx='实发')
			or (nian='2013' and yue=@yue and jxlx='预发'))
			and nian=@nian and yue=@yue
		group by jgbh,nian,yue
	) as t_ggcl  
	
	--------港股年新增---------
	union all
	
		select 
			jgbh,nian,yue
			,1 as sfxz_y
			,0 as sfxz_m
			,'IB_年新增_'||trim(jgbh)  as khbh_hs
			,sum(coalesce(nxzkh_ibywqmzc,0)-coalesce(yxzkh_ibywqmzc,0)) as IB业务期末资产
			,sum(coalesce(nxzkh_ibywrjzc,0)-coalesce(yxzkh_ibywrjzc,0)) as IB业务日均资产
		from dba.t_ddw_yunying2012_yg as t1
		where 
			((nian='2011' and yue=@yue and jxlx='实发')
			or (nian='2012' and yue=@yue and jxlx='实发')
			or (nian='2013' and yue=@yue and jxlx='预发'))
			and nian=@nian and yue=@yue
		group by jgbh,nian,yue
		
	--------港股月新增---------
	union all
	
		select 
			jgbh,nian,yue
			,1 as sfxz_y
			,1 as sfxz_m
			,'IB_月新增_'||trim(jgbh)  as khbh_hs
			,sum(coalesce(yxzkh_ibywqmzc,0)) as IB业务期末资产
			,sum(coalesce(yxzkh_ibywrjzc,0)) as IB业务日均资产
		from dba.t_ddw_yunying2012_yg as t1
		where 
			((nian='2011' and yue=@yue and jxlx='实发')
			or (nian='2012' and yue=@yue and jxlx='实发')
			or (nian='2013' and yue=@yue and jxlx='预发'))
			and nian=@nian and yue=@yue
		group by jgbh,nian,yue
		
)as t_IB 
where t_IB.khbh_hs = t1.khbh_hs;




/*------------------④_更新加私募客户指标------------------*/
declare @nian varchar(16),@yue varchar(16)
set @nian='2013'
set @yue='03'

update #temp_khsx as t1
set t1.产品期末有效市值 = t_sm.期末体外产品保有_考核
 	,t1.期末公募基金保有_考核  = t_sm.期末体外产品保有_考核
	,t1.期末公募基金保有  = t_sm.期末体外产品保有
	,t1.产品月日均有效市值 = t_sm.月日均体外产品保有_考核
	,t1.月日均公募基金保有_考核  = t_sm.月日均体外产品保有_考核
	,t1.月日均公募基金保有  = t_sm.月日均体外产品保有
	
	,t1.gj交易量_月累计_含根网  = t_sm.gj交易量_月累计_含根网
	,t1.gj交易量_月累计_扣根网 = t_sm.gj交易量_月累计_扣根网
	,t1.gj净佣金_月累计 = t_sm.gj净佣金_月累计
	,t1.佣金收入_月累计 = t_sm.gj净佣金_月累计
	,t1.二级收入_月累计 = t_sm.gj净佣金_月累计
	
	,t1.gj交易量_年累计_含根网 = t_sm.gj交易量_年累计_含根网
	,t1.gj交易量_年累计_扣根网 = t_sm.gj交易量_年累计_扣根网
	,t1.gj净佣金_年累计 = t_sm.gj净佣金_年累计
	,t1.佣金收入_年累计 = t_sm.gj净佣金_年累计
	,t1.二级收入_年累计 = t_sm.gj净佣金_年累计
	
	,t1.期末折算资产_方法二 = t_sm.期末体外产品保有
	,t1.月日均折算资产_方法二 =  t_sm.月日均体外产品保有

from 
(
	select
		khbh_hs
		,sum(期末体外产品保有_考核_) as 期末体外产品保有_考核
		,sum(月日均体外产品保有_考核_) as 月日均体外产品保有_考核
		,sum(期末体外产品保有_) as 期末体外产品保有
		,sum(月日均体外产品保有_) as 月日均体外产品保有
		,sum(gj交易量_月累计_扣根网_) as gj交易量_月累计_扣根网
		,sum(gj交易量_月累计_含根网_) as gj交易量_月累计_含根网
		,sum(gj净佣金_月累计_) as gj净佣金_月累计
		,sum(二级收入_月累计_) as 二级收入_月累计
		,sum(gj交易量_年累计_扣根网_) as gj交易量_年累计_扣根网
		,sum(gj交易量_年累计_含根网_) as gj交易量_年累计_含根网
		,sum(gj净佣金_年累计_) as gj净佣金_年累计
		,sum(二级收入_年累计_) as 二级收入_年累计
	from
	(
		select 
			a.jgbh
			,a.nian
			,a.yue
			,case when b.sfxz_y is null or b.sfxz_y <> 1 then '私募_存量_'||trim(a.jgbh) 
				  when b.sfxz_y is not null and b.sfxz_y = 1 and b.sfxz_m = 0  then '私募_年新增_'||trim(a.jgbh) 
				  when b.sfxz_y is not null and b.sfxz_y = 1 and b.sfxz_m = 1  then '私募_月新增_'||trim(a.jgbh) 
				  else null end as khbh_hs	
			,sum(case when cplx in ('固定收益','债券类私募信托') then qmbyje*0.5 else qmbyje end) as 期末体外产品保有_考核_
			,sum(case when cplx in ('固定收益','债券类私募信托') then byje_yrj*0.5 else byje_yrj end) as 月日均体外产品保有_考核_
			,sum(qmbyje) as 期末体外产品保有_
			,sum(byje_yrj) as 月日均体外产品保有_
			,sum(case when b.zjzh is not null then b.gj交易量_月累计_扣根网 * bybl else 0 end) as gj交易量_月累计_扣根网_
			,sum(case when b.zjzh is not null then b.gj交易量_月累计_含根网 * bybl else 0 end) as gj交易量_月累计_含根网_
			,sum(case when b.zjzh is not null then b.gj净佣金_月累计 * bybl else 0 end) as gj净佣金_月累计_
			,sum(case when b.zjzh is not null then b.二级收入_月累计 * bybl else 0 end) as 二级收入_月累计_
			,sum(case when b.zjzh is not null then b.gj交易量_年累计_扣根网 * bybl else 0 end) as gj交易量_年累计_扣根网_
			,sum(case when b.zjzh is not null then b.gj交易量_年累计_含根网 * bybl else 0 end) as gj交易量_年累计_含根网_
			,sum(case when b.zjzh is not null then b.gj净佣金_年累计 * bybl else 0 end) as gj净佣金_年累计_
			,sum(case when b.zjzh is not null then b.二级收入_年累计 * bybl else 0 end) as 二级收入_年累计_
			
		from dba.tmp_ddw_twcp_m as a
		left join #temp_khsx as b on a.zjzh=b.zjzh 
		where ny=convert(int,@nian||@yue) --and a.zjzh is not null  20130313bug修改，删除条件
		group by a.jgbh,a.nian,a.yue,b.sfxz_y,b.sfxz_m 
	)as t
	group by khbh_hs

)t_sm 
where t_sm.khbh_hs = t1.khbh_hs
;