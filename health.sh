#!/bin/sh
cd `dirname $0`

SERVER="localhost"

if [ $# -ne 0 ]; then
  SERVER="$1"
fi

if [ ! -e /tmp/healthcheck-start ]; then
	date '+%s' > /tmp/healthcheck-start
else
	start_time=$(cat /tmp/healthcheck-start)
	elapsed=$(expr `date +%s` - $start_time)
	if [ $elapsed -lt 300 ]; then
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
