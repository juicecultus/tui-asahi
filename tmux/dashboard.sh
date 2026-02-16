#!/bin/bash
# Dashboard layout — MacBook Air M2 15" (2880x1800 Liquid Retina)
# 4-pane layout: btop (top-left), cava (bottom-left), fastfetch (top-right), cmatrix (bottom-right)

SESSION="dashboard"
tmux kill-session -t "$SESSION" 2>/dev/null

tmux new-session -d -s "$SESSION" -x "$(tput cols)" -y "$(tput lines)"

# Pane 1 (top-left): btop
tmux send-keys -t "$SESSION" 'btop' Enter

# Pane 2 (top-right): fastfetch + system info
tmux split-window -h -t "$SESSION" -p 40
tmux send-keys -t "$SESSION" 'fastfetch && echo "" && echo "Press q to close dashboard"' Enter

# Pane 3 (bottom-right): cmatrix
tmux split-window -v -t "$SESSION:1.2" -p 50
tmux send-keys -t "$SESSION" 'cmatrix -ab -u 6 -C green' Enter

# Pane 4 (bottom-left): cava
tmux split-window -v -t "$SESSION:1.1" -p 35
tmux send-keys -t "$SESSION" '/usr/local/bin/cava' Enter

# Focus btop pane
tmux select-pane -t "$SESSION:1.1"

tmux switch-client -t "$SESSION" 2>/dev/null || tmux attach-session -t "$SESSION"
