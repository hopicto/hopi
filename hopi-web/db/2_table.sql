/*==============================================================*/
/* DBMS name:      ORACLE Version 10g                           */
/* Created on:     2013/7/24 13:45:37                           */
/*==============================================================*/


alter table HW_ACCESS_LOG
   drop constraint FK_HW_ACCESS_LOG;

alter table HW_DEPARTMENT
   drop constraint FK_HW_DEPARTMENT_SELF;

alter table HW_POSITION
   drop constraint FK_HW_POSITION_DEPARTMENT;

alter table HW_POSITION_ROLE
   drop constraint FK_HW_POSITION_ROLE_P;

alter table HW_POSITION_ROLE
   drop constraint FK_HW_POSITION_ROLE_R;

alter table HW_ROLE_RESOURCE
   drop constraint FK_HW_ROLE_RESOUCE_RE;

alter table HW_ROLE_RESOURCE
   drop constraint FK_HW_ROLE_RESOUCE_RO;

alter table HW_STAFF
   drop constraint FK_HW_STAFF_DEPARTMENT;

alter table HW_STAFF_POSITION
   drop constraint FK_HW_STAFF_POSITION_P;

alter table HW_STAFF_POSITION
   drop constraint FK_HW_STAFF_POSITION_S;

drop table HW_ACCESS_LOG cascade constraints;

drop table HW_DEPARTMENT cascade constraints;

drop table HW_DICT_TYPE cascade constraints;

drop table HW_POSITION cascade constraints;

drop table HW_POSITION_ROLE cascade constraints;

drop table HW_RESOURCE cascade constraints;

drop table HW_ROLE cascade constraints;

drop table HW_ROLE_RESOURCE cascade constraints;

drop table HW_STAFF cascade constraints;

drop table HW_STAFF_POSITION cascade constraints;

/*==============================================================*/
/* Table: HW_ACCESS_LOG                                         */
/*==============================================================*/
create table HW_ACCESS_LOG  (
   STAFF_ID             VARCHAR2(36)                    not null,
   ACCESS_TIME          DATE                            not null,
   constraint PK_HW_ACCESS_LOG primary key (STAFF_ID, ACCESS_TIME)
);

/*==============================================================*/
/* Table: HW_DEPARTMENT                                         */
/*==============================================================*/
create table HW_DEPARTMENT  (
   ID                   VARCHAR2(36)                    not null,
   NAME                 VARCHAR2(30),
   FULL_NAME            VARCHAR2(200),
   CODE                 VARCHAR2(30),
   SEQ                  NUMBER(5),
   DESCRIPTION          VARCHAR2(200),
   PARENT_ID            VARCHAR2(36),
   constraint PK_HW_DEPARTMENT primary key (ID)
);

/*==============================================================*/
/* Table: HW_DICT_TYPE                                          */
/*==============================================================*/
create table HW_DICT_TYPE  (
   ID                   VARCHAR2(36)                    not null,
   TYPE                 VARCHAR2(30),
   TYPE_CODE            VARCHAR2(30),
   ITEM                 VARCHAR2(30),
   ITEM_CODE            VARCHAR2(50),
   ITEM_VALUE           NUMBER(9),
   SEQ                  NUMBER(5),
   DESCRIPTION          VARCHAR2(200),
   MODIFY_TIME          DATE,
   MODIFIER             NUMBER(9),
   constraint PK_HW_DICT_TYPE primary key (ID)
);

comment on table HW_DICT_TYPE is
'类别字典，类别选项值用ID表示。类别字典不删除，只添加和修改。';

/*==============================================================*/
/* Table: HW_POSITION                                           */
/*==============================================================*/
create table HW_POSITION  (
   ID                   VARCHAR2(36)                    not null,
   DEPARTMENT_ID        VARCHAR2(36),
   NAME                 VARCHAR2(30),
   CODE                 VARCHAR2(30),
   STATUS               VARCHAR2(36),
   DESCRIPTION          VARCHAR2(200),
   constraint PK_HW_POSITION primary key (ID)
);

/*==============================================================*/
/* Table: HW_POSITION_ROLE                                      */
/*==============================================================*/
create table HW_POSITION_ROLE  (
   POSITION_ID          VARCHAR2(36)                    not null,
   ROLE_ID              VARCHAR2(36)                    not null,
   constraint PK_HW_POSITION_ROLE primary key (ROLE_ID, POSITION_ID)
);

/*==============================================================*/
/* Table: HW_RESOURCE                                           */
/*==============================================================*/
create table HW_RESOURCE  (
   ID                   VARCHAR2(36)                    not null,
   NAME                 VARCHAR2(30),
   CODE                 VARCHAR2(30),
   TYPE                 VARCHAR2(36),
   SEQ                  NUMBER(5),
   LEAF                 NUMBER(1),
   DESCRIPTION          VARCHAR2(200),
   PARENT_ID            NUMBER(9),
   CONTENT              VARCHAR2(200),
   EXT_PROP             VARCHAR2(200),
   ICON_ID              NUMBER(9),
   constraint PK_HW_RESOURCE primary key (ID)
);

comment on column HW_RESOURCE.EXT_PROP is
'扩展属性，格式：{name:value}';

/*==============================================================*/
/* Table: HW_ROLE                                               */
/*==============================================================*/
create table HW_ROLE  (
   ID                   VARCHAR2(36)                    not null,
   NAME                 VARCHAR2(30),
   CODE                 VARCHAR2(30),
   DESCRIPTION          VARCHAR2(200),
   constraint PK_HW_ROLE primary key (ID)
);

/*==============================================================*/
/* Table: HW_ROLE_RESOURCE                                      */
/*==============================================================*/
create table HW_ROLE_RESOURCE  (
   ROLE_ID              VARCHAR2(36)                    not null,
   RESOURCE_ID          VARCHAR2(36)                    not null,
   MASK                 NUMBER(9),
   constraint PK_HW_ROLE_RESOURCE primary key (ROLE_ID, RESOURCE_ID)
);

/*==============================================================*/
/* Table: HW_STAFF                                              */
/*==============================================================*/
create table HW_STAFF  (
   ID                   VARCHAR2(36)                    not null,
   LOGIN_NAME           VARCHAR2(30),
   PASSWORD             VARCHAR2(32),
   STATUS               VARCHAR2(36),
   NAME                 VARCHAR2(10),
   DESCRIPTION          VARCHAR2(200),
   DEPARTMENT_ID        VARCHAR2(36),
   EMAIL                VARCHAR2(100),
   PHONE                VARCHAR2(20),
   MOBILE               VARCHAR2(15),
   MSN                  VARCHAR2(100),
   QQ                   VARCHAR2(20),
   constraint PK_HW_STAFF primary key (ID)
);

/*==============================================================*/
/* Table: HW_STAFF_POSITION                                     */
/*==============================================================*/
create table HW_STAFF_POSITION  (
   STAFF_ID             VARCHAR2(36)                    not null,
   POSITION_ID          VARCHAR2(36)                    not null,
   SEQ                  NUMBER(5),
   constraint PK_HW_STAFF_POSITION primary key (STAFF_ID, POSITION_ID)
);

alter table HW_ACCESS_LOG
   add constraint FK_HW_ACCESS_LOG foreign key (STAFF_ID)
      references HW_STAFF (ID)
      on delete cascade;

alter table HW_DEPARTMENT
   add constraint FK_HW_DEPARTMENT_SELF foreign key (PARENT_ID)
      references HW_DEPARTMENT (ID)
      on delete cascade;

alter table HW_POSITION
   add constraint FK_HW_POSITION_DEPARTMENT foreign key (DEPARTMENT_ID)
      references HW_DEPARTMENT (ID)
      on delete cascade;

alter table HW_POSITION_ROLE
   add constraint FK_HW_POSITION_ROLE_P foreign key (POSITION_ID)
      references HW_POSITION (ID)
      on delete cascade;

alter table HW_POSITION_ROLE
   add constraint FK_HW_POSITION_ROLE_R foreign key (ROLE_ID)
      references HW_ROLE (ID)
      on delete cascade;

alter table HW_ROLE_RESOURCE
   add constraint FK_HW_ROLE_RESOUCE_RE foreign key (RESOURCE_ID)
      references HW_RESOURCE (ID)
      on delete cascade;

alter table HW_ROLE_RESOURCE
   add constraint FK_HW_ROLE_RESOUCE_RO foreign key (ROLE_ID)
      references HW_ROLE (ID)
      on delete cascade;

alter table HW_STAFF
   add constraint FK_HW_STAFF_DEPARTMENT foreign key (DEPARTMENT_ID)
      references HW_DEPARTMENT (ID);

alter table HW_STAFF_POSITION
   add constraint FK_HW_STAFF_POSITION_P foreign key (POSITION_ID)
      references HW_POSITION (ID)
      on delete cascade;

alter table HW_STAFF_POSITION
   add constraint FK_HW_STAFF_POSITION_S foreign key (STAFF_ID)
      references HW_STAFF (ID)
      on delete cascade;

