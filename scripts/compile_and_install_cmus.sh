# Move
mkdir ~/labs
cd ~/labs/

# Clone
git clone git@github.com:MatveiSologubov/cmus.git
cd cmus

# Dependencies
pacman -S --needed pkg-config ncurses libiconv faad2 alsa-lib libao libcddb libcdio-paranoia libdiscid ffmpeg flac jack libmad libmodplug libmp4v2 libmpcdec systemd opusfile libpulse libsamplerate libvorbis wavpack

./configure

make
sudo make install

