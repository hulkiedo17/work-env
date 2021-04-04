#!/bin/bash

current_dir="$PWD"
home_dir="$HOME"

flags=(-h -a -u -i -d -f)
source_dotfiles=(vimrc gitconf xresources path prompt ed dbg)
final_dotfiles=(~/.vimrc ~/.gitconfig ~/.Xresources ~/.bashrc.d/path.bash ~/.bashrc.d/prompt.bash ~/.bashrc.d/ed.bash ~/.bashrc.d/dbg.bash)
programs=(vim gcc g++ gdb git make valgrind nasm asciinema xterm radare2 cppcheck)
update_commands=(update upgrade dist-upgrade)
directories=(.bashrc.d .bin work)
sub_directories=(c sh text oth git)

handle_options() {
    for i in $@; do
        case "$i" in
            "${flags[0]}")  # print help
                script_help
                ;;
            "${flags[1]}")  # do all options
                update
                install
                make_directories
                install_files
                ;;
            "${flags[2]}")  # do only update option
                update
                ;;
            "${flags[3]}")  # do only install option
                install
                ;;
            "${flags[4]}")  # do only directories option
                make_directories
                ;;
            "${flags[5]}")  # do only files option
                install_files
                ;;
            *)
                printf "\n$i - unknown option\n"
        esac
    done

    if [ $# = 0 ]; then
        printf "You did not provide any options.\n"
        printf "The system is updated by default.\n"

        update
    fi

    printf "\nEND INITIALIZATION SCRIPT\n"
}

script_help() {
    printf "\nUsage: ./init.sh [-h|-a|-u|-i|-d]\n\n"
    printf "options:\n"
    printf "-h -> print this help\n"
    printf "-a -> all flags (-u -i)\n"
    printf "-u -> update (system)\n"
    printf "-i -> install (programs)\n"
    printf "-d -> directories (make new dirs)\n"
    printf "-f -> install files(dotfiles)\n"
}

update() {
    printf "\nUPDATE & UPGRADE:\n"

    for i in ${update_commands[*]}; do
        printf "\n[$i]:\n"
        sudo apt-get $i
    done
}

install() {
    printf "\nINSTALL PROGRAMS:\n"

    for i in ${programs[*]}; do
        printf "\n[$i]:\n"
        sudo apt-get install $i
    done
}

make_directories() {
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
}

install_files() {
    printf "\nINSTALLING FILES:\n"
    
    cd "$current_dir/dotfiles/"

    # init all files without bashrc (because you can't overwrite it)
    for i in ${!source_dotfiles[*]}; do
        printf "[${source_dotfiles[$i]}]\n"
        cat ${source_dotfiles[$i]} > ${final_dotfiles[$i]}
    done

    printf "[bashrc]\n"
    cat bashrc >> ~/.bashrc
}

handle_options "$@"
exit 0
