#!/bin/bash

input_dir="$1"
output_dir="$2"

mkdir -p "$output_dir"

process_files() {
    local dir="$1"
    local output="$2"

    find "$dir" $max_depth -type f | while read -r file; do
        base_name=$(basename "$file")
        ext="${base_name##*.}"
        name="${base_name%.*}"

        if [ "$name" = "$ext" ]; then
            ext=""
        else
            ext=".$ext"
        fi

        dest_file="$output/$name$ext"
        cnt=1
        while [ -f "$dest_file" ]; do
            dest_file="${output}/${name}_${cnt}${ext}"
            ((cnt++))
        done
        cp "$file" "$dest_file"
    done
}

process_files "$input_dir" "$output_dir"
