#!/usr/bin/env bash

file=$(
  find "$HOME" -type f -name '*.typ' -print 2>/dev/null |
    fzf --prompt='Typst file> '
) || exit 0

[ -n "$file" ] || exit 0

dir=$(dirname -- "$file")
selected_file=$(printf '%q' "$file")
tmux new-window -c "$dir" "typst watch $selected_file"
