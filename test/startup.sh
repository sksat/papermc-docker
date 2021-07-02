#!/bin/bash
cd `dirname $0`
pwd

source ../.env
if [ $# -eq 1 ]; then
	IMG_TAG=$1
fi

mkdir -p data
echo "eula=true" > data/eula.txt

env IMG_TAG=${IMG_TAG} docker-compose up -d
sleep 60
docker-compose ps

if [ -z $(docker-compose ps -q) ]; then
	echo "error: service is down"
	exit 1
fi

MCSTATUS_JSON=$(mcstatus localhost json)
echo "${MCSTATUS_JSON}"

MCSTATUS_ONLINE=$(echo ${MCSTATUS_JSON} | jq .online)

if [ "${MCSTATUS_ONLINE}" != 'true' ]; then
	echo "Minecraft server is down"
fi

docker-compose logs
docker-compose down
rm -rf data
exit 0