--类别字典
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0010','资源类别','RESOURCE_TYPE','路径','RESOURCE_TYPE_URL',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0011','资源类别','RESOURCE_TYPE','菜单','RESOURCE_TYPE_MENU',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0012','资源类别','RESOURCE_TYPE','按钮','RESOURCE_TYPE_ICON',3,sysdate);

insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0020','用户状态','USER_STATUS','有效','USER_STATUS_VALID',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0021','用户状态','USER_STATUS','锁定','USER_STATUS_LOCK',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0022','用户状态','USER_STATUS','删除','USER_STATUS_DELETE',3,sysdate);

insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0030','岗位状态','POSITION_STATUS','有效','POSITION_STATUS_VALID',1,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0031','岗位状态','POSITION_STATUS','锁定','POSITION_STATUS_LOCK',2,sysdate);
insert into HW_DICT_TYPE(ID,TYPE,TYPE_CODE,ITEM,ITEM_CODE,SEQ,MODIFY_TIME) values('0032','岗位状态','POSITION_STATUS','删除','POSITION_STATUS_DELETE',3,sysdate);

--组织
insert into HW_DEPARTMENT(ID,NAME,CODE,PARENT_ID,SEQ) values('root','根节点','root','root',1);
insert into HW_DEPARTMENT(ID,NAME,CODE,PARENT_ID,SEQ) values('1','Hopi公司','HOPI','root',2);
insert into HW_DEPARTMENT(ID,NAME,CODE,PARENT_ID,SEQ) values('2','管理层','GLC','1',1);

--岗位
insert into HW_POSITION(ID,DEPARTMENT_ID,NAME,CODE,STATUS) values('0','1','系统管理员','administrator','0030');

--人员,密码加密方法为MD5,'admin789'加密后为'8ddb74115757af42cf89ef3826ee7e44','111111'加密后为'9cc6cdd82aa1cb48c185f000e00bf1e5'
insert into HW_STAFF(ID,LOGIN_NAME,PASSWORD,STATUS,NAME,DEPARTMENT_ID) values('0','admin','9cc6cdd82aa1cb48c185f000e00bf1e5','0020','系统管理员','1');

--人员岗位
insert into HW_STAFF_POSITION(STAFF_ID,POSITION_ID) values('0','0');

--角色
insert into HW_ROLE(ID,NAME,CODE) values('0','系统管理员','ADMIN');
insert into HW_ROLE(ID,NAME,CODE) values('1','匿名用户','ANONYMOUS');
insert into HW_ROLE(ID,NAME,CODE) values('2','普通用户','USER');

--岗位角色
insert into HW_POSITION_ROLE(POSITION_ID,ROLE_ID) values('0','0');
insert into HW_POSITION_ROLE(POSITION_ID,ROLE_ID) values('0','1');
insert into HW_POSITION_ROLE(POSITION_ID,ROLE_ID) values('0','2');


--菜单资源
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('root','root','root','0011',1,'root','',0);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('1','功能菜单','GNCD','0011',2,'root','',0);
--权限资源
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('98','认证资源','ALL','0010',98,'1','/*.do?method=*',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('99','匿名资源','ANONYMOUS','0010',99,'1','/**',1);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('2','系统设置','XTGL','0011',1,'1','',0);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('20','类型字典','LXZD','0011',1,'2','Hopi.common.DictTypePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('21','图标类别管理','TBLB','0011',2,'2','Hopi.common.IconClassPanel',1);

insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('30','部门管理','BMGL','0011',3,'2','Hopi.common.DepartmentPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('31','岗位管理','GWGL','0011',4,'2','Hopi.common.PositionPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('32','角色管理','JSGL','0011',5,'2','Hopi.common.RolePanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('33','人员管理','RYGL','0011',6,'2','Hopi.common.StaffPanel',1);
insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('34','权限管理','QXGL','0011',7,'2','Hopi.common.ResourcePanel',1);


--角色资源
insert into HW_ROLE_RESOURCE(ROLE_ID,RESOURCE_ID,MASK) values('2','98',1);
insert into HW_ROLE_RESOURCE(ROLE_ID,RESOURCE_ID,MASK) values('1','99',1);


--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('5','人员组织管理','RYGL','2',3,'2','Hopi.common.OrgPanel',1);


--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values('8','图标管理','TBGL',2,5,2,'Ado.jcpt.IconPanel',1);

--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(20,'新功能测试','XGNCS',2,2,1,'',0);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(21,'demofusion1','demofusion1',2,1,20,'DemoFusion1',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(22,'Column3D','demofusion1',2,2,20,'DemoFusion2',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(23,'K线样例1','K线样例1',2,3,20,'DemoFusion3',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(24,'画图工具','HTGJ',2,4,20,'Ado.demo.DrawPanel',1);
----afa测试用
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(25,'资产配置测试','ZCPZCS',2,5,20,'Ado.afa.AfaAssetAllocationPanel',1);
--
--
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF,EXT_PROP) values(7,'公告管理','GGGL',2,5,2,'InfoPanel',1,'{infoTypeName:"公告管理",infoType:53,viewTag:1}');
--
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(10,'数据库管理','SJKGL',2,3,1,'Ado.rup.DmDataBasePanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(11,'数据表管理','SJBGL',2,4,1,'Ado.rup.DmTablePanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(12,'表关联管理','SGLGL',2,5,1,'Ado.rup.DmRelationPanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(13,'表空间管理','BKJGL',2,6,1,'Ado.rup.DmTableSpacePanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(14,'查询管理','CXGL',2,7,1,'Ado.rup.DmQueryPanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(15,'同步工作管理','TBGZGL',2,8,1,'Ado.rup.DmSyncWorkPanel',1);
--
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(30,'UI组件管理','UIZJGL',2,30,1,'Ado.rup.DuComponentPanel',1);
--
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(40,'照片查看','ZPCK',2,40,1,'Ado.rup.PhotoViewPanel',1);
--
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(50,'数据同步管理','SJTBGL',2,50,1,'',0);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(51,'数据库管理','SJKGL',2,1,50,'Ado.ds.DsDataBasePanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(52,'数据表管理','SJBGL',2,2,50,'Ado.ds.DsTablePanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(53,'同步工作管理','TBGZGL',2,3,50,'Ado.ds.DsWorkPanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(54,'同步工作类别管理','TBGZLBGL',2,4,50,'Ado.ds.DsWorkCategoryPanel',1);
--
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(100,'测试表','TEST',2,100,1,'test',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(101,'账户诊断报告','ZHZDBG',2,101,1,'Ado.demo.PortfolioPanel',1);
--
----知识库
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(110,'知识库','ZSK',2,110,1,'',0);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(111,'样例库','YLK',2,1,110,'Ado.km.KmSamplePanel',1);
--
----工作流引擎
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(120,'工作流引擎','GZL',2,120,1,'',0);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(121,'流程图','YLK',2,1,120,'Ado.flow.DrawPanel',1);
--
----报表工具
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(130,'报表工具','BBGJ',2,130,1,'',0);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(131,'模块管理','MKGL',2,1,130,'Ado.xr.XrModulePanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(132,'模板管理','MBGL',2,2,130,'Ado.xr.XrTemplatePanel',1);
--
----金融数据分析
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(140,'金融数据分析','JRSJFX',2,140,1,'',0);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(141,'规则变量管理','GZBLGL',2,1,140,'Ado.pf.PfModelPortfolioPanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(142,'模拟组合管理','MNZHGL',2,2,140,'Ado.pf.PfStrategyRuleVarPanel',1);
--
----产品服务
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(150,'产品服务','XTGL',2,150,1,'',0);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(151,'产品设置','CPSZ',2,1,150,'Ado.ps.PsProductPanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(152,'产品跟踪设置','CPGZSZ',2,2,150,'Ado.ps.PsStockTrackConfigPanel',1);
--insert into HW_RESOURCE(ID,NAME,CODE,TYPE,SEQ,PARENT_ID,CONTENT,LEAF) values(153,'产品跟踪','CPGZ',2,3,150,'Ado.ps.PsStockTrackPanel',1);
--
--
--
----角色资源
--insert into HW_ROLE_RESOURCE(ROLE_ID,RESOURCE_ID,MASK) values(2,98,1);
--insert into HW_ROLE_RESOURCE(ROLE_ID,RESOURCE_ID,MASK) values(1,99,1);
--
----数据表分类根节点
--insert into DS_DATABASE(ID,NAME,CODE) values(1,'样例库','SAMPLE');
--insert into DS_DATABASE(ID,NAME,CODE) values(2,'本地数据库','LC');
--insert into DS_TABLE_CATEGORY(ID,DB_ID,NAME,PARENT_ID) values(1,1,'ROOT',1);
--
----数据表分类根节点
--insert into DM_DATABASE(ID,NAME,CODE) values(1,'根数据库','ROOT_DB');
--insert into DM_TABLE_CATEGORY(ID,DB_ID,NAME,PARENT_ID) values(1,1,'ROOT',1);
--insert into DM_DATABASE(ID,NAME,CODE) values(2,'本地数据库','LC');

