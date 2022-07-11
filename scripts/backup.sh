#!/usr/bin/env bash

backup_name="backup.tar.gz"
archive_name="backup.tar"

ProcessOptions() {
	if [ $# -lt 1 ] ; then
		printf "You did not provide any options.\n"
		exit 0
	fi

	while getopts ":hk:m:e:" opt ; do
		case $opt in
			h) Help ;;
			k) GenerateSSH "$OPTARG" ;;
			m) MakeBackup "$OPTARG" ;;
			e) ExtractBackup "$OPTARG" ;;
			*) printf "\n%s - unknown option\n" "$i" ;;
		esac
	done
}

Help() {
	echo "Usage: backup.sh [-h|-a|-u|-i|-d|-f]"
	echo ""
	echo "[options]:"
	echo -e "\t-h -> this help message"
	echo -e "\t-k [email] -> generate ssh key"
	echo -e "\t-m [path]  -> generate backup file from path"
	echo -e "\t-e [path]  -> extract backup file to path\n"
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
