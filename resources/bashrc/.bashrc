#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# alias grep='grep --color=auto'
#PS1='[\u@\h \W]\$ '
#PS1="\033[37;1m$PS1"
#

set -o vi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Active Aliases

# TTYSH
alias t='/home/"$USER"/ttysh/./ttysh.sh'

# Quit pane
alias q='exit'

# Videos Directory
alias v='cd /home/"$USER"/Videos/'

# Directory cd with fzf
alias d='cd $(find /home/"$USER"/ -type d | /home/"$USER"/.fzf/bin/fzf -i --prompt "Pick a directory that you want to move to: ")'

# unmute and set volume in alsa
alias au='amixer -c 0 -- sset Master unmute; amixer -c 0 -- sset Master playback -10dB'

# record x11 desktop
alias recx='ffmpeg -video_size 1280x800 -framerate 30 -f x11grab -i :0 output.mp4'

alias xc='xclip -selection clipboard' # tty: if in vim > visual > : > :w!xclip > this will make a text file in home directory
alias xp='xclip -selection clipboard -o'
#alias xpp='xclip -selection primary -o'

# a clock in GNUScreen
#alias clock='screen -c /home/"$USER"/.screenrc.clockworking'

# Default Programs
export SUDO_EDITOR="vim"

export EDITOR="vim"

#xset b off

#/usr/local/bin/ttysh

[ $(tty | tr -d '[0-9]') = "/dev/tty" ] && setfont ter-218b
