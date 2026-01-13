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
alias t='/home/"$USER"/TTYSH/./ttysh'

# Quit pane
alias q='exit'

# Videos Directory
alias v='cd /home/"$USER"/Videos/'

# Directory cd with fzf
alias d='cd $(find /home/"$USER"/ -type d | /home/"$USER"/.fzf/bin/fzf -i --prompt "Pick a directory that you want to move to: ")'

# unmute and set volume in alsa
alias au='amixer -c 0 -- sset Master unmute; amixer -c 0 -- sset Master playback -10dB'

# kill x11
alias killx='/home/"$USER"/scr_sh/./xorgk.sh'

# record x11 desktop
alias recx='ffmpeg -video_size 1280x800 -framerate 60 -f x11grab -i :0 output.mp4'

# goto ffmpeg template directory
alias dirf='cd /home/"$USER"/instr_vids_manuals/james_champion/working_on/ffmpeg_template/'

# goto video production directory
alias dirv='cd /home/"$USER"/test/video_production/'

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
