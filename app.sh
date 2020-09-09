#!/bin/bash

APP_HOME=/opt/app/java_apps/ldp/lib

APP_JAR=LDPPlatform-0.0.1.jar

APP_PIDS=$(ps -ef | grep ldp | grep -v grep | awk '{print $2}')

GC_CONF="-XX:+UseG1GC -XX:+DisableExplicitGC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=12 -XX:MetaspaceSize=100M -XX:-OmitStackTraceInFastThrow -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/applog/ldp/java_heapdump.hprof -Xloggc:/opt/applog/ldp/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationConcurrentTime -XX:+PrintHeapAtGC"

JVM_CONF="-Xms256k -Xmx1G -Xms1G"

function start(){

	if [ -z "${APP_PIDS}" ]; then

		echo "start project..."

		exec java -jar ${JVM_CONF} ${GC_CONF} $APP_HOME/$APP_JAR  >/dev/null 2>&1 &
		
		echo "start project end..."
		

	else

		echo "warning: the server is started!!!"

		exit 1

	fi

}

function stop(){
	if [ -z "${APP_PIDS}" ]; then
		echo "No server to stop"
	else
		echo "stop project ${APP_PIDS}..."
		kill -9 ${APP_PIDS}
		echo "stop project end..."
	fi
}

case "$1" in

    start)

    start

    ;;
    stop)

    stop

    ;;

    *)
    printf 'Usage: %s {start|stop|restart}\n' "$prog"
    ;;
esac

exit 1
