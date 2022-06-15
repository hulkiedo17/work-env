#!/usr/bin/env bash

usage() {
	echo "usage: $0 [ -h | -c ] [ -r program | -s program | -d program | -t program ] [ -a file|path ]"
}

sanitize() {
	valgrind "-s" "--leak-check=full" "--track-origins=yes" "--show-leak-kinds=all" "./$1"
}

debug() {
	gdb ./"$1"
}

analyze() {
	cppcheck ./"$1"
}

trace() {
	strace ./"$1"
}

compile_release() {
	mkdir -p build
	cd build

	cmake "-DCMAKE_BUILD_TYPE=RELEASE" ".."
	make
}

compile_debug() {
	mkdir -p build
	cd build

	cmake "-DCMAKE_BUILD_TYPE=DEBUG" ".."
	make
}

execute() {
	./"$1"
}

if [ $# -lt 1 ] ; then
	echo "no options found."
	exit 1
fi

while getopts ":hcCr:s:d:a:t:p:P:" opt ; do
	case $opt in
		h) usage ;;
		c) compile_debug ;;
		C) compile_release ;;
		r) execute "$OPTARG" ;;
		s) sanitize "$OPTARG" ;;
		d) debug "$OPTARG" ;;
		a) analyze "$OPTARG" ;;
		t) trace "$OPTARG" ;;
		*) echo "no reasonable options found" ;;
	esac
done

exit 0
