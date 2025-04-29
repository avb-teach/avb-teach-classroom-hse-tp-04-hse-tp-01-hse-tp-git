#!/bin/bash

copy_files() {
    local cur_dir="$1"

    for item in "$cur_dir"/*; do
        if [ -f "$item" ]; then
            filename=$(basename "$item")
            name="${filename%.*}"
            ext="${filename##*.}"

            new_filename="${name}.${ext}"
            count=1
            
            while [ -e "$output_dir/$new_filename" ]; do
                new_filename="${name}_${count}${ext}"
                count=$((count + 1))
            done

            cp "$item" "$output_dir/$new_filename"
        elif [ -d "$item" ]; then
            copy_files "$item"
        fi
    done
}

copy_files_depth() {
    local cur_dir="$1"
    local out_dir="$2"
    local cur_out_dir="$3"
    local max_d="$4"
    local cur_d="$5"

    for item in "$cur_dir"/*; do
        if [ -f "$item" ]; then
            filename=$(basename "$item")
            name="${filename%.*}"
            ext="${filename##*.}"

            new_filename="${name}.${ext}"

            cp "$item" "$cur_out_dir/$new_filename"
        elif [ -d "$item" ]; then
            cur_dir_name=$(basename "$item")
            if [ "$cur_d" -eq "$max_d" ]; then
                last_dir_name=$(basename "$cur_dir")
                mkdir -p "$out_dir/$last_dir_name/$cur_dir_name"
                copy_files_depth "$item" "$out_dir" "$out_dir/$last_dir_name/$cur_dir_name" "$max_d" "3"
            else
                mkdir -p "$cur_out_dir/$cur_dir_name"
                new_d=$((cur_d + 1))
                copy_files_depth "$item" "$out_dir" "$cur_out_dir/$cur_dir_name" "$max_d" "$new_d"
            fi
        fi
    done
}

if [ $# -eq 2 ]; then
    input_dir="$1"
    output_dir="$2"
    
    copy_files "$input_dir"
elif [ $# -eq 4]; then
    input_dir="$1"
    output_dir="$2"
    max_depth="$4"
    
    copy_files "$input_dir" "$output_dir" "$output_dir" "$max_depth" "1"
fi
