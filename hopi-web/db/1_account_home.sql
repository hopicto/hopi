/*==============================================================*/
/* DBMS name:      ORACLE Version 10g                           */
/* Created on:     2010-8-10 16:12:02                           */
/*==============================================================*/

create temporary tablespace hopi_temp 
tempfile 'D:\oracle\data\hopi_temp01.dbf' 
size 32m 
autoextend on 
next 32m maxsize 2048m 
extent management local; 

create tablespace hopi_data 
logging 
datafile 'D:\oracle\data\hopi_data01.dbf' 
size 32m 
autoextend on 
next 32m maxsize 2048m 
extent management local; 

create user hopi identified by lczx0987
default tablespace hopi_data 
temporary tablespace hopi_temp; 

grant dba to hopi;
