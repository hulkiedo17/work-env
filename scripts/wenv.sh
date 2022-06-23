#!/usr/bin/env bash

path_to_dotfiles="$PWD/dotfiles"
backup_name="backup.tar.gz"
archive_name="backup.tar"

source_dotfiles=(vimrc gitconf xresources path prompt dbg counter)
output_dotfiles=(~/.vimrc ~/.gitconfig ~/.Xresources
	~/.bashrc.d/path.bash ~/.bashrc.d/prompt.bash
	~/.bashrc.d/dbg.bash ~/.bashrc.d/counter.bash)
packages=(vim gcc g++ clang gdb make cmake valgrind nasm
	asciinema xterm cppcheck strace tmux time binutils
	util-linux shellcheck xclip)
update_commands=(update upgrade dist-upgrade)
directories=(.bashrc.d .bin work others)

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
	fi

	while getopts ":hauidfsk:m:e:" opt ; do
		case $opt in
			h) Help ;;
			a)
				Update
				Packages
				Directories
				Files
				Source
				;;
			u) Update ;;
			i) Packages ;;
			d) Directories ;;
			f) Files ;;
			s) Source ;;
			k) GenerateSSH "$OPTARG" ;;
			m) MakeBackup "$OPTARG" ;;
			e) ExtractBackup "$OPTARG" ;;
			*) printf "\n%s - unknown option\n" "$i" ;;
		esac
	done
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
	echo -e "\t-f -> install dotfiles"
	echo -e "\t-k [email] -> generate ssh key"
	echo -e "\t-m [path]  -> generate backup file from path"
	echo -e "\t-e [path]  -> extract backup file to path\n"
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

GenerateSSH() {
	if [ -z "$1" ] ; then
		echo "please type your email."
		exit 0
	fi

	email="$1"

	ssh-keygen "-t" "ed25519" "-C" "\"$email\""
	cat ~/.ssh/id_ed25519.pub | xclip "-selection" "clipboard"
}

MakeBackup() {
	if [ -z "$1" ] ; then
		echo "please type path to directory or files."
		exit 0
	fi

	echo "generating backup..."

	tar -cpvzf "$backup_name" "$1"
}

ExtractBackup() {
	if [ -z "$1" ] ; then
		echo "please type path to extract directory."
		exit 0
	fi

	echo "unpacking backup..."
	gzip -d "$backup_name"
	tar -xvf "$archive_name" -C "$1"
	rm "$archive_name"
}

ProcessOptions "$@"
exit 0
