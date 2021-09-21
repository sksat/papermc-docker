#!/bin/bash

# Official OpenJDK images
OPENJDK=(
  "openjdk:16-slim amd64,arm64/v8"
  "openjdk:16-slim-buster amd64,arm64/v8"
  "openjdk:16-oraclelinux8 amd64,arm64/v8"
)

# Non-Official AdoptOpenJDK images(but AdoptOpenJDK maintained)
ADOPT_NONOFFICIAL=(
  "adoptopenjdk/openjdk16:alpine amd64"
  "adoptopenjdk/openjdk16:alpine-slim amd64"
  "adoptopenjdk/openjdk16:alpine-jre amd64"
  #"adoptopenjdk/openjdk16:aarch64-debianslim-jre-16.0.1_9 aarch64"
  #"adoptopenjdk/openjdk16:armv7l-debianslim-jre-16.0.1_9 arm/v7"
)
# Non-Official AdoptOpenJDK OpenJ9 images(but AdoptOpenJDK maintained)
ADOPT_NONOFFICIAL_OPENJ9=(
  "adoptopenjdk/openjdk16-openj9:alpine amd64"
  "adoptopenjdk/openjdk16-openj9:alpine-slim amd64"
  "adoptopenjdk/openjdk16-openj9:alpine-jre amd64"
)

# Eclipse temurin
TEMURIN=(
  "eclipse-temurin:16.0.2_7-jdk amd64"
  "eclipse-temurin:16.0.2_7-jdk-focal amd64,arm64/v8"
)

function openjdk_imgs(){
	for openjdk in "${OPENJDK[@]}"; do
		oj=(${openjdk[@]})
		img="${oj[0]}"
		arch="${oj[1]}"

		tag=$(cut -d':' -f 2 <<<${img})
		echo "\"$img\""
	done
}

function adopt_imgs(){
	for adopt in "${ADOPT_NONOFFICIAL[@]}"; do
		a=(${adopt[@]})
		img="${a[0]}"
		arch="${a[1]}"

		tag=$(cut -d':' -f 2 <<<${img})

		#echo "img: $img"
		#echo "tag: $tag"
		#echo "arch: $arch"

		echo "\"$img\""
	done
}

function adopt_openj9_imgs(){
	for adopt in "${ADOPT_NONOFFICIAL_OPENJ9[@]}"; do
		a=(${adopt[@]})
		img="${a[0]}"
		arch="${a[1]}"

		tag=$(cut -d':' -f 2 <<<${img})
		echo "\"$img\""
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
	echo "::set-output JDK_MATRIX=openjdk,adopt"
elif [[ $1 == 'base-img' ]]; then
	if [ $# -eq 1 ]; then
		openjdk_imgs
		adopt_imgs
		adopt_openj9_imgs
		temurin_imgs
	fi

	if [[ $2 == 'adopt' ]]; then
		adopt_imgs
	elif [[ $2 == 'adopt-openj9' ]]; then
		adopt_openj9_imgs
	elif [[ $2 == 'temurin' ]]; then
		temurin_imgs
	elif [[ $2 == 'openjdk' ]]; then
		openjdk_imgs
	fi
fi
