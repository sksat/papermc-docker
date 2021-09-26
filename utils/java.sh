#!/bin/bash

# Official OpenJDK images
OPENJDK=(
  "openjdk:16-slim amd64            sha256:f74e140721bffb24b1317df8c8b4ea30c7dd2c068b563e89d4c6f033ebbdad12"
  #"openjdk:16-slim arm64/v8         sha256:d7e6afd5155486baacd0895276cc74d534babc17153776730509df4550db450d"
  "openjdk:16-slim-buster amd64     sha256:98425688c0bdacdee571eb6bb189d6267eba622d3755f4713b7ef1de6fa16841"
  #"openjdk:16-slim-buster arm64/v8  sha256:eb2c3e29cd8bead0443372f887d58ebf3ae163f674caeda4251cd5f37b93f4ec"
  "openjdk:16-oraclelinux8 amd64    sha256:b9bfe157484c290e7eb244af0625bee3db406fbec7e876c5ff23d60c333ed534"
  #"openjdk:16-oraclelinux8 arm64/v8 sha256:af04c50184d0227ece48c85e5535d622a9f4ed649d5f18e0f18f58c006b934c8"
)

# Non-Official AdoptOpenJDK images(but AdoptOpenJDK maintained)
ADOPT_NONOFFICIAL=(
  "adoptopenjdk/openjdk16:alpine amd64      sha256:4c68697011ebfa6f2534c3296386b81b9c49ae3197a33546326a40963811935f"
  "adoptopenjdk/openjdk16:alpine-slim amd64 sha256:96ca2cd0ca4b572dea5efc6c8af6b7354caad941ef7a953b691c7894919393e5"
  "adoptopenjdk/openjdk16:alpine-jre amd64  sha256:55a5fd6d8b6ef9a97a07ffeda2b5e8fbbe462a236b2c76ac04ae8637bc8a6392"
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
  "eclipse-temurin:16.0.2_7-jdk amd64          sha256:0274429ef583aebf510c77fe48186f2fdfeaae1bf5496797924f46d2bb974cb5"
  "eclipse-temurin:16.0.2_7-jdk-focal amd64    sha256:8d90792b442d624250edef8a2550ae0c333e7772253609b4ea45d96b7034a20e"
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
