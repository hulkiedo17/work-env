#!/bin/sh

if [ -z "$1" ]; then
	echo "please type your email."
	exit 0
fi

#username="$1"
#domain="gmail.com"	# "$2"
#email="$username@$domain"

email="$1"

ssh-keygen "-t" "ed25519" "-C" "\"$email\""
cat ~/.ssh/id_ed25519.pub | xclip "-selection" "clipboard"

