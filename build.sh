#!/bin/bash

source .env

if [[ ${PAPER_VERSION} != "${MINECRAFT_VERSION}"* ]]; then echo "version mismatch!!!!"; exit 1; fi;

# Build PaperMC
#apt-get update -y && apt-get upgrade -y && apt-get install -y  git patch time
git config --global user.name sksat && git config --global user.email sksat@sksat
git clone https://github.com/PaperMC/Paper
cd Paper && git checkout $PAPER_COMMIT

# version check
diff <(echo $MINECRAFT_VERSION) <(cat Paper/gradle.properties | grep 'mcVersion =' | sed -e 's/mcVersion = //')
diff <(echo $PAPER_VERSION) <(cat Paper/gradle.properties | grep 'version =' | sed -e 's/version = //')

cd Paper && ./gradlew tasks
cd Paper && time ./gradlew applyPatches && time ./gradlew paperclipJar

find Paper | grep jar
ls Paper/build/libs -lh
cp Paper/build/libs/Paper-${PAPER_VERSION}.jar Paper/paperclip.jar
