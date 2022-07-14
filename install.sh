#!/usr/bin/env bash

path_to_dotfiles="$PWD/files"

source_dotfiles=(vimrc gitconf xresources path prompt dbg counter)
output_dotfiles=(~/.vimrc ~/.gitconfig ~/.Xresources
	~/.bashrc.d/path.bash ~/.bashrc.d/prompt.bash
	~/.bashrc.d/dbg.bash ~/.bashrc.d/counter.bash)
directories=(.bashrc.d .bin work others)

dirs() {
	cd "$HOME" || { echo "cd failure"; exit 1; }

	for i in ${directories[*]}; do
		printf "[%s]\n" "$i"
		mkdir -p "$i"
	done
}

files() {
	cd "$path_to_dotfiles" || { echo "cd failure"; exit 1; }

	# init all files without bashrc (because you can overwrite it)
	for i in ${!source_dotfiles[*]}; do
		printf "[%s]\n" "${source_dotfiles[$i]}"
		cat "${source_dotfiles[$i]}" > "${output_dotfiles[$i]}"
	done

	printf "[bashrc]\n"
	cat "bashrc" >> "$HOME/.bashrc"
}

dirs
files

# shellcheck source=$HOME/.bashrc
source "$HOME/.bashrc"

exit 0
