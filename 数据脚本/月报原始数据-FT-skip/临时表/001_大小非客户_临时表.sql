--大小非客户
drop table #temp_dxf;
create table #temp_dxf
(
	zjzh varchar(128) not null
	,constraint pk_skb_temp_dxf primary key (zjzh)
);
declare 
	--变量设置区域
	@nian varchar(4),		--本月_年份
	@yue varchar(2),		--本月_月份
	@nian_sx varchar(4),	--属性_年份
	@yue_sx varchar(2),		--属性_月份
	@nian_gx varchar(4),	--关系_年份
	@yue_gx varchar(2),		--关系_月份		
	
	--年月		
	@sy_nian varchar(4),	--上月_年份
	@sy_yue varchar(2),		--上月_月份	
	@snm_nian varchar(4),	--上年末_年份
	@snm_yue varchar(2),	--上年末_月份	
	@sntq_nian varchar(4),	--上年同期_年份
	@sntq_yue varchar(2),	--上年同期_月份
	
	--交易日
	@td_nc int,				--年初
	@td_nm int,				--年末
	@td_yc int,				--月初
	@td_ym int,				--月末
	@td_syc int,			--上月初
	@td_sym int,			--上月末
	@td_snc int,			--上年初
	@td_snm int,			--上年末
	--天数		
	@ts_m int,				--当前月自然日
	@ts_y int				--当前年自然日
set @nian='2013'
set @yue='06'
set @nian_sx='2013'
set @yue_sx='06'
set @nian_gx='2013'
set @yue_gx='06'

set @td_nc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@nian||'0101'))
set @td_nm=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@nian||'1231'))
set @td_yc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@nian||@yue||'01'))
set @td_ym=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@nian||@yue||'31'))
set @td_sym=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<@td_yc)
set @sy_nian=substring(convert(varchar,@td_sym),1,4)
set @sy_yue=substring(convert(varchar,@td_sym),5,7)
set @snm_nian=convert(varchar,convert(int,@nian)-1)
set @snm_yue='12'
set @sntq_nian=convert(varchar,convert(int,@nian)-1)
set @sntq_yue=@yue
set @td_syc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@sy_nian||@sy_yue||'01'))
set @td_snc=(select min(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期>=convert(int,@snm_nian||'0101'))
set @td_snm=(select max(t1.日期) from DBA.v_skb_d_rq t1 where t1.是否工作日='1' and t1.日期<=convert(int,@snm_nian||@snm_yue||'31'))
set @ts_m=(select ts_m from dba.t_ddw_d_rq_m where ny=convert(int,@nian||@yue))
set @ts_y=(select ts_y from dba.t_ddw_d_rq_m where ny=convert(int,@nian||@yue))
insert into #temp_dxf(
	zjzh
)
(	
	select zjzh
	from dba.t_edw_dxfkhmd t_dxf
	where t_dxf.nian=@nian and t_dxf.yue=@yue
	union 
	select zjzh
	from dba.t_ddw_yunying2012_kh 
	where nian=@nian and yue=@yue and zjzh in ('30083009','160041993','160042499','160042650')
	group by zjzh
);
