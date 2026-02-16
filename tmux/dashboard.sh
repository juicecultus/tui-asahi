#!/bin/bash
# Dashboard layout — MacBook Air M2 (2880x1800 Liquid Retina)
# 2-pane vertical split for high-DPI displays

SESSION="dashboard"
tmux kill-session -t "$SESSION" 2>/dev/null

tmux new-session -d -s "$SESSION"

# Left pane: fastfetch + cmatrix below
tmux send-keys -t "$SESSION" 'fastfetch; echo ""; cmatrix -ab -u 6 -C green' Enter

# Right pane: btop (full height)
tmux split-window -h -t "$SESSION" -p 55
tmux send-keys -t "$SESSION" 'btop' Enter

# Focus left pane
tmux select-pane -t "$SESSION:1.1"

tmux switch-client -t "$SESSION" 2>/dev/null || tmux attach-session -t "$SESSION"
