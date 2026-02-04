#!/bin/bash

# A script for yt-dlp with search arguments.

x=0

url=$(xclip -o 2> /dev/null)

while [ "$x" = 0 ]
do

	printf "\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" "y to enter video creator and video discription." "a is for if there is a failure downloading using y." "x to download url from xclip." "b is for if there is a failure to download using x." "m to download music." "yt to run again" "q to quit."

	printf "\n%s\n" ""

	read -p "Enter your selection: " answer

	case "$answer" in
		y)
		echo "Enter the creator and description."
		read video
		yt-dlp -f 'bv*[height=480]+ba' "ytsearch1:""$video"""
		x=0
		;;
		a)
		echo "Enter the creator and description."
		read video
		yt-dlp -f 'bv+ba' "ytsearch1:""$video"""
		x=0
		;;
		x)
		yt-dlp -f 'bv*[height=480]+ba' "$url"
		x=0
		;;
		m)
		yt-dlp -f 'ba' -x --audio-format mp3 "$url"
		x=0
		;;
		b)
		yt-dlp -f 'bv+ba' "$url"
		x=0
		;;
		yt)
		exec bash /home/"$USER"/ttysh/resources/./yt.sh
		x=1
		;;
		q)
		x=1
		;;
	esac
done
