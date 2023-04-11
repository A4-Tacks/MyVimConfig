# -*- coding: utf-8; -*-

import vim
import os, sys

PROJECT_ROOT = vim.eval(r"s:project_root")
PYTHON_ROOT = os.path.join(PROJECT_ROOT, "python")
sys.path.insert(0, PYTHON_ROOT)

import re
import shlex
import subprocess
from sys import path

#sys.path.append(vim.eval("""system('echo -n "$HOME"')""") + "/command")
#import MyBaidufanyiApi as translate


# const vars
VIM_TYPES = {
    list, tuple, dict, str, int, float, bool, None
}

def parse_to_vim(obj: object) -> object:  # {{{1
    if type(obj) in VIM_TYPES:
        return obj
    else:
        return f"PyObject: {obj}"
# }}}1
