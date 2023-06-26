#!/bin/bash
 
getdatestring()
{
   TZ='Asia/Chongqing' date "+%Y%m%d%H%M"
}
datestring=$(getdatestring)

LOGS_PATH=/var/log/nginx/7ex
find ${LOGS_PATH}/ -mtime +7 -name "7ex.access.20*.log" -exec rm -f {} \;
find ${LOGS_PATH}/ -mtime +7 -name "7ex.error.20*.log" -exec rm -f {} \;
 
mv ${LOGS_PATH}/7ex.access.log ${LOGS_PATH}/7ex.access.${datestring}.log
mv ${LOGS_PATH}/7ex.error.log ${LOGS_PATH}/7ex.error.${datestring}.log
kill -USR1 `cat /var/run/nginx.pid` 
