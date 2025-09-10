#!/bin/bash

x=0

while [ "$x" = 0 ]; do

echo -e "\nPress 'c' to start your search. Press 'q' to exit\n"
	
	printf "\n%s\n" ""

	read -p "Enter your selection: " answer

	case "$answer" in
		c)
		mpv "$(find /home/jamesc/Downloads | fzf -i)"
		x=0
		;;
		q)
		x=1
		;;
	esac
done
