#!/usr/bin/env python3

import os
import shutil
import argparse

def copy_files(in_dir, out_dir):
    items = os.listdir(in_dir)
    for item in items:
        in_path = os.path.join(in_dir, item)
        if os.path.isfile(in_path):
            in_name, ext = os.path.splitext(in_path)
            out_file = item
            count = 1

            while os.path.exists(os.path.join(out_dir, out_file)):
                out_file = in_name + "_" + str(count) + ext
                count += 1

            shutil.copy2(in_path, os.path.join(out_dir, out_file))
        elif os.path.isdir(in_path):
            copy_files(in_path, out_dir)

def copy_files2(in_dir, out_dir, cur_out_dir, max_d, cur_d):
    if cur_d > max_d:
        last_dir = os.path.basename(in_dir)
        new_dir = os.path.join(out_dir, last_dir)
        os.mkdir(new_dir)
        items = os.listdir(in_dir)
        for item in items:
            in_path = os.path.join(in_dir, item)
            if os.path.isfile(in_path):
                shutil.copy2(in_path, os.path.join(new_dir, item))
            elif os.path.isdir(in_path):
                copy_files2(in_path, out_dir, new_dir, max_d, 2)
    else:
        items = os.listdir(in_dir)
        for item in items:
            in_path = os.path.join(in_dir, item)
            if os.path.isfile(in_path):
                shutil.copy2(in_path, os.path.join(cur_out_dir, item))
            elif os.path.isdir(in_path):
                new_dir = os.path.join(cur_out_dir, item)
                os.mkdir(new_dir)
                copy_files2(in_path, out_dir, new_dir, max_d, cur_d+1)

parser = argparse.ArgumentParser()
parser.add_argument('in_dir')
parser.add_argument('out_dir')
parser.add_argument('max_d', type=int, default=-1)

args = parser.parse_args()

if args.max_d == -1:
    copy_files(args.in_dir, args.out_dir)
else:
    copy_files2(args.in_dir, args.out_dir, args.out_dir, args.max_d, 1)
