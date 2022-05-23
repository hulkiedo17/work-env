#!/usr/bin/env bash

path_to_dotfiles="$PWD/dotfiles"

options=(-h -a -u -i -d -f -s)
source_dotfiles=(vimrc gitconf xresources path prompt dbg)
output_dotfiles=(~/.vimrc ~/.gitconfig ~/.Xresources
	~/.bashrc.d/path.bash ~/.bashrc.d/prompt.bash
	~/.bashrc.d/dbg.bash)
packages=(vim gcc g++ clang gdb make cmake valgrind nasm
	asciinema xterm cppcheck strace tmux time binutils
	util-linux shellcheck)
update_commands=(update upgrade dist-upgrade)
directories=(.bashrc.d .bin work)

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

		update
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
	for i in ${update_commands[*]}; do
		yes | sudo apt-get "$i"
	done
}

Packages() {
	for i in ${packages[*]}; do
		printf "\n[%s]\n" "$i"
		yes | sudo apt-get install "$i"
	done
}

Directories() {
	cd "$HOME" || { echo "cd failure"; exit 1; }

	for i in ${directories[*]}; do
		printf "[%s]\n" "$i"
		mkdir "$i"
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
