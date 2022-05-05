#!/usr/bin/env bash

current_dir="$PWD"
home_dir="$HOME"

options=(-h -a -u -i -d -f -s)
source_dotfiles=(vimrc gitconf xresources path prompt dbg)
final_dotfiles=(~/.vimrc ~/.gitconfig ~/.Xresources ~/.bashrc.d/path.bash ~/.bashrc.d/prompt.bash ~/.bashrc.d/dbg.bash)
programs=(vim gcc g++ clang gdb make cmake valgrind nasm asciinema xterm cppcheck strace tmux time binutils util-linux)
update_commands=(update upgrade dist-upgrade)
directories=(.bashrc.d .bin work)
sub_directories=(text others sources)

handle_options() {
	printf "\nSTART INITIALIZATION SCRIPT\n"

	for i in $@; do
		case "$i" in
			"${options[0]}")  # print help
				Help
				exit 0
				;;
			"${options[1]}")  # do all options
				Update
				Programs
				Directories
				Files
				Source
				;;
			"${options[2]}")  # do only update option
				Update
				;;
			"${options[3]}")  # do only install option
				Programs
				;;
			"${options[4]}")  # do only directories option
				Directories
				;;
			"${options[5]}")  # do only files option
				Files
				;;
			"${options[6]}") # do source bashrc
				Source
				;;
			*)
				printf "\n$i - unknown option\n"
				;;
		esac
	done

	if [ $# = 0 ]; then
		printf "You did not provide any options.\n"
		printf "The system is updated by default.\n"

		update
	fi

	printf "\nEND INITIALIZATION SCRIPT\n"
}

Help() {
	echo "Usage: ./init.sh [-h|-a|-u|-i|-d|-f]"
	echo ""
	echo "[options]:"
	echo -e "\t-h -> help message"
	echo -e "\t-a -> all flags(-u -i -d -f)"
	echo -e "\t-u -> update"
	echo -e "\t-i -> install(programs)"
	echo -e "\t-d -> directories"
	echo -e "\t-f -> install files(dotfiles)"
	echo -e "\n"
	echo -e "\t\t(before installing files, you need to create directories: first -d, then -f)"
}

Update() {
	printf "\nUPDATE & UPGRADE:\n"

	for i in ${update_commands[*]}; do
		printf "\n[$i]:\n"
		yes | sudo apt-get $i
	done

	printf "\nEND UPDATE\n"
}

Programs() {
	printf "\nINSTALL PROGRAMS:\n"

	for i in ${programs[*]}; do
		printf "\n[$i]:\n"
		yes | sudo apt-get install $i
	done
	
	printf "\nEND PROGRAM INSTALLING\n"
}

Directories() {
	printf "\nMAKING DIRECTORIES:\n"

	# main directories
	cd $home_dir
	for i in ${directories[*]}; do
		printf "\n[$i]:\n"
		mkdir $i
	done

	# sub-directories
	cd work
	printf "\n[sub-directories]:\n"
	for i in ${sub_directories[*]}; do
		mkdir $i
	done

	cd ../

	printf "\nEND MAKING DIRECTORIES\n"
}

Files() {
	printf "\nINSTALLING FILES:\n"
    
	cd "$current_dir/dotfiles/"

	# init all files without bashrc (because you can't overwrite it)
	for i in ${!source_dotfiles[*]}; do
		printf "[${source_dotfiles[$i]}]\n"
		cat ${source_dotfiles[$i]} > ${final_dotfiles[$i]}
	done

	printf "[bashrc]\n"
	cat bashrc >> ~/.bashrc
	
	printf "\nEND INSTALLING FILES\n"
}

Source() {
	printf "\nSOURCE BASHRC\n"

	source "$home_dir/.bashrc"
}

handle_options "$@"
exit 0
