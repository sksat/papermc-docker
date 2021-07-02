#!/bin/bash

source .env
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

docker-compose down
rm -rf data
exit 0
