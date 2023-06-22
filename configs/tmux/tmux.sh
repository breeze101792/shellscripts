#!/bin/bash

session="debug"

tmux new-session -d -s $session

window=2
tmux rename-window -t $session:$window 'kernel'
tmux send-keys -t $session:$window 'erun sudo dmesg -w' C-m
tmux split-window -t $session:$window -h
tmux send-keys -t $session:$window 'echo test' C-m

# window=3
# tmux new-window -t $session:$window -n 'serve'
# tmux send-keys -t $session:$window 'npm run serve'

tmux attach-session -t $session

