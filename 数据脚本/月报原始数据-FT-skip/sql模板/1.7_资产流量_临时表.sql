drop table #temp_zcld;
/*------------------------①_客户临时表-----------------------*/
create table #temp_zcld
(
	ny int,  --年月
	zjzh varchar(128),	--资金账号
	khbh_hs varchar(128),	--客户编号
	资产段 varchar(128),	--资产段
	月日均资产 numeric(38,10), 
	
	年初是否状态正常 int,
	年初是否有效户 int,
	月初是否状态正常 int,
	月初是否有效户 int,
	当前是否状态正常 int,
	当前是否有效户 int,
	
	是否本年增加客户 int,
	是否本月增加客户 int,
	是否本年流失客户 int,
	是否本月流失客户 int,
	
	是否本年增加有效户 int,
	是否本月增加有效户 int,
	是否本年流失有效户 int,
	是否本月流失有效户 int,
	
	本月市值流入 numeric(38,10), 
	本月资金流入 numeric(38,10), 
	本年市值流入 numeric(38,10), 
	本年资金流入 numeric(38,10), 
	
	本月市值流出 numeric(38,10), 
	本月资金流出 numeric(38,10), 
	本年市值流出 numeric(38,10), 
	本年资金流出 numeric(38,10), 
);

/*-----------------②_导入客户数据-------------------*/

declare @nian varchar(16),@yue varchar(16)
set @nian='2013'
set @yue='03'

insert into #temp_zcld(ny,zjzh,khbh_hs,资产段,月日均资产,
	年初是否状态正常,年初是否有效户,月初是否状态正常,月初是否有效户,当前是否状态正常,当前是否有效户,
	是否本年增加客户,是否本月增加客户,是否本年流失客户,
	是否本月流失客户,是否本年增加有效户,是否本月增加有效户,是否本年流失有效户,是否本月流失有效户,	
	本月市值流入,本月资金流入,本年市值流入,本年资金流入,
	本月市值流出,本月资金流出,本年市值流出,本年资金流出)
(

	select
		convert(int,@nian||@yue) as ny
		,t1.zjzh 
		,t1.khbh_hs 
		,t_khsx.资产段_2013_粗 as 资产段
		,t_khsx.月日均资产 as 月日均资产
		
		-------------时点状态-------------
		,case when t_last_nian.khzt='正常' then 1 else 0 end as 年初是否状态正常
		,case when t_last_nian.sfyxh=1 then 1 else 0 end as 年初是否有效户
		,case when t_last_yue.khzt='正常' then 1 else 0 end as 月初是否状态正常
		,case when t_last_yue.sfyxh=1 then 1 else 0 end as 月初是否有效户
		,case when t1.khzt='正常' then 1 else 0 end as 当前是否状态正常
		,case when t1.sfyxh=1 then 1 else 0 end as 当前是否有效户
		
		-------------新增、流失客户-------------
		,case when t1.khzt='正常' and (t_last_nian.khzt<>'正常' or t_last_nian.khzt is null) then 1 else 0 end as 是否本年增加客户
		,case when t1.khzt='正常' and (t_last_yue.khzt<>'正常' or t_last_yue.khzt is null) then 1 else 0 end as 是否本月增加客户
		,case when t1.khzt<>'正常' and t_last_nian.khzt='正常' then 1 else 0 end as 是否本年流失客户
		,case when t1.khzt<>'正常' and t_last_yue.khzt='正常' then 1 else 0 end as 是否本月流失客户
		
		-------------新增、流失有效户-------------
		,case when t1.sfyxh=1 and (t_last_nian.sfyxh<>1 or t_last_nian.sfyxh is null) then 1 else 0 end as 是否本年增加有效户
		,case when t1.sfyxh=1 and (t_last_yue.sfyxh<>1 or t_last_yue.sfyxh is null) then 1 else 0 end as 是否本月增加有效户
		,case when t1.sfyxh<>1 and t_last_nian.sfyxh=1 then 1 else 0 end as 是否本年流失有效户
		,case when t1.sfyxh<>1 and t_last_yue.sfyxh=1 then 1 else 0 end as 是否本月流失有效户
		
		-------------资产流动-------------
		,本月市值流入
		,本月资金流入
		,本年市值流入
		,本年资金流入
		,本月市值流出
		,本月资金流出
		,本年市值流出
		,本年资金流出
		
	from dba.t_ddw_yunying2012_kh as t1 
	left join DBA.客户综合分析_月 as t_yue_1 on t1.zjzh=t_yue_1.资金账户 and t1.nian=t_yue_1.年份 and t1.yue=t_yue_1.月份
	left join dba.T_DDW_XYZQ_F00_KHZHFX_2011 as t_yue_2 on t_yue_1.资金账户=t_yue_2.zjzh and t_yue_2.nian=t1.nian and t_yue_2.yue = t1.yue
	
	left join dba.t_ddw_d_rq_m as t_rq on convert(int,t1.nian)=t_rq.nian and convert(int,t1.yue)=t_rq.yue
	left join dba.t_ddw_yunying2012_kh as t_last_yue on t1.zjzh=t_last_yue.zjzh and convert(int,t_last_yue.nian||t_last_yue.yue)=t_rq.ny_last
	left join dba.t_ddw_yunying2012_kh as t_last_nian on t1.zjzh=t_last_nian.zjzh and convert(int,t_last_nian.nian)=convert(int,@nian)-1 and t_last_nian.yue='12'
	left join #temp_khsx as t_khsx on t1.zjzh=t_khsx.zjzh and t1.nian=t_khsx.nian and t1.yue=t_khsx.yue 
	
	----------------客户资产流动--------------
	left join
	(
		select
			资金账号 as zjzh
			,sum(case when t_ld.统计日期 >= t_rq.date_start_yue then 每日市值流入 else 0 end) as 本月市值流入
			,sum(case when t_ld.统计日期 >= t_rq.date_start_yue then 每日资金流入 else 0 end) as 本月资金流入
			,sum(case when t_ld.统计日期 >= t_rq.date_start_nian then 每日市值流入 else 0 end) as 本年市值流入
			,sum(case when t_ld.统计日期 >= t_rq.date_start_nian then 每日资金流入 else 0 end) as 本年资金流入
			
			,sum(case when t_ld.统计日期 >= t_rq.date_start_yue then 每日市值流出 else 0 end) as 本月市值流出
			,sum(case when t_ld.统计日期 >= t_rq.date_start_yue then 每日资金流出 else 0 end) as 本月资金流出
			,sum(case when t_ld.统计日期 >= t_rq.date_start_nian then 每日市值流出 else 0 end) as 本年市值流出
			,sum(case when t_ld.统计日期 >= t_rq.date_start_nian then 每日资金流出 else 0 end) as 本年资金流出

		from 
		(
			select
				t_yue.年份,t_yue.月份
				,min( t_yue.日期) as date_start_yue
				,min( t_nian.日期) as date_start_nian
				,max( t_nian.日期) as date_end
			from DBA.v_skb_d_rq as t_nian
			left join DBA.v_skb_d_rq as t_yue on t_nian.年份=t_yue.年份 and t_yue.月份=@yue and t_yue.是否工作日='1'
			where t_nian.年份=@nian and t_nian.月份<=@yue and t_nian.是否工作日='1'
			group by t_yue.年份,t_yue.月份
		)as t_rq
		left join dba.v_skb_F00_KHMRZJZHHZ_D as t_ld on t_ld.统计日期 between t_rq.date_start_nian and t_rq.date_end
		group by 资金账号
	) as t_zcld on t1.zjzh=t_zcld.zjzh

	where t1.nian=@nian and t1.yue=@yue
);