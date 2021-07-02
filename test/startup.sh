#!/bin/bash

mkdir -p data
echo "eula=true" > data/eula.txt

docker-compose up -d
sleep 60
docker-compose ps

if [ -z $(docker-compose ps -q) ]; then
	echo "error: service is down"
	exit 1
fi

docker-compose down
rm -rf data
exit 0
