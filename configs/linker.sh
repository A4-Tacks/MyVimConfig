#!/usr/bin/bash

cd "$(dirname "$0")"
PROOT="$(pwd -LP)"

ln -s "$PROOT/coc/coc-settings.json" "$HOME/.vim/coc-settings.json"
