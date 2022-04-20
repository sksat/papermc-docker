#!/bin/bash

# Official OpenJDK images
OPENJDK=(
  "openjdk:17-slim amd64            sha256:aaa3b3cb27e3e520b8f116863d0580c438ed55ecfa0bc126b41f68c3f62f9774"
  #"openjdk:16-slim arm64/v8         sha256:d7e6afd5155486baacd0895276cc74d534babc17153776730509df4550db450d"
  "openjdk:17-slim-buster amd64     sha256:2e7658fb62d1c6f319ff9870614deaf8e06038dd41eec3d1ecdcfabd186234fd"
  #"openjdk:16-slim-buster arm64/v8  sha256:eb2c3e29cd8bead0443372f887d58ebf3ae163f674caeda4251cd5f37b93f4ec"
  "openjdk:17-oraclelinux8 amd64    sha256:f2c05f4018f8fd013091972fbd467f60a45418d68e99d908327662e90938a4ae"
  #"openjdk:16-oraclelinux8 arm64/v8 sha256:af04c50184d0227ece48c85e5535d622a9f4ed649d5f18e0f18f58c006b934c8"
)

# Eclipse temurin
TEMURIN=(
  "eclipse-temurin:17.0.1_12-jdk amd64          sha256:3ad6ea71c5a426a38d7cd4ff7fb521c5392d232278b13953b830c0ab0f046ada"
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
