#!/bin/bash
logdate=`date -d "-1 day" "+%Y-%m-%d"`
logdir=/opt/applog/ldp
cd ${logdir}
#需要切割的日志文件
cp daily.log daily.log.${logdate}
echo "" >daily.log
