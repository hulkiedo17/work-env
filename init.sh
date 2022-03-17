#!/usr/bin/env bash

current_dir="$PWD"
home_dir="$HOME"

flags=(-h -a -u -i -d -f)
source_dotfiles=(vimrc gitconf xresources path prompt dbg)
final_dotfiles=(~/.vimrc ~/.gitconfig ~/.Xresources ~/.bashrc.d/path.bash ~/.bashrc.d/prompt.bash ~/.bashrc.d/dbg.bash)
programs=(vim gcc g++ gdb git make valgrind nasm asciinema xterm radare2 cppcheck cmake gdc)
update_commands=(update upgrade dist-upgrade)
directories=(.bashrc.d .bin work)
#sub_directories=(main text future others sources)
#sub_sub_directories=(c git rust sh)

handle_options() {
	printf "\nSTART INITIALIZATION SCRIPT\n"

	for i in $@; do
		case "$i" in
			"${flags[0]}")  # print help
			Help
			exit 0
			;;
		"${flags[1]}")  # do all options
			Update
			Programs
			Directories
			Files
			;;
		"${flags[2]}")  # do only update option
			Update
			;;
		"${flags[3]}")  # do only install option
			Programs
			;;
		"${flags[4]}")  # do only directories option
			Directories
			;;
		"${flags[5]}")  # do only files option
			Files
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

	# commented because it's unnecessary now

	# sub-directories
	#cd work
	#printf "\n[sub-directories]:\n"
	#for i in ${sub_directories[*]}; do
	#	mkdir $i
	#done

	# sub-sub-directories
	#cd lang	// no-one lang directory
	#printf "\n[sub-sub-directories]:\n"
	#for i in ${sub_sub_directories[*]}; do
	#	mkdir $i
	#done

	#cd ../../
	
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

handle_options "$@"
exit 0
