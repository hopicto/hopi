drop table #temp_sxxt;
create table #temp_sxxt
(	
	dszjzh	varchar(128) not null,	--大伞资金帐号	
	jgbh	varchar(128) not null,	--权益营业部
	khxm	varchar(128) not null,	--子账户姓名	
	khbh_hs	varchar(128) not null,	--虚拟子账户客户编号
	khrq	int,
	qmzzc	numeric(20,4),	
	sfxz_m	int,					--是否月新增
	sfxz_y	int,					--是否年新增
	zb		numeric(20,4),			--占比
	constraint pk_skb_temp_sxxt primary key (dszjzh,jgbh,khxm,khbh_hs)
);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('210059999','XYXMFS0700','王艺芳','sxxt_00000001',20120309,1.307156469E7,0,0,0.2158);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('210059999','XYXMFS0700','吕培从','sxxt_00000002',20120920,2.567722325E7,0,0,0.4239);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('210059999','XYXMFS0700','陈子联','sxxt_00000003',20120314,2.182152314E7,0,0,0.3603);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('210060166','XYXMHL0800','李强','sxxt_00000004',20120507,2.74370893E7,0,0,0.2850);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('210060166','XYCDHX1800','彭元福','sxxt_00000005',20121028,2.732757383E7,0,0,0.2838);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('210060166','XYSHTY0150','陈赢','sxxt_00000006',20130123,1.307767805E7,0,1,0.1358);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('210060166','XYQZNA1020','傅梓瑜','sxxt_00000007',20130130,1.454317892E7,0,1,0.1511);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('210060166','XYQZAH1040','杨梅生','sxxt_00000008',20130523,1.389005586E7,1,1,0.1443);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('220123800','XYXMHL0800','韩钱茂','sxxt_00000009',20120907,7202136.31,0,0,0.1773);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('220123800','XYXMHL0800','李荣鑫','sxxt_00000010',20120907,8659761.15,0,0,0.2131);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('220123800','XYXMHL0800','李培松','sxxt_00000011',20120907,7887600.13,0,0,0.1941);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('220123800','XYXMHL0800','洪建元','sxxt_00000012',20120907,7787624.34,0,0,0.1917);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('220123800','XYXMHL0800','吴家铭','sxxt_00000013',20120910,9094962.96,0,0,0.2238);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('690005999','XYQZYB1000','黄家遵','sxxt_00000014',20120511,2.571961629E7,0,0,1.0000);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYFZZS0300','周伟贤','sxxt_00000015',20120719,8330519.15,0,0,0.0301);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYFZST3500','李祖建','sxxt_00000016',20120719,1.05327892E7,0,0,0.0381);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYFZST3500','柯国平','sxxt_00000017',20120719,1.277565668E7,0,0,0.0462);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYNPYB1200','吴汝花','sxxt_00000018',20120913,8025563.06,0,0,0.0290);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYWHYB1600','杨振邦','sxxt_00000019',20120913,8212851.07,0,0,0.0297);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYGZDF2600','陈颖熙','sxxt_00000020',20130117,1.362916494E7,0,1,0.0493);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYFZST3500','黄鑫','sxxt_00000021',20130117,1.154906188E7,0,1,0.0418);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYNPYB1200','李长忠','sxxt_00000022',20130117,1.337482291E7,0,1,0.0484);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYSHFB0100','吴一萍','sxxt_00000023',20130307,2.946052281E7,0,1,0.1065);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYSHFB0100','吴亚军','sxxt_00000024',20130321,3.158098506E7,0,1,0.1142);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYSHFB0100','朱劼远','sxxt_00000025',20130307,2.678888715E7,0,1,0.0968);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYGZDF2600','张耿良','sxxt_00000026',20130307,8102616.24,0,1,0.0293);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYWHYB1600','张义波','sxxt_00000027',20130314,8.275196373E7,0,1,0.2992);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('660003228','XYFZST3500','陈翔','sxxt_00000028',20130314,1.149787037E7,0,1,0.0416);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('220123789','XYXMHL0800','林志东','sxxt_00000029',20120618,1.3813543093E8,0,0,1.0000);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('710005736','XYQZAH1040','黄家遵','sxxt_00000030',20130130,8.239631944E7,0,1,0.8539);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('710005736','XYQZAH1040','龚冰龙','sxxt_00000031',20130130,1.410083051E7,0,1,0.1461);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('818130303','XYQZAH1040','楚明昕','sxxt_00000032',20130601,2.928115234E7,1,1,1.0000);
insert into #temp_sxxt(dszjzh,jgbh,khxm,khbh_hs,khrq,qmzzc,sfxz_m,sfxz_y,zb) values('818130304','XYQZAH1040','刘玉贤','sxxt_00000033',20130601,2.950075758E7,1,1,1.0000);