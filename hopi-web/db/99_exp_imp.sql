导出：
EXP hopi/111111 BUFFER=64000 FILE=D:\本地应用\workspaces\handworkspace\hopi\hopi-web\db\hopi.dmp OWNER=hopi 

导入：
IMP hopi/111111 BUFFER=64000 FILE=D:\本地应用\workspaces\handworkspace\hopi\hopi-web\db\hopi.dmp FROMUSER=hopi TOUSER=hopi ignore=y

增量导入：
imp hopi/111111 inctype=RECTORE FULL=Y FILE=D:\本地应用\workspaces\handworkspace\hopi\hopi-web\db\hopi.dmp
 

