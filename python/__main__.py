# -*- coding: utf-8; -*-

import os
import sys

import re
import shlex
import subprocess

import vim


def swap_list(a: list, b: list) -> None:
    a[:], b[:] = b[:], a[:]


# const vars
VIM_TYPES = {
    list, tuple, dict, str, int, float, bool, None
}

def parse_to_vim(obj: object) -> object:
    if type(obj) in VIM_TYPES:
        return obj
    return f"PyObject: {obj}"
