#!/usr/bin/bash

cd "$(dirname "$0")" || exit

RC=$HOME/.vim/vimrc
start_script='execute "source " . fnameescape(expand("<sfile>:p:h") . "/MyVimConfig/main.vim")'

function out {
    local
    echo "$start_script" > "$RC"
    echo "out to ${RC@Q}"
}

if [ ! -r "$RC" ]; then
    if [ -s "$RC" ]; then
        echo "vimrc is not empty" >&2
    else
        # add start to vimrc
        out
    fi
else
    out
fi

# link file
bash ./configs/linker.sh

set -x
git clone https://github.com/neoclide/coc.nvim --depth=1 ~/.vim/plugged/coc.nvim -b release
