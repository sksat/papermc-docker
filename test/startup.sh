#!/bin/bash
cd `dirname $0`
pwd

source ../.env
if [ $# -eq 1 ]; then
	IMG_TAG=$(echo "$1" | sed 's/\//-/')
fi

mkdir -p data
echo "eula=true" > data/eula.txt

echo "image tag: ${IMG_TAG}"
env IMG_TAG="${IMG_TAG}" docker-compose up -d
sleep 5
docker-compose ps

if [ ! -z "$(docker-compose ps | grep 'Exit 1')" ]; then
	echo "error: service is down"
	exit 1
fi

echo "wait for start..."

# wait start loop
SECONDS=0
while true
do
	sleep 1
	MCSTATUS_JSON=$(mcstatus localhost json)
	MCSTATUS_ONLINE=$(echo ${MCSTATUS_JSON} | jq .online)
	if [ "${MCSTATUS_ONLINE}" == 'true' ]; then
		break
	fi
	echo "waiting...${SECONDS}"
	if [ $SECONDS -gt 300 ]; then
		echo "timeout"
		break
	fi
done

docker-compose ps
docker-compose logs

echo "${MCSTATUS_JSON}"
MCSTATUS_VERSION=$(echo ${MCSTATUS_JSON} | jq .version)

if [ "${MCSTATUS_ONLINE}" != 'true' ]; then
	echo "Minecraft server is down"
	exit 1
fi

if [ "${MCSTATUS_VERSION}" != "\"Paper ${MINECRAFT_VERSION}\"" ]; then
	echo "Minecraft version mismatch: ${MCSTATUS_VERSION}"
	exit 1
fi

env IMG_TAG="${IMG_TAG}" docker-compose down
sudo rm -rf data
exit 0
