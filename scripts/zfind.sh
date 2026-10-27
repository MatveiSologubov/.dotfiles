#!/bin/sh

file=$(find "$HOME" -type f \( -iname '*.pdf' -o -iname '*.epub' \) 2>/dev/null |
    rofi -dmenu -i -p "Open PDF/EPUB" \
        -theme-str 'window { width: 60%; }') || exit 0

[ -n "$file" ] || exit 0
setsid -f zathura -- "$file" >/dev/null 2>&1
