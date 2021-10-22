#!/bin/sh
cd $(dirname $0)
[ -e DATA ] || mkdir DATA

export JENKINS_HOME=/DATA/jenkins/DATA
nohup  java -Xmx6g -jar jenkins.war --httpPort=9091 >/dev/null 2>err.log &
