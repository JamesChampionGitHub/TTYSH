#!/bin/bash

# TTYSH : A daily driver and "desktop/texttop" experience for the tty.


#
# VARIABLES
#

# red warning colour
warncolour='\033[31;1m'
warncolourend='\033[0m'

#
# FUNCTIONS
# 

# function for help using eof in the selection
eofhelp () {

less << EOF

j and k to go down and up. q to return to menu.


This is a help guide for the "select ttysh program".

Key: () denote shortcut keys, e.g. (n) means pressing the n key in the selector will load the (n)otes selection.

Note: (f) will run search on this list of programs for you to select.


	Web Browsing/

		(w)eb browser/ 

		select a (b)ookmark for web browsing/

		(we)b search/

		format librewolf (book)marks/

	Window Managers/

		start (i)3 window manager/

		start (s)way window manager/

		(cl)ose i3 or sway and return to tty/

	Screen splits/

		screen (fou)r panel split/

		screen (hor)izontal split/

		screen (ver)tical split/

	Email/

		(e)mail/

		(mu)tt email configuation/

	Video/
			
		video search on (yo)utube/

		search & play (v)ideo in tty/i3/sway/

	Images/
	
		search & view (im)ages

	Music Player/ 

		(m)usic player/

		(ne)xt song/ 

		(pr)evious song/ 

		(p)ause song/ 

		(fo)rward song/ 

		(st)atus on music/ 

		(pi)ck a song/

		(inc)rease volume/

		(low)er volume/

		(mus)ic search on youtube/

	Text Editing/

		text (ed)itor/

	Calc/Spreadsheet/

		(sp)readsheet/

		(ca)lculator/

	Accessories/

		calender (sch)edule/ 

		(n)otes and todos/ 

		(d)ate & calender/

		(we)ather/

	Search/

		(f)ind a program from this list/

		(ru)n any program/

		(fi)le manager/

		search files to open in text (edi)tor/

		search (pdf)s/

	Backup/

		stop! first run ttysh as sudo su!: (di)sk formatting and setting up removable media/

		*NOTE: RUN THE ABOVE ON REMOVABLE MEDIA BEFORE MAKING YOUR BACKUPS.

 		stop! first run ttysh as sudo su!: (ba)ckup /home/user/ to removable drive/

		stop! first run ttysh as sudo su!: (ti)meshift backup to removable drive/

		stop! first run ttysh as sudo su!: (de)lete timeshift backups from removable drive/

	Audio Settings/

		(a)udio controls/

		default (au)dio levels/

	Record/

		(sc)reenshot(1,2,3,4,5,6) tty/

		(re)cord your tty/s/

		(rec)ord your i3 or sway window manager/

	TTY/
				
		(scro)llback information for tty/

		change (v)t (1,2,3,4,5,6) tty/

		choose ch(vt) tty/

		*NOTE: cannot use this selection in screen split. Use alt+number or alt+arrow key instead

	System/Utilities/

		(fon)t and text change in tty/

		set temporary (font) in tty/

		(net)work manager/

		network manager (dev)ices/

		(pin)g jameschampion.xyz/

		(fan) control on thinkpads/

		(u)pdate the system/

		(sy)tem monitor/

		computer (te)mperatures/

		(fr)ee disk space/

		(c)lock/

		(sto)pwatch/

		(lo)ck the screen/

		(alt)Gr as left mouse click on x11 on thinkpads/

		(res)tart/

		(sh)utdown/

	Rerun/Help/Quit/

		rerun (tty)sh/

		(h)elp/

		(q)uit/

EOF
}

# function for fzf selection
eoffuz() {

less << EOF
web browser
select a bookmark for web browsing
web search
format librewolf bookmarks
start i3 window manager
start sway window manager
close i3 or sway and return to tty
screen four panel split
screen horizontal split
screen vertical split
video search on youtube
search & play video in tty i3 sway
search & view images
music search on youtube
music player 
next song
previous song
pause song
forward song
status on music
pick a song
increase volume
lower volume
email
mutt email configuation
text editor
spreadsheet
find a program from this list
run any program
file manager
search files to open in text editor
search pdfs
stop! first run ttysh as sudo su!: disk formatting and setting up removable media
stop! first run ttysh as sudo su!: backup /home/user/ to removable drive
stop! first run ttysh as sudo su!: timeshift backup to removable drive
stop! first run ttysh as sudo su!: delete timeshift backups from removable drive
screenshot tty 1
screenshot tty 2
screenshot tty 3
screenshot tty 4
screenshot tty 5
screenshot tty 6
record your tty/s
record your i3 or sway window manager
calculator
calender schedule
notes and todos 
date & calender
weather
scrollback information for tty
change to tty 1
change to tty 2
change to tty 3
change to tty 4
change to tty 5
change to tty 6
choose tty
font and text change in tty
set temporary font in tty
audio controls
default audio levels
network manager
network manager devices
ping jameschampion.xyz
fan control on thinkpads
update the system
system monitor
computer temperatures
free disk space
clock
stopwatch
lock the screen
AltGr as left mouse click on x11 on old thinkpads
restart
shutdown
rerun ttysh
help
quit
EOF
}

# $1 arguments selection list
helpflags () {

options=$(printf "\n%s\n" "eofhelp fzfcmus websearch fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner" |
       	tr ' ' '\n' |
       	fzf -i --prompt "Pick the option that you would like: ")

"$options"
}

# sudo user check
sudocheck () {

if [[ ! "$SUDO_USER" ]]; then
	printf "\n"$warncolour"%s"$warncolourend"\n\n" "Run as sudo su first! Exiting..."
	exit 1 
else
	printf "\n%s\n\n%s\n\n" "Checking you are running as sudo user..." "Continuing..."
fi
}

# /dev/mapper/drive check for timeshift
mappercheck () {

if [[ ! -h /dev/mapper/timeshiftbackup ]]; then
	printf "\n\n%s\n\n" "cryptsetup has failed to open /dev/mapper/timeshiftbackup from /dev/"$tdevname" . Make sure you are entering the correct password, or check your devices and mountpoints. Running lsblk and exiting..."
	lsblk
	exit 1
else
	printf "\n\n%s\n\n" "dev/mapper/timeshiftbackup found. Continuing..." 
fi
}

# function for shortcuts selection 
ttyshhelp () {

less /home/"$USER"/ttysh/resources/.ttysh.selection 
}

# function for TTYSH configuration
wizardttysh () {

# a wizard to configure TTYSH

# first, update the system and install needed packages

sudo pacman --needed --noconfirm -Syu \
	base-devel \
	curl \
	xdo \
	bc \
	cmus \
	alsa-utils \
	yt-dlp \
	lynx \
	mpv \
	fzf \
	screen \
	vim \
	less \
	man \
	newsboat \
	mutt \
	xorg-server \
	xorg-xinit \
	i3-wm \
	autotiling \
	xterm \
	xclip \
	xorg-xmodmap \
	sway \
	foot \
	wf-recorder \
	wl-clipboard \
	xorg-xwayland \
	mupdf \
	zathura \
	cryptsetup \
	timeshift \
	imagemagick \
	htop \
	fbgrab \
	tldr \
	go \
	git \
	networkmanager \
	noto-fonts \
	i3lock \
	swaylock \
	terminus-font

# enable and start network manager service

sudo systemctl enable --now NetworkManager.service
	
# install yay package manager

cd /home/"$USER"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

yay -S --noconfirm \
	devour \
	librewolf-bin \
	arkenfox-user.js \
	xkbset \
	clipman \
	fbpdf-git \
	sc-im

# make the following configurations:

[[ ! -f /home/"$USER"/.config/mpv.conf ]] && mkdir -p /home/"$USER"/.config/mpv && printf "%b" '--image-display-duration=1000' > /home/"$USER"/.config/mpv/mpv.conf

printf "%s\n" "NOTES" > /home/"$USER"/.notes.txt

[[ ! -d /home/"$USER"/.newsboat ]] && mkdir -p /home/"$USER"/.newsboat && echo 'https://www.youtube.com/feeds/videos.xml?channel_id=UCeFnqXMczw4BDCoJHr5dBjg "~James Champion (Youtube)"' > /home/"$USER"/.newsboat/urls && cat /home/"$USER"/ttysh/resources/newboatconfig/config > /home/"$USER"/.newsboat/config

mkdir -p /home/"$USER"/.config/mutt/ && touch /home/"$USER"/.config/mutt/muttrc

printf "%b\n%b\n\n%b\n%b\n%b\n\n%b\n%b\n%b\n%b\n\n%b" 'set folder = "imaps://"' 'set smtp_url = "smtp://"' 'set from = ""' 'set realname = ""' 'set editor = "vim"' 'set spoolfile = "+INBOX"' 'set record = "+Sent"' 'set trash = "+Trash"' 'set postponed = "+Drafts"' 'mailboxes =INBOX =Sent =Trash =Drafts =Junk' > /home/"$USER"/.config/mutt/muttrc

cat /home/"$USER"/ttysh/resources/.Xdefaults >> /home/"$USER"/.Xdefaults

printf "%s" "exec i3" > /home/"$USER"/.xinitrc

[[ ! -d /home/"$USER"/.config/i3 ]] && mkdir -p /home/"$USER"/.config/i3 && cat /home/"$USER"/ttysh/resources/i3config/config > /home/"$USER"/.config/i3/config

[[ ! -d /home/"$USER"/.config/sway ]] && mkdir -p /home/"$USER"/.config/sway && cat /home/"$USER"/ttysh/resources/swayconfig/config > /home/"$USER"/.config/sway/config

[[ ! -d /home/"$USER"/.config/foot ]] && mkdir -p /home/"$USER"/.config/foot && cat /home/"$USER"/ttysh/resources/footconfig/foot.ini > /home/"$USER"/.config/foot/foot.ini

[[ ! -d /home/"$USER"/.config/ttysh ]] && mkdir -p /home/"$USER"/.config/ttysh && cat /home/"$USER"/ttysh/resources/ttyshconfig/config > /home/"$USER"/.config/ttysh/config

cat /home/"$USER"/ttysh/resources/bashrc/.bashrc > /home/"$USER"/.bashrc

sudo cat /home/"$USER"/ttysh/resources/x11config/xorg.conf > /etc/X11/xorg.conf

printf "\n%s\n" "Last run" >> /home/"$USER"/.ttyshwizardrun
 
date >> /home/"$USER"/.ttyshwizardrun

printf "\n%s\n" "TTYSH Wizard has finished. Reboot your computer to finish the setup."

exit 0
}

# run toggles update
togglesupdate () {

while read i; do

	case "$i" in

		ttyshautostart=true|ttyshautostart=false)
		if [[ "$(grep -i "ttyshautostart=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/.*autostart.*/\/home\/"$USER"\/ttysh\/\.\/ttysh\.sh #autostart/' /home/"$USER"/.bashrc 
		else	
			sed -i 's/.*autostart.*/#\/home\/"$USER"\/ttysh\/\.\/ttysh\.sh #autostart/' /home/"$USER"/.bashrc 
		fi
		;;
		i3autotiling=true|i3autotiling=false)
		if [[ "$(grep -i "i3autotiling=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/.*autotiling.*/exec --no-startup-id autotiling/' /home/"$USER"/.config/i3/config 
		else	
			sed -i 's/.*autotiling.*/#exec --no-startup-id autotiling/' /home/"$USER"/.config/i3/config
		fi
		;;
		swayautotiling=true|swayautotiling=false)
		if [[ "$(grep -i "swayautotiling=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/.*autotiling.*/exec_always autotiling/' /home/"$USER"/.config/sway/config 
		else	
			sed -i 's/.*autotiling.*/#exec_always autotiling/' /home/"$USER"/.config/sway/config
		fi
		;;
		ttyshfont=true|ttyshfont=false)
		if [[ "$(grep -i "ttyshfont=true" /home/"$USER"/.config/ttysh/config)" ]]; then
 			sed -i 's/.*setfont ter-218b.*/[ $(tty | tr -d '\''[0-9]'\'') = "\/dev\/tty" ] \&\& setfont ter-218b/' /home/"$USER"/.bashrc
		else	
 			sed -i 's/.*setfont ter-218b.*/#[ $(tty | tr -d '\''[0-9]'\'') = "\/dev\/tty" ] \&\& setfont ter-218b/' /home/"$USER"/.bashrc
		fi
		;;
	esac
done < /home/"$USER"/.config/ttysh/config
}

# toggles to change the desktop or ttysh
ttyshtoggles () {

while [ 1 ]; do

		printf "\n%s\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n" "Toggle the following on and off:" "(c)urrent toggle status" "(t)tysh autostart" "(i)3 window manager autotiling" "(s)way window manager autotiling" "ttysh tty (f)ont" "(r)eset toggles to defaults" "(q)uit and return to selection"

	read -e -p "Enter your selection: " pickoption

	case "$pickoption" in

		c)
		less /home/"$USER"/.config/ttysh/config
		;;
		t)
		if [[ "$(grep -i "ttyshautostart=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/ttyshautostart=true/ttyshautostart=false/' /home/"$USER"/.config/ttysh/config
		else
			sed -i 's/ttyshautostart=false/ttyshautostart=true/' /home/"$USER"/.config/ttysh/config
		fi

		if [[ "$(grep -i "ttyshautostart=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/.*autostart.*/\/home\/"$USER"\/ttysh\/\.\/ttysh\.sh #autostart/' /home/"$USER"/.bashrc 
		else	
			sed -i 's/.*autostart.*/#\/home\/"$USER"\/ttysh\/\.\/ttysh\.sh #autostart/' /home/"$USER"/.bashrc 
		fi
		;;
		i)
		if [[ "$(grep -i "i3autotiling=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/i3autotiling=true/i3autotiling=false/' /home/"$USER"/.config/ttysh/config
		else
			sed -i 's/i3autotiling=false/i3autotiling=true/' /home/"$USER"/.config/ttysh/config
		fi

		if [[ "$(grep -i "i3autotiling=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/.*autotiling.*/exec --no-startup-id autotiling/' /home/"$USER"/.config/i3/config 
		else	
			sed -i 's/.*autotiling.*/#exec --no-startup-id autotiling/' /home/"$USER"/.config/i3/config
		fi
		;;
		s)
		if [[ "$(grep -i "swayautotiling=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/swayautotiling=true/swayautotiling=false/' /home/"$USER"/.config/ttysh/config
		else
			sed -i 's/swayautotiling=false/swayautotiling=true/' /home/"$USER"/.config/ttysh/config
		fi

		if [[ "$(grep -i "swayautotiling=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/.*autotiling.*/exec_always autotiling/' /home/"$USER"/.config/sway/config 
		else	
			sed -i 's/.*autotiling.*/#exec_always autotiling/' /home/"$USER"/.config/sway/config
		fi
		;;
		f)
		if [[ "$(grep -i "ttyshfont=true" /home/"$USER"/.config/ttysh/config)" ]]; then
			sed -i 's/ttyshfont=true/ttyshfont=false/' /home/"$USER"/.config/ttysh/config
		else
			sed -i 's/ttyshfont=false/ttyshfont=true/' /home/"$USER"/.config/ttysh/config
		fi

		if [[ "$(grep -i "ttyshfont=true" /home/"$USER"/.config/ttysh/config)" ]]; then
 			sed -i 's/.*setfont ter-218b.*/[ $(tty | tr -d '\''[0-9]'\'') = "\/dev\/tty" ] \&\& setfont ter-218b/' /home/"$USER"/.bashrc
		else	
 			sed -i 's/.*setfont ter-218b.*/#[ $(tty | tr -d '\''[0-9]'\'') = "\/dev\/tty" ] \&\& setfont ter-218b/' /home/"$USER"/.bashrc
		fi
		;;
		r)
		if [[ ! -d /home/"$USER"/.config/ttysh ]]; then
			mkdir -p /home/"$USER"/.config/ttysh
			cat /home/"$USER"/ttysh/resources/ttyshconfig/config > /home/"$USER"/.config/ttysh/config
		else
			cat /home/"$USER"/ttysh/resources/ttyshconfig/config > /home/"$USER"/.config/ttysh/config
		fi
		;;
		q)
		break
		;;
	esac
done
}

#
# functions for fzf
#


# pick music track to play in cmus remotely
fzfcmus () {

cmuspicker=$(find /home/"$USER"/Music/starred/ -type f | fzf -i --prompt "Pick the music track you want to play in cmus: ") 

cmus-remote -f "$cmuspicker"

cmus-remote -Q && printf "\n" ""
}

# format bookmarks for fzfbookmark
bookmarkformat () {

formathtml=$(find /home/"$USER"/ -name '*.html' | fzf -i --prompt "Note: if you already have a /home/"$USER"/.bookmarks_ttysh.txt file, it will be overwritten. Pick the html file you want to format: ")

sed 's/\ /\n/g' "$formathtml" | grep "https\?" | cut -d '"' -f2 | grep "https\?" | grep -v "^fake-favicon-uri" | grep -v ".ico$" > /home/"$USER"/.bookmarks_ttysh.txt

printf "\n%s\n" "Your /home/"$USER"/.bookmarks_ttysh.txt is now formatted for the (b) command"
}

# search the internet
websearch () {

read -e -p "Enter your web search: " webpick

if [[ $TERM = "linux" ]]; then
	lynx search.brave.com/search?q="$webpick"
elif [[ $TERM = "xterm-256color" ]]; then
	devour librewolf search.brave.com/search?q="$webpick"
elif [[ $TERM = "foot" ]]; then
	librewolf search.brave.com/search?q="$webpick"
fi
}

# function for fan speed control
fanspeed () {

	printf "\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n" "The following options:" "s for current fan speed" "Type auto for auto speed. Recommeneded" "1-7 for speeds" "e.g. Press 2 for low speed" "Press 4 for medium speed" "Press 7 for high speed" "full for full-speed (Beware!)" "q to quit"

while [ 1 ]; do

	read -e -p "Enter your selection: " fanselec	

	case "$fanselec" in

		s)
		cat /proc/acpi/ibm/fan
		;;
		auto)
		echo level auto | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		1)
		echo level 1 | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		2)
		echo level 2 | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		3)
		echo level 3 | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		4)
		echo level 4 | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		5)
		echo level 5 | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		6)
		echo level 6 | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		7)
		echo level 7 | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		full)
		echo level full-speed | sudo tee /proc/acpi/ibm/fan
		cat /proc/acpi/ibm/fan
		;;
		q)
		printf "\n%s\n" "Running post resets on wifi modules as fan function bug can break wifi modules..."
		nmcli radio wifi off
		nmcli radio wifi on
		rfkill block wifi
		rfkill list
		rfkill unblock wifi
		rfkill list
		break
		;;
	esac
done
}

# function for fzf video search
fzfvid () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start Press q to quit."

	read -e -p "Enter you selection: " answer

	case "$answer" in
		s)
		if [[ $TERM = "linux" ]]; then
			mpv -vo=drm "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch: ")"
		elif [[ $TERM = "xterm-256color" ]]; then
			devour mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch: ")"
		elif [[ $TERM = "foot" ]]; then
			mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch: ")"
		fi
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

fzfimage() {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start Press q to quit."

	read -e -p "Enter you selection: " answer

	case "$answer" in
		s)
		if [[ $TERM = "linux" ]]; then
			mpv -vo=drm "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the image you want to view: ")"
		elif [[ $TERM = "xterm-256color" ]]; then
			devour mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the image you want to view: ")"
		elif [[ $TERM = "foot" ]]; then
			mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the image you want to view: ")"
		fi
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for fzf file search for vim
fzfvim () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -e -p "Enter your selection: " answer

	case "$answer" in
		s)
		vim "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the file you want to open in vim: ")"
		;;
		q)
		break	
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for fzf pdf search
fzfpdf () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -e -p "Enter your selection: " answer

	case "$answer" in
		s)
		if [[ $TERM = "linux" ]]; then
			sudo fbpdf "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the pdf you want to view. ESC to exit: ")"
		elif [[ $TERM = "xterm-256color" ]]; then
			devour zathura "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the pdf you want to view. ESC to exit: ")" 		
		elif [[ $TERM = "foot" ]]; then
			zathura "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the pdf you want to view. ESC to exit: ")" 		
		fi
		;;
		q)
		break		
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for yt-dlp
yt () {

if [[ ! -d /home/"$USER"/Videos ]]; then 
	mkdir /home/"$USER"/Videos/
	cd /home/"$USER"/Videos/
else
	cd /home/"$USER"/Videos/ 
fi

while [ 1 ]; do

		printf "\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" "y to enter video creator and video discription (720p)." "a for video in best quality available." "x to download video from xclip (720p)." "b for video from xclip in best available quality." "yt to run again." "q to quit"

	read -e -p "Enter your selection: " answer

	printf "\n%s\n" ""

	case "$answer" in
		y)
		read -e -p  "Enter the creator and discription: " video
		printf "\n%s\n"	""
		yt-dlp -f 'bv*[height=720]+ba' "ytsearch1:""$video"""
		;;
		a)
		read -e -p  "Enter the creator and discription: " video
		printf "\n%s\n"	""
		yt-dlp -f 'bv+ba' "ytsearch1:""$video"""
		;;
		x)
		url=$(xclip -o)
		yt-dlp -f 'bv*[height=720]+ba' "$url"
		;;
		b)
		url="$(xclip -o)"
		yt-dlp -f 'bv+ba' "$url"
		;;
		yo)
		yt
		break
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

printf "\n%s\n" "Any video downloaded will be saved in your /home/"$USER"/Videos/ folder"
}

# function for music in yt-dlp
ytmusic () {

if [[ ! -d /home/"$USER"/Music ]]; then
	mkdir /home/"$USER"/Music/
   	cd /home/"$USER"/Music/
else	
	cd /home/"$USER"/Music/ 
fi

while [ 1 ]; do

	printf "\n%s\n"	"sm to enter creator and title. m to download music url from xclip. ytm to run again. q to quit."

	read -e -p "Enter your selection: " answer

	printf "\n%s\n" ""

	case "$answer" in
		sm)
		printf "\n%s\n" "Enter music creator and title: "
		read -e -p music
		yt-dlp -f 'ba' -x --audio-format mp3 "ytsearch1:""$music"""
		;;
		m)
		url=$(xclip -o)
		yt-dlp -f 'ba' -x --audio-format mp3 "$url"
		;;
		ytm)
		ytmusic
		break
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

printf "\n%s\n" "Any music downloaded will be saved in your /home/"$USER"/Music/ folder"
}

# function for creating calender data
calenderdata () {

printf "\n%s\n" "Set your start date, e.g. 2024-01-01"

read -e -p "Enter your start date: " startd

printf "\n%s\n" "Set your end date, e.g. 2024-12-31"

read -e -p "Enter your end date: " endd

printf "\n%s\n" "Running... Please wait..."

d=
n=0

until [ "$d" = $endd ]; do

	n=$((n+1))
	d=$(date +%Y-%m-%d --date "$startd + $n day")
	echo "$d" | tr '-' ' ' | awk '{print $3, $2, $1}' | tr ' ' '-' >> /home/"$USER"/."$(date +%Y)"calenderdatafile
done
}

# function for calender schedule
calenderschedule () {

[[ ! -f /home/"$USER"/.*calenderdatafile ]] && printf "\n%s\n" "Set up your calender data: " && calenderdata && echo "Calender made. Fill in your calender at /home/"$USER"/.*calenderdata and run this selection again or continue with the option to edit your calender." 

printf "\n%s\n\n" "Your Calender Schedule For Today: "

grep -C 15 ""^$(date +%d-%m-%Y)"" /home/"$USER"/.*calenderdatafile | less

printf "\n%s\n" "Do you want to edit your calender? y/n"

while [ 1 ]; do

	read -e -p "Enter your selection: " cpick

	case "$cpick" in
		y)
		vim /home/"$USER"/.*calenderdatafile
		grep -C 15 ""^$(date +%d-%m-%Y)"" /home/"$USER"/.*calenderdatafile | less
		printf "\n%s\n" "Do you want to edit your calender again? y/n"
		;;
		n)
		break
		;;
		*)
		printf "\n%s\n\n" "Not a valid selection"
	esac
done
}

# function for searching weather in wttr.in
weather () {

while [ 1 ]; do

	printf "\n%s\n" "Do you want to update the weather data file? y/n"

	read -e -p "Enter your selection: " wanswer

	case "$wanswer" in
		y)	
		printf "\n%s\n" "Enter your city or town to see the weather forecast: "
		read -e -p wwanswer
		curl wttr.in/"$wwanswer"?T --output /home/"$USER"/ttysh/resources/.weatherdata
		cat /home/"$USER"/ttysh/resources/.weatherdata
		break
		;;
		n)
		cat /home/"$USER"/ttysh/resources/.weatherdata
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for formating and setting up disks for rsync and timeshift
diskformat () {

sudocheck

while [ 1 ]; do

	printf "\n"$warncolour"%s"$warncolourend"\n" "Stop! Have you run sudo su? Are you running on A/C power? y/n"

	read -e -p "Enter your selection: " answer

	case "$answer" in
		y)
		break
		;;
		n)
		exit 0
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

printf "\n%s\n" "This is your current device storage. Do not insert your disk you wish to format yet..."

lsblk

printf "\n%s\n%s\n" "Please insert the device that you want to format..." "This programme will resume in 10 second..."

sleep 10

lsblk

while [ 1 ]; do

	printf "\n%s\n" "Please look for your inserted device above. Is it correct? y/n"

	read -e -p "Enter your selection: " answer

	case "$answer" in
		y)
		break
		;;
		n)
		exit 0
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

printf "\n%s\n%s\n" "Please enter the name of your disk. e.g. sdb. Do not enter any number, as these will be partitions, and we will be formatting the whole disk." "Be careful not to format the wrong drive!"

read -e -p answer

fdisk /dev/"$answer"

printf "\n%s\n" "We need to now create your encrypted partition..."

lsblk

printf "\n%s\n" "What is the new partition name of your drive? e.g. sdb1 ?"

read -e -p setuuid

cryptsetup luksFormat /dev/"$setuuid"

printf "\n%s\n" "We need to now open the new encrypted drive."

cryptsetup open /dev/"$setuuid" drive

printf "\n%s\n" "We need to now add a file system. This will be ext4 filesystem."

mkfs.ext4 /dev/mapper/drive

lsblk

printf "\n%s\n" "The encrypted drive will now be closed..."

sync

cryptestup close drive

lsblk

ls -l /dev/disk/by-uuid/

ls -l /dev/disk/by-uuid/ | grep "$setuuid" | awk '{print $9}' | tr -d /.

while [ 1 ]; do

	printf "\n%s\n%s\n" "You need to now add the UUID number of the disk you have setup for either file backups or system backups." "See above, is this correct? y/n"

	read -e -p "Enter your selection: " answer

	case "$answer" in
		y)
		break
		;;
		n)
		printf "\n%s\n" "Exiting script. Run again, or consult the developer for further instruction or support"
		exit 1
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

while [ 1 ]; do

	printf "\n%s\n" "Choose what this disk will be used for. Press t for timeshift system backups or press f for file system backups"

	read -e -p "Enter your selection: " answer
	
	case "$answer" in
		t)
		ls -l /dev/disk/by-uuid/ | grep "$setuuid" | awk '{print $9}' | tr -d /. > /home/"$SUDO_USER"/.uuidtimeshift
		break
		;;
		f)
		ls -l /dev/disk/by-uuid/ | grep "$setuuid" | awk '{print $9}' | tr -d /. > /home/"$SUDO_USER"/.uuidfiles
		break
		;;	
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

printf "\n%s\n%s\n%s\n%s\n%s\n" "This drive is now ready to be used either file backup, or system backup, depending on your previous selection." "IMPORTANT NOTE: IF YOU ARE USING A NEWLY SETUP DISK FOR SYSTEM BACKUPS FOR THE FIRST TIME - " "YOU MUST RUN timeshift-gtk IN A TERMINAL IN XORG AND RUN THE SETUP WIZARD, SELECTING THIS DISK TO AVOID ERRORS." "THEN PRESS THE create BUTTON." "Complete. Closing."
}

# function for timeshift backups
# function for starting the timeshift process
starttimeshift () {

# timeshift
# find uuid
tdrive=$(cat /home/"$SUDO_USER"/.uuidtimeshift)
tuuid=$(echo "$tdrive")
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
lstdevname=$(ls /dev/disk/by-uuid -l | grep "$tuuid")

printf "\n%s\n" ""

lsblk

printf "\n"$warncolour"%s"$warncolourend"\n" "Stop! Have you run sudo su? Is /dev/"$tdevname" location correct? Are you running on A/C power? y/n"

read -e -p "Enter your selection: " answer

case "$answer" in
	y)
	printf "\n%s\n" "Continuing..."
	cryptsetup open /dev/"$tdevname" "$tencryptedname"
	mappercheck
	timeshift --create --snapshot-device /dev/mapper/"$tencryptedname"
	;;
	n)
	exit 1
	;;
	*)
	printf "\n%s\n" "Not a valid selection."
	;;
esac
}

# function for closing the drive after timeshift
closetimeshift () {
		
printf "\n%s\n" ""

lsblk

while [ 1 ]; do

	printf "\n%s\n" "Does the /dev/mapper/"$tencryptedname" need unmounting? check MOUNTPOINT. press y for umount or n to exit"

	read -e -p "Enter your selection: " answer

	case "$answer" in
		y)
		printf "\n%s\n" "Complete. Closing..."
		umount "$tunmounting"
		sync
		cryptsetup close "$tencryptedname"
		lsblk
		printf "\n%s\n" "Your storage should be correct. Finished."
		exit 0
		;;
		n)
		printf "\n%s\n" "Complete. Closing..."
		sync
		cryptsetup close "$tencryptedname"
		lsblk
		printf "\n%s\n" "Your storage should be correct. Finished."
		exit 0
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for checking drive is correct
tdrivecheck () {

sudocheck

printf "\n%s\n" ""

lsblk

while [ 1 ]; do

	printf "\n"$warncolour"%s"$warncolourend"\n" "Stop! Have you run sudo su? Is /dev/"$tdevname" location correct? Are you running A/C power? y/n"

	read -e -p "Enter your selection: " answer

	case "$answer" in
		y)
		printf "\n%s\n" "Continuing..."
		cryptsetup open /dev/"$tdevname" "$tencryptedname"
		mappercheck
		break
		;;
		n)
		exit 1
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for deleting timehsift backups
timedelete () {

while [ 1 ]; do

	printf "\n%s\n" "Do you want to delete a backup? press d to continue or q to exit"

	read -e -p "Enter your selection: " answer

	case "$answer" in 
		d)
		read -e -p "Enter the line number matching the backup you want to delete: " delete
		tdelete=$(timeshift --list | grep -i -m 1 "^"$delete"" | awk '{print $3}')
		timeshift --delete --snapshot "$tdelete"
		;;
		q)
		closetimeshift	
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

# function for starting main timeshift backup deletions
maintdelete () {

sudocheck

# timeshift
# find uuid
tdrive=$(cat /home/"$SUDO_USER"/.uuidtimeshift)
tuuid=$(echo "$tdrive")
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
lstdevname=$(ls /dev/disk/by-uuid -l | grep "$tuuid")

printf "\n%s\n" "Looking for "$tdrive"..."

if [[ "$lstdevname" ]]; then 
	
	printf "\n%s\n" ""$tdrive" has been found. Starting..." 
	tdrivecheck 
	timeshift --list | less 
	timedelete 
else
	
	printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..."   
	lsblk 
	printf "\n%s" "" 
	exit 1
fi
}

# function main for timeshift
maintimeshift () {

sudocheck

# timeshift
# find uuid
tdrive=$(cat /home/"$SUDO_USER"/.uuidtimeshift)
tuuid=$(echo "$tdrive")
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
lstdevname=$(ls /dev/disk/by-uuid -l | grep "$tuuid")

printf "\n%s\n" "Looking for "$tdrive"..."

if [[ "$lstdevname" ]]; then
	printf "\n%s\n" ""$tdrive" has been found. Starting..." 
	starttimeshift 
	closetimeshift 
else
	printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..."   
	lsblk
	printf "\n%s" ""
	exit 1
fi
}

# function for filebackup
filebackup () {

sudocheck

# find uuid variables
bdrive=$(cat /home/"$SUDO_USER"/.uuidfiles)
buuid=$(echo "$bdrive")
bdevname=$(ls /dev/disk/by-uuid/ -l | grep "$buuid" | cut -d "/" -f3)
lsbdevname=$(ls /dev/disk/by-uuid -l | grep "$buuid")

printf "\n%s\n" "Looking for "$bdrive"..."

if [[ "$lsbdevname" ]]; then
	printf "\n%s\n\n" ""$bdrive" has been found. Starting..."
	lsblk

while [ 1 ]; do

	printf "\n"$warncolour"%s"$warncolourend"\n" "Stop! Have you run sudo su first? Have you saved your latest bookmarks? Is /dev/"$bdevname" correct? Are you running on A/C power? y/n" 

	read -e -p "Enter your selection: " answer

	case "$answer" in
		y)
		printf "\n%s\n" "Continuing..."
		cryptsetup open /dev/"$bdevname" drive
		# enter password
		if [[ ! -h /dev/mapper/drive ]]; then
			printf "\n\n%s\n\n" "cryptsetup has failed to open /dev/mapper/drive from /dev/"$bdevname" . Make sure you are entering the correct password, or check your devices and mountpoints. Running lsblk and exiting..."
			lsblk
			exit 1
		else
			printf "\n\n%s\n\n" "dev/mapper/drive found. Continuing..." 
		fi

		mount /dev/mapper/drive /mnt
		rsync -av /home/"$SUDO_USER"/ /mnt --delete
		sync
		umount /mnt
		cryptsetup close drive 
		printf "\n%s\n" "Complete. Closing..."
		lsblk
		printf "\n%s\n" "Your storage should be correct. Finished."
		exit 0
		;;
		n)
		exit 1
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

else

	printf "\n%s\n\n" "Cannot find "$buuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..."

	lsblk

	printf "\n%s" ""

	#sed -n 31p $SUDO_USER/backup.sh
	
	exit 1

fi
}

# file check for recording

screenshotcheck () {

if [[ ! -d /home/"$USER"/Screenshots ]]; then
	mkdir /home/"$USER"/Screenshots
	cd /home/"$USER"/Screenshots
else
	cd /home/"$USER"/Screenshots/
fi
}

# date
planner () {

printf "\n%s\n\n" "The time and date is:"

date

# calender
printf "\n%s\n\n" "This month's calender:"

cal

printf "\n%s\n" "press q when ready..." | less

calenderschedule

# cat out notes/todo
printf "\n%s\n" ""

less /home/"$USER"/.notes.txt 

printf "\n%s\n" "Do you want to edit your notes? y/n"

while [ 1 ]; do

	read -e -p "Enter your selection: " npick

	case "$npick" in
		y)
		vim /home/"$USER"/.notes.txt
		less /home/"$USER"/.notes.txt 
		printf "\n%s\n" "Do you want to edit your notes again? y/n"
		;;
		n)
		break
		;;
		*)
		printf "\n%s\n\n" "Not a valid selection"
	esac
done

# weather function
weather

# rss
cd /home/"$USER"/Videos
newsboat
cd /home/"$USER"/

printf "\n%s\n" ""

# go everything selection
selection
}

# selecting any program on the system

systemprograms () {

printf "\n%s\n" "Loading programs..."
pacman -Qn > /tmp/allprograms.txt && pacman -Qm >> /tmp/allprograms.txt
pick="$(cat /tmp/allprograms.txt | cut -d " " -f1 | fzf --layout=reverse --margin 3%)" 

if [[ "$pick" ]]; then
	"$pick"
else	
	printf "\n%s\n" "no selection.."
fi

selection
}

# fzf function for selection
selectcheck () {

if [[ "$fuzselect" = true ]]; then
	answer="$(eoffuz | fzf --layout=reverse --margin 3%)"
else
	read -e -p "Enter your selection. h and enter if you need help: " answer
fi
}

# function for selecting everything in ttysh
selection () {

while [ 1 ]; do

printf "\n%s" ""
	
	selectcheck

	unset fuzselect

	case "$answer" in
		"music player"|m)
		screen -r cmusdaemon
		;;
		"cmus with screen"|cmu)
		;;
		"next song"|ne)
		cmus-remote -n
		cmus-remote -Q
		printf "\n%s\n\n" "The next track is playing."
		;;
		"previous song"|pr)
		cmus-remote -r
		cmus-remote -Q
		printf "\n%s\n\n" "The previous track is playing."
		;;
		"pause song"|p)
		cmus-remote -u
		cmus-remote -Q
		printf "\n%s\n\n" "Paused/Playing."
		;;
		"forward song"|fo)
		cmus-remote -k +5
		printf "\n%s\n\n" "Forwarding..."
		;;
		"status on music"|st)
		cmus-remote -Q | less
		;;
		"default audio levels"|au)
		printf "\n%s" ""; amixer -c 0 -- sset Master unmute; amixer -c 0 -- sset Master playback -10dB
		;;
		"increase volume"|inc)
		printf "\n%s" ""; amixer sset Master playback 5%+
		;;
		"lower volume"|low)
		printf "\n%s" ""; amixer sset Master playback 5%-
		;;
		"audio controls"|a)
		alsamixer
		;;
		"video search on youtube"|yo)
		yt
		;;
		"music search on youtube"|mus)
		ytmusic
		;;
		"pick a song"|pi)
		fzfcmus
		;;
		"find a program from this list"|f)
		fuzselect='true'	
		selection
		break
		;;
		"run any program"|ru)
		systemprograms
		;;
		"web search"|we)
		websearch
		;;
		"format bookmarks"|book)
		bookmarkformat
		;;
		"select a bookmark for web browsing"|b)
		[[ ! -f /home/"$USER"/.bookmarks_ttysh.txt ]] && cat /home/"$USER"/ttysh/resources/bookmarks/.bookmarks_ttysh.txt > /home/"$USER"/.bookmarks_ttysh.txt
		bookmarkpick="$(cat /home/"$USER"/.bookmarks_ttysh.txt | fzf --prompt "Pick a bookmark: ")"
		if [[ $TERM  = "linux" ]]; then
			lynx "$bookmarkpick"
		elif [[ $TERM = "xterm-256color" ]]; then
			devour librewolf "$bookmarkpick" 
		elif [[ $TERM = "foot" ]]; then
			librewolf "$bookmarkpick" 
		fi
		;;
		"web browser"|w)
		if [[ $TERM = "linux" ]]; then
			lynx
		elif [[ $TERM = "xterm-256color" ]]; then
			devour librewolf
		elif [[ $TERM = "foot" ]]; then
			librewolf
		fi
		;;
		"ping jameschampion.xyz"|pin)
		ping -c 3 jameschampion.xyz
		;;
		"calender schedule"|sch)
		calenderschedule
		;;
		"notes and todos"|n)
		vim /home/"$USER"/.notes.txt
		;;
		"mutt email configuation"|mu)
		screen -c /home/"$USER"/ttysh/resources/.screenrc.mutt_conf
		;;
		"date & calender"|d)
		printf "\n%s\n"
		cal
		date
		printf "\n%s\n"
		;;
		"clock"|c)
		screen -c /home/"$USER"/ttysh/resources/.screenrc.clockworking
		;;
		"stopwatch"|sto)
		before=$(date +%s)

		printf "\n\n"

		while [ 1 ]; do

        	minutes=$(($(date +%s)-$before))
        	printf "\033[A"
        	echo "Seconds: $(($(date +%s)-$before)) - Minutes: $(($minutes/60)) - Hours: $(($minutes/3600))"
        	sleep 1
		done
		;;
		r)
		cd /home/"$USER"/Videos
		newsboat
		cd /home/"$USER"/
		;;
		"email"|e)
		mutt
		;;
		"start i3 window manager"|i)
		startx
		;;
		"start sway window manager"|s)
		sway
		;;
		"file manager"|fi)
		vim /home/"$USER"/
		;;
		"search & play video in tty i3 sway"|v)
		fzfvid	
		;;
		"search & view images"|im)
		fzfimage	
		;;
		"search files to open in text editor"|edi)
		fzfvim	
		;;
		"weather"we)
		weather
		;;
		"search pdfs"|pdf)
		fzfpdf
		;;
		"stop! first run ttysh as sudo su!: disk formatting and setting up removable media"|di)
		diskformat
		;;
		"stop! first run ttysh as sudo su!: backup /home/user/ to removable drive"|ba)
		filebackup
		;;
		"stop! first run ttysh as sudo su!: timeshift backup to removable drive"|ti)
		maintimeshift
		;;
		"stop! first run ttysh as sudo su!: delete timeshift backups from removable drive"|de)
		maintdelete	
		;;
		"close i3 or sway and return to tty"|cl)
		if [[ $TERM = "foot" ]]; then
			pkill "sway"
		else
			pkill "Xorg"
		fi
		;;
		"AltGr as left mouse click on x11 on old thinkpads"|alt)
		xkbset m; xmodmap -e "keycode 108 = Pointer_Button1"
		;;
		"lock the screen"|lo)
		if [[ $TERM = "linux" ]]; then
		vlock -a
		elif [[ $TERM = "xterm-256color" ]]; then
		i3lock
		elif [[ $TERM = "foot" ]]; then
		swaylock
		fi
		;;
		"screenshot tty 1"|sc1)
		screenshotcheck 
		sudo fbgrab -c 1 screenshot1.png
		;;
		"screenshot tty 2"|sc2)
		screenshotcheck 
		sudo fbgrab -c 2 screenshot2.png
		;;
		"screenshot tty 3"|sc3)
		screenshotcheck 
		sudo fbgrab -c 3 screenshot3.png
		;;
		"screenshot tty 4"|sc4)
		screenshotcheck 
		sudo fbgrab -c 4 screenshot4.png
		;;
		"screenshot tty 5"|sc5)
		screenshotcheck 
		sudo fbgrab -c 5 screenshot5.png
		;;
		"screenshot tty 6"|sc6)
		screenshotcheck
		sudo fbgrab -c 6 screenshot6.png
		;;
		"record your tty/s"|re)
		if [[ ! -d /home/"$USER"/Recordings ]]; then
			mkdir /home/"$USER"/Recordings
			cd /home/"$USER"/Recordings 
		else
			cd /home/"$USER"/Recordings/
			sudo ffmpeg -f fbdev -framerate 30 -i /dev/fb0 ttyrecord.mp4
		fi
		;;
		"record your i3 or sway window manager"|rec)
		[[ ! -d /home/"$USER"/Recordings ]] && mkdir /home/"$USER"/Recordings

		if [[ $TERM = "foot" ]]; then
			cd /home/"$USER"/Recordings/ 
			wf-recorder -r 30 -F "scale=1280:720" -f swayrecord.mp4
		else
			cd /home/"$USER"/Recordings/
			ffmpeg -video_size 1280x800 -framerate 30 -f x11grab -i :0 x11record.mp4
		fi
		;;
		"text editor"|ed)
		vim
		;;
		"calculator"|ca)
		bc -l
		;;
		"spreadsheet"|sp)
		sc-im
		;;
		"system monitor"|sy)
		htop
		;;
		"computer temperatures"|te)
		watch sensors
		;;
		"free disk space"|fr)
		printf "\n%s\n" ""
		df -h
		;;
		"screen four panel split"|fou)
		screen -c /home/"$USER"/ttysh/resources/.screenrc.four_split
		;;
		"screen horizontal split"|hor)
		screen -c /home/"$USER"/ttysh/resources/.screenrc.hsplit
		;;
		"screen vertical split"|ver) 
		screen -c /home/"$USER"/ttysh/resources/.screenrc.vsplit
		;;
		"scrollback information for tty"|scro)
		printf "\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n" "How To Achieve Scrollback In A TTY" "Login to a TTY and run the following: " "bash | tee /tmp/scrollback" "Now login to a seperate TTY and run: " "less +F /tmp/scrollback" "Now switch back to your first TTY. When you want to scrollback then return to your second TTY and press CTRL+C to interrupt less from following your file. You can then scroll back through your output. When you have finished scrolling back through your history press SHIFT+F in less and it'll go back to following the /tmp/scrollback file"
		;;
		"change to tty 1"|v1)
		if [[ $(tty | tr -d '[0-9]') = "/dev/pts/" ]]; then
			sudo chvt 1
		else
			chvt 1
		fi
		;;
		"change to tty 2"|v2)
		if [[ $(tty | tr -d '[0-9]') = "/dev/pts/" ]]; then
			sudo chvt 2
		else
			chvt 2
		fi
		;;
		"change to tty 3"|v3)
		if [[ $(tty | tr -d '[0-9]') = "/dev/pts/" ]]; then
			sudo chvt 3
		else
			chvt 3
		fi
		;;
		"change to tty 4"|v4)
		if [[ $(tty | tr -d '[0-9]') = "/dev/pts/" ]]; then
			sudo chvt 4
		else
			chvt 4
		fi
		;;
		"change to tty 5"|v5)
		if [[ $(tty | tr -d '[0-9]') = "/dev/pts/" ]]; then
			sudo chvt 5
		else
			chvt 5
		fi
		;;
		"change to tty 6"|v6)
		if [[ $(tty | tr -d '[0-9]') = "/dev/pts/" ]]; then
			sudo chvt 6
		else
			chvt 6
		fi
		;;
		"choose tty"|vt)
		while [ 1 ]; do

			printf "\n\n%s\n\n%s" "Choose your TTY: " "You are currently in: "; tty

			printf "\n"

			read -e -p "Enter your selection [ 1 - 6 ]: " answer
			
			case "$answer" in
				"1" | "2" | "3" | "4" | "5" | "6" )	
				if [[ $(tty | tr -d '[0-9]') = "/dev/pts/" ]]; then
					sudo chvt "$answer"
				else
					chvt "$answer"
				fi
				break
				;;
				*)
				printf "\n\n%s\n\n" "Not a valid selection."
				;;
			esac
		done
		;;
		"rerun ttysh"|tty)
		refresh="$0"
		"$refresh"
		exit 0
		;;
		"network manager"|net)
		nmtui
		;;
		"network manager devices"|dev)
		printf "\n%s\n%s\n%s\n%s\n%s\n%s\n\n" "Press s to show your NetworkManager devices." "Press d to shutdown a device." "Press u to start up a device."  "Press r to restart a running device." "Press re to restart wireless device and network manager" "Press q to quit."

		while [ 1 ]; do

			read -e -p "Enter your selection: " nmpick

			case "$nmpick" in
				s)
				nmcli connection show
				;;
				d)
				nmcli device disconnect "$(nmcli connection show | awk '{print $4}' | sed '/DEVICE/d; /--/d' | fzf --prompt "Pick a device to disconnect: ")"
				;;
				u)	
				nmcli device connect "$(nmcli device show | grep "GENERAL.DEVICE" | awk '{print $2}' | fzf --prompt "Pick a device to start up: ")"
				;;	
				r)
				resdev="$(nmcli connection show | awk '{print $4}' | sed '/DEVICE/d; /--/d' | fzf --prompt "Pick a running device to restart: ")"
				nmcli device disconnect "$resdev"
				nmcli device connect "$resdev"
				;;
				re)
				nmcli radio wifi off
				nmcli radio wifi on
				rfkill block wifi
				rfkill list
				rfkill unblock wifi
				rfkill list
				;;
				q)
				break
				;;
			esac
		done
		;;
		"fan control on thinkpads"|fan)
		printf "\n%s\n" "Starting up thinkpad_acpi kernel module..."

		sudo modprobe -r thinkpad_acpi && sudo modprobe thinkpad_acpi

		printf "\n%s\n" "Completed"

		printf "\n"$warncolour"%s"$warncolourend"\n" "Changing your fan speed can damage your computer. Would you like to continue? y/n"

		read -e -p "Enter your selection: " fpick

			case "$fpick" in 
				y)
				fanspeed
				;;
				n)
				printf "\n%s\n" "Exiting..."	
				;;
				*)
				;;
			esac
		;;
		"update the system"|u)
		printf "\n"$warncolour"%s"$warncolourend"\n" "Is your device running on A/C, incase of powerloss during updates? y/n or q to quit"

		while [ 1 ]; do
		
			read -e -p "Enter your selection: " upick

			case "$upick" in
				y)
				printf "\n%s\n" "Updating Arch Linux..."
				sudo pacman --needed -Syu \
					base-devel \
					curl \
					xdo \
					bc \
					cmus \
					alsa-utils \
					yt-dlp \
					lynx \
					mpv \
					fzf \
					screen \
					vim \
					less \
					man \
					newsboat \
					mutt \
					xorg-server \
					xorg-xinit \
					i3-wm \
					autotiling \
					xterm \
					xclip \
					xorg-xmodmap \
					sway \
					foot \
					wf-recorder \
					wl-clipboard \
					xorg-xwayland \
					mupdf \
					zathura \
					cryptsetup \
					timeshift \
					imagemagick \
					htop \
					fbgrab \
					tldr \
					go \
					git \
					networkmanager \
					noto-fonts \
					i3lock \
					swaylock \
					terminus-font

				printf "\n\n%s\n" "Updating the Arch Linux AUR..."
				yay -Sua
				installed=(
				"devour"
				"librewolf-bin"
				"arkenfox-user.js"
				"xkbset"
				"clipman"
				"fbpdf-git"
				"sc-im"
				)
				for i in "${installed[@]}"; do
				
					if [[ ! "$(pacman -Qm | grep -i "$i")" ]]; then
						echo ""$i" not installed"
						echo "now installing... "$i""
						yay -S --noconfirm "$i"
					else
						echo ""$i" already installed"
					fi	
				done
				printf "\n\n%s\n" "Updating TTYSH..."
				cd /home/"$USER"/ttysh/
				git pull
				printf "\n\n%s\n" "Setting i3, sway, foot, bashrc, Xdefaults configs etc..."
				cat /home/"$USER"/ttysh/resources/i3config/config > /home/"$USER"/.config/i3/config
				cat /home/"$USER"/ttysh/resources/swayconfig/config > /home/"$USER"/.config/sway/config
				cat /home/"$USER"/ttysh/resources/footconfig/foot.ini > /home/"$USER"/.config/foot/foot.ini
				cat /home/"$USER"/ttysh/resources/bashrc/.bashrc > /home/"$USER"/.bashrc
				cat /home/"$USER"/ttysh/resources/.Xdefaults > /home/"$USER"/.Xdefaults
				cat /home/"$USER"/ttysh/resources/newsboatconfig/config > /home/"$USER"/.newsboat/config
				sudo cat /home/"$USER"/ttysh/resources/x11config/xorg.conf > /etc/X11/xorg.conf
				printf "\n\n%s\n" "Setting your person toggles..."
				togglesupdate
				printf "\n%s\n" "You should now exit TTYSH and reboot your system to complete any new updates."
				break
				;;
				n)
				printf "\n%s\n\n%s\n" "Run on A/C power and then run the update selection again" "Is your device running on A/C, incase of powerloss during updates? y/n or q to quit"
				;;
				q)
				break
				;;
				*)
				;;
			esac
		done
		;;
		"font and text change in tty"|fon)
		sudo screen -c /home/"$USER"/ttysh/resources/.screenrc.font_conf
		[[ "$(grep -i "ttyshfont=true" /home/"$USER"/.config/ttysh/config)" ]] && sed -i 's/ttyshfont=true/ttyshfont=false/' /home/"$USER"/.config/ttysh/config && sed -i 's/.*setfont ter-218b.*/#[ $(tty | tr -d '\''[0-9]'\'') = "\/dev\/tty" ] \&\& setfont ter-218b/' /home/"$USER"/.bashrc
		printf "\n%b\n" "You should reboot your system to see any changes that you have made."
		;;
		"set temporary font in tty"|font)
		setfont "$(ls /usr/share/kbd/consolefonts | fzf -i --prompt "Pick a font, or select nothing to return to original terminal font: ")"
		;;
		"restart"|res)
		sudo reboot
		exit 0
		;;
		"shutdown"|sh)
		sudo poweroff
		exit 0
		;;
		"help"|h)
		eofhelp
		;;
		"quit"|q)
		printf "\n%s" ""
		exit 0
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
}

#
# PROGRAMME START
# 

if [[ -f /home/"$USER"/.ttyshwizardrun ]] || [[ "$USER" = root ]]; then
	printf "%s" ""
else
	printf "\n%s\n" "First time using TTYSH, or you do not yet have TTYSH setup and configured? Press y to begin setup, or press n to exit."

	read -e -p "Enter your selection: " answer

	case "$answer" in
		y)
		wizardttysh
		;;
		n)
		printf "\n%s\n" "exiting"; exit 0
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
fi

[[ "$1" ]] && options=$(printf "%s" "fzfcmus websearch fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner helpflags" | tr ' ' '\n' | grep "$1") && "$options"

while [ 1 ]; do

[[ ! $(screen -list | grep "cmusdaemon" | cut -d "." -f2 | cut -f1) ]] && screen -dmS cmusdaemon cmus

intro="$(printf "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s" "select a ttysh program" "find a ttysh program" "run any program" "i3 window manager" "sway window manager" "toggle options" "config wizard" "help" "quit" | fzf --prompt "TTYSH " --layout=reverse --margin 20%)"

	case "$intro" in
		"select a ttysh program")
		unset fuzselect
		selection
		break
		;;
		"find a ttysh program")
		fuzselect='true'	
		selection
		break
		;;	
		"run any program")
		systemprograms
		;;
		"i3 window manager")
		startx
		selection
		break
		;;
		"sway window manager")
		sway
		selection
		break
		;;
		"help")
		eofhelp
		;;
		"toggle options")
		ttyshtoggles
		printf "\n%s\n" "To see your changes restart the program/s or your computer"
		selection
		break
		;;
		"config wizard")
		wizardttysh
		;;
		"quit")
		printf "\n%s" ""
		exit 0
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
