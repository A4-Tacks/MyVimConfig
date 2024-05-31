#!/usr/bin/bash

cd "$(dirname "$0")" || exit
PROOT="$(pwd -LP)"

ln -s "$PROOT/coc/coc-settings.json" "$HOME/.vim/coc-settings.json"
