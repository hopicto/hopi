

/*------------------大宗交易量-----------------*/
declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'

select 
	@nian||@yue as 年月
	,t_jg.jgbh as 机构编号
	,t_jg.jgmc as 机构名称
	
	,t_jg.zxyybbh as 中心营业部编号
	,t_jg.zxyybmc as 中心营业部名称

	,count(distinct case when t_rq.月份=@yue then fund_acct else null end) as 本月参与大宗交易客户数
	,sum(case when t_rq.月份=@yue then trad_amt else 0 end) as 本月大宗交易量
	,sum(case when t_rq.月份=@yue then fact_comm else 0 end) as 本月大宗净佣金
	
	,count(distinct fund_acct) as 本年参与大宗交易客户数
	,sum(trad_amt) as 本年大宗交易量
	,sum(fact_comm) as 本年大宗净佣金
	
from  DBA.VIEW_SKB_T_EDW_T05_TRADE_JOUR a
left join dba.v_skb_d_rq as t_rq on a.occur_dt=t_rq.日期
left join dba.yybdz as t_jg on t_jg.jgbh=a.org_cd
where 
	((a.market_type_cd = '01' and a.order_way_cd = '53') 
	or (a.market_type_cd = '02' and a.note like '%大宗%')) 
	and a.busi_cd in ('3101', '3102')
	and t_rq.年份=@nian

group by t_rq.年份,t_jg.jgmc,t_jg.jgbh,t_jg.zxyybbh,t_jg.zxyybmc
order by t_rq.年份,t_jg.jgmc,t_jg.jgbh,t_jg.zxyybbh,t_jg.zxyybmc

;

output to "C:\ado_data\月报数据\201303_5_大宗交易.xls" format excel