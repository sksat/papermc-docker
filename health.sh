#!/bin/sh

SERVER="localhost"

if [ $# -ne 0 ]; then
  SERVER="$1"
fi

timeout 10 mc-monitor status --host ${SERVER} --port 25565
STATUS=$?
echo
echo "status exit code=${STATUS}"

if [ ${STATUS} -ne 0 ]; then
  pkill -KILL java
fi

exit 1
