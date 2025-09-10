#!/bin/sh

# pick music track to play in cmus remotely

cmuspicker=$(find /home/"$USER"/Music/starred/ -type f | /home/"$USER"/.fzf/bin/fzf -i --prompt "Pick the music track you want to play in cmus: ")

cmus-remote -f "$cmuspicker"

printf "\n" ""

