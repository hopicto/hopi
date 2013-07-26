--类别字典
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(1,'资源类别','RESOURCE_TYPE','URL','RESOURCE_TYPE_URL',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(2,'菜单类别','RESOURCE_TYPE','URL','RESOURCE_TYPE_MENU',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(3,'用户状态','USER_STATUS','有效','USER_STATUS_VALID',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(4,'用户状态','USER_STATUS','锁定','USER_STATUS_LOCK',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(5,'用户状态','USER_STATUS','删除','USER_STATUS_DELETE',3,sysdate);

insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(53,'信息类别','INFO_TYPE','内部公告','INFO_TYPE_1',1,sysdate);

insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(60,'附件类别','AFFIX_TYPE','信息发布','AFFIX_TYPE_1',1,sysdate);

--信息状态info status
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(66,'信息状态','INFO_STATUS','新增','INFO_STATUS_CREATE',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(67,'信息状态','INFO_STATUS','已发布','INFO_STATUS_PUBLISH',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(68,'信息状态','INFO_STATUS','已撤销','INFO_STATUS_UNPUBLISH',3,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(69,'信息状态','INFO_STATUS','删除','INFO_STATUS_DELETE',4,sysdate);

--消息状态
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(72,'消息状态','MESSAGE_STATUS','新增','MESSAGE_STATUS_0',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(73,'消息状态','MESSAGE_STATUS','已读','MESSAGE_STATUS_1',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(74,'消息状态','MESSAGE_STATUS','删除','MESSAGE_STATUS_2',3,sysdate);

--数据类型
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(80,'数据类型','DATA_TYPE','varchar','DATA_TYPE_VARCHAR',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(81,'数据类型','DATA_TYPE','number','DATA_TYPE_NUMBER',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(82,'数据类型','DATA_TYPE','date','DATA_TYPE_DATE',3,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(83,'数据类型','DATA_TYPE','clob','DATA_TYPE_CLOB',4,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(84,'数据类型','DATA_TYPE','blob','DATA_TYPE_BLOB',5,sysdate);

--级联操作类型
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(85,'数据级联类型','DATA_RELATION_TYPE','级联删除','DATA_RELATION_TYPE_CASCADE',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(86,'数据级联类型','DATA_RELATION_TYPE','限制删除','DATA_RELATION_TYPE_RESTRICT',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(87,'数据级联类型','DATA_RELATION_TYPE','设置为空','DATA_RELATION_TYPE_SETNULL',3,sysdate);

insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(88,'表空间类型','TABLE_SPACE_TYPE','按年份分区','TABLE_SPACE_TYPE_YEAR',1,sysdate);

--UI组件类型
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(100,'UI组件类型','UI_COMPONENT_TYPE','表单','UI_COMPONENT_TYPE_FORM',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(101,'UI组件类型','UI_COMPONENT_TYPE','列表','UI_COMPONENT_TYPE_GRID',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(102,'UI组件类型','UI_COMPONENT_TYPE','图表','UI_COMPONENT_TYPE_CHART',3,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(103,'UI组件类型','UI_COMPONENT_TYPE','数据源','UI_COMPONENT_TYPE_DATASTORE',4,sysdate);


--同步状态
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(110,'数据同步状态','DS_SYNC_STATUS','新建','DS_SYNC_STATUS_NEW',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(111,'数据同步状态','DS_SYNC_STATUS','同步','DS_SYNC_STATUS_ON',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(112,'数据同步状态','DS_SYNC_STATUS','完成','DS_SYNC_STATUS_SUCCESS',3,sysdate);

--同步类型
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(121,'同步数据来源','DM_SYNC_WORK_TYPE','万得数据库','DM_SYNC_WORK_TYPE_WIND',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values(122,'同步数据来源','DM_SYNC_WORK_TYPE','聚源数据库','DM_SYNC_WORK_TYPE_JYDB',2,sysdate);


--UI布局类型

--组织
insert into HW_ORG(ID,NAME,CODE,PARENT_ID,SEQ) values(0,'ROOT','ROOT',0,1);
insert into HW_ORG(ID,NAME,CODE,PARENT_ID,SEQ) values(1,'ADO公司','ADO',0,2);
insert into HW_ORG(ID,NAME,CODE,PARENT_ID,SEQ) values(2,'管理层','GLC',1,1);
insert into HW_ORG(ID,NAME,CODE,PARENT_ID,SEQ) values(3,'产品研究部','CPYJB',1,2);
insert into HW_ORG(ID,NAME,CODE,PARENT_ID,SEQ) values(4,'财务部','CWB',1,3);


--用户,密码加密方法为MD5,'admin789'加密后为'8ddb74115757af42cf89ef3826ee7e44','111111'加密后为'9cc6cdd82aa1cb48c185f000e00bf1e5'
insert into HW_USER(ID,LOGIN_NAME,PASSWORD,STATUS,NAME,ORG_ID) values(0,'admin','8ddb74115757af42cf89ef3826ee7e44',3,'系统管理员',1);

--角色
insert into HW_ROLE(ID,NAME,CODE) values(0,'系统管理员','ADMIN');
insert into HW_ROLE(ID,NAME,CODE) values(1,'匿名用户','ANONYMOUS');
insert into HW_ROLE(ID,NAME,CODE) values(2,'普通用户','USER');

--用户角色
insert into HW_USER_ROLE(USER_ID,LOGIN_NAME,ROLE_ID) values(0,'admin',0);
insert into HW_USER_ROLE(USER_ID,LOGIN_NAME,ROLE_ID) values(0,'admin',1);
insert into HW_USER_ROLE(USER_ID,LOGIN_NAME,ROLE_ID) values(0,'admin',2);

--菜单资源
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(0,'root','root',2,1,0,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(1,'功能菜单','GNCD',2,2,0,'',0);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(2,'系统管理','XTGL',2,1,1,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(3,'类型字典','LXZD',2,1,2,'Ado.jcpt.DictTypePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(4,'资源权限管理','ZYQXGL',2,2,2,'Ado.jcpt.ResourcePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(5,'人员组织管理','RYGL',2,3,2,'Ado.jcpt.OrgPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(6,'角色管理','JSGL',2,4,2,'Ado.jcpt.RolePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(8,'图标管理','TBGL',2,5,2,'Ado.jcpt.IconPanel',1);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(20,'新功能测试','XGNCS',2,2,1,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(21,'demofusion1','demofusion1',2,1,20,'DemoFusion1',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(22,'Column3D','demofusion1',2,2,20,'DemoFusion2',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(23,'K线样例1','K线样例1',2,3,20,'DemoFusion3',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(24,'画图工具','HTGJ',2,4,20,'Ado.demo.DrawPanel',1);
--afa测试用
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(25,'资产配置测试','ZCPZCS',2,5,20,'Ado.afa.AfaAssetAllocationPanel',1);


insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF,EXT_PROP) values(7,'公告管理','GGGL',2,5,2,'InfoPanel',1,'{infoTypeName:"公告管理",infoType:53,viewTag:1}');

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(10,'数据库管理','SJKGL',2,3,1,'Ado.rup.DmDataBasePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(11,'数据表管理','SJBGL',2,4,1,'Ado.rup.DmTablePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(12,'表关联管理','SGLGL',2,5,1,'Ado.rup.DmRelationPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(13,'表空间管理','BKJGL',2,6,1,'Ado.rup.DmTableSpacePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(14,'查询管理','CXGL',2,7,1,'Ado.rup.DmQueryPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(15,'同步工作管理','TBGZGL',2,8,1,'Ado.rup.DmSyncWorkPanel',1);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(30,'UI组件管理','UIZJGL',2,30,1,'Ado.rup.DuComponentPanel',1);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(40,'照片查看','ZPCK',2,40,1,'Ado.rup.PhotoViewPanel',1);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(50,'数据同步管理','SJTBGL',2,50,1,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(51,'数据库管理','SJKGL',2,1,50,'Ado.ds.DsDataBasePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(52,'数据表管理','SJBGL',2,2,50,'Ado.ds.DsTablePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(53,'同步工作管理','TBGZGL',2,3,50,'Ado.ds.DsWorkPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(54,'同步工作类别管理','TBGZLBGL',2,4,50,'Ado.ds.DsWorkCategoryPanel',1);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(100,'测试表','TEST',2,100,1,'test',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(101,'账户诊断报告','ZHZDBG',2,101,1,'Ado.demo.PortfolioPanel',1);

--知识库
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(110,'知识库','ZSK',2,110,1,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(111,'样例库','YLK',2,1,110,'Ado.km.KmSamplePanel',1);

--工作流引擎
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(120,'工作流引擎','GZL',2,120,1,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(121,'流程图','YLK',2,1,120,'Ado.flow.DrawPanel',1);

--报表工具
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(130,'报表工具','BBGJ',2,130,1,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(131,'模块管理','MKGL',2,1,130,'Ado.xr.XrModulePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(132,'模板管理','MBGL',2,2,130,'Ado.xr.XrTemplatePanel',1);

--金融数据分析
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(140,'金融数据分析','JRSJFX',2,140,1,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(141,'规则变量管理','GZBLGL',2,1,140,'Ado.pf.PfModelPortfolioPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(142,'模拟组合管理','MNZHGL',2,2,140,'Ado.pf.PfStrategyRuleVarPanel',1);

--产品服务
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(150,'产品服务','XTGL',2,150,1,'',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(151,'产品设置','CPSZ',2,1,150,'Ado.ps.PsProductPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(152,'产品跟踪设置','CPGZSZ',2,2,150,'Ado.ps.PsStockTrackConfigPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(153,'产品跟踪','CPGZ',2,3,150,'Ado.ps.PsStockTrackPanel',1);

--权限资源
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(98,'认证资源','ALL',1,98,1,'/*.do?method=*',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(99,'匿名资源','ANONYMOUS',1,99,1,'/**',1);

--角色资源
insert into HW_ROLE_RESOURCE(ROLE_ID,RESOURCE_ID,MASK) values(2,98,1);
insert into HW_ROLE_RESOURCE(ROLE_ID,RESOURCE_ID,MASK) values(1,99,1);

--数据表分类根节点
insert into DS_DATABASE(ID,NAME,CODE) values(1,'样例库','SAMPLE');
insert into DS_DATABASE(ID,NAME,CODE) values(2,'本地数据库','LC');
insert into DS_TABLE_CATEGORY(ID,DB_ID,NAME,PARENT_ID) values(1,1,'ROOT',1);

--数据表分类根节点
insert into DM_DATABASE(ID,NAME,CODE) values(1,'根数据库','ROOT_DB');
insert into DM_TABLE_CATEGORY(ID,DB_ID,NAME,PARENT_ID) values(1,1,'ROOT',1);
insert into DM_DATABASE(ID,NAME,CODE) values(2,'本地数据库','LC');

