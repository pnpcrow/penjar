#!/usr/bin/env bash

set -e

EMSDK_QUIET=1 . /opt/emsdk/emsdk_env.sh;

usermod -u ${EXTERNAL_UID:-1000} penjar;

cp /root/.bashrc /home/penjar/.bashrc
cp /root/.vimrc /home/penjar/.vimrc
cp /root/.tmux.conf /home/penjar/.tmux.conf

chown penjar:users /home/penjar
rsync -ar --chown=penjar:users /opt/cargo/ /home/penjar/.cargo/

export PATH="/home/penjar/.cargo/bin:$PATH"
export CARGO_HOME="/home/penjar/.cargo"

exec "$@"
