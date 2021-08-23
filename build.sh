#!/bin/bash

source .env

if [[ ${PAPER_VERSION} != "${MINECRAFT_VERSION}"* ]]; then echo "version mismatch!!!!"; exit 1; fi;

# Build PaperMC
#apt-get update -y && apt-get upgrade -y && apt-get install -y  git patch time
git config --global user.name sksat && git config --global user.email sksat@sksat.net
git clone https://github.com/PaperMC/Paper
cd Paper && git checkout $PAPER_COMMIT

# version check
diff <(echo $MINECRAFT_VERSION) <(cat gradle.properties | grep 'mcVersion =' | sed -e 's/mcVersion = //')
diff <(echo $PAPER_VERSION) <(cat gradle.properties | grep 'version =' | sed -e 's/version = //')

./gradlew tasks
time ./gradlew applyPatches && time ./gradlew paperclipJar

find . | grep jar
ls build/libs -lh
cp build/libs/Paper-${PAPER_VERSION}.jar paperclip.jar
