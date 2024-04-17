#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacc='sudo pacman -Syu && yay && sudo pacman -Rns $(sudo pacman -Qtdq); paccache -r'
alias comp='cd /home/disco/dwm && sudo make clean install && cd ../st && sudo make clean install'
PS1='[\u@\h \W]\$ '
