#!/bin/bash

# Official OpenJDK images
OPENJDK=(
  "openjdk:16-slim amd64            sha256:5e30ca58b3a57274d10066db652e53a452c446b1509514aa2f59dbe6979841f9"
  #"openjdk:16-slim arm64/v8         sha256:d7e6afd5155486baacd0895276cc74d534babc17153776730509df4550db450d"
  "openjdk:16-slim-buster amd64     sha256:8c903c0f29cd406dcea7011037338a6070f1e08098f793fb49135848d4874c27"
  #"openjdk:16-slim-buster arm64/v8  sha256:eb2c3e29cd8bead0443372f887d58ebf3ae163f674caeda4251cd5f37b93f4ec"
  "openjdk:16-oraclelinux8 amd64    sha256:5cb18383b0d7f469501021258a451bef2c2bbeb838dadb81d71129c643cf3638"
  #"openjdk:16-oraclelinux8 arm64/v8 sha256:af04c50184d0227ece48c85e5535d622a9f4ed649d5f18e0f18f58c006b934c8"
)

# Non-Official AdoptOpenJDK images(but AdoptOpenJDK maintained)
ADOPT_NONOFFICIAL=(
  "adoptopenjdk/openjdk16:alpine amd64      sha256:bfbd644a7134a25c9033c8bd7b8122679df1f1e0ba3b3efa11e7ca54a268f0ab"
  "adoptopenjdk/openjdk16:alpine-slim amd64 sha256:48e7722bfebda7f3e032b82cdcf741ed1d8286deaef9670dfac8f0cdd1fcbddb"
  "adoptopenjdk/openjdk16:alpine-jre amd64  sha256:ecc5ee8fb51c91740f79340c56d5abac0b7e76182cd7ce7ee38601806c7831fa"
  #"adoptopenjdk/openjdk16:aarch64-debianslim-jre-16.0.1_9 aarch64"
  #"adoptopenjdk/openjdk16:armv7l-debianslim-jre-16.0.1_9 arm/v7"
)
# Non-Official AdoptOpenJDK OpenJ9 images(but AdoptOpenJDK maintained)
ADOPT_NONOFFICIAL_OPENJ9=(
  "adoptopenjdk/openjdk16-openj9:alpine amd64      sha256:7da4de3b8bc632c16ed5b4b533943a34438ac23260ae71770035ce3ba88de3e2"
  "adoptopenjdk/openjdk16-openj9:alpine-slim amd64 sha256:e99a6f03c3f418eb34b982fbb5294549ff6c2981bded54eab053cf9f5431c2b6"
  "adoptopenjdk/openjdk16-openj9:alpine-jre amd64  sha256:34b080fc64a346f7e4d8b7985dcac88400f3c07d2e4ff3d57d6fa0e117a92657"
)

# Eclipse temurin
TEMURIN=(
  "eclipse-temurin:16.0.2_7-jdk amd64          sha256:f3f10742cdf64b964f9398f6ef515a7a9d0ad5b6d995f76b380bca38e3c11d86"
  "eclipse-temurin:16.0.2_7-jdk-focal amd64    sha256:6a2a5069f866178af582e224210678321b71bb2ffb5626fc1b287f29e25dd836"
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
