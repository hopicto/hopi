
drop table #temp_khsx;
/*==================STEP 3_客户属性表==================*/

create table #temp_khsx
(
	---------客户属性--------
	分公司 varchar(128),
	中心营业部 varchar(128),
	营业部 varchar(128),
	zjzh varchar(128),
	khbh_hs varchar(128),
	nian varchar(128),
	yue varchar(128),
	sfxz_y int,
	sfxz_m int,
	sfyxh int,									--kh2012表: sfyxh 	是否有效户
	sfdxfkh int,								--kh2012表: sfdxfkh 是否大小非客户

	khzt varchar(128),							--kh2012表: zhzt  	账户状态
	账户性质 varchar(128),						--客户综合分析月
	资产段_2012_细 varchar(128),						--加工指标
	资产段_2013_细 varchar(128),						--加工指标
	资产段_2012_粗 varchar(128),						--加工指标
	资产段_2013_粗 varchar(128),						--加工指标
	目标客户标准 numeric(38,10), 				--营业部对照表
	是否目标客户 int,							--加工指标
	sfcpxkh int,							--kh2012表: sfcpxkh		是否产品新客户
	--------------月日均资产------------
	月日均有效二级资产 numeric(38,10), 			--kh2012表:yxzc_yrj     	有效资产_月日均
	月日均公募基金保有_考核 numeric(38,10), 			--kh2012表:
	月日均定向保有_考核 numeric(38,10), 			--kh2012表:
	月日均集合理财保有_考核 numeric(38,10), 			--kh2012表:
	产品月日均有效市值 numeric(38,10), 			--kh2012表: 				待增加
	月日均有效总资产 numeric(38,10), 			--kh2012表: 				待增加
	月日均资产 numeric(38,10), 					--kh2012表: 				待增加
	月日均资产_大小非 numeric(38,10), 			--kh2012表: 				待增加
	月日均资产_不含大小非 numeric(38,10), 		--kh2012表: 				待增加
	月日均保证金 numeric(38,10), 				--kh2012表: 				待增加
	
	月日均股基市值 numeric(38,10), 				--kh2012表: gpjjsz_yrj   	股票基金市值_月日均
	月日均债券市值 numeric(38,10), 				--kh2012表: zqsz_yrj     	债券市值_月日均
	月日均回购市值 numeric(38,10), 				--kh2012表: bzqsz_yrj    	标准券市值_月日均
	--
	月日均公募基金保有 numeric(38,10), 			--kh2012表: kfsjj_cwbysz_yrj +   	开放式基金场外保有市值_月日均         
	月日均核心公募基金保有 numeric(38,10), 		--kh2012表: kfsjj_cwbysz_hx_yrj	开放式基金场外保有市值_核心基金_月日均
	月日均定向保有 numeric(38,10), 				--kh2012表: dxcp_cwbysz_yrj
	月日均集合理财保有 numeric(38,10), 			--kh2012表: 
	月日均产品保有 numeric(38,10), 				--加工指标=月日均公募基金保有+月日均定向保有+月日均集合理财保有
	月日均约定购回净资产 numeric(38,10), 		--kh2012表: ydghjzc_yrj	约定购回净资产_月日均
	月日均其他资产 numeric(38,10), 
	月日均标准资产 numeric(38,10),  			--kh2012表: bzzc_yrj	标准资产_月日均
	
	--------------------折算方法二-------------------
	月日均货币型基金 numeric(38,10), 
	月日均无手续费债券型基金 numeric(38,10), 
	月日均低风险_原始 numeric(38,10), 
	月日均低风险_封顶待扣除 numeric(38,10), 
	月日均资产_大小非_三千万封顶 numeric(38,10),
	月日均资产_大小非_封顶 numeric(38,10), 
	月日均折算资产_方法二 numeric(38,10), 
	
	--------------期末资产------------
	期末有效二级资产 numeric(38,10), 			--kh2012表: qmyxzc	期末有效资产
	期末公募基金保有_考核 numeric(38,10), 			--kh2012表:
	期末定向保有_考核 numeric(38,10), 			--kh2012表:
	期末集合理财保有_考核 numeric(38,10), 			--kh2012表:
	产品期末有效市值 numeric(38,10), 			--kh2012表: 				待增加
	期末有效总资产 numeric(38,10), 				--kh2012表: 				待增加
	期末资产 numeric(38,10), 					--kh2012表: 				待增加
	期末资产_大小非 numeric(38,10), 			--kh2012表: 				待增加
	期末资产_不含大小非 numeric(38,10), 		--kh2012表: 				待增加
	期末保证金 numeric(38,10), 					--kh2012表: 				待增加
	
	期末股基市值 numeric(38,10), 				--kh2012表: gpjjqmsz		股票基金期末市值
	期末债券市值 numeric(38,10), 				--kh2012表: zqqmsz 			债券期末市值
	期末回购市值 numeric(38,10), 				--kh2012表: bzqqmsz      	标准券期末市值
	
	期末公募基金保有 numeric(38,10), 		--kh2012表:kfsjj_cwbyqmsz  场外开放式基金保有期末市值
	期末核心公募基金保有 numeric(38,10), 		--kh2012表:kfsjj_cwbyqmsz_hx  	场外开放式基金保有期末市值_其中核心基金

	期末定向保有 numeric(38,10), 			--kh2012表: dxcp_cwbyqmsz  	定向产品场外保有期末市值 
	期末集合理财保有 numeric(38,10), 		--kh2012表: zgcp_cwbyqmsz  	资管产品场外保有期末市值  
	期末产品保有 numeric(38,10), 			--加工指标=期末公募基金保有+期末定向保有+期末集合理财保有
	期末约定购回净资产 numeric(38,10),		--kh2012表: ydghjzc_qm		约定购回净资产_期末
	期末其他资产 numeric(38,10), 
	期末标准资产 numeric(38,10),  			--kh2012表: qmbzzc	期末标准资产

	--------------------折算方法二-------------------
	期末货币型基金 numeric(38,10), 
	期末无手续费债券型基金 numeric(38,10), 
	期末低风险_原始 numeric(38,10), 
	期末低风险_封顶待扣除 numeric(38,10), 
	期末资产_大小非_三千万封顶 numeric(38,10), 
	期末资产_大小非_封顶 numeric(38,10), 
	期末折算资产_方法二 numeric(38,10), 
	
	
	年日均保证金_计算利差使用 numeric(38,10), 			--kh2012表: bzjye_nrj    	年日均保证金 
	
	--------------收入_月累计------------
	佣金收入_月累计 numeric(38,10), 					--kh2012表: ejcs_m-lcsr_m	待增加
	利差收入_月累计 numeric(38,10), 					--kh2012表: lcsr_m
	二级收入_月累计 numeric(38,10), 					--kh2012表: ejcs_m
	
	
	融资融券信用交易净收入_月累计 numeric(38,10), 		--kh2012表: rzrq_xyjyjsr_m	融资融券信用交易收入_月，累加
	融资融券利息收入_月累计 numeric(38,10), 			--kh2012表: rzrq_lxsr_m		融资融券利息收入_月，累加
	
	开放式基金手续费_月累计 numeric(38,10), 			--kh2012表: kfsjj_cwsxf_m	开放式基金场外手续费_月
														--		+kfsjj_cnrgsxf_m	开放式基金场内手续费_月
	定向产品手续费_月累计 numeric(38,10), 				--kh2012表: dxcp_cwsxf_m	定向产品场外手续费_月
														--		+dxcp_cnrgsxf_m		定向产品场内认购手续费_月
	资管产品手续费_月累计 numeric(38,10), 				--kh2012表: zgcp_cwsxf_m	资管产品场外手续费_月
														--		+zgcp_cnrgsxf_m		资管产品场内手续费_月

	公募基金分仓转移_月累计 numeric(38,10),				--kh2012表: kfsjj_zydjzfsr_m   	公募基金转移定价支付收入(需更新，增加保有分仓收入)

	
	
	--------------收入_年累计------------
	佣金收入_年累计 numeric(38,10), 					--kh2012表: ejcs_m-lcsr_m	待增加
	利差收入_年累计 numeric(38,10), 					--kh2012表: lcsr_m
	二级收入_年累计 numeric(38,10), 					--kh2012表: ejcs_m
	
	
	融资融券信用交易净收入_年累计 numeric(38,10), 		--kh2012表: rzrq_xyjyjsr_m	融资融券信用交易收入_月，累加
	融资融券利息收入_年累计 numeric(38,10), 			--kh2012表: rzrq_lxsr_m		融资融券利息收入_月，累加
	
	开放式基金手续费_年累计 numeric(38,10), 			--kh2012表: kfsjj_cwsxf_m	开放式基金场外手续费_月
														--		+kfsjj_cnrgsxf_m	开放式基金场内手续费_月
	定向产品手续费_年累计 numeric(38,10), 				--kh2012表: dxcp_cwsxf_m	定向产品场外手续费_月
														--		+dxcp_cnrgsxf_m		定向产品场内认购手续费_月
	资管产品手续费_年累计 numeric(38,10), 				--kh2012表: zgcp_cwsxf_m	资管产品场外手续费_月
														--		+zgcp_cnrgsxf_m		资管产品场内手续费_月

	公募基金分仓转移_年累计 numeric(38,10),				--kh2012表: kfsjj_zydjzfsr_m   	公募基金转移定价支付收入(需更新，增加保有分仓收入)

	-------产品销售_月累计------
	开放式基金销售金额_月累计 numeric(38,10),					--kh2012表: kfsjj_cwxsje_m	场外开放式基金销售金额_月
																--		+ kfsjj_cnrgje_m		场内开放式基金认购金额_月
	开放式基金销售金额_其中核心基金_月累计 numeric(38,10),		--kh2012表: kfsjj_cwxsje_hx_m	开放式基金场外销售金额_核心_月
	资管产品销售金额_月累计 numeric(38,10),						--kh2012表: zgcp_cwxsje_m  + zgcp_cnrgje_m
	定向产品销售金额_月累计 numeric(38,10),						--kh2012表: dxcp_cwxsje_m + dxcp_cnrgje_m
	
	-------产品销售_年累计------
	开放式基金销售金额_年累计 numeric(38,10),					--kh2012表: kfsjj_cwxsje_m	场外开放式基金销售金额_月
																--		+ kfsjj_cnrgje_m		场内开放式基金认购金额_月
	开放式基金销售金额_其中核心基金_年累计 numeric(38,10),		--kh2012表: kfsjj_cwxsje_hx_m	开放式基金场外销售金额_核心_月
	资管产品销售金额_年累计 numeric(38,10),						--kh2012表: zgcp_cwxsje_m  + zgcp_cnrgje_m
	定向产品销售金额_年累计 numeric(38,10),						--kh2012表: dxcp_cwxsje_m + dxcp_cnrgje_m
						

	--------------产品保有------------
	开放式基金场外保有市值_月日均 numeric(38,10), 			--kh2012表: kfsjj_cwbysz_yrj	开放式基金场外保有市值_月日均
	开放式基金场外保有市值_核心基金_月日均 numeric(38,10), 	--kh2012表: kfsjj_cwbysz_hx_yrj	开放式基金场外保有市值_核心基金_月日均
	资管产品场外保有市值_月日均 numeric(38,10),  			--kh2012表: zgcp_cwbysz_yrj
	定向产品场外保有市值_月日均 numeric(38,10),  			--kh2012表: dxcp_cwbysz_yrj
	
	
	
	--------------二级股基------------
	gj交易量_月累计_含根网 numeric(38,10), 					--含融资融券普通交易,不含信用交易
	gj交易量_月累计_扣根网 numeric(38,10), 
	gj净佣金_月累计 numeric(38,10), 						--含过户费一半
	gj交易量_年累计_含根网 numeric(38,10), 
	gj交易量_年累计_扣根网 numeric(38,10), 
	gj净佣金_年累计 numeric(38,10),
	
	债券交易量_月累计 numeric(38,10),  			--kh2012表: zqjyl_m  	债券交易量_月累计   
	回购交易量_月累计 numeric(38,10),  			--kh2012表: zhgjyl_m	正回购交易量_月累计 + nhgjyl_m	逆回购交易量_月累计
	债券净佣金_月累计 numeric(38,10),  			--kh2012表: 
	回购净佣金_月累计 numeric(38,10),  			--kh2012表: 
	
	债券交易量_年累计 numeric(38,10),  			--kh2012表: 
	回购交易量_年累计 numeric(38,10),  			--kh2012表: 
	债券净佣金_年累计 numeric(38,10),  			--kh2012表: 
	回购净佣金_年累计 numeric(38,10),  			--kh2012表: 
		
	--完整明细	
	核心公募股票型销售_月累计 numeric(38,10),
	非核心公募股票型销售_月累计 numeric(38,10),
	公募债券型有手续费销售_月累计 numeric(38,10),
	公募债券型无手续费销售_月累计 numeric(38,10),
	公募货币型销售_月累计 numeric(38,10),
	集合理财股票型销售_月累计 numeric(38,10),
	集合理财债券型销售_月累计 numeric(38,10),
	集合理财货币型销售_月累计 numeric(38,10),
--	基金专户销售_月累计 numeric(38,10),
	基金专户股票型销售_月累计 numeric(38,10),
	基金专户债券型销售_月累计 numeric(38,10),
	基金专户货币型销售_月累计 numeric(38,10),
	
	核心公募股票型销售_年累计 numeric(38,10),
	非核心公募股票型销售_年累计 numeric(38,10),
	公募债券型有手续费销售_年累计 numeric(38,10),
	公募债券型无手续费销售_年累计 numeric(38,10),
	公募货币型销售_年累计 numeric(38,10),
	集合理财股票型销售_年累计 numeric(38,10),
	集合理财债券型销售_年累计 numeric(38,10),
	集合理财货币型销售_年累计 numeric(38,10),
--	基金专户销售_年累计 numeric(38,10),
	基金专户股票型销售_年累计 numeric(38,10),
	基金专户债券型销售_年累计 numeric(38,10),
	基金专户货币型销售_年累计 numeric(38,10),
	
	核心公募股票型保有_月日均 numeric(38,10),
	非核心公募股票型保有_月日均 numeric(38,10),
	公募债券型有手续费保有_月日均 numeric(38,10),
	公募债券型无手续费保有_月日均 numeric(38,10),
	公募货币型保有_月日均 numeric(38,10),
	集合理财股票型保有_月日均 numeric(38,10),
	集合理财债券型保有_月日均 numeric(38,10),
	集合理财货币型保有_月日均 numeric(38,10),
--	基金专户保有_月日均 numeric(38,10),
	基金专户股票型保有_月日均 numeric(38,10),
	基金专户债券型保有_月日均 numeric(38,10),
	基金专户货币型保有_月日均 numeric(38,10),
	
	核心公募股票型保有_年日均 numeric(38,10),
	非核心公募股票型保有_年日均 numeric(38,10),
	公募债券型有手续费保有_年日均 numeric(38,10),
	公募债券型无手续费保有_年日均 numeric(38,10),
	公募货币型保有_年日均 numeric(38,10),
	集合理财股票型保有_年日均 numeric(38,10),
	集合理财债券型保有_年日均 numeric(38,10),	
	集合理财货币型保有_年日均 numeric(38,10),
--	基金专户保有_年日均 numeric(38,10),
	基金专户股票型保有_年日均 numeric(38,10),
	基金专户债券型保有_年日均 numeric(38,10),
	基金专户货币型保有_年日均 numeric(38,10),
	
	
	核心公募股票型手续费_月累计 numeric(38,10),
	非核心公募股票型手续费_月累计 numeric(38,10),
	公募债券型有手续费手续费_月累计 numeric(38,10),
	公募债券型无手续费手续费_月累计 numeric(38,10),
	公募货币型手续费_月累计 numeric(38,10),
	集合理财股票型手续费_月累计 numeric(38,10),
	集合理财债券型手续费_月累计 numeric(38,10),
	集合理财货币型手续费_月累计 numeric(38,10),
--	基金专户手续费_月累计 numeric(38,10),
	基金专户股票型手续费_月累计 numeric(38,10),
	基金专户债券型手续费_月累计 numeric(38,10),
	基金专户货币型手续费_月累计 numeric(38,10),
	
	核心公募股票型手续费_年累计 numeric(38,10),
	非核心公募股票型手续费_年累计 numeric(38,10),
	公募债券型有手续费手续费_年累计 numeric(38,10),
	公募债券型无手续费手续费_年累计 numeric(38,10),
	公募货币型手续费_年累计 numeric(38,10),
	集合理财股票型手续费_年累计 numeric(38,10),
	集合理财债券型手续费_年累计 numeric(38,10),
	集合理财货币型手续费_年累计 numeric(38,10),
--	基金专户手续费_年累计 numeric(38,10)
	基金专户股票型手续费_年累计 numeric(38,10),
	基金专户债券型手续费_年累计 numeric(38,10)
	,基金专户货币型手续费_年累计 numeric(38,10)		
	
	,股基市值_期末_大小非三千万封顶	numeric(38,10)
	,股基市值_期末_大小非三千万封顶_创收	numeric(38,10)
	
	,股基市值加其他资产_期末_大小非三千万封顶	numeric(38,10)
	,股基市值加其他资产_期末_大小非三千万封顶_创收	numeric(38,10)
	
	,股基市值_月日均_大小非三千万封顶	numeric(38,10)
	,股基市值_月日均_大小非三千万封顶_创收	numeric(38,10)
	
	,股基市值加其他资产_月日均_大小非三千万封顶	numeric(38,10)
	,股基市值加其他资产_月日均_大小非三千万封顶_创收	numeric(38,10)
);


/*------------------②_导入客户明细------------------*/
declare @nian varchar(16),@yue varchar(16),@nian_dxf varchar(16),@yue_dxf varchar(16)
set @nian='2013'
set @yue='03'
set @nian_dxf='2013'
set @yue_dxf='03'

insert into #temp_khsx(分公司,中心营业部,营业部,zjzh,khbh_hs,nian,yue,sfxz_y,sfxz_m,sfyxh,sfdxfkh,khzt,账户性质
						,资产段_2012_细,资产段_2013_细,资产段_2012_粗,资产段_2013_粗,目标客户标准,是否目标客户,月日均有效二级资产
						,月日均公募基金保有_考核,月日均定向保有_考核,月日均集合理财保有_考核,产品月日均有效市值 --月日均产品_考核
						,月日均有效总资产,月日均资产,月日均资产_大小非,月日均资产_不含大小非,月日均保证金
						,月日均股基市值,月日均债券市值,月日均回购市值
						,月日均公募基金保有,月日均核心公募基金保有,月日均定向保有,月日均集合理财保有,月日均产品保有								--月日均产品_原始
						,月日均约定购回净资产,月日均其他资产,月日均标准资产
						-------折算资产_方法二------
						,月日均货币型基金,月日均无手续费债券型基金,月日均低风险_原始,月日均低风险_封顶待扣除,月日均资产_大小非_三千万封顶,月日均资产_大小非_封顶,月日均折算资产_方法二 		
						,期末有效二级资产
						,期末公募基金保有_考核,期末定向保有_考核,期末集合理财保有_考核,产品期末有效市值		   	--期末产品_考核
						,期末有效总资产,期末资产,期末资产_大小非,期末资产_不含大小非,期末保证金
						,期末股基市值,期末债券市值,期末回购市值
						,期末公募基金保有,期末核心公募基金保有,期末定向保有,期末集合理财保有,期末产品保有											--期末产品_原始
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
						-------股基交易------
						,gj交易量_月累计_含根网,gj交易量_月累计_扣根网,gj净佣金_月累计
						,gj交易量_年累计_含根网,gj交易量_年累计_扣根网,gj净佣金_年累计
						-------债券交易------
						,债券交易量_月累计,回购交易量_月累计,债券净佣金_月累计,回购净佣金_月累计
						,债券交易量_年累计,回购交易量_年累计,债券净佣金_年累计,回购净佣金_年累计,
						
	--完整明细	
	核心公募股票型销售_月累计,
	非核心公募股票型销售_月累计,
	公募债券型有手续费销售_月累计,
	公募债券型无手续费销售_月累计,
	公募货币型销售_月累计,
	集合理财股票型销售_月累计,
	集合理财债券型销售_月累计,
	集合理财货币型销售_月累计,
--	基金专户销售_月累计,
	基金专户股票型销售_月累计,
	基金专户债券型销售_月累计,
	基金专户货币型销售_月累计,
	
	核心公募股票型销售_年累计,
	非核心公募股票型销售_年累计,
	公募债券型有手续费销售_年累计,
	公募债券型无手续费销售_年累计,
	公募货币型销售_年累计,
	集合理财股票型销售_年累计,
	集合理财债券型销售_年累计,
	集合理财货币型销售_年累计,
--	基金专户销售_年累计,
	基金专户股票型销售_年累计,
	基金专户债券型销售_年累计,
	基金专户货币型销售_年累计,
	
	核心公募股票型保有_月日均,
	非核心公募股票型保有_月日均,
	公募债券型有手续费保有_月日均,
	公募债券型无手续费保有_月日均,
	公募货币型保有_月日均,
	集合理财股票型保有_月日均,
	集合理财债券型保有_月日均,
	集合理财货币型保有_月日均,
--	基金专户保有_月日均,
	基金专户股票型保有_月日均,
	基金专户债券型保有_月日均,
	基金专户货币型保有_月日均,
	
	核心公募股票型保有_年日均,
	非核心公募股票型保有_年日均,
	公募债券型有手续费保有_年日均,
	公募债券型无手续费保有_年日均,
	公募货币型保有_年日均,
	集合理财股票型保有_年日均,
	集合理财债券型保有_年日均,	
	集合理财货币型保有_年日均,
--	基金专户保有_年日均,
	基金专户股票型保有_年日均,
	基金专户债券型保有_年日均,
	基金专户货币型保有_年日均,
	
	
	核心公募股票型手续费_月累计,
	非核心公募股票型手续费_月累计,
	公募债券型有手续费手续费_月累计,
	公募债券型无手续费手续费_月累计,
	公募货币型手续费_月累计,
	集合理财股票型手续费_月累计,
	集合理财债券型手续费_月累计,
	集合理财货币型手续费_月累计,
--	基金专户手续费_月累计,
	基金专户股票型手续费_月累计,
	基金专户债券型手续费_月累计,
	基金专户货币型手续费_月累计,
	
	核心公募股票型手续费_年累计,
	非核心公募股票型手续费_年累计,
	公募债券型有手续费手续费_年累计,
	公募债券型无手续费手续费_年累计,
	公募货币型手续费_年累计,
	集合理财股票型手续费_年累计,
	集合理财债券型手续费_年累计,
	集合理财货币型手续费_年累计,
--	基金专户手续费_年累计
	基金专户股票型手续费_年累计,
	基金专户债券型手续费_年累计
	,基金专户货币型手续费_年累计
	
	,股基市值_期末_大小非三千万封顶
	,股基市值_期末_大小非三千万封顶_创收
	
	,股基市值加其他资产_期末_大小非三千万封顶
	,股基市值加其他资产_期末_大小非三千万封顶_创收
	
	,股基市值_月日均_大小非三千万封顶
	,股基市值_月日均_大小非三千万封顶_创收
	
	,股基市值加其他资产_月日均_大小非三千万封顶
	,股基市值加其他资产_月日均_大小非三千万封顶_创收	
)
(
	select
		t_yybdz.fgs as 分公司
		,t_yybdz.zxyybmc as 中心营业部
		,t_yybdz.jgmc as 营业部
		,t_yue.zjzh
		,t_yue.khbh_hs
		,t_yue.nian
		,t_yue.yue
		,t_yue.sfxz_y
		,t_yue.sfxz_m
		,t_yue.sfyxh  ----新口径
		,case when t_dxf.zjzh is not null then 1 else 0 end as sfdxfkh
		,t_yue.khzt
		,t_yue_zh.帐户性质 as 账户性质
		,case when 月日均资产_2012<=20*10000 then '1-小于20w'
			when 月日均资产_2012 > 20*10000 and 月日均资产_2012<=50*10000 then '2-20w_50w'
			when 月日均资产_2012 > 50*10000 and 月日均资产_2012<=100*10000 then '3-50w_100w'
			when 月日均资产_2012 > 100*10000 and 月日均资产_2012<=200*10000 then '4-100w_200w'
			when 月日均资产_2012 > 200*10000 and 月日均资产_2012<=300*10000 then '5-200w_300w'
			when 月日均资产_2012 > 300*10000 and 月日均资产_2012<=500*10000 then '6-300w_500w'
			when 月日均资产_2012 > 500*10000 and 月日均资产_2012<=1000*10000 then '7-500w_1000w'
			when 月日均资产_2012 > 1000*10000 and 月日均资产_2012<=3000*10000 then '8-1000w_3000w'
			when 月日均资产_2012 > 3000*10000 then '9->3000w'
		else '1-小于20w' end as 资产段_2012_细
		
		,case when 月日均资产_总<=20*10000 then '1-小于20w'
			when 月日均资产_总 > 20*10000 and 月日均资产_总<=50*10000 then '2-20w_50w'
			when 月日均资产_总 > 50*10000 and 月日均资产_总<=100*10000 then '3-50w_100w'
			when 月日均资产_总 > 100*10000 and 月日均资产_总<=200*10000 then '4-100w_200w'
			when 月日均资产_总 > 200*10000 and 月日均资产_总<=300*10000 then '5-200w_300w'
			when 月日均资产_总 > 300*10000 and 月日均资产_总<=500*10000 then '6-300w_500w'
			when 月日均资产_总 > 500*10000 and 月日均资产_总<=1000*10000 then '7-500w_1000w'
			when 月日均资产_总 > 1000*10000 and 月日均资产_总<=3000*10000 then '8-1000w_3000w'
			when 月日均资产_总 > 3000*10000 then '9->3000w'
		else '1-小于20w' end as 资产段_2013_细
		
		,case when 月日均资产_2012<=50*10000 then '1-小于50w'
			when 月日均资产_2012 > 50*10000 and 月日均资产_2012<=100*10000 then '2-50w_100w'
			when 月日均资产_2012 > 100*10000 then '3->100w'
		else '1-小于20w' end as 资产段_2012_粗
		
		,case when 月日均资产_总<=50*10000 then '1-小于50w'
			when 月日均资产_总 > 50*10000 and 月日均资产_总<=100*10000 then '2-50w_100w'
			when 月日均资产_总 > 100*10000 then '3->100w'
		else '1-小于50w' end as 资产段_2013_粗
		
		,t_yybdz.mbkhzc as 目标客户标准
		,case when 月日均资产_总>= (目标客户标准*10000) then 1 else 0 end as 是否目标客户
		
		------------月日均资产------------
		,case when t_yue.nian in('2011','2012') then t_yue.yxzc_yrj else t_yue.yxzc_yrj - t_yue.dxfzssz_yrj end as 月日均有效二级资产
		,t_cp.月日均公募基金保有_考核
		,t_cp.月日均定向保有_考核
		,t_cp.月日均集合理财保有_考核
		,t_cp.月日均产品有效市值 as 产品月日均有效市值
		,月日均有效二级资产+产品月日均有效市值 as 月日均有效总资产
		,t_yue_zh.日均资产 + t_yue_2011.rzrq_rjzc_m +月日均约定购回净资产 as 月日均资产_总
		,case when t_dxf.zjzh is not null then 月日均资产_总 else 0 end as 月日均资产_大小非
		,case when t_dxf.zjzh is null then 月日均资产_总 else 0 end as 月日均资产_不含大小非
		,t_yue_zh.日均余额 as 月日均保证金
		,t_yue.gpjjsz_yrj as 月日均股基市值
		,t_yue.zqsz_yrj as 月日均债券市值
		,t_yue.bzqsz_yrj as 月日均回购市值
		
--		,t_yue.kfsjj_cwbysz_yrj as 月日均公募基金保有
--		,t_yue.kfsjj_cwbysz_hx_yrj as 月日均核心公募基金保有
--		,t_yue.dxcp_cwbysz_yrj as 月日均定向保有
--		,t_yue.zgcp_cwbysz_yrj as 月日均集合理财保有		
		,t_cp.月日均公募基金保有_扣减资管总部销售 as 月日均公募基金保有
		,t_cp.月日均核心公募基金保有_扣减资管总部销售 as 月日均核心公募基金保有
		,t_cp.月日均定向保有_扣减资管总部销售 as 月日均定向保有 			
		,t_cp.月日均集合理财保有_扣减资管总部销售 as 月日均集合理财保有
		
		,月日均公募基金保有+月日均定向保有+月日均集合理财保有 as 月日均产品保有
		,coalesce(t_yue.ydghjzc_yrj,0) as 月日均约定购回净资产
		,月日均资产_总-月日均保证金-月日均股基市值-月日均债券市值-月日均回购市值-月日均产品保有-月日均约定购回净资产 as 月日均其他资产
		,t_yue.bzzc_yrj as 月日均标准资产
		
		------------------资产折算方法二------------------
		,t_cp.月日均货币型产品 as 月日均货币型基金
		,t_cp.月日均无手续费债券型产品 as 月日均无手续费债券型基金
		,月日均货币型基金 + 月日均无手续费债券型基金 + 月日均回购市值+月日均集合理财货币型+月日均基金专户货币型 as 月日均低风险_原始
		,case when 月日均低风险_原始>=300*10000 then 月日均低风险_原始 - 300*10000 else 0 end as 月日均低风险_封顶待扣除
		,case when t_dxf.zjzh is not null and 3000 * 10000 > 月日均资产_总 then 月日均资产_总
			  when t_dxf.zjzh is not null and 3000 * 10000 <= 月日均资产_总 then 3000 * 10000
			  else 0 end as 月日均资产_大小非_三千万封顶       --大小非资产封顶（大小非资产、按创收能力折算资产二者取大；并且以3000万封顶）
		,case when t_dxf.zjzh is not null and 月日均资产_大小非_三千万封顶>=(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then 月日均资产_大小非_三千万封顶 
			  when t_dxf.zjzh is not null and 月日均资产_大小非_三千万封顶<(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then (二级收入_月累计*(12/convert(int,@yue))*10000/80.12) 
			  else 0 end as 月日均资产_大小非_封顶
		,月日均资产_不含大小非 + 月日均资产_大小非_封顶 - 月日均低风险_封顶待扣除 as 月日均折算资产_方法二

		
		------------期末资产------------
		,case when t_yue.nian in('2011','2012') then t_yue.qmyxzc else t_yue.qmyxzc - t_yue.dxfzssz_qm end as 期末有效二级资产
		,t_cp.期末公募基金保有_考核
		,t_cp.期末定向保有_考核
		,t_cp.期末集合理财保有_考核
		,t_cp.期末产品有效市值 as 产品期末有效市值
		,期末有效二级资产+产品期末有效市值 as 期末有效总资产
		,t_yue_zh.期末资产 + t_yue_2011.rzrq_qmzc+ 期末约定购回净资产 as 期末资产_总
		,case when t_dxf.zjzh is not null then 期末资产_总 else 0 end as 期末资产_大小非
		,case when t_dxf.zjzh is null then 期末资产_总 else 0 end as 期末资产_不含大小非
		,t_yue_zh.期末余额 as 期末保证金
		,t_yue.gpjjqmsz as 期末股基市值
		,t_yue.zqqmsz as 期末债券市值
		,t_yue.bzqqmsz as 期末回购市值
--		,t_yue.kfsjj_cwbyqmsz as 期末公募基金保有  --！！
--		,t_yue.kfsjj_cwbyqmsz_hx as 期末核心公募基金保有
--		,t_yue.dxcp_cwbyqmsz as 期末定向保有
--		,t_yue.zgcp_cwbyqmsz as 期末集合理财保有

		,t_cp.期末公募基金保有_扣减资管总部销售 as 期末公募基金保有
		,t_cp.期末核心公募基金保有_扣减资管总部销售 as 期末核心公募基金保有
		,t_cp.期末定向保有_扣减资管总部销售 as 期末定向保有 			
		,t_cp.期末集合理财保有_扣减资管总部销售 as 期末集合理财保有
		
		,期末公募基金保有+期末定向保有+期末集合理财保有 as 期末产品保有
		,coalesce(t_yue.ydghjzc_qm,0) as 期末约定购回净资产
		,期末资产_总-期末保证金-期末股基市值-期末债券市值-期末回购市值-期末产品保有-期末约定购回净资产 as 期末其他资产
		,t_yue.qmbzzc as 期末标准资产
		
		------------------资产折算方法二------------------
		,t_cp.期末货币型产品 as 期末货币型基金
		,t_cp.期末无手续费债券型产品 as 期末无手续费债券型基金
		,期末货币型基金 + 期末无手续费债券型基金 + 期末回购市值+期末集合理财货币型+期末基金专户货币型 as 期末低风险_原始
		,case when 期末低风险_原始>=300*10000 then 期末低风险_原始 - 300*10000 else 0 end as 期末低风险_封顶待扣除
		,case when t_dxf.zjzh is not null and 3000*10000 > 期末资产_总 then 期末资产_总
			  when t_dxf.zjzh is not null and 3000*10000 <= 期末资产_总 then 3000*10000
			  else 0 end as 期末资产_大小非_三千万封顶       --大小非资产封顶（大小非资产、按创收能力折算资产二者取大；并且以3000万封顶）
		,case when t_dxf.zjzh is not null and	期末资产_大小非_三千万封顶>=(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then 期末资产_大小非_三千万封顶
			  when t_dxf.zjzh is not null and	期末资产_大小非_三千万封顶<(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then (二级收入_月累计*(12/convert(int,@yue))*10000/80.12)
			  else 0 end as 期末资产_大小非_封顶
		,期末资产_不含大小非 + 期末资产_大小非_封顶 - 期末低风险_封顶待扣除 as 期末折算资产_方法二

		,t_yue.bzjye_nrj as 年日均保证金_计算利差使用
		
		------------收入_月累计------------
		,t_yue.ejcs_m-t_yue.lcsr_m as 佣金收入_月累计
		,t_yue.lcsr_m as 利差收入_月累计
		,t_yue.ejcs_m as 二级收入_月累计
		,t_yue.rzrq_xyjyjsr_m as 融资融券信用交易净收入_月累计
		,t_yue.rzrq_lxsr_m as 融资融券利息收入_月累计
		,t_yue.kfsjj_cwsxf_m+t_yue.kfsjj_cnrgsxf_m as 开放式基金手续费_月累计
		,t_yue.dxcp_cwsxf_m+t_yue.dxcp_cnrgsxf_m as 定向产品手续费_月累计
		,t_yue.zgcp_cwsxf_m+t_yue.zgcp_cnrgsxf_m as 资管产品手续费_月累计
		,开放式基金销售金额_其中核心基金_月累计 * 20 * 8/10000 +   	--销售分仓
		  + 开放式基金场外保有市值_核心基金_月日均 * 4 * 8/(10000*12) as 公募基金分仓转移_月累计		--保有分仓

			
		------------收入_年累计------------
		,t_nian.佣金收入_年累计
		,t_nian.利差收入_年累计
		,t_nian.二级收入_年累计
		,t_nian.融资融券信用交易净收入_年累计
		,t_nian.融资融券利息收入_年累计
		,t_nian.开放式基金手续费_年累计
		,t_nian.定向产品手续费_年累计
		,t_nian.资管产品手续费_年累计
		,t_nian.公募基金分仓转移_年累计
		
		------------产品销售_月累计------------
		,t_yue.kfsjj_cwxsje_m + t_yue.kfsjj_cnrgje_m as 开放式基金销售金额_月累计
		,t_yue.kfsjj_cwxsje_hx_m + t_yue.kfsjj_cnrgje_hx_m as 开放式基金销售金额_其中核心基金_月累计
		
		,t_yue.zgcp_cwxsje_m  + t_yue.zgcp_cnrgje_m as 资管产品销售金额_月累计
		,t_yue.dxcp_cwxsje_m + t_yue.dxcp_cnrgje_m as 定向产品销售金额_月累计

		------------产品销售_年累计------------
		,t_nian.开放式基金销售金额_年累计
		,t_nian.开放式基金销售金额_其中核心基金_年累计
		,t_nian.资管产品销售金额_年累计
		,t_nian.定向产品销售金额_年累计
		
		------------产品保有------------
		,t_nian.开放式基金场外保有市值_月日均
		,t_nian.开放式基金场外保有市值_核心基金_月日均
		,t_nian.资管产品场外保有市值_月日均
		,t_nian.定向产品场外保有市值_月日均
		
		------------二级股基_交易收入------------
		,t_nian.gj交易量_月累计_含根网
		,t_nian.gj交易量_月累计_扣根网
		,t_nian.gj净佣金_月累计
		,t_nian.gj交易量_年累计_含根网
		,t_nian.gj交易量_年累计_扣根网
		,t_nian.gj净佣金_年累计
		
		------------债券交易------------
		,t_yue.zqjyl_m as 债券交易量_月累计
		,t_yue.zhgjyl_m + t_yue.nhgjyl_m as 回购交易量_月累计
		,t_yue_zh.国债累计净佣金 + t_yue_zh.企债累计净佣金 + t_yue_zh.转债累计净佣金 as 债券净佣金_月累计
		,t_yue_zh.回购累计净佣金 as 回购净佣金_月累计
		
		,t_nian.债券交易量_年累计 as 债券交易量_年累计
		,t_nian.回购交易量_年累计 as 回购交易量_年累计
		,t_nian_zh.国债累计净佣金 + t_nian_zh.企债累计净佣金 + t_nian_zh.转债累计净佣金 as 债券净佣金_年累计
		,t_nian_zh.回购累计净佣金 as 回购净佣金_年累计,
		
--完整明细
t_cp.核心公募股票型销售_月累计,
t_cp.非核心公募股票型销售_月累计,
t_cp.公募债券型有手续费销售_月累计,
t_cp.公募债券型无手续费销售_月累计,
t_cp.公募货币型销售_月累计,
t_cp.集合理财股票型销售_月累计,
t_cp.集合理财债券型销售_月累计,
t_cp.集合理财货币型销售_月累计,

t_cp.基金专户股票型销售_月累计,
t_cp.基金专户债券型销售_月累计,
t_cp.基金专户货币型销售_月累计,

t_cp.核心公募股票型销售_年累计,
t_cp.非核心公募股票型销售_年累计,
t_cp.公募债券型有手续费销售_年累计,
t_cp.公募债券型无手续费销售_年累计,
t_cp.公募货币型销售_年累计,
t_cp.集合理财股票型销售_年累计,
t_cp.集合理财债券型销售_年累计,
t_cp.集合理财货币型销售_年累计,

t_cp.基金专户股票型销售_年累计,
t_cp.基金专户债券型销售_年累计,
t_cp.基金专户货币型销售_年累计,

t_cp.核心公募股票型保有_月日均,
t_cp.非核心公募股票型保有_月日均,
t_cp.公募债券型有手续费保有_月日均,
t_cp.公募债券型无手续费保有_月日均,
t_cp.公募货币型保有_月日均,
t_cp.集合理财股票型保有_月日均,
t_cp.集合理财债券型保有_月日均,
t_cp.集合理财货币型保有_月日均,

t_cp.基金专户股票型保有_月日均,
t_cp.基金专户债券型保有_月日均,
t_cp.基金专户货币型保有_月日均,

t_cp.核心公募股票型保有_年日均,
t_cp.非核心公募股票型保有_年日均,
t_cp.公募债券型有手续费保有_年日均,
t_cp.公募债券型无手续费保有_年日均,
t_cp.公募货币型保有_年日均,
t_cp.集合理财股票型保有_年日均,
t_cp.集合理财债券型保有_年日均,
t_cp.集合理财货币型保有_年日均,

t_cp.基金专户股票型保有_年日均,
t_cp.基金专户债券型保有_年日均,
t_cp.基金专户货币型保有_年日均,

t_cp.核心公募股票型手续费_月累计,
t_cp.非核心公募股票型手续费_月累计,
t_cp.公募债券型有手续费手续费_月累计,
t_cp.公募债券型无手续费手续费_月累计,
t_cp.公募货币型手续费_月累计,
t_cp.集合理财股票型手续费_月累计,
t_cp.集合理财债券型手续费_月累计,
t_cp.集合理财货币型手续费_月累计,

t_cp.基金专户股票型手续费_月累计,
t_cp.基金专户债券型手续费_月累计,
t_cp.基金专户货币型手续费_月累计,

t_cp.核心公募股票型手续费_年累计,
t_cp.非核心公募股票型手续费_年累计,
t_cp.公募债券型有手续费手续费_年累计,
t_cp.公募债券型无手续费手续费_年累计,
t_cp.公募货币型手续费_年累计,
t_cp.集合理财股票型手续费_年累计,
t_cp.集合理财债券型手续费_年累计,
t_cp.集合理财货币型手续费_年累计,

t_cp.基金专户股票型手续费_年累计,
t_cp.基金专户债券型手续费_年累计,
t_cp.基金专户货币型手续费_年累计

,case when sfdxfkh=1 and t_yue.gpjjqmsz>3000*10000 then 3000*10000 else t_yue.gpjjqmsz end as 股基市值_期末_大小非三千万封顶
,case when sfdxfkh=1 and 股基市值_期末_大小非三千万封顶>=(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then 股基市值_期末_大小非三千万封顶 
	when sfdxfkh=1 and 股基市值_期末_大小非三千万封顶<(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then (二级收入_月累计*(12/convert(int,@yue))*10000/80.12) 
	else 0 end as 股基市值_期末_大小非三千万封顶_创收
	
,case when sfdxfkh=1 and t_yue.gpjjqmsz+期末其他资产>3000*10000 then 3000*10000 else t_yue.gpjjqmsz+期末其他资产 end as 股基市值加其他资产_期末_大小非三千万封顶
,case when sfdxfkh=1 and 股基市值加其他资产_期末_大小非三千万封顶>=(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then 股基市值加其他资产_期末_大小非三千万封顶 
	when sfdxfkh=1 and 股基市值加其他资产_期末_大小非三千万封顶<(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then (二级收入_月累计*(12/convert(int,@yue))*10000/80.12) 
	else 0 end as 股基市值加其他资产_期末_大小非三千万封顶_创收

,case when sfdxfkh=1 and t_yue.gpjjsz_yrj>3000*10000 then 3000*10000 else t_yue.gpjjsz_yrj end as 股基市值_月日均_大小非三千万封顶
,case when sfdxfkh=1 and 股基市值_月日均_大小非三千万封顶>=(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then 股基市值_月日均_大小非三千万封顶 
	when sfdxfkh=1 and 股基市值_月日均_大小非三千万封顶<(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then (二级收入_月累计*(12/convert(int,@yue))*10000/80.12) 
	else 0 end as 股基市值_月日均_大小非三千万封顶_创收
	
,case when sfdxfkh=1 and t_yue.gpjjsz_yrj+月日均其他资产>3000*10000 then 3000*10000 else t_yue.gpjjsz_yrj+月日均其他资产 end as 股基市值加其他资产_月日均_大小非三千万封顶 
,case when sfdxfkh=1 and 股基市值加其他资产_月日均_大小非三千万封顶>=(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then 股基市值加其他资产_月日均_大小非三千万封顶 
	when sfdxfkh=1 and 股基市值加其他资产_月日均_大小非三千万封顶<(二级收入_月累计*(12/convert(int,@yue))*10000/80.12) then (二级收入_月累计*(12/convert(int,@yue))*10000/80.12) 
	else 0 end as 股基市值加其他资产_月日均_大小非三千万封顶_创收
		
	from dba.t_ddw_yunying2012_kh as t_yue
	left join 
	(

		select zjzh
		from dba.t_edw_dxfkhmd t_dxf
		where t_dxf.nian=@nian_dxf and t_dxf.yue=@yue_dxf
		union 
		select zjzh
		from dba.t_ddw_yunying2012_kh 
		where nian=@nian and yue=@yue and zjzh in ('30083009','160041993','160042499','160042650')

	) as t_dxf on t_yue.zjzh = t_dxf.zjzh 
	left join #temp_khcp as t_cp on t_yue.zjzh = t_cp.zjzh and convert(int,t_yue.nian||t_yue.yue)=t_cp.ny
	left join DBA.客户综合分析_月 as t_yue_zh on t_yue.zjzh=t_yue_zh.资金账户 and t_yue.nian=t_yue_zh.年份 and t_yue.yue=t_yue_zh.月份
	left join DBA.客户综合分析_年 as t_nian_zh on t_yue.zjzh=t_nian_zh.资金账户 
							and t_yue.nian=t_nian_zh.年份 and t_yue.yue=t_nian_zh.月份 and t_nian_zh.账户状态 is not null
	
	left join dba.T_DDW_XYZQ_F00_KHZHFX_2011 as t_yue_2011 on t_yue.zjzh=t_yue_2011.zjzh and t_yue.nian=t_yue_2011.nian and t_yue.yue=t_yue_2011.yue
	left join dba.yybdz  as t_yybdz on t_yue.jgbh=t_yybdz.jgbh   --营业部对照表
	left join 
	(
		select 
			t1.资金账户 as zjzh
			,t1.日均资产+t2.rzrq_rjzc_m as 月日均资产_2012
		from DBA.客户综合分析_月 as t1
		left join dba.T_DDW_XYZQ_F00_KHZHFX_2011 as t2 on t1.资金账户=t2.zjzh and t1.年份=t2.nian and t1.月份=t2.yue
		where t1.年份='2012' and t1.月份='12'
	)as t_2013 on t_yue.zjzh=t_2013.zjzh 
	
	-------------年度累计_收入_产品------------
	left join 
	(
		select
			zjzh
			,khbh_hs
			,sum(ejcs_m-lcsr_m) as 佣金收入_年累计
			,sum(lcsr_m) as 利差收入_年累计
			,sum(ejcs_m) as 二级收入_年累计
			
			,sum(rzrq_xyjyjsr_m) as 融资融券信用交易净收入_年累计
			,sum(rzrq_lxsr_m) as 融资融券利息收入_年累计
			
			,sum(kfsjj_cwsxf_m+kfsjj_cnrgsxf_m) as 开放式基金手续费_年累计
			,sum(dxcp_cwsxf_m+dxcp_cnrgsxf_m) as 定向产品手续费_年累计
			,sum(zgcp_cwsxf_m+zgcp_cnrgsxf_m) as 资管产品手续费_年累计

			,sum(kfsjj_cwxsje_m + kfsjj_cnrgje_m) as 开放式基金销售金额_年累计
			,sum(kfsjj_cwxsje_hx_m + kfsjj_cnrgje_hx_m) as 开放式基金销售金额_其中核心基金_年累计
			
			,sum(case when yue='12' then kfsjj_cwbysz_yrj else 0 end) as 开放式基金场外保有市值_月日均
			,sum(case when yue='12' then kfsjj_cwbysz_hx_yrj else 0 end) as 开放式基金场外保有市值_核心基金_月日均     
			,sum(dxcp_cwxsje_m + dxcp_cnrgje_m) as 定向产品销售金额_年累计         
			,sum(case when yue='12' then dxcp_cwbysz_yrj else 0 end) as 定向产品场外保有市值_月日均 
			,sum(zgcp_cwxsje_m  + zgcp_cnrgje_m) as 资管产品销售金额_年累计       
			,sum(case when yue='12' then zgcp_cwbysz_yrj else 0 end) as 资管产品场外保有市值_月日均
			
			,开放式基金销售金额_其中核心基金_年累计 * 20 * 8/10000 +   	--销售分仓
				+ sum(kfsjj_cwbysz_hx_yrj * 4 * 8 /(10000*12) )		--保有分仓
			as 公募基金分仓转移_年累计

			------------月度------------
			,sum(case when yue=@yue then
					gpjjjyl_m   	--gj交易量_剔除根网
					+ gw_gpjyl_m	--根网股票交易量_月累计
					+ gw_jjjyl_m	--根网基金交易量_月累计
				 else 0 end 
				) as gj交易量_月累计_含根网
			,sum(case when yue=@yue then gpjjjyl_m else 0 end) as gj交易量_月累计_扣根网
			,sum(case when yue=@yue then gjjyj_m+gjghf_m/2 else 0 end) as gj净佣金_月累计
			 
			
			------------年度------------
			,sum(
					gpjjjyl_m   	--gj交易量_剔除根网
					+ gw_gpjyl_m	--根网股票交易量_月累计
					+ gw_jjjyl_m	--根网基金交易量_月累计
				) as gj交易量_年累计_含根网
			,sum(gpjjjyl_m) as gj交易量_年累计_扣根网
			,sum(gjjyj_m+gjghf_m/2) as gj净佣金_年累计

			--------------债券年度---------------
			,sum(zqjyl_m) as 债券交易量_年累计
			,sum(zhgjyl_m+nhgjyl_m) as 回购交易量_年累计
			
		from dba.t_ddw_yunying2012_kh as kh
		where nian=@nian and yue<=@yue
		group by zjzh,khbh_hs
	)as t_nian on t_yue.zjzh=t_nian.zjzh
	
where t_yue.nian=@nian and t_yue.yue=@yue
);


