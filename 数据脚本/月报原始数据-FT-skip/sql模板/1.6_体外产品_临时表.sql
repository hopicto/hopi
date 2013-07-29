-------------------------------------START-----------------------------------
declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'

insert into #temp_cp_yg(ny,ygh,sfcpxkh,zcd,cplx,xsje_m_ys,xsje_m_kh,shje_m_ys,shje_m_kh,xsje_y_ys,xsje_y_kh,
shje_y_ys,shje_y_kh,qcsz_ys,qcsz_kh,qmsz_ys,qmsz_kh,rjsz_m_ys,rjsz_m_kh,rjsz_y_ys,rjsz_y_kh,xsje_m_sf,xsje_y_sf)
(
select 
	--本月销售
	convert(varchar,t_rq.ny) as 年月
	,t_yg.ygh
	,0
--	,'3->100w'
	,'体外产品'
	,t_all.cplx
	,sum(coalesce(t1.xsje_m_ys,0)) as 销售金额_月累计_原始_tw
	,sum(coalesce(t1.xsje_m_kh,0)) as 销售金额_月累计_考核_tw
	,sum(coalesce(t1.shje_m_ys,0)) as 赎回金额_月累计_原始_tw
	,sum(coalesce(t1.shje_m_kh,0)) as 赎回金额_月累计_考核_tw
	--本年销售
	,sum(coalesce(t1.xsje_y_ys,0)) as 销售金额_年累计_原始_tw
	,sum(coalesce(t1.xsje_y_kh,0)) as 销售金额_年累计_考核_tw
	,sum(coalesce(t1.shje_y_ys,0)) as 赎回金额_年累计_原始_tw
	,sum(coalesce(t1.shje_y_kh,0)) as 赎回金额_年累计_考核_tw
				
	--保有
	,sum(coalesce(t_last.qmbyje_ys,0)) as 期初市值_原始_tw
	,sum(coalesce(t_last.qmbyje_kh,0)) as 期初市值_考核_tw
	,sum(coalesce(t1.qmbyje_ys,0)) as 期末市值_原始_tw
	,sum(coalesce(t1.qmbyje_kh,0)) as 期末市值_考核_tw
	,sum(coalesce(t1.byje_yrj_ys,0)) as 月日均市值_原始_tw
	,sum(coalesce(t1.byje_yrj_kh,0)) as 月日均市值_考核_tw
	,sum(coalesce(t1.byje_nrj_ys,0)) as 年日均市值_原始_tw
	,sum(coalesce(t1.byje_nrj_kh,0)) as 年日均市值_考核_tw
	,0
	,0
	from 
	dba.t_yunying2012_param_yg as t_yg
	left join dba.t_ddw_d_rq_m as t_rq on t_rq.nian=convert(int,@nian) and t_rq.yue=convert(int,@yue)
	left join 
	(
		select ygh,cplx
		from dba.tmp_ddw_twcp_m
		group by ygh,cplx
	) as t_all on t_yg.ygh=t_all.ygh 
	left join 
	(
		select 
			ygh
			,nian,yue,cplx
			--原始
			,sum(xsje_m) as xsje_m_ys
			,sum(shje_m) as shje_m_ys
			,sum(xsje_y) as xsje_y_ys
			,sum(shje_y) as shje_y_ys
			,sum(qmbyje) as qmbyje_ys
			,sum(byje_yrj) as byje_yrj_ys
			,sum(byje_nrj) as byje_nrj_ys
			--考核
			,sum(case when cplx in ('固定收益','债券类私募信托') then xsje_m*0.5 else xsje_m end) as xsje_m_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then shje_m*0.5 else shje_m end) as shje_m_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then xsje_y*0.5 else xsje_y end) as xsje_y_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then shje_y*0.5 else shje_y end) as shje_y_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then qmbyje*0.5 else qmbyje end) as qmbyje_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then byje_yrj*0.5 else byje_yrj end) as byje_yrj_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then byje_nrj*0.5 else byje_yrj end) as byje_nrj_kh
			
		from dba.tmp_ddw_twcp_m
		where ny=convert(int,@nian||@yue)
		group by ygh,nian,yue,cplx
	) as t1 on t_all.ygh=t1.ygh and t_all.cplx=t1.cplx 	
	
	-------------期初---------------
	left join 
	(
		select 
			ygh,cplx
			--原始
			,sum(xsje_m) as xsje_m_ys
			,sum(shje_m) as shje_m_ys
			,sum(xsje_y) as xsje_y_ys
			,sum(shje_y) as shje_y_ys
			,sum(qmbyje) as qmbyje_ys
			,sum(byje_yrj) as byje_yrj_ys
			--考核
			,sum(case when cplx in ('固定收益','债券类私募信托') then xsje_m*0.5 else xsje_m end) as xsje_m_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then shje_m*0.5 else shje_m end) as shje_m_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then xsje_y*0.5 else xsje_y end) as xsje_y_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then shje_y*0.5 else shje_y end) as shje_y_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then qmbyje*0.5 else qmbyje end) as qmbyje_kh
			,sum(case when cplx in ('固定收益','债券类私募信托') then byje_yrj*0.5 else byje_yrj end) as byje_yrj_kh
			
		from dba.tmp_ddw_twcp_m
		where ny=(convert(int,@nian)-1)*100+12
		group by ygh,cplx
	) as t_last on t_all.ygh=t_last.ygh and t_all.cplx=t_last.cplx 	
	where 
	--注意修改
		t_yg.nian=@nian_gx and t_yg.yue=@yue_gx
		and (t1.ygh is not null or t_last.ygh is not null)
group by t_rq.ny,t_yg.ygh,t_all.cplx
)