#!/bin/bash
#Replace file
filedir=/DATA/script/TEST/NewFile
uname=prouser
remotedir=/opt/app/java_apps/ldp/lib
jarname=LDPPlatform-0.0.1.jar
backdir=/opt/app/earPool/earBak/$(date "+%Y-%m-%d")
checkdir=`ls ${filedir}`
#Backup files
for i in iplist
do
        echo $i
        ssh -T ${uname}@$i <<EOF
        if [ ! -d "${backdir}" ]; then
                echo -e "\033[31m directory does not exist, creating。。。 \033[0m"
                mkdir ${backdir}
                cp ${remotedir}/${jarname} ${backdir}
                cd ${backdir} && ls
                echo -e "\033[32m +++++++++++++++++backup successful+++++++++++++++++ \033[0m"
        else
                echo -e "\033[32m directory already exists,start backup files。。。 \033[0m"
                cp ${remotedir}/${jarname} ${backdir}
                cd ${backdir} && ls
                echo -e "\033[32m +++++++++++++++++backup successful+++++++++++++++++ \033[0m"
        fi

EOF
done
#scp files
for i in iplist
do
	echo -e "\033[32m +++++++++++++++++Check the files in the directory+++++++++++++++++ \033[0m"
	echo -e "\033[32m ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \033[0m"
	echo -e "\033[32m ++                    ${checkdir}                 ++ \033[0m"
	echo -e "\033[32m ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ \033[0m"
	echo -e "\033[32m +++++++++++++++++++++++Start SCP $i file++++++++++++++++++++++++++ \033[0m"			
	scp ${filedir}/* ${uname}@$i:${remotedir}
	echo -e "\033[32m +++++++++++++++++++++The SCP $i file is end+++++++++++++++++++++++ \033[0m"
done

#restart app
for i in iplist
do
        echo $i
        ssh -T ${uname}@$i <<EOF
	echo -e "\033[32m +++++++++++++++++++++restart $i+++++++++++++++++++++++ \033[0m"
	sh /opt/app/java_apps/bin/restart.sh
	echo -e "\033[32m ++++++++++++++++++The restart $i is end+++++++++++++++ \033[0m"
EOF
done	
exit	
