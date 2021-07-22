#!/bin/bash

# check latest commit
git clone --depth 1 https://github.com/PaperMC/Paper.git
cd Paper
PAPER_COMMIT_LATEST=$(git rev-parse HEAD)
cd ..
rm -rf Paper

# diff commit
source .env
diff <(echo $PAPER_COMMIT) <(echo $PAPER_COMMIT_LATEST)
if [ $? -eq 0 ]; then
	echo "no update"
	exit 0
fi

# update
sed -e '/PAPER_COMMIT=/d' .env > .env_new
echo "PAPER_COMMIT=${PAPER_COMMIT_LATEST}" >> .env_new
mv .env_new .env
