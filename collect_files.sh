#!/bin/bash

if [[ $# -lt 2 ]]; then
    printf "\nОШИБКА: Недостаточно аргументов.\nИспользуйте: %s путь_к_каталогу входящий путь_к_каталогу выходной [глубина]\n\n" "$0"
    exit 1
fi

SOURCE_DIR=$1
DESTINATION_DIR=$2
DEPTH_LIMIT=${3:-"-1"}

python3 -c "
import os
import shutil
import sys
from pathlib import Path

def copy_with_rename(src, dest, count=None):
    basename = os.path.basename(src)
    stem, extension = os.path.splitext(basename)
    
    if count is not None:
        filename = f'{stem}_{count}{extension}'
    else:
        filename = basename
    
    destination = os.path.join(dest, filename)
    shutil.copy2(src, destination)
    return destination

def gather_and_copy(source_dir, target_dir, max_depth=-1):
    source_dir_abs = os.path.abspath(source_dir)
    collected_files = {}

    for dirpath, dirs, filenames in os.walk(source_dir_abs):
        relative_path = os.path.relpath(dirpath, start=source_dir_abs)
        current_depth = relative_path.count(os.sep)

        if max_depth >= 0 and current_depth > max_depth:
            continue

        for fname in sorted(filenames):
            full_src_path = os.path.join(dirpath, fname)
            if fname not in collected_files:
                collected_files[fname] = []
            collected_files[fname].append(full_src_path)

    for file_name, sources in sorted(collected_files.items(), key=lambda x: x[0]):
        for idx, src_path in enumerate(sources, start=1):
            if len(sources) > 1:
                final_dest = copy_with_rename(src_path, target_dir, idx)
            else:
                final_dest = copy_with_rename(src_path, target_dir)
            print(f'Файл скопирован: {src_path} → {final_dest}')

try:
    gather_and_copy('$SOURCE_DIR', '$DESTINATION_DIR', int($DEPTH_LIMIT))
except Exception as err:
    print('Ошибка:', str(err), file=sys.stderr)
exit()
"