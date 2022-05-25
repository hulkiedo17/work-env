# work-env
My collection of dotfiles and initialization script for work environment

# how to use
It is recommended to use this script when you first start the
system, otherwise there may be problems (the same information
is re-included in the file, so be careful with .bashrc).

This repository is not only about dotfiles, it is about the 
working environment in general. I use it after reinstalling
so that i don't have to configure everything manually.

# how to run
usage:
```shell
$ ./env.sh [-u|-a|-d|-f|-i|-h|-s]
```

if cannot work, type this:
```shell
$ chmod +x env.sh
$ ./env.sh
```

## ssh script
```shell
$ ./ssh.sh [username]	# for example: ./ssh.sh example
$ # it creates an ssh key to example@gmail.com, and copies to clipboard this key
```

if cannot work, type this:
```shell
$ chmod +x ssh.sh
$ ./ssh.sh [username]
```

# command line options

| options | description |
| --- | --- |
| -h | help message |
| -a | all options below |
| -u | update system |
| -d | make directories |
| -i | install packages |
| -f | install dotfiles |
| -s | source bash config |

# notes

Programs and dotfiles for install, directories to create, see in init.sh

after running -i, all *.bash files contains in ~/.bashrc.d or in ~/

Prefer use -i after using -d, because some files should be in the ~/.bashrc.d

