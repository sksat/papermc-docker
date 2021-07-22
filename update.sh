#!/bin/bash

# check latest commit
git clone --depth 1 https://github.com/PaperMC/Paper.git
cd Paper

tmp_ver=$(cat gradle.properties | grep 'version =')
tmp_mcver=$(cat gradle.properties | grep 'mcVersion')
MINECRAFT_VERSION_LATEST=${tmp_mcver:12}
PAPER_VERSION_LATEST=${tmp_ver:10}
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

# update
mv .env_latest .env
