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
set @yue='05'
set @nian_sx='2013'
set @yue_sx='05'
set @nian_gx='2013'
set @yue_gx='05'

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

		
insert into #temp_khcp(
	nian
	,yue
	,zjzh		
--	,jjdm
	,产品类型
	,责权关系类型
	--未扣减数据
	,销售金额_月累计_原始
	,销售金额_月累计_考核	
	,赎回金额_月累计_原始	
	,赎回金额_月累计_考核	
	,销售金额_年累计_原始	
	,销售金额_年累计_考核	
	,赎回金额_年累计_原始	
	,赎回金额_年累计_考核	
	,期初市值_原始
	,期初市值_考核
	,期末市值_原始
	,期末市值_考核
	,月日均市值_原始
	,月日均市值_考核
	,年日均市值_原始
	,年日均市值_考核
	,认申购手续费_月累计
	,认申购手续费_年累计		
	--资管总部销售待扣减项
	,销售金额_月累计_总部_原始
	,销售金额_月累计_总部_考核
	,赎回金额_月累计_总部_原始
	,赎回金额_月累计_总部_考核
	,销售金额_年累计_总部_原始
	,销售金额_年累计_总部_考核
	,赎回金额_年累计_总部_原始
	,赎回金额_年累计_总部_考核
	,期初市值_总部_原始
	,期初市值_总部_考核
	,期末市值_总部_原始
	,期末市值_总部_考核
	,月日均市值_总部_原始
	,月日均市值_总部_考核	
	,年日均市值_总部_原始	
	,年日均市值_总部_考核		
	--资管总部销售扣减后
	,销售金额_月累计_扣减后_原始
	,销售金额_月累计_扣减后_考核
	,赎回金额_月累计_扣减后_原始
	,赎回金额_月累计_扣减后_考核
	,销售金额_年累计_扣减后_原始
	,销售金额_年累计_扣减后_考核
	,赎回金额_年累计_扣减后_原始
	,赎回金额_年累计_扣减后_考核
	,期初市值_扣减后_原始	
	,期初市值_扣减后_考核	
	,期末市值_扣减后_原始	
	,期末市值_扣减后_考核	
	,月日均市值_扣减后_原始
	,月日均市值_扣减后_考核
	,年日均市值_扣减后_原始
	,年日均市值_扣减后_考核
	--首发数据
	,销售金额_月累计_首发_原始
	,销售金额_月累计_首发_考核
	,销售金额_年累计_首发_原始
	,销售金额_年累计_首发_考核
	,认申购手续费_月累计_首发
	,认申购手续费_年累计_首发	
	--换购数据
	,换购金额_月累计
	,换购金额_年累计	
)
(
	select
		@nian as nian
		,@yue as yue
		,t_all.zjzh
--		,t_all.jjdm
		,t_all.产品类型
		,t_khxs.责权关系类型
		,sum(coalesce(t1.cwje_rgqr_m,0)
			+coalesce(t1.cwje_sgqr_m,0)
			+coalesce(t1.cwje_dsdetzqr_m,0)
			+coalesce(t1.cwje_zhrqr_m,0)
			+coalesce(t1.ztgrqrje_m,0)
			+coalesce(t1.cnje_rgqr_m,0)
			+coalesce(t1.hg_je_m, 0)) as 销售金额_月累计_原始
		,销售金额_月累计_原始*t_khxs.考核系数 as 销售金额_月累计_考核
		,sum(coalesce(t1.cwje_shqr_m,0)
			+coalesce(t1.ztgcqrje_m,0)
			+coalesce(t1.cwje_cgpxzhc_m,0)) as 赎回金额_月累计_原始
		,赎回金额_月累计_原始*t_khxs.考核系数 as 赎回金额_月累计_考核
		,sum(coalesce(t1.cwje_rgqr_y,0)
			+coalesce(t1.cwje_sgqr_y,0)
			+coalesce(t1.cwje_dsdetzqr_y,0)
			+coalesce(t1.cwje_zhrqr_y,0)
			+coalesce(t1.ztgrqrje_y,0)
			+coalesce(t1.cnje_rgqr_y,0)
			+coalesce(t1.hg_je_y, 0)) as 销售金额_年累计_原始
		,销售金额_年累计_原始*t_khxs.考核系数 as 销售金额_年累计_考核		
		,sum(coalesce(t1.cwje_shqr_y,0)
			+coalesce(t1.ztgcqrje_y,0)
			+coalesce(t1.cwje_cgpxzhc_y,0)) as 赎回金额_年累计_原始
		,赎回金额_年累计_原始*t_khxs.考核系数 as 赎回金额_年累计_考核		
		,sum(coalesce(t_last.qmsz_cw_m,0)) as 期初市值_原始
		,期初市值_原始*t_khxs.考核系数 as 期初市值_考核
		,sum(coalesce(t1.qmsz_cw_m,0)) as 期末市值_原始
		,期末市值_原始*t_khxs.考核系数 as 期末市值_考核		
		,sum(coalesce(t1.ljsz_cw_m,0))/@ts_m as 月日均市值_原始
		,月日均市值_原始*t_khxs.考核系数 as 月日均市值_考核
		,sum(coalesce(t1.ljsz_cw_y,0))/@ts_y as 年日均市值_原始
		,月日均市值_原始*t_khxs.考核系数 as 年日均市值_考核
		,sum(coalesce(t1.cnsxf_rgqr_m,0)
			+coalesce(t1.cnsxf_sgqr_m,0)
			+coalesce(t1.cnsxf_dsdetzqr_m,0)
			+coalesce(t1.cwsxf_rgqr_m,0)
			+coalesce(t1.cwsxf_sgqr_m,0)
			+coalesce(t1.cwsxf_dsdetzqr_m,0)
			+coalesce(t1.cwsxf_zhrqr_m,0)) as 认申购手续费_月累计
		,sum(coalesce(t1.cnsxf_rgqr_y,0)
			+coalesce(t1.cnsxf_sgqr_y,0)
			+coalesce(t1.cnsxf_dsdetzqr_y,0)
			+coalesce(t1.cwsxf_rgqr_y,0)
			+coalesce(t1.cwsxf_sgqr_y,0)
			+coalesce(t1.cwsxf_dsdetzqr_y,0)
			+coalesce(t1.cwsxf_zhrqr_y,0)) as 认申购手续费_年累计
	
		--资管总部销售待扣减
		,sum(coalesce(t_zb.xsje_m, 0)) as 销售金额_月累计_总部_原始
		,销售金额_月累计_总部_原始*t_khxs.考核系数 as 销售金额_月累计_总部_考核
		,sum(coalesce(t_zb.shje_m, 0)) as 赎回金额_月累计_总部_原始
		,赎回金额_月累计_总部_原始*t_khxs.考核系数 as 赎回金额_月累计_总部_考核
		
		,sum(coalesce(t_zb.xsje_y, 0)) as 销售金额_年累计_总部_原始
		,销售金额_年累计_总部_原始*t_khxs.考核系数 as 销售金额_年累计_总部_考核
		,sum(coalesce(t_zb.shje_y, 0)) as 赎回金额_年累计_总部_原始
		,赎回金额_年累计_总部_原始*t_khxs.考核系数 as 赎回金额_年累计_总部_考核
	
		,sum(coalesce(t_zb_last.qmsz, 0)) as 期初市值_总部_原始
		,期初市值_总部_原始*t_khxs.考核系数 as 期初市值_总部_考核
		,sum(coalesce(t_zb.qmsz, 0)) as 期末市值_总部_原始
		,期末市值_总部_原始*t_khxs.考核系数 as 期末市值_总部_考核
		
		,case when 期末市值_总部_原始>月日均市值_原始 then 月日均市值_原始 else 期末市值_总部_原始 end as 月日均市值_总部_原始
		,月日均市值_总部_原始*t_khxs.考核系数 as 月日均市值_总部_考核
		,case when 期末市值_总部_原始>年日均市值_原始 then 年日均市值_原始 else 期末市值_总部_原始 end as 年日均市值_总部_原始
		,年日均市值_总部_原始*t_khxs.考核系数 as 年日均市值_总部_考核	
		
		--资管总部销售扣减后
		,销售金额_月累计_原始-销售金额_月累计_总部_原始 as 销售金额_月累计_扣减后_原始
		,销售金额_月累计_考核-销售金额_月累计_总部_考核 as 销售金额_月累计_扣减后_考核
		,赎回金额_月累计_原始-赎回金额_月累计_总部_原始 as 赎回金额_月累计_扣减后_原始
		,赎回金额_月累计_考核-赎回金额_月累计_总部_考核 as 赎回金额_月累计_扣减后_考核
		
		,销售金额_年累计_原始-销售金额_年累计_总部_原始 as 销售金额_年累计_扣减后_原始
		,销售金额_年累计_考核-销售金额_年累计_总部_考核 as 销售金额_年累计_扣减后_考核
		,赎回金额_年累计_原始-赎回金额_年累计_总部_原始 as 赎回金额_年累计_扣减后_原始
		,赎回金额_年累计_考核-赎回金额_年累计_总部_考核 as 赎回金额_年累计_扣减后_考核
		
		,期初市值_原始-期初市值_总部_原始 as 期初市值_扣减后_原始
		,期初市值_考核-期初市值_总部_考核 as 期初市值_扣减后_考核
		,期末市值_原始-期末市值_总部_原始 as 期末市值_扣减后_原始
		,期末市值_考核-期末市值_总部_考核 as 期末市值_扣减后_考核
	
		,月日均市值_原始-月日均市值_总部_原始 as 月日均市值_扣减后_原始
		,月日均市值_考核-月日均市值_总部_考核 as 月日均市值_扣减后_考核
		,年日均市值_原始-年日均市值_总部_原始 as 年日均市值_扣减后_原始
		,年日均市值_考核-年日均市值_总部_考核 as 年日均市值_扣减后_考核			
	
		--首发数据
		,sum(coalesce(t1.cwje_rgqr_m,0)
			+coalesce(t1.cnje_rgqr_m,0)
			+coalesce(t1.hg_je_m,0)) as 销售金额_月累计_首发_原始
		,销售金额_月累计_首发_原始*t_khxs.考核系数 as 销售金额_月累计_首发_考核	
		,sum(coalesce(t1.cwje_rgqr_y,0)
			+coalesce(t1.cnje_rgqr_y,0)
			+coalesce(t1.hg_je_y,0)) as 销售金额_年累计_首发_原始
		,销售金额_年累计_首发_原始*t_khxs.考核系数 as 销售金额_年累计_首发_考核	
		,sum(coalesce(t1.cnsxf_rgqr_m,0)
			+coalesce(t1.cwsxf_rgqr_m,0)
			+coalesce(t1.hg_sxf_m,0)) as 认申购手续费_月累计_首发
		,sum(coalesce(t1.cnsxf_rgqr_y,0)
			+coalesce(t1.cwsxf_rgqr_y,0)
			+COALESCE(t1.hg_sxf_y,0)) as 认申购手续费_年累计_首发
		--换购数据
		,sum(coalesce(t1.hg_je_m, 0)) as 换购金额_月累计
		,sum(coalesce(t1.hg_je_y, 0)) as 换购金额_年累计		
	from
	(
		select
			t1.zjzh
			,t1.jjdm
			,case when t_sx.jjlb is null then '未设置类型'
			  when t_sx.jjlb='公募-股票型' and t_sx.sfhx=1 then '核心-'||trim(t_sx.jjlb)
			  when t_sx.jjlb='公募-股票型' and (t_sx.sfhx<>1 or t_sx.sfhx is null) then '非核心-'||trim(t_sx.jjlb)
			  when t_sx.jjlb='公募-债券型' and t_sx.sfsxf_zq =1 then trim(t_sx.jjlb)||'-有手续费'
			  when t_sx.jjlb='公募-债券型' and t_sx.sfsxf_zq =0 then trim(t_sx.jjlb)||'-无手续费'
			  else trim(t_sx.jjlb) end as 产品类型
		from
		(
			select
				t1.zjzh
				,t1.jjdm
			from dba.t_ddw_xy_jjzb_m t1
			where t1.nian=@nian and t1.yue=@yue or t1.nian=@snm_nian and t1.yue=@snm_yue
			group by t1.zjzh,t1.jjdm
		) t1
		left join dba.t_ddw_d_jj t_sx on t_sx.jjdm=t1.jjdm and t_sx.nian = @nian_sx and t_sx.yue=@yue_sx		
	) t_all
	left join #temp_khxs t_khxs on t_all.产品类型=t_khxs.产品类型
	left join dba.t_ddw_xy_jjzb_m t1 on t_all.zjzh=t1.zjzh and t_all.jjdm=t1.jjdm and t1.nian=@nian and t1.yue=@yue
	left join dba.t_ddw_xy_jjzb_m t_last on t_all.zjzh=t_last.zjzh and t_all.jjdm=t_last.jjdm and t_last.nian=@snm_nian and t_last.yue=@snm_yue	
    left join
	(--资管总部销售扣减项
		select
			t1.zjzh
			,t1.jjdm
			,t1.期末市值_总部 as qmsz
			,t1.销售金额_月_总部 as xsje_m
			,t1.赎回金额_月_总部 as shje_m
			,t1.销售金额_年_总部 as xsje_y
			,t1.赎回金额_年_总部 as shje_y		
		from dba.t_tmp_ryhz t1
		where t1.nian=@nian and t1.yue=@yue
	) t_zb on t_all.zjzh= t_zb.zjzh and t_all.jjdm= t_zb.jjdm
	left join
	(--资管总部销售扣减项_去年底
		select
			t1.zjzh
			,t1.jjdm
			,t1.期末市值_总部 as qmsz
			,t1.销售金额_月_总部 as xsje_m
			,t1.赎回金额_月_总部 as shje_m
			,t1.销售金额_年_总部 as xsje_y
			,t1.赎回金额_年_总部 as shje_y		
		from dba.t_tmp_ryhz t1
		where t1.nian=@snm_nian and t1.yue=@snm_yue
	) t_zb_last on t_all.zjzh= t_zb_last.zjzh and t_all.jjdm= t_zb_last.jjdm
	group by t_all.zjzh,t_all.产品类型,t_khxs.考核系数,t_khxs.责权关系类型
);