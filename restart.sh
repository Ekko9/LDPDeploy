#!/bin/bash
ps_out=` ps -ef|grep ldp |grep -v grep | awk '{print $2}' `
if  [ "${ps_out}" != "" ];then
	echo -e "\033[32m +++++++++++++++++running,start Restart+++++++++++++++++ \033[0m"
	sh /opt/app/java_apps/bin/app.sh stop
	sleep 3
	sh /opt/app/java_apps/bin/app.sh start

else
	echo -e "\033[32m +++++++++++++++++Process does not exist,start service+++++++++++++++++ \033[0m"
	sh /opt/app/java_apps/bin/app.sh start

fi

