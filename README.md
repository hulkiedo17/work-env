# dotfiles

My collection of dotfiles

# how to use

It is recommended to use installation script when you first start the system, otherwise there may be problems (the same information is re-included in the file, so be careful with .bashrc).

# how to run

usage:
```shell
$ ./install.sh [options...]
```

# command line options

| options | description |
| --- | --- |
| -h | help message |
| -a | all options below |
| -d | make directories |
| -f | install dotfiles |
| -s | source bash config |

# notes

after running -f, all *.bash files contains in ~/.bashrc.d or in ~/

Prefer use -f after using -d, because some files should be in the ~/.bashrc.d

