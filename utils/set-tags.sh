#!/bin/bash
cd `dirname $0`

source ../.env

DEFAULT_BRANCH='main'
DEFAULT_JDK='adoptopenjdk'
DEFAULT_BASE_IMG='alpine'

#JDK=openjdk
#BASE_IMG=alpine

function add_mc(){
	echo "$1"
	echo "$1-${MINECRAFT_VERSION}"
	echo "$1-${PAPER_VERSION}"
	echo "$1-${PAPER_VERSION}-${PAPER_COMMIT}"
}

function add_jdk(){
	echo "$1-${JDK}"
}

function add_base(){
	echo "$1-${BASE_IMG}"
}

function fix_empty(){
	local tag
	tag="$1"

	#echo "fix empty: $tag" 1>&2

	tag=$(echo $tag | sed -e 's/--/-/')

	# remove first
	tag=$(echo $tag | sed -e 's/:-/:/')
	if [[ ${tag:0:1} == '-' ]]; then
		tag="${tag:1}"
	fi

	# remove last
	if [[ ${tag: -1} == '-' ]]; then
		tag="${tag/%?/}"
	fi

	#echo "fixed    : $tag" 1>&2
	echo "$tag"
}

function add_all(){
	local origin
	local tags
	local tags_tmp

	origin="$1"
	tags=""
	tags_tmp=""

	#echo "original tag: ${origin}" 1>&2

	# Add Minecraft Version
	tags=$(add_mc ${origin})

	# Add JDK
	tags_tmp=""
	for t in $tags; do
		tags_tmp="${tags_tmp} $(add_jdk $t)"
	done
	tags="$tags_tmp"

	# Add base image
	tags_tmp=""
	for t in $tags; do
		tags_tmp="${tags_tmp} $(add_base $t)"
	done
	tags="$tags_tmp"

	# Fix empty & output
	for t in $tags; do
		t=$(fix_empty $t)
		echo $t
	done
}

function gen_default(){
	local tags
	tags="$1"

	# default branch
	if [[ $(git symbolic-ref --short HEAD) == "$DEFAULT_BRANCH" ]]; then
		tags=$(echo $tags | sed -e "s/${DEFAULT_BRANCH}//g")
	fi

	# default JDK
	if [[ $JDK == "$DEFAULT_JDK" ]]; then
		tags=$(echo $tags | sed -e "s/${DEFAULT_JDK}//g")
	fi

	# default base image
	if [[ $BASE_IMG == "$DEFAULT_BASE_IMG" ]]; then
		tags=$(echo $tags | sed -e "s/${DEFAULT_BASE_IMG}//g")
	fi

	# Fix empty & output
	for t in $tags; do
		t=$(fix_empty $t)
		echo $t
	done
}

function main(){
	local tags
	local tags_tmp

	# get tags from stdin
	tags=$(cat -)

	# generate all tags
	tags_tmp=""
	for t in $tags; do
		tags_tmp="$tags_tmp $(add_all $t)"
	done
	tags="$tags_tmp"

	# generate default version tags
	gen_default "$tags"

	# print tags
	for t in $tags; do
		echo $t
	done
}

if [ $# -eq 1 ]; then
	add_all $1
	exit 0
fi

main
