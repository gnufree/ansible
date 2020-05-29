#!/bin/bash

SQL_MODEL=$1
HOST="localhost"
USER="devops"
PASSWD="xxxxxx"
UPSQL="aaa"
DB=$2
TABLE=$3
TIMES=`date +%Y%m%d%H%M`
BAK_DIR="/data/backup/db/"
UPDIR="/data/update/db/"

check_fun() {
if [ ! -d $BAK_DIR ]
then
    mkdir -p $BAK_DIR
elif [ ! -d $UPDIR ]
then
    mkdir -p $UPDIR
fi
}

CKDB=`mysql -h $HOST -u${USER} -p"${PASSWD}" -e 'show databases' |grep -w "$DB"`
CKTAB=`mysql -h $HOST -u${USER} -p"${PASSWD}" -D "$DB" -e 'show tables' |grep -w "$TABLE"`

bak_db_fun() {
	check_fun
	mysqldump --skip-opt -h $HOST -u${USER} -p${PASSWD}  -R $DB |gzip > ${BAK_DIR}${DB}${TIMES}.sql.gz
}

bak_table_fun() {
	check_fun
	mysqldump --skip-opt -h $HOST -u${USER} -p${PASSWD} $DB $TABLE |gzip > ${BAK_DIR}${DB}-${TABLE}${TIMES}.sql.gz
}

check_db_bak_fun() {
#echo "${BAK_DIR}${DB}${TIMES}.sq.gz"
#if [ ! -f "${BAK_DIR}${DB}${TIMES}.sql.gz" ];then
	echo "备份$DB 在 $TIMES 失败!!!"
#	backup_db()
#fi
}

check_table_bak_fun() {
#if [ ! -f "${BAK_DIR}${DB}-${TABLE}${TIMES}.sql.gz" ];
#then
	echo "备份$DB 在 $TIMES 失败!!!"
#	backup_table()
#fi
}

exec_sql_fun() {
	mysql -h $HOST -u${USER} -p${PASSWD} -D $DB <  ${UPDIR}${UPSQL}.sql
}

if [ ! $# -ge 2 ]
then
    echo -e "\033[31:41m 参数个数小于2，不予执行!!! \033[0m"
    exit 1
elif [ $SQL_MODEL == "DDL" ]
then
    echo -e "\033[31:41m DDL \033[0m"
    if [ "$DB"x != "$CKDB"x ]
    then
	echo -e "\033[31:41m 库不存在，请确认清楚后在执行!!! \033[0m"
	exit 1
    fi
    bak_db_fun
    exec_sql_fun
elif [ $SQL_MODEL == "DML" ]
then
    echo -e "\033[31:41m DML \033[0m"
    if [ "$TABLE"x != "$CKTAB"x ]
    then
	echo -e "\033[31:41m 表不存在，请确认清楚后在执行!!! \033[0m"
	exit 1
    fi
    bak_table_fun
    exec_sql_fun
else
    echo -e "\033[31:41m 参数不匹配，请确认!!! \033[0m"
    exit 1
fi
