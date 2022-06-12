#!/usr/bin/env sh

if [ -z "$1" ]; then
	echo "please type your email."
	exit 0
fi

email="$1"

ssh-keygen "-t" "ed25519" "-C" "\"$email\""
cat ~/.ssh/id_ed25519.pub | xclip "-selection" "clipboard"

