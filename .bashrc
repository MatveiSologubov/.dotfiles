#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR="nvim"
export BROWSER="brave"

alias ls='ls --color=auto'
alias df='df -h'
alias du='du -h'

alias grep='grep --color=auto'
alias pacc='sudo pacman -Syu && yay && sudo pacman -Rns $(sudo pacman -Qtdq); paccache -r'
alias comp='cd ~/dwm && sudo make clean install && cd ../st && sudo make clean install'
alias yt-best='yt-dlp --merge-output-format mp4 -f "bestvideo+bestaudio[ext=m4a]/best"'
alias yt-mid='yt-dlp -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'
alias ss='ssh -p 640 disco@192.168.1.112'

PS1='[\u@\h \W]\$ '
