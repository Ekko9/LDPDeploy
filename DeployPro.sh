#!/bin/bash
#deploy PRO LDPPlatform
jarName=LDPPlatform-0.0.1.jar
appDir=/DATA/jenkins/workspace/LDP
jarDir=/DATA/jenkins/workspace/LDP/target
backupdir=/DATA/earBak/$(date "+%Y-%m-%d")

#Determine whether the packing directory exists
cd ${appDir}
if [ ! -d "${jarDir}" ];then
        echo -e "\033[31m +++++++++++++++++${jarDir} not exist，Please check+++++++++++++++++  \033[0m"
	exit 1
fi

#Create a backup directory. There is no new directory created according to the date
if [ ! -d "${backupdir}" ]; then
	echo -e "\033[31m directory does not exist, creating。。。 \033[0m"
        mkdir ${backupdir}
	cd ${backupdir} && pwd
	echo -e "\033[32m backup directory creat success。。。 \033[0m"
	#Start to backup the application package and check whether the backup is successful. If it fails, terminate the judgment
	echo -e "\033[32m +++++++++++++++++start backup ${jarName}+++++++++++++++++  \033[0m"
	cd ${jarDir} 
	cp ${jarName} ${backupdir}
	cd ${backupdir}
	if [ ! -f "${jarName}" ];then
		echo -e "\033[32m +++++++++++++++++${jarName} not exist，Please check the backup source+++++++++++++++++  \033[0m"
		exit 1
	else
		ls
		echo -e "\033[32m +++++++++++++++++Backup success+++++++++++++++++ \033[0m"
	fi
	
else
        echo -e "\033[32m directory already exists,start backup files。。。 \033[0m"
	#Start to backup the application package and check whether the backup is successful. If it fails, terminate the judgment
	cd ${jarDir} 
	cp ${jarName} ${backupdir}
	cd ${backupdir}
        if [ ! -f "${jarName}" ];then
                echo -e "\033[31m +++++++++++++++++${jarName} not exist，Please check the backup source+++++++++++++++++  \033[0m"
                exit 1
        else
                ls
		echo -e "\033[32m +++++++++++++++++Backup success+++++++++++++++++ \033[0m"
        fi
fi

sleep 3
#New application package
cd ${appDir}
echo -e "\033[32m +++++++++++++++++Start packing+++++++++++++++++ \033[0m"
rm -rf ${jarDir}
mvn clean package -DskipTests
echo -e "\033[32m +++++++++++++++++Package successful,The catalog contains the following+++++++++++++++++ \033[0m"
echo -e "\033[32m [INFO] ------------------------------------------------------------------------ \033[0m"
cd ${jarDir} && ls
echo -e "\033[32m [INFO] ------------------------------------------------------------------------ \033[0m"


