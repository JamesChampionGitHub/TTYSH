#!/bin/bash

# TTYSH : A daily driver and "desktop/non-desktop" experience for the tty.
# 	  For all level of user. 


#
# VARIABLES
#

# red warning colour
warncolour='\033[31;1m'
warncolourend='\033[0m'


# variable for while loop
x=0

# splash screen variable for tty/pts
splash=$(tty | tr -d '[0-9]') 
#splash=$(tty)
#splash=$(echo ""${splash%y*}"y")

# ps aux kill xorg
#xorg=$(ps aux | grep -i xorg | awk '{print }' | sed -n '1p')


#
# FUNCTIONS
# 

# function for help using eof
eofhelp () {

less << EOF

HELP: j and k to go down and up. q to return to menu.

Key: () denote shortcut keys, e.g. (n) means pressing the n key in the selector will load the (n)otes selection.


		Internet/

			select a (bo)okmark for web browsing/

			format (boo)kmarks/

			(we)b search/

			(ly)nx with image viewer for saved/

			(bro)wsh web browser/

			(brow)sh configuration in xorg/

			(lib)rewolf in xorg/ 

			p(i)ng jameschampion.xyz/

		Email/

			(e)mail/

			(mu)tt email configuation/

		Search/

			(fi)le manager/

			search & play video in (t)ty/or (se)earch & play in gui/

			(fz)f search files to open in Vim/

			search files and (del)ete/
			
			NOTE: the above command will only work effectively on properly named files. Try the command below:

			remove (wh)ite spaces from file names/

			search images and (pdf)s/

			(a)rticles/

		Music/

			(cm)us without screen/

			(cmu)s with screen/

			reattach (cmus) screen session/

			cmus-control: (ne)xt/ (pr)evious/ (p)ause/ (f)orward/ (st)atus/ (pi)ck a song/

			alsa (au)to setting/

			(inc)rease volume/

			(low)er volume/

			(al)samixer/

			(mus)ic search on youtube/

		Video/

			play your (vid)eos/

			(l)ist videos/

			video search on (yo)utube/

		Record/

			(sc)reenshot(1,2,3,4,5,6) TTY/

			(re)cord your TTY/s/

			(rec)ord your X server/

		Wordprocessing/

			(wr)iter/

		Calc/Spreadsheet/

			(sp)readsheet/

			(ca)lculator/

		Accessories/

			calender (sch)edule/ 

			(n)otes/todos/split/ 

			(d)ate & calender/

		Backup/

			stop! first run as sudo su!: (di)sk formatting and setting up removable media/

			*NOTE: RUN THE ABOVE ON REMOVABLE MEDIA BEFORE MAKING YOUR BACKUPS.

	 		stop! first run as sudo su!: (ba)ckup /home/$SUDO_USER/ to removable drive/

			stop! first run sudo su!: (ti)meshift backup to removable drive/

			stop! first run sudo su!: (de)lete timeshift backups from removable drive/

		TTY/
				
			(scro)llback information for TTY/

			change (v)t (1,2,3,4,5,6) TTY/

			choose ch(vt) TTY/

			*NOTE: cannot use this selection in screen split. Use alt+number or alt+arrow key instead

		Screen splits/

			(scr)een four panel split/

			(scre)en horizontal split/

			(scree)n vertical split/

		Xorg/Wayland/

			(s)tartx/

			(sw)ay window manager/

			close (x)org and return to TTY/

			close swa(y) and return to TTY/

			(cap)s lock as left mouse clock on X11 on ThinkPads/

		System/Utilities/

			(fo)nt and text change/

			set temporary (fon)t/

			(net)work manager/

			network manager (dev)ices/

			(fan) control on ThinkPads/

			(u)pdate the system/

			(ht)op/

			(fr)ee disk space/

			(c)lock/

			(sto)pwatch/

			(lo)ck console/

			*NOTE: if you are in xorg/i3, press Ctrl + Alt + and an F key to return to the TTY
			       before you lock the console.

			(res)tart/

			(sh)utdown/

		Rerun/Help/Quit/

			rerun (tty)sh/

			(h)elp/

			(q)uit/

EOF
}

# $1 arguments selection list
helpflags () {

#options=$(printf "\n%s\n" "ttyshhelp fzfcmus websearch bookmarkcheck fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner" |\
#       	tr ' ' '\n' |\
#       	/home/"$USER"/.fzf/bin/fzf -i --prompt "Pick the option that you would like: ")

#clear

options=$(printf "\n%s\n" "eofhelp fzfcmus websearch bookmarkcheck fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner" |
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

#[ "$splash" = /dev/pts/ ] && devour mpv --really-quiet /home/"$USER"/.splash_ttysh.png && clear || mpv --really-quiet /home/"$USER"/.splash_ttysh.png && clear

[ "$splash" = /dev/pts/ ] && devour mpv --really-quiet /home/"$USER"/TTYSH/resources/.splash_ttysh.png || mpv --really-quiet /home/"$USER"/TTYSH/resources/.splash_ttysh.png

#if [ "$splash" = /dev/pts/ ]; then
#	devour mpv --really-quiet /home/"$USER"/.splash_ttysh.png; clear
#else	
#	mpv --really-quiet /home/"$USER"/.splash_ttysh.png; clear
#fi

}

# function for shortcuts selection 
ttyshhelp () {

less /home/"$USER"/TTYSH/resources/.ttysh.selection 
}

# function for TTYSH configuration
wizardttysh () {
# TO DO LIST
# insert newsboat rss for my instruction videos
# ttysh.selection

# a wizard to configure TTYSH

# first, update the system

sudo pacman -Syu --noconfirm

# install go as dependency for yay
# install yay package manager
# need to research

sudo pacman -S --needed --noconfirm go
sudo pacman -S --needed --noconfirm git base-devel
cd /home/"$USER"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

# install some misc. AUR packages

yay -S --noconfirm devour
yay -S --noconfirm xdo-git

# install curl

sudo pacman -S --needed --noconfirm curl

# install bc

sudo pacman -S --needed --noconfirm bc

# install Cmus music player

sudo pacman -S --needed --noconfirm cmus

# install alsa-utils for alsamixer

sudo pacman -S --needed --noconfirm alsa-utils

# install yt-dlp

sudo pacman -S --needed --noconfirm yt-dlp

# install lynx browser/pager

sudo pacman -S --needed --noconfirm lynx

# install mpv
# install fzf
# make the fzf file for use with lynx
# make the .screenrc.lynx conf file and install screen

sudo pacman -S --needed --noconfirm mpv
sudo pacman -S --needed --noconfirm fzf
sudo pacman -S --needed --noconfirm screen

[ ! -f /home/"$USER"/.config/mpv.conf ] && mkdir -p /home/"$USER"/.config/mpv; printf "%b" '--image-display-duration=1000' > /home/"$USER"/.config/mpv/mpv.conf

#try %b with \ to try and escape characters
#printf "%b\n\n%b\n\n%b\n\n%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n%b" '#!/bin/bash' 'x=0' 'while [ "$x" = 0 ]; do' 'printf "\\n%b\\n" "Press c to start your search. Press q to exit"' 'read -p "Enter your selection: " answer' 'case "$answer" in' 'c)' 'mpv "$(find /home/"$USER"/Downloads | /home/"$USER"/.fzf/bin/fzf -i)"' 'x=0' ';;' 'q)' 'x=1' ';;' 'esac' 'done' > /home/"$USER"/.mpv_fzf_screen.sh

#chmod +x /home/"$USER"/TTYSH/resources/.mpv_fzf_screen.sh

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'chdir /home/"$USER"/Downloads' 'screen -t bash /bin/bash' 'screen -t ./mpv_fzf_screen.sh /home/"$USER"/.mpv_fzf_screen.sh' 'focus down' 'screen -t lynx /usr/bin/lynx /home/"$USER"/Downloads' > /home/"$USER"/.screenrc.lynx

# install browsh web browser

yay -S --noconfirm browsh

# install librewolf

yay -S --noconfirm librewolf-bin

# install arkenfoxuser.js

yay -S --noconfirm arkenfox-user.js

# install vim, and make the .screenrc.birthdays_split file

sudo pacman -S --needed --noconfirm vim

# install less and man

sudo pacman -S --needed --noconfirm less

sudo pacman -S --needed --noconfirm man

#mkdir /home/"$USER"/info

#printf "\n%s\n" "BIRTHDAYS" > /home/"$USER"/info/birthdays.txt

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/info/birthdays.txt' 'focus down' 'chdir /home/"$USER"/' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.birthdays_split

# make notes file and the sceenrc_notes_split

printf "%s\n" "NOTES" > /home/"$USER"/.notes.txt

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/info/notes.txt' 'focus down' 'chdir /home/"$USER"/' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.notes_split

# install newsboat and make the .screenrc.rss and the yt.sh script

sudo pacman -S --needed --noconfirm newsboat

[ ! -f /home/"$USER"/.newsboat/urls ] && echo 'https://www.youtube.com/feeds/videos.xml?channel_id=UCeFnqXMczw4BDCoJHr5dBjg "~James Champion (Youtube)"' > /home/"$USER"/.newsboat/urls 

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n\t%b\n\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\t%b\n\n%b" '#!/bin/bash' '# A script for yt-dlp with search arguments.' 'x=0' 'url=$(xclip -o 2> /dev/null)' 'while [ "$x" = 0 ]; do' 'echo "y to enter video creator and video discription. x to download url from xclip. m to download music url from xclip. q to quit. yt to run again."' 'read -p "Enter your selection: " answer' 'case "$answer" in' 'y)' 'echo "Enter the creator and discription."' 'read video' "yt-dlp -f 'bv*[height=480]+ba' \"ytsearch1:\"\"\$video\"\"\"" 'x=0' ';;' 'x)' "yt-dlp -f 'bv*[height=480]+ba' \"\$url\"" 'x=0' ';;' 'm)' "yt-dlp -f 'ba' -x --audio-format mp3 \"\$url\"" 'x=0' ';;' 'yt)' '/home/"$USER"/./.yt.sh' 'x=1' ';;' 'q)' 'x=1' ';;' 'esac' 'done' > /home/"$USER"/.yt.sh

#chmod +x /home/"$USER"/.yt.sh

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n" 'split' 'focus up' 'screen -t newsboat /usr/bin/newsboat' 'focus down' 'chdir /home/"$USER"/Videos/' 'screen -t bash /bin/bash' 'screen -t ./yt.sh /home/"$USER"/.yt.sh' 'focus up' > /home/"$USER"/.screenrc.rss

# install mutt email and make muttrc for configuration

sudo pacman -S --needed --noconfirm mutt

mkdir -p /home/"$USER"/.config/mutt/ && touch /home/"$USER"/.config/mutt/muttrc

printf "%b\n%b\n\n%b\n%b\n%b\n\n%b\n%b\n%b\n%b\n\n%b" 'set folder = "imaps://"' 'set smtp_url = "smtp://"' 'set from = ""' 'set realname = ""' 'set editor = "vim"' 'set spoolfile = "+INBOX"' 'set record = "+Sent"' 'set trash = "+Trash"' 'set postponed = "+Drafts"' 'mailboxes =INBOX =Sent =Trash =Drafts =Junk' > /home/"$USER"/.config/mutt/muttrc

# make mutt config screen split

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/.config/mutt/muttrc' 'focus down' 'chdir /home/"$USER"/.config/mutt/' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.mutt_conf

# make screen config for listing saved articles

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/Downloads' 'focus down' 'chdir /home/"$USER"/Downloads' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.articles

# install xorg-server, i3, etc... and make the various configuration files

sudo pacman -S --needed --noconfirm xorg-server
sudo pacman -S --needed --noconfirm xorg-xinit
sudo pacman -S --needed --noconfirm i3-wm
sudo pacman -S --needed --noconfirm autotiling
sudo pacman -S --needed --noconfirm xterm
sudo pacman -S --needed --noconfirm xclip
sudo pacman -S --needed --noconfirm xorg-xmodmap
yay -S --noconfirm xkbset

cat /home/"$USER"/TTYSH/resources/.Xdefaults >> /home/"$USER"/.Xdefaults

printf "%s" "exec i3" > /home/"$USER"/.xinitrc

[ ! -d /home/"$USER"/.config/i3 ] && mkdir -p /home/"$USER"/.config/i3; cat /home/"$USER"/TTYSH/resources/i3config/config > /home/"$USER"/.config/i3/config

# install sway

sudo pacman -S --needed --noconfirm sway
sudo pacman -S --needed --noconfirm foot
sudo pacman -S --needed --noconfirm wf-recorder
sudo pacman -S --needed --noconfirm wl-clipboard
yay -S --noconfirm clipman
sudo pacman -S --needed --noconfirm xorg-xwayland

[ ! -d /home/"$USER"/.config/sway ] && mkdir -p /home/"$USER"/.config/sway; cat /home/"$USER"/TTYSH/resources/swayconfig/config > /home/"$USER"/.config/sway/config

[ ! -d /home/"$USER"/.config/foot ] && mkdir -p /home/"$USER"/.config/foot; cat /home/"$USER"/TTYSH/resources/footconfig/foot.ini > /home/"$USER"/.config/foot/foot.ini

cat /home/"$USER"/TTYSH/resources/bashrc/.bashrc > /home/"$USER"/.bashrc


#printf "%b\n%b\n%b\n%b\n\n\n%b\n%b\n\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b\n%b" '#URxvt*background: black' '#URxvt*foreground: white' '#URxvt*font: xft:monospace:size=12' '#URxvt*scrollBar: false' 'XTerm.vt100.foreground: white' 'XTerm.vt100.background: black' 'xterm*faceName: Monospace' 'xterm*faceSize: 12' 'XTerm*font: -*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1' '# unreadable' 'XTerm*font1: -*-terminus-medium-*-*-*-12-*-*-*-*-*-iso10646-1' '# tiny' 'XTerm*font2: -*-terminus-medium-*-*-*-14-*-*-*-*-*-iso10646-1' '# small' 'XTerm*font3: -*-terminus-medium-*-*-*-16-*-*-*-*-*-iso10646-1' '# medium' 'XTerm*font4: -*-terminus-medium-*-*-*-22-*-*-*-*-*-iso10646-1' '# large' 'XTerm*font5: -*-terminus-medium-*-*-*-24-*-*-*-*-*-iso10646-1' '# huge' 'XTerm*font6: -*-terminus-medium-*-*-*-32-*-*-*-*-*-iso10646-1' > /home/"$USER"/.Xdefaults

#printf "%b\n%b\n%b\n%b\n%b\n\n%b\n%b\n%b\n%b\n%b\n%b\n%b" 'XTerm.vt100.foreground: white' 'XTerm.vt100.background: black' 'XTerm.vt100.color0: rgb:28/28/28' '! ...' 'XTerm.vt100.color15: rgb:e4/e4/e4XTerm.vt100.reverseVideo: true# default' 'XTerm*font: -*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1' 'XTerm*font1: -*-terminus-medium-*-*-*-12-*-*-*-*-*-iso10646-1' 'XTerm*font2: -*-terminus-medium-*-*-*-14-*-*-*-*-*-iso10646-1' 'XTerm*font3: -*-terminus-medium-*-*-*-16-*-*-*-*-*-iso10646-1' 'XTerm*font4: -*-terminus-medium-*-*-*-22-*-*-*-*-*-iso10646-1' 'XTerm*font5: -*-terminus-medium-*-*-*-24-*-*-*-*-*-iso10646-1' 'XTerm*font6: -*-terminus-medium-*-*-*-32-*-*-*-*-*-iso10646-1' > /home/"$USER"/.Xresources

# make screen list videos config

#printf "%b\n\n%b" '#!/bin/bash' 'mpv "$(find /home/"$USER"/Videos | /home/"$USER"/.fzf/bin/fzf -i)"' > /home/"$USER"/.mpv_fzf_screen_videos.sh

#chmod +x /home/"$USER"/.mpv_fzf_screen_videos.sh

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /home/"$USER"/Videos' 'focus down' 'chdir /home/"$USER"/Videos' 'screen -t bash /bin/bash' 'screen -t ./mpv_fzf_screen_videos.sh /home/"$USER"/.mpv_fzf_screen_videos.sh' 'focus up' > /home/"$USER"/.screenrc.videos

# install jfbview and mupdf

sudo pacman -S --needed --noconfirm mupdf
yay -S --noconfirm fbpdf-git

# install cryptsetup for diskformat function

sudo pacman -S --needed --noconfirm cryptsetup

# install timeshift for system backups

sudo pacman -S --needed --noconfirm timeshift

# install fbcat for screenshots

yay -S --noconfirm fbcat
sudo pacman -S --needed --noconfirm imagemagick

# install sc-im for spreadsheets

yay -S --noconfirm sc-im

# install htop for system monitoring

sudo pacman -S --needed --noconfirm htop

# install noto-fonts

sudo pacman -S --needed --noconfirm noto-fonts

# make four way screen split

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'split -v' 'focus down' 'split -v' 'focus up' 'focus left' 'screen -t bash /bin/bash' 'focus right' 'screen -t bash /bin/bash' 'focus left' 'focus down' 'screen -t bash /bin/bash' 'focus right' 'screen -t bash /bin/bash' 'focus up' 'focus left' > /home/"$USER"/.screenrc.four_split

# make horizontal screen split

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t bash /bin/bash' 'focus down' 'screen -t bash /bin/bash' 'focus up' > /home/"$USER"/.screenrc.hsplit

# make virtical screen split

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split -v' 'focus left' 'screen -t bash /bin/bash' 'focus right' 'screen -t bash /bin/bash' 'focus left' > /home/"$USER"/.screenrc.vsplit

#printf "%b\n\n%b\n\n%b\n\n%b\n\n%b\n\n%b" 'split' 'focus up' 'screen -t vim /usr/bin/vim /usr/share/kbd/consolefonts' 'focus down' 'screen -t vim /usr/bin/vim /etc/vconsole.conf' 'focus up' > /home/"$USER"/.screenrc.vsplit

# make ttysh help/selection

#printf "\n%b\n\n%b\n\n\t\t%b\n\n%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n\t\t\t%b\n\n" 'HELP: j and k to go down and up. q to go to menu.' 'Key: () denote shortcut keys, e.g. (b) means pressing the b key to get to the selector will load the (b)irthdays selection.' 'Pinned/' 'Internet/' '(ly)nx with image viewer/' '(bro)wsh web browser/' '(brow)sh configuration xorg/' '(lib)rewolf xorg/' 'p(i)ng jameschampion.xyz/' 'Email/' '(e)mail/' '(mu)tt email configuation/' 'Search/' '(fi)le manager/' 'search & play video with (t)ty/or (se)earch & play with gui/' '(fz)f search files to open with Vim/' 'search images and (pdf)s/' '(a)rticles/' '(w)eather/' 'Music/' '(cm)us/' 'cmus-control: (ne)xt/ (pr)evious/ (p)ause/ (f)orward/ (st)atus/' '(al)samixer/' '(mus)ic search on yt-dlp/' 'Video/' 'play your (vid)eos/' '(l)ist videos/' 'search and (del)ete files' 'NOTE: the above command will only work effectively on properly named files. Try the command below:' 'remove (wh)ite spaces from file names/' 'video search on (yt)-dlp/' 'Record/' '(sc)reenshot(1,2,3,4,5,6) TTY/' '(re)cord your TTY/s/' 'Wordprocessing/' '(wr)iter/' 'Calc/Spreadsheet/' '(sp)readsheet/' '(ca)lculator/' 'Accessories/' '(b)irthdays/split/' '(n)otes/todos/split/' '(d)ate & calender/' 'Backup/' 'first run as sudo su!: (di)sk formatting and setting up removable media/' '*NOTE: RUN THE ABOVE ON REMOVABLE MEDIA BEFORE MAKING YOUR BACKUPS.' 'first run as sudo su!: (ba)ckup /home/"$SUDO_USER"/ to removable drive/' 'first run sudo su!: (ti)meshift backup to removable drive/' 'first run sudo su!: (de)lete timeshift backups from removable drive/' 'TTY/' '(scro)llback information for TTY/' 'change (v)t (1,2,3,4,5,6) TTY/' 'choose ch(vt) TTY/' '*NOTE: cannot use this selection with screen split. Use alt+number or alt+arrow key instead' 'Screen splits/' '(scr)een four panel split/' '(scre)en horizontal split/' '(scree)n vertical split/' 'Close Xorg/' 'close (x)org and go to TTY/' 'System/Utilities' '(fo)nt and text change' '(u)pdate the system/' '(ht)op/' '(fr)ee disk space' '(c)lock/' '(lo)ck console/' '*NOTE: when you are using xorg/i3, press Ctrl + Alt + and an F key to go to the TTY' 'before you lock the console.' '(res)tart/' '(sh)utdown/' 'Rerun/Help/Quit/' 'rerun (tty)sh/' '(h)elp/' 'edit (hel)p to add and remove your pinned selections' '(q)uit/' > /home/"$USER"/.ttysh.selection

#sudo mv splash_ttysh.png /home/"$USER"/.splash_ttysh.png
#sudo mv ttysh.sh /usr/local/bin/ttysh 
#chown root:root /usr/local/bin/ttysh

printf "\n%s\n" "Last run" >> /home/"$USER"/.ttyshwizardrun
 
date >> /home/"$USER"/.ttyshwizardrun

printf "\n%s\n" "TTYSH Wizard has finished. Please exit out of TTYSH and reboot to complete."
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

# if cmus is not running as pseudo daemon in screen, use below:

#pscmus=$(ps aux | grep -i "[c]mus" | cut -d " " -f22)

#[ ! "$pscmus" = cmus ] && screen -c /home/"$USER"/.screenrc.cmusplay && return || cmuspicker=$(find /home/"$USER"/Music/starred/ -type f | fzf -i --prompt "Pick the music track you want to play in cmus: ") && cmus-remote -f "$cmuspicker" && cmus-remote -Q && printf "\n" ""
}

# fzfbookmark case statement
casefzfbookmark () {

while [ 1 ]; do

	printf "\n%s\n\n" "Pick f for firefox, l for librewolf, or q to quit:"

	read -e -p "Enter your selection: " xbrowser

	case "$xbrowser" in 
		f) 
		devour firefox "$bookmark"
		break
		;;
		l)
		devour librewolf "$bookmark"
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

#[ "$splash" = /dev/pts/ ] && read -e -p "Pick f for firefox or l for librewolf: " xbrowser && case "$xbrowser" in 
#
#										        f) 
#											[ "$splash" = /dev/pts/ ] && devour firefox "$bookmark" || browsh --startup-url "$bookmark" 
#											;;
#											l)
#											[ "$splash" = /dev/pts/ ] && devour librewolf "$bookmark" || browsh --startup-url "$bookmark" 

}

# pick a bookmark to open in TTY or X11 using the appropriate web browser
fzfbookmark () {

printf "\n" ""

bookmark=$(cat /home/"$USER"/.bookmarks_ttysh.html | fzf -i --prompt "Pick a bookmark: ") 

#[ "$splash" = /dev/pts/ ] && casefzfbookmark && return || lynx "$bookmark"

[ "$splash" = /dev/pts/ ] && casefzfbookmark && return || browsh --startup-url "$bookmark"
	
#printf "\n" ""
#
#
#
#[ "$splash" = /dev/pts/ ] && read -e -p "Pick f for firefox or l for librewolf: " xbrowser && case "$xbrowser" in 
#
#										        f) 
#											[ "$splash" = /dev/pts/ ] && devour librewolf "$bookmark" || browsh --startup-url "$bookmark" 
#											;;
#											l)
#											[ "$splash" = /dev/pts/ ] && devour librewolf "$bookmark" || browsh --startup-url "$bookmark" 
#											;;
#									       esac
#

#[ "$splash" = /dev/pts/ ] && devour librewolf "$bookmark" || browsh --startup-url "$bookmark" 

}

# check for bookmark file
bookmarkcheck () {

[ -e /home/"$USER"/.bookmarks_ttysh.html ] && printf "\n%s\n" "Bookmarks file found." && fzfbookmark && return || printf "\n%s\n" "Bookmarks file not found." && touch /home/"$USER"/.bookmarks_ttysh.html && printf "\n%s\n" "Created." && sleep 1 && printf "\n%s\n" "Remember to add your bookmarks manually, or export them from librewolf. If exported or updated, run the 'boo' command. See help for more info. Starting in 10 seconds." && sleep 10 && return
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

while [ 1 ]; do

	printf "\n%s\n\n" "Pick f for firefox, l for librewolf, or q to quit:"

	read -e -p "Enter your selection: " xbrowser

	case "$xbrowser" in 
		f) 
		printf "\n" ""
		read -e -p "Search: " webpick
		devour firefox searx.be/search?q="$webpick"
		break
		;;
		l)
		printf "\n" ""
		read -e -p "Search: " webpick
		devour librewolf searx.be/search?q="$webpick"
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

# search the internet
websearch () {

printf "\n" ""

#[ "$splash" = /dev/pts/ ] && casewebsearch && return || read -e -p "Search: " webpick && lynx searx.be/search?q="$webpick"

[ "$splash" = /dev/pts/ ] && casewebsearch && return || read -e -p "Search: " webpick && browsh --startup-url searx.be/search?q="$webpick"
	
#[ $splash" = /dev/pts/ ] && devour librewolf searx.be/search?q="$webpick" || browsh --startup-url searx.be/search?q="$webpick"
}

# function for fan speed control
fanspeed () {

printf "\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n" "The following options:" "s for current fan speed" "Type auto for auto speed. Recommeneded" "1-7 for speeds" "e.g. Press 2 for low speed" "Press 4 for medium speed" "Press 7 for max speed" "q to quit"

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
		q)
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
		[ "$splash" = /dev/pts/ ] && mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the GUI: ")" || mpv -vo=drm "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the TTY: ")"
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
		[ "$splash" = /dev/pts/ ] && devour mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the terminal GUI: ")" || mpv -vo=drm "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch fullscreen in the TTY: ")"
		;;
		q)
		break
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done

#while [ "$x" = 0 ]; do
#
#	printf "\n%s\n" "Press s to start. Press q to quit."
#
#	read -e -p "Enter your selection: " answer
#
#	case "$answer" in
#		s)
#		mpv "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the video you want to watch in the TTY: ")"
#		x=0
#		;;
#		q)
#		x=1
#		;;
#		*)
#		printf "\n%s\n" "Not a valid selection."
#		x=0
#		;;
#	esac
#done

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
		[ "$splash" = /dev/pts/ ] && devour mupdf "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the pdf you want to view. ESC to exit: ")" || sudo fbpdf "$(find /home/"$USER"/ -type f | fzf -i --prompt "Pick the pdf you want to view. ESC to exit: ")"
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

while [ 1 ]; do

	printf "\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n" "y to enter video creator and video discription." "a for video that fails choosing y." "x to download url from xclip." "b for video that fails choosing x." "yt to run again." "q to quit"

	read -e -p "Enter your selection: " answer

	printf "\n%s\n" ""

	case "$answer" in
		y)
		printf "\n%s\n" "Enter the creator and discription: "
		read -e video
		printf "\n%s\n"	""
		yt-dlp -f 'bv*[height=480]+ba' "ytsearch1:""$video"""
		;;
		a)
		printf "\n%s\n" "Enter the creator and discription: "
		read -e video
		printf "\n%s\n"	""
		yt-dlp -f 'bv+ba' "ytsearch1:""$video"""
		;;
		x)
		url=$(xclip -o)
		yt-dlp -f 'bv*[height=480]+ba' "$url"
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
		screen -c /home/"$USER"/TTYSH/resources/.screenrc.rss
		break
		;;
		n)
		[ ! -f /home/"$USER"/.newsboat/urls ] && echo 'https://www.youtube.com/feeds/videos.xml?channel_id=UCeFnqXMczw4BDCoJHr5dBjg "~James Champion (Youtube)"' > /home/"$USER"/.newsboat/urls || cd /home/"$USER"/Videos/; newsboat; cd /home/"$USER"/; break
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
		curl wttr.in/"$wwanswer"?T --output /home/"$USER"/TTYSH/resources/.weatherdata
		cat /home/"$USER"/TTYSH/resources/.weatherdata
		#wget -qO- wttr.in/"$answer"
		break
		;;
		n)
		cat /home/"$USER"/TTYSH/resources/.weatherdata
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

[ "$splash" = /dev/pts/ ] && devour mpv /home/"$USER"/Videos/* || mpv -vo=drm /home/"$USER"/Videos/*

#if [ "$splash" = /dev/pts/ ]; then
#	devour mpv /home/"$USER"/Videos/*
#else	
#	mpv /home/"$USER"/Videos/*
#fi

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
#devname=$(lsblk | awk '{print $1}' | sed -n 8p | sed s/└─//g)
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
#echo -e "\nAwaiting $tuuid\n"
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
#devname=$(lsblk | awk '{print $1}' | sed -n 8p | sed s/└─//g)
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
#echo -e "\nAwaiting $tuuid\n"
lstdevname=$(ls /dev/disk/by-uuid -l | grep "$tuuid")

printf "\n%s\n" "Looking for "$tdrive"..."

[ "$lstdevname" ] && printf "\n%s\n" ""$tdrive" has been found. Starting..." && tdrivecheck && timeshift --list | less && timedelete || printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..." && lsblk && printf "\n%s" "" && exit 1

#if [ "$lstdevname" ]; then
#
#	printf "\n%s\n" ""$tdrive" has been found. Starting..."
#
#	tdrivecheck
#	timeshift --list
#	timedelete
#
#else
#
#	printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..."
#
#	lsblk
#
#	printf "\n%s" ""
#
#	exit
#
#fi

}

# function main for timeshift
maintimeshift () {

sudocheck

# timeshift
# find uuid
tdrive=$(cat /home/"$SUDO_USER"/.uuidtimeshift)
tuuid=$(echo "$tdrive")
#devname=$(lsblk | awk '{print $1}' | sed -n 8p | sed s/└─//g)
tdevname=$(ls /dev/disk/by-uuid/ -l | grep "$tuuid" | awk '{print $11}' | tr -d /.)
tencryptedname="timeshiftbackup"
tunmounting=$(lsblk | grep "$tencryptedname" | awk '{print $7}')
#echo -e "\nAwaiting $tuuid\n"
lstdevname=$(ls /dev/disk/by-uuid -l | grep "$tuuid")

printf "\n%s\n" "Looking for "$tdrive"..."

[ "$lstdevname" ] && printf "\n%s\n" ""$tdrive" has been found. Starting..." && starttimeshift && closetimeshift || printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..." && lsblk && printf "\n%s" "" && exit 1

#if [ "$lstdevname" ]; then
#
#	printf "\n%s\n" ""$tdrive" has been found. Starting..."
#
#	starttimeshift
#	closetimeshift
#
#else
#
#	printf "\n%s\n\n" "Cannot find "$tuuid". Check you are run as sudo su. Check that you have connected your drive. Exiting..."
#
#	lsblk
#
#	printf "\n%s" ""
#
#	exit
#
#fi

}

# function for filebackup
filebackup () {

sudocheck

# find uuid variables
bdrive=$(cat /home/"$SUDO_USER"/.uuidfiles)
buuid=$(echo "$bdrive")
bdevname=$(ls /dev/disk/by-uuid/ -l | grep "$buuid" | cut -d "/" -f3)
#bdevname=$(ls /dev/disk/by-uuid/ -l | grep "$buuid" | colrm 1 85)
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

#cmuscheck

#printf "\n%s\n\n" "Start Cmus Under Screen Session?"
#
#while [ 1 ]; do
#	
#	read -e -p "Choose y/n: " cmuspick
#
#	case "$cmuspick" in
#		y)
#		#screen -q -r cmus
#		#cmus
#		#fzfcmus
#		screen cmus
#		break
#		;;
#		n)
#		break
#		;;
#		*)
#		printf "\n%s\n\n" "Not a valid selection"
#		;;
#	esac
#done

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

#printf "\n%s\n" "Do you want to start i3 Window Manager with email and the web browser for additional email, additional notes, banking, news, etc...? y/n"
#
#while [ 1 ]; do
#
#	read -e -p "Enter your selection: " panswer
#	
#	case "$panswer" in
#		y)
#		# i3 configured to open bookmark selector for web browser and email in seperate windows
#		startx
#		break
#		;;
#		n)
#		break
#		;;
#		*)
#		printf "\n%s\n" "Not a valid selection."
#		;;
#	esac
#done

printf "\n%s\n" ""

# go everything selection
selection
}

# function for selecting everything
selection () {

while [ 1 ]; do

printf "\n%s" ""

	read -e -p "Enter your selection. h and enter if you need help: " answer

	case "$answer" in
		cm)
		cmus
		;;
		cmu)
		#cmuscheck
		#cmus
		#screen -q -r cmus
		screen -S cmusdaemon cmus
		#screen -D -R cmus
		;;
		cmus)
		screen -r cmusdaemon
		;;
		ne)
		#cmuscheck
		cmus-remote -n
		cmus-remote -Q
		printf "\n%s\n\n" "The next track is playing."
		;;
		pr)
		#cmuscheck
		cmus-remote -r
		cmus-remote -Q
		printf "\n%s\n\n" "The previous track is playing."
		;;
		p)
		#cmuscheck
		cmus-remote -u
		cmus-remote -Q
		printf "\n%s\n\n" "Paused/Playing."
		;;
		f)
		#cmuscheck
		cmus-remote -k +5
		printf "\n%s\n\n" "Forwarding..."
		;;
		st)
		#cmuscheck
		cmus-remote -Q | less
		;;
		au)
		printf "\n%s" ""; amixer -c 0 -- sset Master unmute; amixer -c 0 -- sset Master playback -10dB
		;;
		inc)
		printf "\n%s" ""; amixer sset Master playback 5%+
		;;
		low)
		printf "\n%s" ""; amixer sset Master playback 5%-
		;;
		al)
		alsamixer
		;;
		yo)
		[ ! -d /home/"$USER"/Video ] && mkdir /home/"$USER"/Videos; cd /home/"$USER"/Videos || cd /home/"$USER"/Videos/; yt 
		;;
		mus)
		[ ! -d /home/"$USER"/Music ] && mkdir /home/"$USER"/Music; cd /home/"$USER"/Music || cd /home/"$USER"/Music/; ytmusic 
		;;
		pi)
		fzfcmus
		;;
		we)
		websearch
		;;
		boo)
		bookmarkformat
		;;
		bo)
		bookmarkcheck
		;;
		ly)
		while [ 1 ]; do

			printf "\n%s\n%s\n%s\n" "Stop! It is recommended to run lynx browser offline for your saved webpages." "Use Browsh/Librewolf for web online browsing and saving webpages for later." "Are you offline? Do you want to continue? y/n"

			read -e -p "Enter your selection: " answer

			case "$answer" in
				y)
				screen -c /home/"$USER"/TTYSH/resources/.screenrc.lynx
				break
				;;
				n)
				break	
				;;	
				*)
				printf "\n\n%s\n\n" "Not a valid selection."
				;;
			esac

		done
		;;
		bro)
		printf "\n%s\n" "Tips: prefix 'searx.be/search?q=' or 'wiby.me/?q=' in the URL to search."
		#sudo gpm -m /dev/psaux -t ps2
		# searching: searx.be/search?q=
		# searching: wiby.me/?q=
		# browsh --firefox.path /usr/bin/librewolf
		browsh
		;;
		brow)
		browsh --firefox.with-gui
		;;
		lib)
		devour librewolf
		;;
		i)
		#screen -c /home/"$USER"/TTYSH/resources/.screenrc.ping
		ping -c 3 jameschampion.xyz
		;;
		sch)
		calenderschedule
		#vim /home/"$USER"/.*calenderdatafile
		#
		#while [ 1 ]; do

		#	printf "\n%s\n\n" "Would you like your birthday file in a split-screen with a shell? y/n"

		#	read -e -p "Enter your selection: " answer

		#	case "$answer" in
		#		y)
		#		screen -c /home/"$USER"/TTYSH/resources/.screenrc.birthdays_split	
		#		break
		#		;;
		#		n)
		#		vim /home/"$USER"/info/Events_2023_08_27_15_08_10.ics
		#		break
		#		;;
		#		*)
		#		printf "\n\n%s\n\n" "Not a valid selection."
		#		;;
		#	esac

		#done
		;;
		n)
		while [ 1 ]; do

			printf "\n%s\n\n" "Would you like your notes in a split-screen with a shell? y/n"

			read -e -p "Enter your selection: " answer

			case "$answer" in
				y)
				screen -c /home/"$USER"/TTYSH/resources/.screenrc.notes_split
				break
				;;
				n)
				vim /home/"$USER"/.notes.txt
				break
				;;
				*)
				printf "\n\n%s\n\n" "Not a valid selection."
				;;
			esac

		done
		;;
		mu)
		screen -c /home/"$USER"/TTYSH/resources/.screenrc.mutt_conf
		;;
		d)
		cal; date; printf "\n%s\n" "q to return" | less
		;;
		c)
		screen -c /home/"$USER"/TTYSH/resources/.screenrc.clockworking
		#printf "\n%s\n\n" "Ctr and C to quit"

		#while [ 1 ]; do

		#	date
		#	printf "\033[A"
		#	sleep 1

		#done
		#watch -td -n 1 date
		#screen -c /home/"$USER"/TTYSH/resources/TTYSH/resources/.screenrc.clock
		;;
		sto)
		before=$(date +%s)

		printf "\n\n"

		while [ 1 ]; do

        		minutes=$(($(date +%s)-$before))
        		printf "\033[A"
        		echo "Seconds: $(($(date +%s)-$before)) - Minutes: $(($minutes/60)) - Hours: $(($minutes/3600))"
        		#echo "$seconds"
        		#date -u -d "1970-01-01 $end 10 - $start 0" +"%T"
        		sleep 1
		done
		;;
		r)
		rsssplit
		;;
		e)
		mutt
		;;
		a)
		while [ 1 ]; do

			printf "\n%s\n\n" "Would you like your article list in a split-screen with a shell? y/n"

			read -e -p "Enter your selection: " answer

			case "$answer" in
				y)
				screen -c /home/"$USER"/TTYSH/resources/.screenrc.articles 
				break
				;;
				n)
				vim /home/"$USER"/Downloads
				break
				;;
				*)
				printf "\n\n%s\n\n" "Not a valid selection."
				;;
			esac

		done
		;;
		s)
		startx
		;;
		sw)
		sway
		;;
		l)
		screen -c /home/"$USER"/TTYSH/resources/.screenrc.videos 
		;;
		vid)
		devourvid
		;;
		m)
		#chosendir=$(find /home/"$USER"/ -type d | fzf)
		#screen -c /home/"$USER"/TTYSH/resources/TTYSH/resources/.screenrc.cd
		printf "\n\n%b\n\n" 'alias the following in your bashrc for quick directory search and change: $(find /home/"$USER"/ -type d | fzf)'
		;;
		fi)
		vim /home/"$USER"/
		;;
		se)
		fzfxorgvid
		;;
		t)
		fzfttyvid	
		;;
		fz)
		fzfvim	
		;;
		del)
		fzfdelete
		;;
		wh)
		fzfwhitespace
		;;
		w)
		#until curl wttr.in 1>/dev/null; do
			#sleep 1
			#echo "Awaiting wttr.in to respond. The server might be down. You could try again later."
			#break
		#done
		weather
		;;
		pdf)
		fzfpdf
		;;
		#v)
		#vim 0 -c "set laststatus=0" -o /home/"$USER"/proj/working_on/*YEN/drafts/*1  
		#;;
		#vn)
		#vim /home/"$USER"/proj/working_on/*YEN/characters/* -o /home/"$USER"/proj/working_on/*YEN/notes/*screenplay_notes -o /home/"$USER"/proj/working_on/*YEN/notes/*prompt_notes -o /home/"$USER"/proj/working_on/*YEN/notes/*archive_notes
		#;;
		di)
		diskformat
		;;
		ba)
		filebackup
		;;
		ti)
		maintimeshift
		;;
		de)
		maintdelete	
		;;
		x)
		pkill "Xorg"
		;;
		y)
		pkill "sway"
		;;
		cap)
		xkbset m; xmodmap -e "keycode 108 = Pointer_Button1"
		;;
		lo)
		vlock -a
		;;
		sc1)
		screenshotcheck 
		sudo fbgrab -c 1 screenshot1.png
		;;
		sc2)
		screenshotcheck 
		sudo fbgrab -c 2 screenshot2.png
		;;
		sc3)
		screenshotcheck 
		sudo fbgrab -c 3 screenshot3.png
		;;
		sc4)
		screenshotcheck 
		sudo fbgrab -c 4 screenshot4.png
		;;
		sc5)
		screenshotcheck 
		sudo fbgrab -c 5 screenshot5.png
		;;
		sc6)
		screenshotcheck
		sudo fbgrab -c 6 screenshot6.png
		;;
		re)
		[ ! -d /home/"$USER"/Recordings ] && mkdir /home/"$USER"/Recordings; cd /home/"$USER"/Recordings || cd /home/"$USER"/Recordings/; sudo ffmpeg -f fbdev -framerate 30 -i /dev/fb0 ttyrecord.mp4
		;;
		rec)
		[ ! -d /home/"$USER"/Recordings ] && mkdir /home/"$USER"/Recordings; cd /home/"$USER"/Recordings || cd /home/"$USER"/Recordings/; ffmpeg -video_size 1280x800 -framerate 30 -f x11grab -i :0 x11record.mp4
		;;
		wr)
		vim
		;;
		ca)
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
		screen -c /home/"$USER"/TTYSH/resources/.screenrc.shellcalc
		;;
		sp)
		sc-im
		;;
		ht)
		htop
		;;
		fr)
		printf "\n%s\n" ""
		df -h
		;;
		scr)
		screen -c /home/"$USER"/TTYSH/resources/.screenrc.four_split
		;;
		scre)
		screen -c /home/"$USER"/TTYSH/resources/.screenrc.hsplit
		;;
		scree) 
		screen -c /home/"$USER"/TTYSH/resources/.screenrc.vsplit
		;;
		scro)
		printf "\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n" "How To Achieve Scrollback In A TTY" "Login to a TTY and run the following: " "bash | tee /tmp/scrollback" "Now login to a seperate TTY and run: " "less +F /tmp/scrollback" "Now switch back to your first TTY. When you want to scrollback then return to your second TTY and press CTRL+C to interrupt less from following your file. You can then scroll back through your output. When you have finished scrolling back through your history press SHIFT+F in less and it'll go back to following the /tmp/scrollback file"
		;;
		v1)
		[ "$splash" = /dev/pts/ ] && sudo chvt 1 || chvt 1
		;;
		v2)
		[ "$splash" = /dev/pts/ ] && sudo chvt 2 || chvt 2
		;;
		v3)
		[ "$splash" = /dev/pts/ ] && sudo chvt 3 || chvt 3
		;;
		v4)
		[ "$splash" = /dev/pts/ ] && sudo chvt 4 || chvt 4
		;;
		v5)
		[ "$splash" = /dev/pts/ ] && sudo chvt 5 || chvt 5
		;;
		v6)
		[ "$splash" = /dev/pts/ ] && sudo chvt 6 || chvt 6
		;;
		vt)
		while [ 1 ]; do

			printf "\n\n%s\n\n%s" "Choose your TTY: " "You are currently in: "; tty

			printf "\n"

			read -e -p "Enter your selection [ 1 - 6 ]: " answer
			
			case "$answer" in
				"1" | "2" | "3" | "4" | "5" | "6" )	
				[ "$splash" = /dev/pts/ ] && sudo chvt "$answer" || chvt "$answer"
				break
				;;
				*)
				printf "\n\n%s\n\n" "Not a valid selection."
				;;
			esac
		done
		;;
		tty)
		clear
		refresh="$0"
		"$refresh"
		#ttysh
		#[ "$#" -lt 1 ] && "$0" || ttysh
		exit 0
		;;
		net)
		nmtui
		;;
		dev)
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
		fan)
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
		u)
		printf "\n"$warncolour"%s"$warncolourend"\n" "Is your device running on A/C, incase of powerloss during updates? y/n or q to quit"

		while [ 1 ]; do
		
			read -e -p "Enter your selection: " upick

			case "$upick" in
				y)
				printf "\n%s\n" "Updating Arch Linux..."
				sudo pacman -Syu
				printf "\n\n%s\n" "Updating the Arch Linux AUR..."
				yay -Sua
				printf "\n\n%s\n" "Updating TTYSH..."
				cd /home/"$USER"/TTYSH/
				git pull
				printf "\n\n%s\n" "Setting i3, sway, foot, and bashrc configs..."
				cat /home/"$USER"/TTYSH/resources/i3config/config > /home/"$USER"/.config/i3/config
				cat /home/"$USER"/TTYSH/resources/swayconfig/config > /home/"$USER"/.config/sway/config
				cat /home/"$USER"/TTYSH/resources/footconfig/foot.ini > /home/"$USER"/.config/foot/foot.ini
				cat /home/"$USER"/TTYSH/resources/bashrc/.bashrc > /home/"$USER"/.bashrc
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
		fo)
		sudo screen -c /home/"$USER"/TTYSH/resources/.screenrc.font_conf
		printf "\n%b\n" "You should reboot your system to see any changes that you have made."
		;;
		fon)
		setfont "$(ls /usr/share/kbd/consolefonts | fzf -i --prompt "Pick a font, or select nothing to return to original terminal font: ")"
		;;
		res)
		sudo reboot
		exit 0
		;;
		sh)
		sudo poweroff
		exit 0
		;;
		h)
		eofhelp
		#ttyshhelp
		;;
		q)
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

#clear

#clear replaces /dev/null and variations as they crash mpv
#[[ ]] needs work, and is forcing an enter key press to continue after mpv and clear
#[[ -f /usr/local/bin/ttyhs ]] && [[ -f /home/"$USER"/.splash_ttysh.png ]]; mpv /home/"$USER"/.splash_ttysh.png; clear; || echo "If you are using this for the first time, configuration is required. Do you want to continue? y/n"
#	read -e answer
#	case "$answer" in
#		y)
#		echo "true"; exit
#		;;
#		n)
#		echo "false"; exit
#		;;
#	esac

# --no-terminal breaks in the TTY, --really-quiet is used as best alternative
if [ -f /home/"$USER"/.ttyshwizardrun ] || [ "$USER" = root ]; then
	printf "%s" ""
	#splashscreen
	#mpv --really-quiet /home/"$USER"/.splash_ttysh.png; clear
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

#[ "$1" ] && "$1" || printf "\n\t%s\n" "TTYSH"

#options="${1:-$(printf "Use the following options after typing ttysh, e.g. ttsyh planner Note: ttysh flags create a menu picker ttyshhelp fzfcmus websearch bookmarkcheck fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner"}"

[ "$1" ] && options=$(printf "%s" "fzfcmus websearch bookmarkcheck fzfxorgvid fzfttyvid fzfvim fzfpdf yt ytmusic weather planner helpflags" | tr ' ' '\n' | grep "$1") && "$options" || printf "\n\t%s\n" "TTYSH"

while [ 1 ]; do

		printf "\n\t%s\n\n" "(sc)hedule, (s)election, (h)elp, (config) wizard, or (q)uit?"
		
	read -e -p "Enter your selection: " intro

	case "$intro" in
		sc)
		clear
		planner
		selection
		;;	
		s)
		selection
		break
		;;
		h)
		eofhelp
		#ttyshhelp
		;;
		config)
		wizardttysh
		;;
		#hel)
		#vim /home/"$USER"/TTYSH/resources/.ttysh.selection
		#;;
		q)
		printf "\n%s" ""
		exit 0
		;;
		*)
		printf "\n%s\n" "Not a valid selection."
		;;
	esac
done
