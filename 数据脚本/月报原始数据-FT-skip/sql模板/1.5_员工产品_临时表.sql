drop table #temp_cp_yg;
----------------------创建产品临时表---------------------
create table #temp_cp_yg
(
	ny int,  --年月
	ygh varchar(128),	--员工编号
	sfcpxkh int,		--是否产品新客户
	zcd varchar(128),	--资产段
	cplx varchar(128),	--产品类型
	xsje_m_ys numeric(38,10),  --销售金额_月累计_原始
	xsje_m_kh numeric(38,10),  --销售金额_月累计_考核
	shje_m_ys numeric(38,10),  --赎回金额_月累计_原始
	shje_m_kh numeric(38,10),  --赎回金额_月累计_考核
	xsje_y_ys numeric(38,10),  --销售金额_年累计_原始
	xsje_y_kh numeric(38,10),  --销售金额_年累计_考核
	shje_y_ys numeric(38,10),  --赎回金额_年累计_原始
	shje_y_kh numeric(38,10),  --赎回金额_年累计_考核

	qcsz_ys numeric(38,10),  --期初市值_原始
	qcsz_kh numeric(38,10),  --期初市值_考核
	qmsz_ys numeric(38,10),  --期末市值_原始
	qmsz_kh numeric(38,10),  --期末市值_考核

	rjsz_m_ys numeric(38,10),  --月日均市值_原始
	rjsz_m_kh numeric(38,10),  --月日均市值_考核
	rjsz_y_ys numeric(38,10),  --年日均市值_原始
	rjsz_y_kh numeric(38,10),  --年日均市值_考核
	
	xsje_m_sf numeric(38,10),  --首发月
	xsje_y_sf numeric(38,10),  --首发年
	
	sxf_m numeric(38,10),  --手续费_月
	sxf_y numeric(38,10),  --手续费_年	
	
	sf_sxf_m numeric(38,10),  --首发手续费_月
	sf_sxf_y numeric(38,10),  --首发手续费_年
	
	xsje_m_sf_kh numeric(38,10),  --首发月_考核
	xsje_y_sf_kh numeric(38,10)  --首发年_考核	
);


--*******************************************************************--
---将产品销售按照类型和ygh汇总,导入临时表
---注意要修改@nain和@yue
--*******************************************************************--

-------------------------------------START-----------------------------------

declare @nian varchar(16),@yue varchar(16),@nian_gx varchar(16),@yue_gx varchar(16),@nian_sx varchar(16),@yue_sx varchar(16)
set @nian='2013'
set @yue='03'
set @nian_gx='2013'
set @yue_gx='03'
set @nian_sx='2013'   --产品属性
set @yue_sx='03'	  --产品属性

insert into #temp_cp_yg(ny,ygh,sfcpxkh,zcd,cplx,xsje_m_ys,xsje_m_kh,shje_m_ys,shje_m_kh,xsje_y_ys,xsje_y_kh,
shje_y_ys,shje_y_kh,qcsz_ys,qcsz_kh,qmsz_ys,qmsz_kh,rjsz_m_ys,rjsz_m_kh,rjsz_y_ys,rjsz_y_kh,xsje_m_sf,xsje_y_sf
,sxf_m
,sxf_y
,sf_sxf_m
,sf_sxf_y
,xsje_m_sf_kh
,xsje_y_sf_kh
)

(
SELECT 
	convert(int,t_cp.nian||t_cp.yue) as 年月
	--,t_jg.org_full_name as 营业部
	--,t_jg_2.jgmc as 营业部_简称
	--,t_jg_2.zxyybmc as 中心营业部
	,t_yg.ygh as 员工编号
	,t_kh_sfcpxkh.是否产品新客户 
--	,t_fenduan.资产段_2013_粗 as 资产段
	,t_fenduan.资产段_2013_细 as 资产段
	,cplx as 产品类型
	
	--本月销售
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl			  
			 else 0 end
		) as 销售金额_月累计_原始		
		
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then (tmp_cwxsje_m+tmp_cnrgje_m)*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' and tmp_cwszbh_m >0 then tmp_cwszbh_m*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' and tmp_cwszbh_m >0 then tmp_cwszbh_m*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' and tmp_cwszbh_m >0 then tmp_cwszbh_m*jxbl*0.1			  
			 else 0 end
		) as 销售金额_月累计_考核
	
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwshje_m*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then tmp_cwshje_m*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then tmp_cwshje_m*jxbl			  
			 else 0 end
		) as 赎回金额_月累计_原始
	
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwshje_m*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwshje_m*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then tmp_cwshje_m*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then tmp_cwshje_m*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then tmp_cwshje_m*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then tmp_cwshje_m*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then tmp_cwshje_m*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' and tmp_cwszbh_m <0 then -tmp_cwszbh_m*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' and tmp_cwszbh_m <0 then -tmp_cwszbh_m*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' and tmp_cwszbh_m <0 then -tmp_cwszbh_m*jxbl*0.1
			 else 0 end
		) as 赎回金额_月累计_考核			

	--本年销售
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl			  
			 else 0 end
		) as 销售金额_年累计_原始		
		
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then (tmp_cwxsje_y+tmp_cnrgje_y)*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' and tmp_cwszbh_m >0 then tmp_cwszbh_m*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' and tmp_cwszbh_m >0 then tmp_cwszbh_m*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' and tmp_cwszbh_m >0 then tmp_cwszbh_m*jxbl*0.1			  
			 else 0 end
		) as 销售金额_年累计_考核
	
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwshje_y*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then tmp_cwshje_y*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then tmp_cwshje_y*jxbl			  
			 else 0 end
		) as 赎回金额_年累计_原始
	
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwshje_y*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwshje_y*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then tmp_cwshje_y*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then tmp_cwshje_y*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then tmp_cwshje_y*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then tmp_cwshje_y*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then tmp_cwshje_y*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' and tmp_cwszbh_m <0 then -tmp_cwszbh_m*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' and tmp_cwszbh_m <0 then -tmp_cwszbh_m*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' and tmp_cwszbh_m <0 then -tmp_cwszbh_m*jxbl*0.1
			 else 0 end
		) as 赎回金额_年累计_考核	
		
	--保有
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwbyqcsz*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then tmp_cwbyqcsz*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then tmp_cwbyqcsz*jxbl			  
			 else 0 end
		) as 期初市值_原始	
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwbyqcsz*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwbyqcsz*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then tmp_cwbyqcsz*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then tmp_cwbyqcsz*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then tmp_cwbyqcsz*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then tmp_cwbyqcsz*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then tmp_cwbyqcsz*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwbyqcsz*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' then tmp_cwbyqcsz*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' then tmp_cwbyqcsz*jxbl*0.1
			 else 0 end
		) as 期初市值_考核	
		
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwbyqmsz*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then tmp_cwbyqmsz*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then tmp_cwbyqmsz*jxbl			  
			 else 0 end
		) as 期末市值_原始	
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwbyqmsz*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwbyqmsz*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then tmp_cwbyqmsz*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then tmp_cwbyqmsz*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then tmp_cwbyqmsz*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then tmp_cwbyqmsz*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then tmp_cwbyqmsz*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwbyqmsz*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' then tmp_cwbyqmsz*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' then tmp_cwbyqmsz*jxbl*0.1
			 else 0 end
		) as 期末市值_考核

	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwbysz_yrj*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then tmp_cwbysz_yrj*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then tmp_cwbysz_yrj*jxbl			  
			 else 0 end
		) as 月日均市值_原始	
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwbysz_yrj*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwbysz_yrj*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then tmp_cwbysz_yrj*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then tmp_cwbysz_yrj*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then tmp_cwbysz_yrj*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then tmp_cwbysz_yrj*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then tmp_cwbysz_yrj*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwbysz_yrj*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' then tmp_cwbysz_yrj*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' then tmp_cwbysz_yrj*jxbl*0.1
			 else 0 end
		) as 月日均市值_考核	
		
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwbysz_nrj*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then tmp_cwbysz_nrj*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then tmp_cwbysz_nrj*jxbl			  
			 else 0 end
		) as 年日均市值_原始	
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwbysz_nrj*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then tmp_cwbysz_nrj*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then tmp_cwbysz_nrj*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then tmp_cwbysz_nrj*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then tmp_cwbysz_nrj*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then tmp_cwbysz_nrj*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then tmp_cwbysz_nrj*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_cwbysz_nrj*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' then tmp_cwbysz_nrj*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' then tmp_cwbysz_nrj*jxbl*0.1
			 else 0 end
		) as 年日均市值_考核
	
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_sfje_m*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then tmp_sfje_m*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then tmp_sfje_m*jxbl			  
			 else 0 end
		) as 销售金额_月累计_首发	
		
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_sfje_y*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then tmp_sfje_y*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then tmp_sfje_y*jxbl			  
			 else 0 end
		) as 销售金额_年累计_首发	
		

	--手续费收入
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then t_cp.sxf_m*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then t_cp.sxf_m*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then t_cp.sxf_m*jxbl			  
			 else 0 end
		) as 手续费_月累计	
		
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then t_cp.sxf_y*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then t_cp.sxf_y*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then t_cp.sxf_y*jxbl			  
			 else 0 end
		) as 手续费_年累计	
		
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then t_cp.sf_sxf_m*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then t_cp.sf_sxf_m*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then t_cp.sf_sxf_m*jxbl			  
			 else 0 end
		) as 首发_手续费_月累计	
		
	,sum(case when t_cp.cplx in ('非核心-公募-股票型','核心-公募-股票型','公募-债券型-有手续费','公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then t_cp.sf_sxf_y*jxbl			  
			  when t_cp.cplx in ('基金专户-股票型','基金专户-债券型','基金专户-货币型') and t_gx.ywlb='5' then t_cp.sf_sxf_y*jxbl			  
			  when t_cp.cplx in ('集合理财-股票型','集合理财-债券型','集合理财-货币型') and t_gx.ywlb='6' then t_cp.sf_sxf_y*jxbl			  
			 else 0 end
		) as 首发_手续费_年累计
		
		
	--添加首发考核	
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then tmp_sfje_m*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then tmp_sfje_m*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then tmp_sfje_m*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then tmp_sfje_m*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then tmp_sfje_m*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then tmp_sfje_m*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then tmp_sfje_m*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_sfje_m*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' then tmp_sfje_m*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' then tmp_sfje_m*jxbl*0.1
			 else 0 end
		) as 销售金额_月累计_首发_考核
		
	,sum(case when t_cp.cplx='非核心-公募-股票型' and t_gx.ywlb='4' then tmp_sfje_y*jxbl*0.8
			  when t_cp.cplx='核心-公募-股票型' and t_gx.ywlb='4' then tmp_sfje_y*jxbl*1
			  when t_cp.cplx='基金专户-股票型' and t_gx.ywlb='5' then tmp_sfje_y*jxbl*1
			  when t_cp.cplx='集合理财-股票型' and t_gx.ywlb='6' then tmp_sfje_y*jxbl*1			  
			  when t_cp.cplx='公募-债券型-有手续费' and t_gx.ywlb='4' then tmp_sfje_y*jxbl*0.4
			  when t_cp.cplx='基金专户-债券型' and t_gx.ywlb='5' then tmp_sfje_y*jxbl*0.5
			  when t_cp.cplx='集合理财-债券型' and t_gx.ywlb='6' then tmp_sfje_y*jxbl*0.5			  
			  when t_cp.cplx in ('公募-债券型-无手续费','公募-货币型') and t_gx.ywlb='4' then tmp_sfje_y*jxbl*0.1
			  when t_cp.cplx='基金专户-货币型' and t_gx.ywlb='5' then tmp_sfje_y*jxbl*0.1
			  when t_cp.cplx='集合理财-货币型' and t_gx.ywlb='6' then tmp_sfje_y*jxbl*0.1
			 else 0 end
		) as 销售金额_年累计_首发_考核
	
FROM 
(
	select *
	from dba.t_yunying2012_param_yg 
	where nian=@nian_gx and yue=@yue_gx
)as t_yg

-----------------绩效关系-----------------
--责权关系
left join dba.t_ddw_zrqygx as t_gx on t_gx.ygh=t_yg.ygh and t_gx.nian=@nian_gx and t_gx.yue=@yue_gx      --客户映射
--营业部
left join DBA.T_EDW_T06_ORGANIZATION as t_jg on t_jg.org_cd=t_yg.jgbh   --营业部表
left join dba.yybdz as t_jg_2 on t_jg_2.jgbh=t_yg.jgbh   --营业部表

/*-------------------客户指标-----------------*/

left join dba.t_ddw_yunying2012_kh as t1 on t1.nian=@nian and t1.yue=@yue and t1.khbh_hs= t_gx.khbh_hs
left join #temp_khsx as t_fenduan on t1.zjzh=t_fenduan.zjzh   --客户资产段
left join 
(
select 
	zjzh,
	case when sum(sfcpxkh)>0 then 1 else 0 end as 是否产品新客户
	from dba.t_ddw_yunying2012_kh
where nian=@nian and yue<=@yue
group by zjzh
)as t_kh_sfcpxkh on t1.zjzh=t_kh_sfcpxkh.zjzh

left join 
(
	SELECT 
		t_rq.nian,
		t_rq.yue,
		t_all.zjzh,
        t_all.jjdm,
		case when b.jjlb in ('公募-股票型') and b.sfhx=1 then '核心-'||trim(b.jjlb)
		  when b.jjlb in ('公募-股票型') and (b.sfhx<>1 or b.sfhx is null) then '非核心-'||trim(b.jjlb)
		  when b.jjlb in ('公募-债券型') and sfsxf_zq =1 then trim(b.jjlb)||'-有手续费'
		  when b.jjlb in ('公募-债券型') and sfsxf_zq =0 then trim(b.jjlb)||'-无手续费'
		  when b.jjlb in ('公募-货币型') then trim(b.jjlb)
		  
--		  when b.lx='基金专户' and jjzh.jjdm is null then '基金专户-股票型'
--		  when b.lx='基金专户' and jjzh.jjdm is not null then '基金专户-债券型'
		  
		else trim(b.jjlb) end as cplx,

		
		 ------月度销售------
         SUM(a.cwje_rgqr_m + a.cwje_sgqr_m + a.cwje_dsdetzqr_m + a.cwje_zhrqr_m + a.ztgrqrje_m - coalesce(t_zb.xsje_m, 0)) AS tmp_cwxsje_m,    -- 场外销售金额_月累计(原始值)                  
         
         SUM(a.ljsz_cw_y / t_rq.ts_y - COALESCE(a_last.qmsz_cw_m, 0)) AS tmp_cwszbh_m,    -- 场外销售金额_月累计(市值变化)
         SUM(a.cnje_rgqr_m + COALESCE(a.hg_je_m, 0)) AS tmp_cnrgje_m,    -- 场内认购金额_月累计(原始值)
         SUM(a.ljsz_cn_y / t_rq.ts_y - COALESCE(a_last.qmsz_cn_m, 0)) AS tmp_cnszbh_m,    -- 场内销售金额_月累计(市值变化)
         SUM(a.cwje_shqr_m + a.ztgcqrje_m + a.cwje_cgpxzhc_m - coalesce(t_zb.shje_m, 0)) AS tmp_cwshje_m ,    -- 场外赎回金额_月累计(原始)

		 ------年度销售------
         SUM(a.cwje_rgqr_y + a.cwje_sgqr_y + a.cwje_dsdetzqr_y + a.cwje_zhrqr_y + a.ztgrqrje_y - coalesce(t_zb.xsje_y, 0)) AS tmp_cwxsje_y,    -- 场外销售金额_年累计(原始值)
         SUM(a.cnje_rgqr_y + COALESCE(a.hg_je_y, 0)) AS tmp_cnrgje_y,    -- 场内认购金额_年累计(原始值)
         SUM(a.cwje_shqr_y + a.ztgcqrje_y+ a.cwje_cgpxzhc_y - coalesce(t_zb.shje_y, 0)) AS tmp_cwshje_y,    -- 场外赎回金额_年累计(原始)

		 /*-----------------------保有---------------------*/
		 
		 SUM(coalesce(a_last.qmsz_cw_m,0) - coalesce(t_zb_last.qmsz, 0)) AS tmp_cwbyqcsz,      				-- 场外保有期末市值（原始）
         SUM(coalesce(a.qmsz_cw_m,0) - coalesce(t_zb.qmsz, 0)) AS tmp_cwbyqmsz,      						-- 场外保有期末市值（原始）
		 SUM(a.ljsz_cw_m) / max(t_rq.ts_m) - sum(coalesce(t_zb.qmsz, 0))  AS tmp_cwbysz_yrj,     			 -- 场外保有市值_月日均（原始）
		 SUM(a.ljsz_cw_y) / max(t_rq.ts_y) - sum(coalesce(t_zb.qmsz, 0))  AS tmp_cwbysz_nrj,     			 -- 场外保有市值_年日均（原始）
         
		 --add by dongyl
		 SUM(a.cwje_rgqr_m + a.cnje_rgqr_m+a.hg_je_m) AS tmp_sfje_m,    -- 首发
         SUM(a.cwje_rgqr_y+ a.cnje_rgqr_y+a.hg_je_y) AS tmp_sfje_y,    -- 首发
         
		 sum(a.cnsxf_rgqr_m
			+COALESCE(a.hg_sxf_m,0)
		 	+a.cwsxf_rgqr_m
			+a.cwsxf_sgqr_m
			+a.cwsxf_dsdetzqr_m
			+a.cwsxf_zhrqr_m			
		) as sxf_m,
		
		 sum(a.cnsxf_rgqr_y
			+COALESCE(a.hg_sxf_y,0)
		 	+a.cwsxf_rgqr_y
			+a.cwsxf_sgqr_y
			+a.cwsxf_dsdetzqr_y
			+a.cwsxf_zhrqr_y		
		) as sxf_y,
				
		sum(a.cnsxf_rgqr_m
			+a.cwsxf_rgqr_m
			+COALESCE(a.hg_sxf_m,0)		
		) as sf_sxf_m,
		
		sum(a.cnsxf_rgqr_y
			+a.cwsxf_rgqr_y
			+COALESCE(a.hg_sxf_y,0)
		) as sf_sxf_y
    FROM 
	-----------------所有产品、客户----------------
	(
		select zjzh,jjdm
			from dba.t_ddw_xy_jjzb_m 
			where convert(int,nian)+1=convert(int,@nian) and yue='12'
		union 
			select zjzh,jjdm
			from dba.t_ddw_xy_jjzb_m 
			where nian=@nian and yue=@yue
	)as t_all
	-----------------当前年月----------------
	cross join 
	(
		select 
			convert(varchar,nian) as nian
			,convert(varchar,convert(int,nian)-1) as nian_qn
			,right('0'||convert(varchar,yue),2) as yue
			,ts_m
			,ts_y
		from dba.t_ddw_d_rq_m 
		where ny=convert(int,@nian||@yue)
	)as t_rq  
	-----------------当前基金属性----------------
    LEFT JOIN dba.t_ddw_d_jj b ON b.nian = @nian_sx
                              AND b.yue = @yue_sx
                              AND t_all.jjdm = b.jjdm
							  
	-----------------当前基金销售----------------
	left join dba.t_ddw_xy_jjzb_m a on a.zjzh=t_all.zjzh and a.jjdm=t_all.jjdm
										and a.nian=t_rq.nian and a.yue=t_rq.yue
	--资管总部销售
--	left join query_skb.wjh_temp_2 as t_zb on a.nian=t_zb.nian and a.yue=t_zb.yue and a.zjzh= t_zb.zjzh and a.jjdm= t_zb.zqdm 	
	left join
	(
--		select
--			nian,
--			yue,
--			zjzh,
--			zqdm,
--			max(qmsz) as qmsz,
--			max(xsje_m) as xsje_m,
--			max(shje_m) as shje_m,
--			max(xsje_y) as xsje_y,
--			max(shje_y) as shje_y		
--		from query_skb.wjh_temp_2
--		where nian=@nian and yue=@yue
--		group by nian,yue,zjzh,zqdm	
		
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
	
	-----------------期初基金销售----------------
	left join dba.t_ddw_xy_jjzb_m as a_last on t_all.zjzh =a_last.zjzh and t_all.jjdm =a_last.jjdm 
											and a_last.nian = nian_qn and a_last.yue='12'
--	left join query_skb.wjh_temp_2 as t_zb_last on a_last.nian=t_zb_last.nian and a_last.yue=t_zb_last.yue 
--													and a_last.zjzh= t_zb_last.zjzh and a_last.jjdm= t_zb_last.zqdm
	--20130517更新 总部销售存在重复数据 
	left join
	(
--		select
--			nian,
--			yue,
--			zjzh,
--			zqdm,
--			max(qmsz) as qmsz,
--			max(xsje_m) as xsje_m,
--			max(shje_m) as shje_m,
--			max(xsje_y) as xsje_y,
--			max(shje_y) as shje_y
--		from query_skb.wjh_temp_2
--		group by nian,yue,zjzh,zqdm
		
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
	) as t_zb_last on a_last.nian=t_zb_last.nian and a_last.yue=t_zb_last.yue 
	and a_last.zjzh= t_zb_last.zjzh and a_last.jjdm= t_zb_last.zqdm 	
													
	--基金专户区分
--    left join #temp_jjzhyx jjzh on t_all.jjdm=jjzh.jjdm
    
   WHERE jjlb is not null
   and t_all.zjzh not in --不含关联方以及总部销售定向
	(select zjzh from #temp_teshu where lx in ('剔除'))
	
	and t_all.zjzh not in --不含特殊账户
	(
		select zjzh
		from dba.gt_ods_simu_trade_jour a
		where 
			ny <= convert(int,@nian||@yue)				 --发生日期在本月之前
			and yxq_end >=(convert(int,@nian||@yue)*100+31)  --当期仍有效！！
			and zjzh is not null
		group by zjzh
	)
   GROUP BY t_rq.nian,t_rq.yue,t_all.zjzh, b.jjlb, b.sfhx, b.sfsxf_zq,t_all.jjdm
   --,jjzh.jjdm
)as t_cp on t_cp.zjzh=t1.zjzh


GROUP BY t_cp.nian,t_cp.yue,t_yg.ygh,cplx
,t_fenduan.资产段_2013_细
--,t_fenduan.资产段_2013_粗
,是否产品新客户,资产段
/* having 
	销售金额_月累计_原始+
	赎回金额_月累计_原始+
	销售金额_年累计_原始+
	赎回金额_年累计_原始+
	期初市值_原始+
	期末市值_原始+
	月日均市值_原始<>0
order by t_cp.nian,t_cp.yue,t_yg.ygh,cplx,t_fenduan.资产段_2013_粗,是否产品新客户,资产段 */
);
