
source /vagrant/config/setup.env 

export ST_NODE1_HOSTNAME=rac2-node1
export ST_NODE2_HOSTNAME=rac2-node2

export ST_NAME=CDBST21
export ST2_NAME=CDBST19



srvctl stop database -d ${DB2_NAME} ; srvctl start database -d ${DB2_NAME} -o mount





export ORACLE_SID=${DB2_NAME}1
export ORACLE_HOME=${DB2_HOME}
export PATH=$ORACLE_HOME/bin:$PATH



sqlplus / as sysdba << EOF
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 = 'LOCATION=USE_DB_RECOVERY_FILE_DEST' scope=BOTH sid='*';
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 5G;
ALTER SYSTEM SET db_recovery_file_dest = '+RECO' scope=BOTH sid='*';
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE FORCE LOGGING;


ALTER DATABASE ADD LOGFILE THREAD 1
GROUP 11 '+DATA' SIZE 100m,
GROUP 12 '+DATA' SIZE 100m,
GROUP 13 '+DATA' SIZE 100m;

ALTER DATABASE ADD LOGFILE THREAD 2
GROUP 21 '+DATA' SIZE 100m,
GROUP 22 '+DATA' SIZE 100m,
GROUP 23 '+DATA' SIZE 100m;


ALTER DATABASE ADD STANDBY LOGFILE THREAD 2
GROUP 111 '+DATA' SIZE 100m,
GROUP 112 '+DATA' SIZE 100m,
GROUP 113 '+DATA' SIZE 100m,
GROUP 114 '+DATA' SIZE 100m;


ALTER DATABASE ADD STANDBY LOGFILE THREAD 2
GROUP 121 '+DATA' SIZE 100m,
GROUP 122 '+DATA' SIZE 100m,
GROUP 123 '+DATA' SIZE 100m,
GROUP 124 '+DATA' SIZE 100m;


alter database clear unarchived logfile group 1;
alter database clear unarchived logfile group 2;
alter database clear unarchived logfile group 3;

alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;


-- REDO Status
col member format a65
col STATUS format a10
set linesize 150
set pagesize 99
select l.group#, l.thread#,
f.member,
l.archived,
l.status,
(bytes/1024/1024) fsize
from
v\$log l, v\$logfile f
where f.group# = l.group#
order by 2,1
/

-- Standby REDO Status
col member format a65
col STATUS format a10
set linesize 150
set pagesize 99
select l.group#, l.thread#,
f.member,
l.archived,
l.status,
(bytes/1024/1024) fsize
from
v\$standby_log l, v\$logfile f
where f.group# = l.group#
order by 2,1
/


exit
EOF


srvctl stop database -d ${DB2_NAME} ; srvctl start database -d ${DB2_NAME}

