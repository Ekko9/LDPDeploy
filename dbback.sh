#!/bin/bash

# 日期
date=$(date '+%Y%m%d')
# 设置备份目录和保留天数  
backup_dir="/opt/dbback"
retention_days=7

#数据库账密
muser=
mpasswd=
mhost=
# 创建备份目录（如果不存在）  
mkdir -p $backup_dir

# 获取当前时间戳  
now=$(date +%s)

# 备份MySQL数据库到备份目录中
mysqldump -u${muser} -p${mpasswd} user > $backup_dir/${date}_user.sql
# 备份全量
mysqldump --socket=/var/lib/mysql/mysql.sock --single-transaction --master-data=2 -u${muser} -p${mpasswd} -h${mhost}  --all-databases > $backup_dir/dbbak_${date}.sql

# 遍历备份目录中的所有文件，找到7天前的备份文件并删除  
for file in $backup_dir/*; do
  file_timestamp=$(stat -c %Y $file)
  file_age=$(($now - $file_timestamp))
  if [ $file_age -gt $(($retention_days * 86400)) ]; then
    rm -rf $file
  fi
done
