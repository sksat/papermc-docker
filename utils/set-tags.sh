#!/bin/bash
cd `dirname $0`

source ../.env

DEFAULT_BRANCH='main'
DEFAULT_JDK='openjdk'

if [[ "$JDK" == 'openjdk' ]]; then
	DEFAULT_BASE_IMG='17-slim'  # そうか？
elif [[ "$JDK" == 'temurin' ]]; then
	DEFAULT_BASE_IMG='17.0.1_12-jdk'
fi

#JDK=openjdk
#BASE_IMG=alpine

function add_mc(){
	local commit_short
	commit_short=$(git rev-parse --short ${PAPER_COMMIT})

	echo "$1"
	echo "$1-${MINECRAFT_VERSION}"
	echo "$1-${PAPER_VERSION}"
	echo "$1-${PAPER_VERSION}-${commit_short}"

	# FIXYOU: USE SEMVER!!!!!
	local of_couse_you_should_have_patch_version
	of_couse_you_should_have_patch_version=$(echo "${MINECRAFT_VERSION}" | awk -F'.' '{print $3}')

	local why_not_use_semver
	if [ -z "${of_couse_you_should_have_patch_version}" ]; then
		# MAKE PATCH VERSION EXIST AGAIN!!!!!
		why_not_use_semver="${MINECRAFT_VERSION}.0"

		echo "$1-${why_not_use_semver}"
	fi
}

function add_jdk(){
	echo "$1-${JDK}"
}

function add_base(){
	echo "$1-${BASE_IMG}"
}

function fix_empty(){
	# fix like hoge--fuga

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

	# ignore all empty
	if [[ ${tag: -1} != ':' ]]; then
		echo "$tag"
	fi
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

	# default JDK
	if [[ $JDK == "$DEFAULT_JDK" ]]; then
		tags="$tags $(echo $tags | sed -e "s/${DEFAULT_JDK}//g")"
	fi

	# default base image
	if [[ $BASE_IMG == "$DEFAULT_BASE_IMG" ]]; then
		tags="$tags $(echo $tags | sed -e "s/${DEFAULT_BASE_IMG}//g")"
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

	# get image tags from stdin
	base_imgs=$(cat -)
	for img in $base_imgs; do
		base=$(cut -d':' -f 1 <<<$img)
		base_tag=$(cut -d':' -f 2 <<<$img)
		#echo "base: $base, tag: $base_tag"

		# generate tags
		tags=$(add_all "")
		tags=$(gen_default "$tags")

		for t in $tags; do
			echo "$base:$base_tag-$t"
		done

		# default branch
		if [[ "$base_tag" == "$DEFAULT_BRANCH" ]]; then
			for t in $tags; do
				echo "$base:$t"
			done
		fi
	done
}

if [ $# -eq 1 ]; then
	add_all $1
	exit 0
fi

main
