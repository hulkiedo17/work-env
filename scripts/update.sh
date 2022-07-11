#!/usr/bin/env bash

packages=(vim gcc g++ clang gdb make cmake valgrind nasm
	asciinema xterm cppcheck strace tmux time binutils
	util-linux shellcheck xclip)

if [ -f "/etc/debian_version" ] ; then
	linux_type=debian
elif [ -f "/etc/arch-release" ] ; then
	linux_type=arch
else
	echo "unknown linux release"
	exit 0
fi

ProcessOptions() {
	if [ $# -lt 1 ] ; then
		printf "You did not provide any options.\n"
		printf "The system is updated by default.\n"

		Update
		exit 0
	fi

	while getopts ":haui" opt ; do
		case $opt in
			h) Help ;;
			a)
				Update
				Packages
				;;
			u) Update ;;
			i) Packages ;;
			*) printf "\n%s - unknown option\n" "$i" ;;
		esac
	done
}

Help() {
	echo "Usage: update.sh [-h|-a|-u|-i|]"
	echo ""
	echo "[options]:"
	echo -e "\t-h -> this help message"
	echo -e "\t-a -> use all flags(-u -i)"
	echo -e "\t-u -> update"
	echo -e "\t-i -> install packages"
}

Update() {
	if [ "$linux_type" == "debian" ] ; then
		yes | sudo apt-get update
		yes | sudo apt-get upgrade
		yes | sudo apt-get dist-upgrade
	elif [ "$linux_type" == "arch" ] ; then
		yes | sudo pacman -Syu
		yes | sudo pacman -Syy
	else
		echo "unknown type of package manager"
	fi
}

Packages() {
	for i in ${packages[*]}; do
		printf "\n[%s]\n" "$i"

		if [ "$linux_type" == "debian" ] ; then
			yes | sudo apt-get install "$i"
		elif [ "$linux_type" == "arch" ] ; then
			yes | sudo pacman -S "$i"
		else
			echo "unknown type of package manager"
		fi
	done
}

ProcessOptions "$@"
exit 0
