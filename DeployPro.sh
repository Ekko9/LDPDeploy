#!/bin/bash
#deploy PRO LDPPlatform
jarName=LDPPlatform-0.0.1.jar
appDir=/DATA/jenkins/workspace/LDP-Deploy-PRO
jarDir=/DATA/jenkins/workspace/LDP-Deploy-PRO/target
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

sleep 3
#Deploy application
echo -e "\033[32m +++++++++++++++++Start backup app+++++++++++++++++ \033[0m"
uname=prouser
appBackdir=/opt/app/earPool/earBak/$(date "+%Y-%m-%d")
appDir=/opt/app/java_apps/ldp/lib
for i in xxx.xxx.xxx.{1..10}
do
        echo $i
        ssh -T ${uname}@$i <<EOF
        if [ ! -d "${appBackdir}" ]; then
                echo -e "\033[31m directory does not exist, creating。。。 \033[0m"      
                mkdir ${appBackdir}
		mv ${appDir}/${jarName} ${appBackdir} 
		cd ${appBackdir} && ls
		echo -e "\033[32m +++++++++++++++++backup successful+++++++++++++++++ \033[0m"
        else
                echo -e "\033[32m directory already exists,start backup files。。。 \033[0m"
		mv ${appDir}/${jarName} ${appBackdir}
		cd ${appBackdir} && ls	
  		echo -e "\033[32m +++++++++++++++++backup successful+++++++++++++++++ \033[0m"
        fi
                   
EOF
	echo -e "\033[32m +++++++++++++++++Start deploying $i app+++++++++++++++++ \033[0m"
	scp ${jarDir}/${jarName} ${uname}@$i:${appDir}
	ssh -T ${uname}@$i <<EOF
	cd ${appDir}
	if [ ! -f "${jarName}" ]; then
		echo -e "\033[32m +++++++++++++++++${i}_${jarName} not exist，Please check+++++++++++++++++ \033[0m"
		exit 1
	else
		echo -e "\033[32m +++++++++++++++++${i}_${jarName} exist， Deployment successful+++++++++++++++++ \033[0m"
		ls
		echo -e "\033[32m +++++++++++++++++${i}_Restarting+++++++++++++++++ \033[0m"
		sh /opt/app/java_apps/bin/restart.sh
		echo -e "\033[32m +++++++++++++++++${i}_restart successful+++++++++++++++++ \033[0m"	
	fi

EOF

done
exit
