left join
	(
		select
			nian,
			yue,
			zjzh,
			zqdm,
			max(qmsz) as qmsz,
			max(xsje_m) as xsje_m,
			max(shje_m) as shje_m,
			max(xsje_y) as xsje_y,
			max(shje_y) as shje_y		
		from query_skb.wjh_temp_2
		where nian=@nian and yue=@yue
		group by nian,yue,zjzh,zqdm	
	) as t_zb on a.nian=t_zb.nian and a.yue=t_zb.yue and a.zjzh= t_zb.zjzh and a.jjdm= t_zb.zqdm
	
declare @nian varchar(16),@yue varchar(16)
set @nian='2013'
set @yue='05'
		
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

--代码替换，新的资管总部销售
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
	
--内部创设产品销售
select
	SUM(a.cwje_rgqr_m + a.cwje_sgqr_m + a.cwje_dsdetzqr_m + a.cwje_zhrqr_m + a.ztgrqrje_m) AS 场外销售_月,    -- 场外销售金额_月累计(原始值)
		         SUM(a.cnje_rgqr_m + COALESCE(a.hg_je_m, 0)) AS 场内销售_月,    -- 场内认购金额_月累计(原始值)
		         SUM(a.cwje_shqr_m + a.ztgcqrje_m + a.cwje_cgpxzhc_m ) AS 赎回_月 ,    -- 场外赎回金额_月累计(原始)
		
				 ------年度销售------
		         SUM(a.cwje_rgqr_y + a.cwje_sgqr_y + a.cwje_dsdetzqr_y + a.cwje_zhrqr_y + a.ztgrqrje_y) AS 场外销售_年,    -- 场外销售金额_年累计(原始值)
		         SUM(a.cnje_rgqr_y + COALESCE(a.hg_je_y, 0)) AS 场内销售_年,    -- 场内认购金额_年累计(原始值)
		         SUM(a.cwje_shqr_y + a.ztgcqrje_y+ a.cwje_cgpxzhc_y ) AS 赎回_年    -- 场外赎回金额_年累计(原始)			
from dba.t_ddw_xy_jjzb_m a
left join #temp_nbcscp t2 on a.jjdm=t2.jjdm
where t2.jjdm is not null
and a.nian='2013' and a.yue='05'