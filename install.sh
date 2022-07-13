#!/usr/bin/env bash

path_to_dotfiles="$PWD/dotfiles"

source_dotfiles=(vimrc gitconf xresources path prompt dbg counter)
output_dotfiles=(~/.vimrc ~/.gitconfig ~/.Xresources
	~/.bashrc.d/path.bash ~/.bashrc.d/prompt.bash
	~/.bashrc.d/dbg.bash ~/.bashrc.d/counter.bash)
directories=(.bashrc.d .bin work others)

ProcessOptions() {
	if [ $# -lt 1 ] ; then
		printf "You did not provide any options.\n"
		exit 0
	fi

	while getopts ":hadfs" opt ; do
		case $opt in
			h) Help ;;
			a)
				Directories
				Files
				Source
				;;
			d) Directories ;;
			f) Files ;;
			s) Source ;;
			*) printf "\n%s - unknown option\n" "$i" ;;
		esac
	done
}

Help() {
	echo "Usage: dotfiles.sh [-h|-a|-d|-f|-s]"
	echo ""
	echo "[options]:"
	echo -e "\t-h -> this help message"
	echo -e "\t-a -> use all flags(-d -f -s)"
	echo -e "\t-d -> make directories"
	echo -e "\t-f -> install dotfiles"
	echo -e "\t-s -> update bashrc"
	echo -e "(before installing files, you need to create directories: first -d, then -f)"
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

ProcessOptions "$@"
exit 0
