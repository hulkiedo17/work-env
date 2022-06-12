#!/usr/bin/env bash

EXEC="$1"
options=(-v -s -a -d -c -r)

# -v
valgrind_check() {
	echo "build.sh: valgrind"
	valgrind "-s" "--leak-check=full" "--track-origins=yes" "--show-leak-kinds=all" "./$EXEC"
}

# -s
strace_check() {
	echo "build.sh: strace"
}

# -a
cppcheck_start() {
	echo "build.sh: cppcheck"
}

# -d
debug() {
	echo "build.sh: debug"
	gdb "./$EXEC"
}

# -c
compile() {
	echo "build.sh: compile"
	gcc "./$EXEC.c" "-o" "./$EXEC" "-g" "-O0" "-Wall" "-Wextra" "-Werror" "-lconf"
}

# -r
run_exec() {
	echo "build.sh: run_exec"
	./$EXEC
}

handle_options() {
	for i in $@; do
		case "$i" in
			"${options[0]}")
				valgrind_check
				;;
			"${options[1]}")
				#
				;;
			"${options[2]}")
				#
				;;
			"${options[3]}")
				debug
				;;
			"${options[4]}")
				compile
				;;
			"${options[5]}")
				run_exec
				;;
			*)
				echo "build.sh: unknown command"
				;;
		esac
	done
}

handle_options "$@"
exit 0
