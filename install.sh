#!/usr/bin/env bash

path_to_dotfiles="$PWD/dotfiles"

options=(-h -a -u -i -d -f -s)
source_dotfiles=(vimrc gitconf xresources path prompt dbg)
output_dotfiles=(~/.vimrc ~/.gitconfig ~/.Xresources
	~/.bashrc.d/path.bash ~/.bashrc.d/prompt.bash
	~/.bashrc.d/dbg.bash)
packages=(vim gcc g++ clang gdb make cmake valgrind nasm
	asciinema xterm cppcheck strace tmux time binutils
	util-linux shellcheck xclip)
update_commands=(update upgrade dist-upgrade)
directories=(.bashrc.d .bin work)

if [ -f "/etc/debian_version" ] ; then
	linux_type=debian
elif [ -f "/etc/arch-release" ] ; then
	linux_type=arch
else
	echo "unknown linux release"
	exit 0
fi

handle_options() {
	for i in "$@"; do
		case "$i" in
			"${options[0]}")
				Help
				exit 0
				;;
			"${options[1]}")
				Update
				Packages
				Directories
				Files
				Source
				;;
			"${options[2]}")
				Update
				;;
			"${options[3]}")
				Packages
				;;
			"${options[4]}")
				Directories
				;;
			"${options[5]}")
				Files
				;;
			"${options[6]}")
				Source
				;;
			*)
				printf "\n%s - unknown option\n" "$i"
				;;
		esac
	done

	if [ $# = 0 ]; then
		printf "You did not provide any options.\n"
		printf "The system is updated by default.\n"

		Update
	fi
}

Help() {
	echo "Usage: ./init.sh [-h|-a|-u|-i|-d|-f]"
	echo ""
	echo "[options]:"
	echo -e "\t-h -> this help message"
	echo -e "\t-a -> use all flags(-u -i -d -f -s)"
	echo -e "\t-u -> update"
	echo -e "\t-i -> install packages"
	echo -e "\t-d -> make directories"
	echo -e "\t-f -> install dotfiles\n"
	echo -e "(before installing files, you need to create directories: first -d, then -f)"
}

Update() {
	if [ "$linux_type" == "debian" ] ; then
		for i in ${update_commands[*]}; do
			yes | sudo apt-get "$i"
		done
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

Directories() {
	cd "$HOME" || { echo "cd failure"; exit 1; }

	for i in ${directories[*]}; do
		printf "[%s]\n" "$i"
		mkdir -p "$i"
	done
}

Files() {
	cd "$path_to_dotfiles" || { echo "cd failure"; exit 1; }

	# init all files without bashrc (because you can overwrite it)
	for i in ${!source_dotfiles[*]}; do
		printf "[%s]\n" "${source_dotfiles[$i]}"
		cat "${source_dotfiles[$i]}" > "${output_dotfiles[$i]}"
	done

	printf "[bashrc]\n"
	cat "bashrc" >> "$HOME/.bashrc"
}

Source() {
	# shellcheck source=$HOME/.bashrc
	source "$HOME/.bashrc"
}

handle_options "$@"
exit 0
