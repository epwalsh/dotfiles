#!/usr/bin/env python

"""
This script creates symlinks for all the important configuration files.
"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import sys


EXCLUDE_LIST = ['.DS_Store']


def bootstrap_module(src_path, dst_path):
    """
    Creates symlinks for all files or dirs in src_path to dst_path.
    """
    if not os.path.isdir(dst_path):
        os.makedirs(dst_path)

    files_to_link = [f for f in os.listdir(src_path) if f not in EXCLUDE_LIST]
    for f in files_to_link:
        src = os.path.join(src_path, f)
        dst = os.path.join(dst_path, f)
        os.symlink(src, dst)


if __name__ == '__main__':
    base_dir = os.path.dirname(os.path.abspath(__file__))
    user_dir = os.path.expanduser('~/')

    # Bootstrap neovim.
    src_path = os.path.join(base_dir, 'neovim')
    dst_path = os.path.join(user_dir, '.config/nvim')
    bootstrap_module(src_path, dst_path)

    # Bootstrap bin.
    src_path = os.path.join(base_dir, 'bin')
    dst_path = os.path.join(user_dir, 'bin')
    bootstrap_module(src_path, dst_path)

    # Bootstrap tmux.
    src_path = os.path.join(base_dir, 'tmux')
    dst_path = os.path.join(user_dir, '')
    bootstrap_module(src_path, dst_path)

    # Bootstrap bash.
    src_path = os.path.join(base_dir, 'bash')
    dst_path = os.path.join(user_dir, '')
    bootstrap_module(src_path, dst_path)
