#!/bin/sh

SERVER="localhost"

if [ $# -ne 0 ]; then
  SERVER="$1"
fi

if [ ! -e /tmp/healthcheck-start ]; then
	date '+%s' > /tmp/healthcheck-start
	exit 0
else
	start_time=$(cat /tmp/healthcheck-start)
	now_time=$(date '+%s')
	elapsed=$(expr $now_time - $start_time)
	if [ $elapsed -lt 600 ]; then
		exit 0
	fi
fi

timeout 10 mc-monitor status --host ${SERVER} --port 25565
STATUS=$?
echo
echo "status exit code=${STATUS}"

if [ ${STATUS} -ne 0 ]; then
  pkill -KILL java
fi

exit 1
