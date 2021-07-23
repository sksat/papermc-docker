#!/bin/bash

# check latest commit
git clone --depth 1 https://github.com/PaperMC/Paper.git
cd Paper

MINECRAFT_VERSION_LATEST=$(cat gradle.properties | grep 'mcVersion =' | sed -e 's/mcVersion = //')
PAPER_VERSION_LATEST=$(cat gradle.properties | grep 'version =' | sed -e 's/version = //')
PAPER_COMMIT_LATEST=$(git rev-parse HEAD)

cd ..
rm -rf Paper

# check diff
source .env
echo "IMG_TAG=${IMG_TAG}" >> .env_latest
echo "MINECRAFT_VERSION='${MINECRAFT_VERSION_LATEST}'" >> .env_latest
echo "PAPER_VERSION='${PAPER_VERSION_LATEST}'" >> .env_latest
echo "PAPER_COMMIT=${PAPER_COMMIT_LATEST}" >> .env_latest

diff .env .env_latest
if [ $? -eq 0 ]; then
	echo "no update"
	exit 0
fi

diff <(echo $MINECRAFT_VERSION) <(echo $MINECRAFT_VERSION_LATEST)
if [ $? -ne 0 ]; then
	echo "Minecraft version update!!!!!"
	if [[ $1 != "minecraft" ]]; then
		echo "please update manually: ./update.sh minecraft"
		rm .env_latest
		exit 1
	fi
fi

# update
mv .env_latest .env
