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


def swap_list(a: list, b: list) -> None:
    a[:], b[:] = b[:], a[:]


def try_import(name: str, *, target_path=None) -> bool:
    """try_import
    """
    if target_path is not None:
        sys.path.insert(0, target_path)
    try:
        __import__(name)
    except ModuleNotFoundError:
        return False
    finally:
        if target_path is not None:
            assert target_path == sys.path.pop(0)
    return True


try_import("cdecl_to_rust", target_path="/home/lrne/command")
import cdecl_to_rust
def cdecl_to_rs(expr: str):
    return cdecl_to_rust.english_to_rs(cdecl_to_rust.split_tokens(expr))

def rs_to_cdecl(expr: str):
    return cdecl_to_rust.rs_to_english(cdecl_to_rust.split_tokens(expr))


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
