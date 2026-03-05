#!/usr/bin/env bash

sudo chown penjar:users /home/penjar

cd ~;

source ~/.bashrc

echo "[start-tmux.sh] Installing node dependencies"
pushd ~/penjar/frontend/
./scripts/setup;
popd
pushd ~/penjar/exporter/
./scripts/setup;
popd

tmux -2 new-session -d -s penjar

tmux rename-window -t penjar:0 'frontend watch'
tmux select-window -t penjar:0
tmux send-keys -t penjar 'cd penjar/frontend' enter C-l
tmux send-keys -t penjar './scripts/watch app' enter

tmux new-window -t penjar:1 -n 'frontend storybook'
tmux select-window -t penjar:1
tmux send-keys -t penjar 'cd penjar/frontend' enter C-l
tmux send-keys -t penjar './scripts/watch storybook' enter

tmux new-window -t penjar:2 -n 'exporter'
tmux select-window -t penjar:2
tmux send-keys -t penjar 'cd penjar/exporter' enter C-l
tmux send-keys -t penjar 'rm -f target/app.js*' enter C-l
tmux send-keys -t penjar './scripts/watch' enter

tmux split-window -v
tmux send-keys -t penjar 'cd penjar/exporter' enter C-l
tmux send-keys -t penjar './scripts/wait-and-start.sh' enter

tmux new-window -t penjar:3 -n 'backend'
tmux select-window -t penjar:3
tmux send-keys -t penjar 'cd penjar/backend' enter C-l
tmux send-keys -t penjar './scripts/start-dev' enter

tmux -2 attach-session -t penjar
