xrandr --output HDMI-1 --primary --mode 1920x1080 --output DVI-D-1 --mode 1680x1050 --right-of HDMI-1
xinput --set-prop 13 290 0 1 0
xinput --set-prop 11 290 0 1 0
xinput --set-prop 13 287 -0.2
xinput --set-prop 11 287 -0.2

setxkbmap -model pc86 -layout us,ru -option grp:alt_shift_toggle

exec dwm

