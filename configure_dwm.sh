sudo pacman -Syu xorg-server xorg-xinit libx11 libxinerama libxft webkit2gtk

echo "startx" >> ~/.bash_profile

cp ~/.dotfiles/.xinitrc ~/.
