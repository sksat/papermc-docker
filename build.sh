#!/bin/bash

source .env

if [[ ${PAPER_VERSION} != "${MINECRAFT_VERSION}"* ]]; then echo "version mismatch!!!!"; exit 1; fi;

# Build PaperMC
#apt-get update -y && apt-get upgrade -y && apt-get install -y  git patch time

if [ -e Paper/paperclip.jar ]; then
	echo "paperclip.jar already exist. skip build."
	exit
fi

# clone PaperMC if not exists
if [ ! -d Paper ]; then
	git clone https://github.com/PaperMC/Paper
fi
cd Paper && git checkout $PAPER_COMMIT

if $CI; then
	#echo "CI"
	git config --global user.name sksat && git config --global user.email sksat@sksat.net
fi

# version check
diff <(echo $MINECRAFT_VERSION) <(cat gradle.properties | grep 'mcVersion =' | sed -e 's/mcVersion = //')
diff <(echo $PAPER_VERSION) <(cat gradle.properties | grep 'version =' | sed -e 's/version = //')

./gradlew tasks
time ./gradlew applyPatches && time ./gradlew paperclipJar

find . | grep jar
ls build/libs -lh
cp build/libs/Paper-${PAPER_VERSION}.jar paperclip.jar
