# init-script
My collection of dotfiles and initialization script for work environment

# how to use
It is recommended to use this script when you first start the
system, otherwise there may be problems (the same information
is re-included in the file, so be careful with .bashrc and .gitconfig).

This repository is not only about dotfiles, it is about the 
working environment in general. I use it after reinstalling
so that i don't have to configure everything manually.

# how to run
usage:
```shell
$ ./init.sh [-u|-i|-d|-f|-a|-h]
```

if (./init.sh) cannot work, type this:
```shell
$ chmod +x init.sh
$ ./init.sh
```

# command line options

### -h -> help
some info about options and usage

### -u -> update system
update upgrade dist-upgrade

### -i -> install programs
this programs: vim gcc g++ gdb git make valgrind nasm asciinema xterm radare2 cppcheck

### -d -> creates directories
this directores: .bin .bashrc.d work

the following directories are created in the work directory: c sh text oth git

### -f -> install files
this files: .vimrc .gitconfig .Xresources path.bash prompt.bash ed.bash dbg.bash

all *.bash files contains in ~/.bashrc.d

### -a -> all options 
does everything that the above options do combined
