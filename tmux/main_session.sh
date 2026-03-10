#!/usr/bin/env bash

session_name=main
if ! tmux has-session -t $session_name 2>/dev/null; then
    # First window in ~/dotfiles/.
    tmux new-session -d -s $session_name -n dotfiles -c ~/dotfiles
    # Target format: session:window.pane
    tmux split-window -h -t "$session_name:1" -c ~/dotfiles
    tmux send-keys -t "$session_name:1.2" 'claude' Enter
    tmux select-pane -t "$session_name:1.1"

    # Second window in ~/github.com/
    tmux new-window -t $session_name:2 -c ~/github.com

    # Attach session
    tmux attach-session -t $session_name
else
    exit 1
fi
