--特殊账户
drop table #temp_teshu;
create table #temp_teshu
(	
	zjzh varchar(128)	
	,constraint pk_skb_temp_teshu primary key (zjzh)
);

--大小非客户
drop table #temp_dxf;
create table #temp_dxf
(
	zjzh varchar(128)
	,constraint pk_skb_temp_dxf primary key (zjzh)
);

--内部创设产品
drop table #temp_nbcscp;
create table #temp_nbcscp
(
	jjdm varchar(128)
	,jjmc varchar(128)
	,jjgs varchar(128)
	,jjlb varchar(128)
	,constraint pk_skb_temp_nbcscp primary key (jjdm)
);

--财富中心对照
drop table #temp_cfzx;
create table #temp_cfzx
(
	ygh varchar(128),
	ygxm varchar(128),
	constraint pk_skb_temp_cfzx primary key (ygh)
);

--营业部对照表（增加财富中心）
drop table #temp_yybdz;
create table #temp_yybdz
(
	jgbh varchar(128)
	,jgmc varchar(128)
	,zxyybbh varchar(128)
	,zxyybmc varchar(128)
	,fgs varchar(128)
	,jgfl varchar(128)
	,dqfl varchar(128)
	,mbkhzc numeric(20,4)
	,szcs varchar(128)
	,jgqc varchar(128)
	,constraint pk_skb_temp_yybdz primary key (jgbh)
);

--产品分类考核系数
drop table #temp_khxs;
create table #temp_khxs
(
	产品类型 					varchar(128)	not null,
	考核系数 					numeric(20,4),	
	责权关系类型					varchar(128),--对应责任权益关系业务类别	
	constraint pk_skb_temp_khxs primary key (产品类型)
);

--责任权益关系表:1、行列转化；2、存放当前月份和上年末
drop table #temp_gx;
create table #temp_gx
(
	nian		varchar(4)
	,yue		varchar(2)
	,khbh_hs	varchar(128)
	,ygh		varchar(128)	
	,jxbl_1		numeric(20,4)
	,jxbl_2		numeric(20,4)
	,jxbl_3		numeric(20,4)
	,jxbl_4		numeric(20,4)
	,jxbl_5		numeric(20,4)
	,jxbl_6		numeric(20,4)
	,jxbl_7		numeric(20,4)
	,jxbl_8		numeric(20,4)
	,jxbl_9		numeric(20,4)
	,jxbl_10	numeric(20,4)
	,jxbl_11	numeric(20,4)	
	,jxbl_12	numeric(20,4)
	,constraint pk_skb_temp_gx primary key (nian,yue,khbh_hs,ygh)
);

drop table #temp_khcp;
create table #temp_khcp
(
	nian						varchar(4)		not null,--年
	yue 						varchar(2)		not null,--月
	zjzh 						varchar(128)	not null,--资金帐号		
--	jjdm						varchar(128)	not null,--基金代码
	产品类型						varchar(128)	not null,
	责权关系类型					varchar(128)	not null,
	--未扣减数据
	销售金额_月累计_原始			numeric(20,4),
	销售金额_月累计_考核			numeric(20,4),
	赎回金额_月累计_原始			numeric(20,4),
	赎回金额_月累计_考核			numeric(20,4),
	销售金额_年累计_原始			numeric(20,4),
	销售金额_年累计_考核			numeric(20,4),
	赎回金额_年累计_原始			numeric(20,4),
	赎回金额_年累计_考核			numeric(20,4),
	期初市值_原始				numeric(20,4),--去年末市值
	期初市值_考核				numeric(20,4),--去年末市值
	期末市值_原始				numeric(20,4),
	期末市值_考核				numeric(20,4),
	月日均市值_原始				numeric(20,4),
	月日均市值_考核				numeric(20,4),
	年日均市值_原始				numeric(20,4),
	年日均市值_考核				numeric(20,4),
	认申购手续费_月累计			numeric(20,4),
	认申购手续费_年累计			numeric(20,4),		
	--资管总部销售待扣减项
	销售金额_月累计_总部_原始		numeric(20,4),
	销售金额_月累计_总部_考核		numeric(20,4),
	赎回金额_月累计_总部_原始		numeric(20,4),
	赎回金额_月累计_总部_考核		numeric(20,4),
	销售金额_年累计_总部_原始		numeric(20,4),
	销售金额_年累计_总部_考核		numeric(20,4),
	赎回金额_年累计_总部_原始		numeric(20,4),
	赎回金额_年累计_总部_考核		numeric(20,4),
	期初市值_总部_原始			numeric(20,4),--去年末市值
	期初市值_总部_考核			numeric(20,4),--去年末市值
	期末市值_总部_原始			numeric(20,4),
	期末市值_总部_考核			numeric(20,4),
	月日均市值_总部_原始			numeric(20,4),
	月日均市值_总部_考核			numeric(20,4),
	年日均市值_总部_原始			numeric(20,4),
	年日均市值_总部_考核			numeric(20,4),		
	--扣除总部销售后
	销售金额_月累计_扣减后_原始	numeric(20,4),
	销售金额_月累计_扣减后_考核	numeric(20,4),
	赎回金额_月累计_扣减后_原始	numeric(20,4),
	赎回金额_月累计_扣减后_考核	numeric(20,4),
	销售金额_年累计_扣减后_原始	numeric(20,4),
	销售金额_年累计_扣减后_考核	numeric(20,4),
	赎回金额_年累计_扣减后_原始	numeric(20,4),
	赎回金额_年累计_扣减后_考核	numeric(20,4),
	期初市值_扣减后_原始			numeric(20,4),--去年末市值
	期初市值_扣减后_考核			numeric(20,4),--去年末市值
	期末市值_扣减后_原始			numeric(20,4),
	期末市值_扣减后_考核			numeric(20,4),
	月日均市值_扣减后_原始		numeric(20,4),
	月日均市值_扣减后_考核		numeric(20,4),
	年日均市值_扣减后_原始		numeric(20,4),
	年日均市值_扣减后_考核		numeric(20,4),	
	--首发数据
	销售金额_月累计_首发_原始 	numeric(20,4),
	销售金额_月累计_首发_考核 	numeric(20,4),
	销售金额_年累计_首发_原始 	numeric(20,4),
	销售金额_年累计_首发_考核 	numeric(20,4),
	认申购手续费_月累计_首发		numeric(20,4),
	认申购手续费_年累计_首发		numeric(20,4),	
	--换购数据
	换购金额_月累计				numeric(20,4),
	换购金额_年累计				numeric(20,4),	
	constraint pk_skb_temp_khcp primary key (nian,yue,zjzh,产品类型,责权关系类型)
);
--存放客户分类属性
drop table #temp_khsx;
create table #temp_khsx
(
	nian					varchar(4)		not null,--年
	yue 					varchar(2)		not null,--月
	zjzh 					varchar(128)	not null,--资金帐号		
	khbh_hs					varchar(128)	not null,--资金帐号
	jgbh					varchar(128),
	目标客户标准				numeric(20,4),
	资产段					varchar(128),
	资产段_上年末			varchar(128),
	总资产_月日均			numeric(20,4),
	总资产_月日均_上年末		numeric(20,4),
	账户性质					varchar(128),
	是否年新增				int,
	是否月新增				int,
	是否大小非客户			int,
	是否营业部目标客户		int,
	是否有效户				int,
	是否产品新客户			int,
	
	--月日均资产
	月日均有效二级资产 		numeric(20,4),
	月日均公募基金保有_考核	numeric(20,4),
	月日均定向保有_考核		numeric(20,4),
	月日均集合理财保有_考核	numeric(20,4),
	产品月日均有效市值 		numeric(20,4),
	月日均有效总资产			numeric(20,4),
	月日均资产				numeric(20,4),
	月日均资产_大小非		numeric(20,4),
	月日均资产_不含大小非		numeric(20,4),
	月日均保证金				numeric(20,4),
	
	月日均股基市值			numeric(20,4),
	月日均债券市值			numeric(20,4),
	月日均回购市值			numeric(20,4),
	
	月日均公募基金保有		numeric(20,4), 			--kh2012表: kfsjj_cwbysz_yrj +   	开放式基金场外保有市值_月日均         
	月日均核心公募基金保有	numeric(20,4), 		--kh2012表: kfsjj_cwbysz_hx_yrj	开放式基金场外保有市值_核心基金_月日均
	月日均定向保有			numeric(20,4), 				--kh2012表: dxcp_cwbysz_yrj
	月日均集合理财保有		numeric(20,4), 			--kh2012表: 
	月日均产品保有			numeric(20,4), 				--加工指标=月日均公募基金保有+月日均定向保有+月日均集合理财保有
	月日均约定购回净资产		numeric(20,4), 		--kh2012表: ydghjzc_yrj	约定购回净资产_月日均
	月日均其他资产			numeric(20,4), 
	月日均标准资产			numeric(20,4),  			--kh2012表: bzzc_yrj	标准资产_月日均
	
	--------------------折算方法二-------------------
	月日均货币型基金 numeric(20,4), 
	月日均无手续费债券型基金 numeric(20,4), 
	月日均低风险_原始 numeric(20,4), 
	月日均低风险_封顶待扣除 numeric(20,4), 
	月日均资产_大小非_三千万封顶 numeric(20,4),
	月日均资产_大小非_封顶 numeric(20,4), 
	月日均折算资产_方法二 numeric(20,4), 
	
	--------------期末资产------------
	期末有效二级资产 numeric(20,4), 			--kh2012表: qmyxzc	期末有效资产
	期末公募基金保有_考核 numeric(20,4), 			--kh2012表:
	期末定向保有_考核 numeric(20,4), 			--kh2012表:
	期末集合理财保有_考核 numeric(20,4), 			--kh2012表:
	产品期末有效市值 numeric(20,4), 			--kh2012表: 				待增加
	期末有效总资产 numeric(20,4), 				--kh2012表: 				待增加
	期末资产 numeric(20,4), 					--kh2012表: 				待增加
	期末资产_大小非 numeric(20,4), 			--kh2012表: 				待增加
	期末资产_不含大小非 numeric(20,4), 		--kh2012表: 				待增加
	期末保证金 numeric(20,4), 					--kh2012表: 				待增加
	
	期末股基市值 numeric(20,4), 				--kh2012表: gpjjqmsz		股票基金期末市值
	期末债券市值 numeric(20,4), 				--kh2012表: zqqmsz 			债券期末市值
	期末回购市值 numeric(20,4), 				--kh2012表: bzqqmsz      	标准券期末市值
	
	期末公募基金保有 numeric(20,4), 		--kh2012表:kfsjj_cwbyqmsz  场外开放式基金保有期末市值
	期末核心公募基金保有 numeric(20,4), 		--kh2012表:kfsjj_cwbyqmsz_hx  	场外开放式基金保有期末市值_其中核心基金

	期末定向保有 numeric(20,4), 			--kh2012表: dxcp_cwbyqmsz  	定向产品场外保有期末市值 
	期末集合理财保有 numeric(20,4), 		--kh2012表: zgcp_cwbyqmsz  	资管产品场外保有期末市值  
	期末产品保有 numeric(20,4), 			--加工指标=期末公募基金保有+期末定向保有+期末集合理财保有
	期末约定购回净资产 numeric(20,4),		--kh2012表: ydghjzc_qm		约定购回净资产_期末
	期末其他资产 numeric(20,4), 
	期末标准资产 numeric(20,4),  			--kh2012表: qmbzzc	期末标准资产

	--------------------折算方法二-------------------
	期末货币型基金 numeric(20,4), 
	期末无手续费债券型基金 numeric(20,4), 
	期末低风险_原始 numeric(20,4), 
	期末低风险_封顶待扣除 numeric(20,4), 
	期末资产_大小非_三千万封顶 numeric(20,4), 
	期末资产_大小非_封顶 numeric(20,4), 
	期末折算资产_方法二 numeric(20,4), 
	
	
	年日均保证金_计算利差使用 numeric(20,4), 			--kh2012表: bzjye_nrj    	年日均保证金 
	
	--------------收入_月累计------------
	佣金收入_月累计 numeric(20,4), 					--kh2012表: ejcs_m-lcsr_m	待增加
	利差收入_月累计 numeric(20,4), 					--kh2012表: lcsr_m
	二级收入_月累计 numeric(20,4), 					--kh2012表: ejcs_m
	
	
	融资融券信用交易净收入_月累计 numeric(20,4), 		--kh2012表: rzrq_xyjyjsr_m	融资融券信用交易收入_月，累加
	融资融券利息收入_月累计 numeric(20,4), 			--kh2012表: rzrq_lxsr_m		融资融券利息收入_月，累加
	
	开放式基金手续费_月累计 numeric(20,4), 			--kh2012表: kfsjj_cwsxf_m	开放式基金场外手续费_月
														--		+kfsjj_cnrgsxf_m	开放式基金场内手续费_月
	定向产品手续费_月累计 numeric(20,4), 				--kh2012表: dxcp_cwsxf_m	定向产品场外手续费_月
														--		+dxcp_cnrgsxf_m		定向产品场内认购手续费_月
	资管产品手续费_月累计 numeric(20,4), 				--kh2012表: zgcp_cwsxf_m	资管产品场外手续费_月
														--		+zgcp_cnrgsxf_m		资管产品场内手续费_月

	公募基金分仓转移_月累计 numeric(20,4),				--kh2012表: kfsjj_zydjzfsr_m   	公募基金转移定价支付收入(需更新，增加保有分仓收入)

	
	
	--------------收入_年累计------------
	佣金收入_年累计 numeric(20,4), 					--kh2012表: ejcs_m-lcsr_m	待增加
	利差收入_年累计 numeric(20,4), 					--kh2012表: lcsr_m
	二级收入_年累计 numeric(20,4), 					--kh2012表: ejcs_m
	
	
	融资融券信用交易净收入_年累计 numeric(20,4), 		--kh2012表: rzrq_xyjyjsr_m	融资融券信用交易收入_月，累加
	融资融券利息收入_年累计 numeric(20,4), 			--kh2012表: rzrq_lxsr_m		融资融券利息收入_月，累加
	
	开放式基金手续费_年累计 numeric(20,4), 			--kh2012表: kfsjj_cwsxf_m	开放式基金场外手续费_月
														--		+kfsjj_cnrgsxf_m	开放式基金场内手续费_月
	定向产品手续费_年累计 numeric(20,4), 				--kh2012表: dxcp_cwsxf_m	定向产品场外手续费_月
														--		+dxcp_cnrgsxf_m		定向产品场内认购手续费_月
	资管产品手续费_年累计 numeric(20,4), 				--kh2012表: zgcp_cwsxf_m	资管产品场外手续费_月
														--		+zgcp_cnrgsxf_m		资管产品场内手续费_月

	公募基金分仓转移_年累计 numeric(20,4),				--kh2012表: kfsjj_zydjzfsr_m   	公募基金转移定价支付收入(需更新，增加保有分仓收入)

	-------产品销售_月累计------
	开放式基金销售金额_月累计 numeric(20,4),					--kh2012表: kfsjj_cwxsje_m	场外开放式基金销售金额_月
																--		+ kfsjj_cnrgje_m		场内开放式基金认购金额_月
	开放式基金销售金额_其中核心基金_月累计 numeric(20,4),		--kh2012表: kfsjj_cwxsje_hx_m	开放式基金场外销售金额_核心_月
	资管产品销售金额_月累计 numeric(20,4),						--kh2012表: zgcp_cwxsje_m  + zgcp_cnrgje_m
	定向产品销售金额_月累计 numeric(20,4),						--kh2012表: dxcp_cwxsje_m + dxcp_cnrgje_m
	
	-------产品销售_年累计------
	开放式基金销售金额_年累计 numeric(20,4),					--kh2012表: kfsjj_cwxsje_m	场外开放式基金销售金额_月
																--		+ kfsjj_cnrgje_m		场内开放式基金认购金额_月
	开放式基金销售金额_其中核心基金_年累计 numeric(20,4),		--kh2012表: kfsjj_cwxsje_hx_m	开放式基金场外销售金额_核心_月
	资管产品销售金额_年累计 numeric(20,4),						--kh2012表: zgcp_cwxsje_m  + zgcp_cnrgje_m
	定向产品销售金额_年累计 numeric(20,4),						--kh2012表: dxcp_cwxsje_m + dxcp_cnrgje_m
						

	--------------产品保有------------
	开放式基金场外保有市值_月日均 numeric(20,4), 			--kh2012表: kfsjj_cwbysz_yrj	开放式基金场外保有市值_月日均
	开放式基金场外保有市值_核心基金_月日均 numeric(20,4), 	--kh2012表: kfsjj_cwbysz_hx_yrj	开放式基金场外保有市值_核心基金_月日均
	资管产品场外保有市值_月日均 numeric(20,4),  			--kh2012表: zgcp_cwbysz_yrj
	定向产品场外保有市值_月日均 numeric(20,4),  			--kh2012表: dxcp_cwbysz_yrj
	
	
	
	--------------二级股基------------
	gj交易量_月累计_含根网 numeric(20,4), 					--含融资融券普通交易,不含信用交易
	gj交易量_月累计_扣根网 numeric(20,4), 
	gj净佣金_月累计 numeric(20,4), 						--含过户费一半
	gj交易量_年累计_含根网 numeric(20,4), 
	gj交易量_年累计_扣根网 numeric(20,4), 
	gj净佣金_年累计 numeric(20,4),
	
	债券交易量_月累计 numeric(20,4),  			--kh2012表: zqjyl_m  	债券交易量_月累计   
	回购交易量_月累计 numeric(20,4),  			--kh2012表: zhgjyl_m	正回购交易量_月累计 + nhgjyl_m	逆回购交易量_月累计
	债券净佣金_月累计 numeric(20,4),  			--kh2012表: 
	回购净佣金_月累计 numeric(20,4),  			--kh2012表: 
	
	债券交易量_年累计 numeric(20,4),  			--kh2012表: 
	回购交易量_年累计 numeric(20,4),  			--kh2012表: 
	债券净佣金_年累计 numeric(20,4),  			--kh2012表: 
	回购净佣金_年累计 numeric(20,4),  			--kh2012表: 
	
	constraint pk_skb_temp_khsx primary key (nian,yue,zjzh,khbh_hs)
);
--体外产品客户属性
drop table #temp_khsx_tw;
create table #temp_khsx_tw
(
	nian					varchar(4)		not null,--年
	yue 					varchar(2)		not null,--月
	zjzh 					varchar(128)	not null,--资金帐号
	ygh 					varchar(128)	not null,--员工号		
	jgbh					varchar(128)	not null,--机构编号
	sfkh					int,					 --是否已经在我司开立资金账户
	资产段					varchar(128),
	期末总资产				numeric(20,4),
	总资产_月日均			numeric(20,4),	
	是否年新增				int,
	是否月新增				int,	
	是否营业部目标客户		int,	
	constraint pk_skb_temp_khsx_tw primary key (nian,yue,zjzh,ygh,jgbh)
);
--增加分公司本部特殊处理
drop table #temp_yg;
create table #temp_yg
(
	nian		varchar(4)
	,yue		varchar(2)
	,ygh		varchar(128)
	,jgbh		varchar(128)	
);
drop table #temp_ygcp;
create table #temp_ygcp
(
	nian 						varchar(4)		not null,--年
	yue 						varchar(2)		not null,--月		
	ygh							varchar(128)	not null,--员工号
	是否产品新客户				int				not null,--是否产品新客户
	资产段						varchar(128)	not null,--资产段		
	
	资产段_上年末				varchar(128)	not null,--资产段_上年末		
	账户性质						varchar(128)	not null,--账户性质		
	是否年新增					int				not null,--是否年新增		
	是否月新增					int				not null,--是否月新增
	是否大小非客户				int				not null,--是否大小非客户
	是否营业部目标客户			int				not null,--是否营业部目标客户
	是否有效户					int				not null,--是否有效户
	
	产品类型						varchar(128)	not null,--产品类型	
	
	销售金额_月累计_原始			numeric(20,4),
	销售金额_月累计_考核			numeric(20,4),
	赎回金额_月累计_原始			numeric(20,4),
	赎回金额_月累计_考核			numeric(20,4),
	销售金额_年累计_原始			numeric(20,4),
	销售金额_年累计_考核			numeric(20,4),
	赎回金额_年累计_原始			numeric(20,4),
	赎回金额_年累计_考核			numeric(20,4),
	期初市值_原始				numeric(20,4),
	期初市值_考核				numeric(20,4),
	期末市值_原始				numeric(20,4),
	期末市值_考核				numeric(20,4),
	月日均市值_原始				numeric(20,4),
	月日均市值_考核				numeric(20,4),
	年日均市值_原始				numeric(20,4),
	年日均市值_考核				numeric(20,4),
	手续费_月累计				numeric(20,4),
	手续费_年累计				numeric(20,4),	
	销售金额_月累计_首发_原始 	numeric(20,4),
	销售金额_月累计_首发_考核 	numeric(20,4),
	销售金额_年累计_首发_原始 	numeric(20,4),
	销售金额_年累计_首发_考核 	numeric(20,4),
	手续费_月累计_首发			numeric(20,4),
	手续费_年累计_首发			numeric(20,4),
	constraint pk_temp_ygcp primary key (nian,yue,ygh,是否产品新客户,资产段,资产段_上年末,账户性质,是否年新增,是否月新增,是否大小非客户,是否营业部目标客户,是否有效户,产品类型)
);
