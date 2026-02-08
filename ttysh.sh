#!/bin/bash

# TTYSH : A daily driver and "desktop/texttop" experience for the tty.


#
# VARIABLES
#

# red warning colour
warncolour='\033[31;1m'
warncolourend='\033[0m'


# variable for while loop
x=0

# splash screen variable for tty/pts
ttytest=$(tty | tr -d '[0-9]') 
#splash=$(echo ""${splash%y*}"y")


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

		Internet/

			select a (b)ookmark for web browsing/

			(we)b search/

			(w)eb browser/ 

			format (boo)kmarks/

		Email/

			(e)mail/

			(mu)tt email configuation/

		Search/

			(f)ind a program from this list/

			(ru)n any program/

			(fi)le manager/

			search & play video in (t)ty/

			(se)arch & play in gui/

			(fz)f search files to open in vim/

			search files and (del)ete/
			
			NOTE: the above command will only work effectively on properly named files. Try the command below:

			remove (wh)ite spaces from file names/

			search images and (pdf)s/

		Music Player/ 

			(cm)us music player/

			(ne)xt song/ 

			(pr)evious song/ 

			(p)ause song/ 

			(fo)rward song/ 

			(st)atus on music/ 

			(pi)ck a song/

			(inc)rease volume/

			(low)er volume/

			(mus)ic search on youtube/

		Audio Settings/

			alsa (au)to setting/

			(al)samixer/

		Video/
			
			video search on (yo)utube/

			play your downloaded youtube (vid)eos/

		Record/

			(sc)reenshot(1,2,3,4,5,6) tty/

			(re)cord your tty/s/

			(rec)ord your x server/

		Wordprocessing/

			(wr)iter/

		Calc/Spreadsheet/

			(sp)readsheet/

			(ca)lculator/

		Accessories/

			calender (sch)edule/ 

			(n)otes and todos/ 

			(d)ate & calender/

			(we)ather/

		Backup/

			stop! first run ttysh as sudo su!: (di)sk formatting and setting up removable media/

			*NOTE: RUN THE ABOVE ON REMOVABLE MEDIA BEFORE MAKING YOUR BACKUPS.

	 		stop! first run ttysh as sudo su!: (ba)ckup /home/user/ to removable drive/

			stop! first run ttysh as sudo su!: (ti)meshift backup to removable drive/

			stop! first run ttysh as sudo su!: (de)lete timeshift backups from removable drive/

		TTY/
				
			(scro)llback information for tty/

			change (v)t (1,2,3,4,5,6) tty/

			choose ch(vt) tty/

			*NOTE: cannot use this selection in screen split. Use alt+number or alt+arrow key instead

		Screen splits/

			(scr)een four panel split/

			(scre)en horizontal split/

			(scree)n vertical split/

		Xorg/Wayland/

			(s)tart i3 window manager/

			start (sw)ay window manager/

			close (i3) and return to tty/

			close swa(y) and return to tty/

			(alt)Gr as left mouse click on x11 on thinkpads/

		System/Utilities/

			(fon)t and text change/

			set temporary (font)/

			(net)work manager/

			network manager (dev)ices/

			p(i)ng jameschampion.xyz/

			(fan) control on thinkpads/

			(u)pdate the system/

			(ht)op/

			computer (te)mperatures/

			(fr)ee disk space/

			(c)lock/

			(sto)pwatch/

			(lo)ck console/

			*NOTE: if you are in xorg/i3, press Ctrl + Alt + and an F key to return to the TTY before you lock the console.

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
select a bookmark for web browsing
web search
web browser
format bookmarks
email
mutt email configuation
find a program from this list
run any program
file manager
search & play video in tty
search & play in gui
fzf search files to open in vim
search files and delete
remove white spaces from file names
search images and pdfs
cmus music player 
next song
previous song
pause song
forward song
status on music
pick a song
audio auto setting
increase volume
lower volume
alsamixer
music search on youtube
video search on youtube
play your downloaded youtube videos
screenshot tty 1
screenshot tty 2
screenshot tty 3
screenshot tty 4
screenshot tty 5
screenshot tty 6
record your tty/s
record your x server
writer
spreadsheet
calculator
calender schedule
notes and todos 
date & calender
weather
stop! first run ttysh as sudo su!: disk formatting and setting up removable media
stop! first run ttysh as sudo su!: backup /home/user/ to removable drive
stop! first run ttysh as sudo su!: timeshift backup to removable drive
stop! first run ttysh as sudo su!: delete timeshift backups from removable drive
scrollback information for tty
change to tty 1
change to tty 2
change to tty 3
change to tty 4
change to tty 5
change to tty 6
choose tty
screen four panel split
screen horizontal split
screen vertical split
start i3 window manager
start sway window manager
close i3 and return to tty
close sway and return to tty
AltGr as left mouse click on x11 on old thinkpads
font and text change
set temporary font
network manager
network manager devices
ping jameschampion.xyz
fan control on thinkpads
update the system
htop
computer temperatures
free disk space
clock
stopwatch
lock console
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

[ ! "$SUDO_USER" ] && printf "\n"$warncolour"%s"$warncolourend"\n\n" "Run as sudo su first! Exiting..." && exit 1 || printf "\n%s\n\n%s\n\n" "Checking you are running as sudo user..." "Continuing..."
}

# /dev/mapper/drive check for timeshift
mappercheck () {

[ ! -h /dev/mapper/timeshiftbackup ] && printf "\n\n%s\n\n" "cryptsetup has failed to open /dev/mapper/timeshiftbackup from /dev/"$tdevname" . Make sure you are entering the correct password, or check your devices and mountpoints. Running lsblk and exiting..." && lsblk && exit 1 || printf "\n\n%s\n\n" "dev/mapper/timeshiftbackup found. Continuing..." 
}

# cmus daemon question
cmusquest () {

while [ 1 ]; do

	printf "\n%s\n%s\n%s\n" "Do you want to start the music daemon?" "Note: the music daemon runs with screen. Press Ctrl a + d to detach the running daemon, unless you are running special binds for cmus." "Starting up the daemon from a TTY is prefered behaviour, incase of errors with X11."

	read -e -p "Press y to run the cmus music daemon, or n for no: " cmusanswer

	case "$cmusanswer" in
		y)
		printf "\n%s\n\n" "Run cmus from the command line to run the daemon before starting TTYSH again."
		exit 0
		#cmus
		#break
		;;
		n)
		break
		;;
		*)
		printf "\n%s\n\n" "Invalid selection"
	esac

done
}

# cmus checker for running daemon
cmuscheck () {

cmuslist=$(screen -list | grep -i "cmus" | cut -d '.' -f2 | awk '{print $1}')

[ "$cmuslist" = cmus ] && printf "\n%s\n\n" "Cmus Status: The cmus daemon is running." && return || cmusquest 
}

# function for tty or pts splash screen
splashscreen () {

[ "$ttytest" = /dev/pts/ ] && devour mpv --really-quiet /home/"$USER"/ttysh/resources/.splash_ttysh.png || mpv --really-quiet /home/"$USER"/ttysh/resources/.splash_ttysh.png
}

# function for shortcuts selection 
ttyshhelp () {

less /home/"$USER"/ttysh/resources/.ttysh.selection 
}

# function for TTYSH configuration
wizardttysh () {

# a wizard to configure TTYSH

# first, update the system and install needed packages

sudo pacman --noconfirm -Syu \
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

[ ! -f /home/"$USER"/.config/mpv.conf ] && mkdir -p /home/"$USER"/.config/mpv; printf "%b" '--image-display-duration=1000' > /home/"$USER"/.config/mpv/mpv.conf

printf "%s\n" "NOTES" > /home/"$USER"/.notes.txt

[ ! -d /home/"$USER"/.newsboat ] && mkdir -p /home/"$USER"/.newsboat; echo 'https://www.youtube.com/feeds/videos.xml?channel_id=UCeFnqXMczw4BDCoJHr5dBjg "~James Champion (Youtube)"' > /home/"$USER"/.newsboat/urls; cat /home/"$USER"/ttysh/resources/newboatconfig/config > /home/"$USER"/.newsboat/config

mkdir -p /home/"$USER"/.config/mutt/ && touch /home/"$USER"/.config/mutt/muttrc

printf "%b\n%b\n\n%b\n%b\n%b\n\n%b\n%b\n%b\n%b\n\n%b" 'set folder = "imaps://"' 'set smtp_url = "smtp://"' 'set from = ""' 'set realname = ""' 'set editor = "vim"' 'set spoolfile = "+INBOX"' 'set record = "+Sent"' 'set trash = "+Trash"' 'set postponed = "+Drafts"' 'mailboxes =INBOX =Sent =Trash =Drafts =Junk' > /home/"$USER"/.config/mutt/muttrc

cat /home/"$USER"/ttysh/resources/.Xdefaults >> /home/"$USER"/.Xdefaults

printf "%s" "exec i3" > /home/"$USER"/.xinitrc

[ ! -d /home/"$USER"/.config/i3 ] && mkdir -p /home/"$USER"/.config/i3; cat /home/"$USER"/ttysh/resources/i3config/config > /home/"$USER"/.config/i3/config

[ ! -d /home/"$USER"/.config/sway ] && mkdir -p /home/"$USER"/.config/sway; cat /home/"$USER"/ttysh/resources/swayconfig/config > /home/"$USER"/.config/sway/config

[ ! -d /home/"$USER"/.config/foot ] && mkdir -p /home/"$USER"/.config/foot; cat /home/"$USER"/ttysh/resources/footconfig/foot.ini > /home/"$USER"/.config/foot/foot.ini

[ ! -d /home/"$USER"/.config/ttysh ] && mkdir -p /home/"$USER"/.config/ttysh; cat /home/"$USER"/ttysh/resources/ttyshconfig/config > /home/"$USER"/.config/ttysh/config

cat /home/"$USER"/ttysh/resources/bashrc/.bashrc > /home/"$USER"/.bashrc

printf "\n%s\n" "Last run" >> /home/"$USER"/.ttyshwizardrun
 
date >> /home/"$USER"/.ttyshwizardrun

printf "\n%s\n" "TTYSH Wizard has finished. Reboot your computer to finish the setup."

exit 0
}

# run toggles update
togglesupdate () {

while read i; do

	case "$i" in

		i3autotiling=true|i3autotiling=false)
		if [ "$(grep -i "i3autotiling=true" /home/"$USER"/.config/ttysh/config)" ]; then

			sed -i 's/^exec --no-startup-id autotiling/exec --no-startup-id autotiling/g;s/^#exec --no-startup-id autotiling/exec --no-startup-id autotiling/g' /home/"$USER"/.config/i3/config 

		else	
			sed -i 's/^#exec --no-startup-id autotiling/#exec --no-startup-id autotiling/g;s/^exec --no-startup-id autotiling/#exec --no-startup-id autotiling/g' /home/"$USER"/.config/i3/config
		fi
		;;
		swayautotiling=true|swayautotiling=false)
		if [ "$(grep -i "swayautotiling=true" /home/"$USER"/.config/ttysh/config)" ]; then

			sed -i 's/^exec_always autotiling/exec_always autotiling/g;s/^#exec_always autotiling/exec_always autotiling/g' /home/"$USER"/.config/sway/config 

		else	
			sed -i 's/^#exec_always autotiling/#exec_always autotiling/g;s/^exec_always autotiling/#exec_always autotiling/g' /home/"$USER"/.config/sway/config
		fi
		;;
		ttyshfont=true|ttyshfont=false)
		if [ "$(grep -i "ttyshfont=true" /home/"$USER"/.config/ttysh/config)" ]; then

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

		printf "\n%s\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n" "Toggle the following on and off:" "(c)urrent toggle status" "(t)tysh autostart (under development)" "(i)3 window manager autotiling" "(s)way window manager autotiling" "ttysh tty (f)ont" "(r)eset toggles to defaults" "(q)uit and return to selection"

	read -e -p "Enter your selection: " pickoption

	case "$pickoption" in

		c)
		less /home/"$USER"/.config/ttysh/config
		;;
		#t)
		#[ "$(grep -i "ttyshautostart=true" /home/"$USER"/.config/ttysh/config)" ] && sed -i 's/ttyshautostart=true/ttyshautostart=false/g' /home/"$USER"/.config/ttysh/config || sed -i 's/ttyshautostart=false/ttyshautostart=true/g' /home/"$USER"/.config/ttysh/config
		#;;
		i)
		[ "$(grep -i "i3autotiling=true" /home/"$USER"/.config/ttysh/config)" ] && sed -i 's/i3autotiling=true/i3autotiling=false/g' /home/"$USER"/.config/ttysh/config || sed -i 's/i3autotiling=false/i3autotiling=true/g' /home/"$USER"/.config/ttysh/config

		if [ "$(grep -i "i3autotiling=true" /home/"$USER"/.config/ttysh/config)" ]; then

			sed -i 's/^exec --no-startup-id autotiling/exec --no-startup-id autotiling/g;s/^#exec --no-startup-id autotiling/exec --no-startup-id autotiling/g' /home/"$USER"/.config/i3/config 

		else	
			sed -i 's/^#exec --no-startup-id autotiling/#exec --no-startup-id autotiling/g;s/^exec --no-startup-id autotiling/#exec --no-startup-id autotiling/g' /home/"$USER"/.config/i3/config
		fi
		;;
		s)
		[ "$(grep -i "swayautotiling=true" /home/"$USER"/.config/ttysh/config)" ] && sed -i 's/swayautotiling=true/swayautotiling=false/g' /home/"$USER"/.config/ttysh/config || sed -i 's/swayautotiling=false/swayautotiling=true/g' /home/"$USER"/.config/ttysh/config

		if [ "$(grep -i "swayautotiling=true" /home/"$USER"/.config/ttysh/config)" ]; then

			sed -i 's/^exec_always autotiling/exec_always autotiling/g;s/^#exec_always autotiling/exec_always autotiling/g' /home/"$USER"/.config/sway/config 

		else	
			sed -i 's/^#exec_always autotiling/#exec_always autotiling/g;s/^exec_always autotiling/#exec_always autotiling/g' /home/"$USER"/.config/sway/config
		fi
		;;
		f)
		[ "$(grep -i "ttyshfont=true" /home/"$USER"/.config/ttysh/config)" ] && sed -i 's/ttyshfont=true/ttyshfont=false/g' /home/"$USER"/.config/ttysh/config || sed -i 's/ttyshfont=false/ttyshfont=true/g' /home/"$USER"/.config/ttysh/config

		if [ "$(grep -i "ttyshfont=true" /home/"$USER"/.config/ttysh/config)" ]; then

 			sed -i 's/.*setfont ter-218b.*/[ $(tty | tr -d '\''[0-9]'\'') = "\/dev\/tty" ] \&\& setfont ter-218b/' /home/"$USER"/.bashrc

		else	
 			sed -i 's/.*setfont ter-218b.*/#[ $(tty | tr -d '\''[0-9]'\'') = "\/dev\/tty" ] \&\& setfont ter-218b/' /home/"$USER"/.bashrc
		fi
		;;
		r)
		[ ! -d /home/"$USER"/.config/ttysh ] && mkdir -p /home/"$USER"/.config/ttysh && cat /home/"$USER"/ttysh/resources/ttyshconfig/config > /home/"$USER"/.config/ttysh/config || cat /home/"$USER"/ttysh/resources/ttyshconfig/config > /home/"$USER"/.config/ttysh/config
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

#cmuscheck

cmuspicker=$(find /home/"$USER"/Music/starred/ -type f | fzf -i --prompt "Pick the music track you want to play in cmus: ") 

cmus-remote -f "$cmuspicker"

cmus-remote -Q && printf "\n" ""
}

# format bookmarks for fzfbookmark
bookmarkformat () {

formathtml=$(find /home/"$USER"/ -name '*.html' | fzf -i --prompt "Note: if you already have a /home/"$USER"/.bookmarks_ttysh.html file, it will be overwritten. Pick the html file you want to format: ")

#sed 's/\ /\n/g' "$formathtml" | sed -n '/https\|https/p' | sed 's/^HREF="//g;s/ICON_URI="//g;s/^LAST_MODIFIED="//g;s/[0-9]//g;s/">//g;s/^fake-icon-uri//g;s/"$//g'

sed 's/\ /\n/g' "$formathtml" | grep "https\?" | cut -d '"' -f2 | grep "https\?" | grep -v "^fake-favicon-uri" | grep -v ".ico$" > /home/"$USER"/.bookmarks_ttysh.html

printf "\n%s\n" "Your /home/"$USER"/.bookmarks_ttysh.html is now formatted for the 'bo' command"
}

# websearch case statement
casewebsearch () {

read -e -p "Search: " webpick

devour librewolf search.brave.com/search?q="$webpick"
}

# search the internet
websearch () {

printf "\n" ""

#[ "$splash" = /dev/pts/ ] && casewebsearch && return || read -e -p "Search: " webpick && lynx searx.be/search?q="$webpick"

if [ "$ttytest" = /dev/pts/ ]; then
		
	casewebsearch
	return
else
	
	read -e -p "Search: " webpick 
	lynx search.brave.com/search?q="$webpick"
fi
#[ $splash" = /dev/pts/ ] && devour librewolf searx.be/search?q="$webpick" || browsh --startup-url searx.be/search?q="$webpick"
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
		#killall nm-applet
		rfkill unblock wifi
		rfkill list
		#nm-applet
		break
		;;
	esac
done
}

# function for fzf video search in the xorg/GUI
fzfxorgvid () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start Press q to quit."

	read -e -p "Enter you selection: " answer

	case "$answer" in
		s)
		[ "$ttytest" = /dev/pts/ ] && mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the GUI: ")" || mpv -vo=drm "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the TTY: ")"
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

# function for fzf video in TTY & Xorg
fzfttyvid () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -e -p "Enter your selection: " answer

	case "$answer" in
		s)
		[ "$ttytest" = /dev/pts/ ] && devour mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the terminal GUI: ")" || mpv -vo=drm "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch fullscreen in the TTY: ")"
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
		[ "$ttytest" = /dev/pts/ ] && devour mupdf "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the pdf you want to view. ESC to exit: ")" || sudo fbpdf "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the pdf you want to view. ESC to exit: ")"
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

# function for fzf file search and deletion
fzfdelete () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -e -p "Enter your selection: " answer

	case "$answer" in
		s)
		rm -iv $(find /home/"$USER"/ -type f | fzf -i --multi --prompt "Pick the file for deletion. ESC to exit: ")
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

# function for fzf directory and file search to remove white space
fzfwhitespace () {

while [ 1 ]; do

	printf "\n%s\n" "Press s to start. Press q to quit."

	read -e -p "Enter your selection: " answer

	case "$answer" in
		s)
		chosendir="$(find /home/"$USER"/ | fzf -i --prompt "Pick the directory with the files names that you want to remove white space from: ")"
		for file in "$chosendir"/*
		do
			read -e -p "Did you pick something, or do you want to quit? Press c to continue, or e to exit: " pick
			case "$pick" in
				c)
				mv "$file" "$(echo "$file" | sed -e 's/\ /_/g')"
				break
				;;
				e)
				break
				;;
				*)
				printf "\n%s\n" "Not a valid selection."
				;;
			esac
		done
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

if [ ! -d /home/"$USER"/Videos ]; then 
		
	mkdir /home/"$USER"/Videos/
	cd /home/"$USER"/Videos/

else

	cd /home/"$USER"/Videos/ 
fi

while [ 1 ]; do

	printf "\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" "y to enter video creator and video discription." "a for video that fails choosing y." "x to download url from xclip." "b for video that fails choosing x." "yt to run again." "q to quit"

	read -e -p "Enter your selection: " answer

	printf "\n%s\n" ""

	case "$answer" in
		y)
		printf "\n%s\n" "Enter the creator and discription: "
		read -e video
		printf "\n%s\n"	""
		yt-dlp -f 'bv*[height=720]+ba' "ytsearch1:""$video"""
		;;
		a)
		printf "\n%s\n" "Enter the creator and discription: "
		read -e video
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
}

# function for music in yt-dlp
ytmusic () {

if [ ! -d /home/"$USER"/Music ]; then
		
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
		read -e music
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
}

# rss function
rssread () {

printf "\n%s\n" "Do you want to run your rss reader? y/n"

while [ 1 ]; do

	read -e -p "Enter your selection: " rpick

	case "$rpick" in
		y)
		rsssplit
		printf "\n%s\n" "Do you want to run your rss reader again? y/n"
		;;
		n)
		break
		;;
		*)
		printf "\n%s\n\n" "Not a valid selection"
	esac
done
}

# rss split
rsssplit () {

while [ 1 ]; do

	printf "\n%s\n\n" "Would you like your rss feed in a split-screen with a shell? y/n"

	read -e -p "Enter your selection: " ranswer

	case "$ranswer" in
		y)
		screen -c /home/"$USER"/ttysh/resources/.screenrc.rss
		break
		;;
		n)
		[ ! -d /home/"$USER"/.newsboat ] && mkdir -p /home/"$USER"/.newsboat; echo 'https://www.youtube.com/feeds/videos.xml?channel_id=UCeFnqXMczw4BDCoJHr5dBjg "~James Champion (Youtube)"' > /home/"$USER"/.newsboat/urls; cat /home/"$USER"/ttysh/resources/newboatconfig/config > /home/"$USER"/.newsboat/config || cd /home/"$USER"/Videos/; newsboat; cd /home/"$USER"/; break
		;;
		*)
		printf "\n\n%s\n\n" "Not a valid selection."
		;;
	esac
done
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

[ ! -f /home/"$USER"/.*calenderdatafile ] && printf "\n%s\n" "Set up your calender data: " && calenderdata && echo "Calender made. Fill in your calender at /home/"$USER"/.*calenderdata and run this selection again or continue with the option to edit your calender." ||

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
		read -e wwanswer
		curl wttr.in/"$wwanswer"?T --output /home/"$USER"/ttysh/resources/.weatherdata
		cat /home/"$USER"/ttysh/resources/.weatherdata
		#wget -qO- wttr.in/"$answer"
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

# function for devour vid in xorg
devourvid () {

[ "$ttytest" = /dev/pts/ ] && devour mpv /home/"$USER"/Videos/* || mpv -vo=drm /home/"$USER"/Videos/*
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

	read -e answer

fdisk /dev/"$answer"

printf "\n%s\n" "We need to now create your encrypted partition..."

lsblk

printf "\n%s\n" "What is the new partition name of your drive? e.g. sdb1 ?"

	read -e setuuid

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

#sed -n 32p $SUDO_USER/timebackup.sh
	
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

if [ "$lstdevname" ]; then 
	
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

if [ "$lstdevname" ]; then
	   
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

if [ "$lsbdevname" ]; then

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
		[ ! -h /dev/mapper/drive ] && printf "\n\n%s\n\n" "cryptsetup has failed to open /dev/mapper/drive from /dev/"$bdevname" . Make sure you are entering the correct password, or check your devices and mountpoints. Running lsblk and exiting..." && lsblk && exit 1 || printf "\n\n%s\n\n" "dev/mapper/drive found. Continuing..." 
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

[ ! -d /home/"$USER"/Screenshots ] && mkdir /home/"$USER"/Screenshots; cd /home/"$USER"/Screenshots || cd /home/"$USER"/Screenshots/

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
rssread

printf "\n%s\n" ""

# go everything selection
selection
}

# selecting any program on the system

systemprograms () {

printf "\n%s\n" "Loading programs..."
pacman -Qn > /tmp/allprograms.txt && pacman -Qm >> /tmp/allprograms.txt
pick="$(cat /tmp/allprograms.txt | cut -d " " -f1 | fzf --layout=reverse --margin 3%)" && "$pick" || printf "\n%s\n" "no selection.."
selection
}

# fzf function for selection
selectcheck () {

if [ "$fuzselect" = true ]; then

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
		"cmus music player"|cm)
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
		"audio auto setting"|au)
		printf "\n%s" ""; amixer -c 0 -- sset Master unmute; amixer -c 0 -- sset Master playback -10dB
		;;
		"increase volume"|inc)
		printf "\n%s" ""; amixer sset Master playback 5%+
		;;
		"lower volume"|low)
		printf "\n%s" ""; amixer sset Master playback 5%-
		;;
		"alsamixer"|al)
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
		"format bookmarks"|boo)
		bookmarkformat
		;;
		"select a bookmark for web browsing"|b)
		[[ ! -f /home/"$USER"/.bookmarks_ttysh.html ]] && cat /home/"$USER"/ttysh/resources/bookmarks/.bookmarks_ttysh.html > /home/"$USER"/.bookmarks_ttysh.html
		bookmarkpick="$(cat /home/"$USER"/.bookmarks_ttysh.html | fzf --prompt "Pick a bookmark: ")"
		if [[ $(tty | tr -d '[0-9]')  = "/dev/pts/" ]]; then
			devour librewolf "$bookmarkpick" 
		else
			lynx "$bookmarkpick"
		fi
		;;
		"web browser"|w)
		[ $ttytest = "/dev/tty" ] && lynx || devour librewolf
		;;
		"ping jameschampion.xyz"|i)
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
		cal; date; printf "\n%s\n"
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
		;;
		"email"|e)
		mutt
		;;
		"start i3 window manager"|s)
		startx
		;;
		"start sway window manager"|sw)
		sway
		;;
		"play your downloaded youtube videos"|vid)
		devourvid
		;;
		m)
		#chosendir=$(find /home/"$USER"/ -type d | fzf)
		#screen -c /home/"$USER"/TTYSH/resources/TTYSH/resources/.screenrc.cd
		printf "\n\n%b\n\n" 'alias the following in your bashrc for quick directory search and change: $(find /home/"$USER"/ -type d | fzf)'
		;;
		"file manager"|fi)
		vim /home/"$USER"/
		;;
		"seearch & play in gui"|se)
		fzfxorgvid
		;;
		"search & play video in tty"|t)
		fzfttyvid	
		;;
		"fzf search files to open in vim"|fz)
		fzfvim	
		;;
		"search files and delete"|del)
		fzfdelete
		;;
		"remove white spaces from file names"|wh)
		fzfwhitespace
		;;
		"weather"we)
		weather
		;;
		"search images and pdfs"|pdf)
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
		"close i3 and return to tty"|i3)
		pkill "Xorg"
		;;
		"close sway and return to tty"|y)
		pkill "sway"
		;;
		"AltGr as left mouse click on x11 on old thinkpads"|alt)
		xkbset m; xmodmap -e "keycode 108 = Pointer_Button1"
		;;
		"lock console"|lo)
		vlock -a
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
		if [ ! -d /home/"$USER"/Recordings ]; then

			mkdir /home/"$USER"/Recordings
			cd /home/"$USER"/Recordings 
		else

			cd /home/"$USER"/Recordings/
			sudo ffmpeg -f fbdev -framerate 30 -i /dev/fb0 ttyrecord.mp4
		fi
		;;
		"record your x server"|rec)
		if [ ! -d /home/"$USER"/Recordings ]; then

			mkdir /home/"$USER"/Recordings
			cd /home/"$USER"/Recordings 
		else

			cd /home/"$USER"/Recordings/
			ffmpeg -video_size 1280x800 -framerate 30 -f x11grab -i :0 x11record.mp4
		fi
		;;
		"writer"|wr)
		vim
		;;
		"calculator"|ca)
		#screen -c /home/"$USER"/.screenrc.calculator
		#printf "\n%s\n\n%s\n\n" "Shell Calculator" "Awaiting input:"
		#	
		#date >> /home/"$USER"/.calchist
		#	
		#while [ 1 ]; do
		#
		#	read -e i 
		#	
		#	printf "%s\n" ""$i"" >> /home/"$USER"/.calchist
		#	
		#	printf "%s\n" "$(($i))" | tee -a /home/"$USER"/.calchist
		#done
		#screen -c /home/"$USER"/ttysh/resources/.screenrc.shellcalc
		bc -l
		;;
		"spreadsheet"|sp)
		sc-im
		;;
		"htop"|ht)
		htop
		;;
		"computer temperatures"|te)
		watch sensors
		;;
		"free disk space"|fr)
		printf "\n%s\n" ""
		df -h
		;;
		"screen four panel split"|scr)
		screen -c /home/"$USER"/ttysh/resources/.screenrc.four_split
		;;
		"screen horizontal split"|scre)
		screen -c /home/"$USER"/ttysh/resources/.screenrc.hsplit
		;;
		"screen vertical split"|scree) 
		screen -c /home/"$USER"/ttysh/resources/.screenrc.vsplit
		;;
		"scrollback information for tty"|scro)
		printf "\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n" "How To Achieve Scrollback In A TTY" "Login to a TTY and run the following: " "bash | tee /tmp/scrollback" "Now login to a seperate TTY and run: " "less +F /tmp/scrollback" "Now switch back to your first TTY. When you want to scrollback then return to your second TTY and press CTRL+C to interrupt less from following your file. You can then scroll back through your output. When you have finished scrolling back through your history press SHIFT+F in less and it'll go back to following the /tmp/scrollback file"
		;;
		"change to tty 1"|v1)
		[ "$ttytest" = /dev/pts/ ] && sudo chvt 1 || chvt 1
		;;
		"change to tty 2"|v2)
		[ "$ttytest" = /dev/pts/ ] && sudo chvt 2 || chvt 2
		;;
		"change to tty 3"|v3)
		[ "$ttytest" = /dev/pts/ ] && sudo chvt 3 || chvt 3
		;;
		"change to tty 4"|v4)
		[ "$ttytest" = /dev/pts/ ] && sudo chvt 4 || chvt 4
		;;
		"change to tty 5"|v5)
		[ "$ttytest" = /dev/pts/ ] && sudo chvt 5 || chvt 5
		;;
		"change to tty 6"|v6)
		[ "$ttytest" = /dev/pts/ ] && sudo chvt 6 || chvt 6
		;;
		"choose tty"|vt)
		while [ 1 ]; do

			printf "\n\n%s\n\n%s" "Choose your TTY: " "You are currently in: "; tty

			printf "\n"

			read -e -p "Enter your selection [ 1 - 6 ]: " answer
			
			case "$answer" in
				"1" | "2" | "3" | "4" | "5" | "6" )	
				[ "$ttytest" = /dev/pts/ ] && sudo chvt "$answer" || chvt "$answer"
				break
				;;
				*)
				printf "\n\n%s\n\n" "Not a valid selection."
				;;
			esac
		done
		;;
		"rerun ttysh"|tty)
		clear
		refresh="$0"
		"$refresh"
		#ttysh
		#[ "$#" -lt 1 ] && "$0" || ttysh
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
				#killall nm-applet
				rfkill unblock wifi
				rfkill list
				#nm-applet
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
				
					[ ! "$(pacman -Qm | grep -i "$i")" ] && echo ""$i" not installed" && echo "now installing... "$i"" && yay -S --noconfirm "$i" || echo ""$i" already installed"
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
		"font and text change"|fon)
		sudo screen -c /home/"$USER"/ttysh/resources/.screenrc.font_conf
		[ "$(grep -i "ttyshfont=true" /home/"$USER"/.config/ttysh/config)" ] && sed -i 's/ttyshfont=true/ttyshfont=false/g' /home/"$USER"/.config/ttysh/config && sed -i 's/.*setfont ter-218b.*/#[ $(tty | tr -d '\''[0-9]'\'') = "\/dev\/tty" ] \&\& setfont ter-218b/' /home/"$USER"/.bashrc
		printf "\n%b\n" "You should reboot your system to see any changes that you have made."
		;;
		"set temporary font"|font)
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

if [ -f /home/"$USER"/.ttyshwizardrun ] || [ "$USER" = root ]; then
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

[ "$1" ] && options=$(printf "%s" "fzfcmus websearch fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner helpflags" | tr ' ' '\n' | grep "$1") && "$options" || #printf "\n\t%s\n" "TTYSH"

while [ 1 ]; do

[ ! $(screen -list | grep "cmusdaemon" | cut -d "." -f2 | cut -f1) ] && screen -dmS cmusdaemon cmus

intro="$(printf "%s\n%s\n%s\n%s\n%s\n%s\n%s" "select a ttysh program" "find a ttysh program" "run any program" "help" "toggle options" "config wizard" "quit" | fzf --prompt "TTYSH " --layout=reverse --margin 20%)"

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
