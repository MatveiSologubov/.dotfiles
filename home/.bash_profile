#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Added by Toolbox App
export PATH="$PATH:/home/disco/.local/share/JetBrains/Toolbox/scripts"

if [ -z "$TMUX" ] && { [ -n "$SSH_TTY" ] || [ "${TERM%%-*}" = "linux" ]; } then
    if ! tmux has-session 2>/dev/null; then
        # Create detached session with default window
        tmux new-session -d
        # Create second window and run btop
        tmux new-window -d 'btop'

        # Select btop window
        tmux select-window -t 0:2
    fi
fi

startx


