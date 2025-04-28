#!/bin/bash

input_directory="$1"
output_directory="$2"


find "$input_directory" -type f | while read -r file; do
    filename=$(basename "$file")
    target="$output_directory/$filename"
    
    
    if [ -e "$target" ]; then
        base="${filename%.*}"
        ext="${filename##*.}"

        i=1
        while true; do
            if [ "$base" = "$ext" ]; then
                new_filename="${base}${i}"
            else
                new_filename="${base}${i}.${ext}"
            fi

            target="$output_directory/$new_filename"
            if [ ! -e "$target" ]; then
                break
            fi
            i=$((i+1))
        done
    fi

    
    cp "$file" "$target"
done