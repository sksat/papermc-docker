#!/bin/bash

# Official OpenJDK images
OPENJDK=(
  "openjdk:19-slim amd64            sha256:060fa4ceeacb7ca54f77a4ae075d3a5957f57f49d474a0d3c586ca07b3214791"
  #"openjdk:16-slim arm64/v8         sha256:d7e6afd5155486baacd0895276cc74d534babc17153776730509df4550db450d"
  "openjdk:19-slim-buster amd64     sha256:43c40788ca60bea0eab3ba159884ad70fe519b160858261b2111631a9faaf1d4"
  #"openjdk:16-slim-buster arm64/v8  sha256:eb2c3e29cd8bead0443372f887d58ebf3ae163f674caeda4251cd5f37b93f4ec"
  "openjdk:19-oraclelinux8 amd64    sha256:07ee6f60e278a41220d808ccc2f2284c67886211c3c464f8fc34bb6b094be0d1"
  #"openjdk:16-oraclelinux8 arm64/v8 sha256:af04c50184d0227ece48c85e5535d622a9f4ed649d5f18e0f18f58c006b934c8"
)

# Eclipse temurin
TEMURIN=(
  "eclipse-temurin:17.0.1_12-jdk amd64          sha256:9807260b54b9cfb3c076a975983577bf9f81400e11cf9ff6e3342f96b7ff2f8e"
  "eclipse-temurin:17.0.1_12-jdk-focal amd64    sha256:fc1c2aa974ab02283a771a9ae9fa9ad9e45dfce694cab6f10c30101cd32632ec"
  #"eclipse-temurin:16.0.2_7-jdk-focal arm64/v8"
)

function openjdk_imgs(){
	for openjdk in "${OPENJDK[@]}"; do
		oj=(${openjdk[@]})
		img="${oj[0]}"
		arch="${oj[1]}"
		digest="${oj[2]}"

		tag=$(cut -d':' -f 2 <<<${img})
		echo "\"${img}@${digest}\""
	done
}

function temurin_imgs(){
	for temurin in "${TEMURIN[@]}"; do
		t=(${temurin[@]})
		img="${t[0]}"
		arch="${t[1]}"

		tag=$(cut -d':' -f 2 <<<${img})
		echo "\"$img\""
	done
}

if [[ $1 == 'jdk-list' ]]; then
	# JDK matrix for build jar
	echo "::set-output JDK_MATRIX=openjdk,temurin"
elif [[ $1 == 'base-img' ]]; then
	if [ $# -eq 1 ]; then
		openjdk_imgs
		temurin_imgs
	fi

	if [[ $2 == 'temurin' ]]; then
		temurin_imgs
	elif [[ $2 == 'openjdk' ]]; then
		openjdk_imgs
	fi
fi
