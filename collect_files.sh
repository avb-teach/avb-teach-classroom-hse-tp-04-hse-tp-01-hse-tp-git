#!/bin/bash

if [ $# -lt 2 ]; then
    echo
    exit 1
fi

INPUT_DIR=$1
OUTPUT_DIR=$2
MAX_DEPTH=""

if [[ "$3" == --max_depth=* ]]; then
    MAX_DEPTH=$(echo "$3" | cut -d= -f2)
fi

if [ ! -d "$INPUT_DIR" ]; then
    echo
    exit 1
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir "$OUTPUT_DIR"
fi

declare -A filenames

if [ -z "$MAX_DEPTH" ]; then
    FILES=$(find "$INPUT_DIR" -type f)
else
    FILES=$(find "$INPUT_DIR" -maxdepth "$MAX_DEPTH" -type f)
fi

for FILE in $FILES
do
    BASENAME=$(basename "$FILE")
    if [ -e "$OUTPUT_DIR/$BASENAME" ]; then
        if [ -z "${filenames[$BASENAME]}" ]; then
            filenames[$BASENAME]=1
        fi
        filenames[$BASENAME]=$((filenames[$BASENAME]+1))
        NAME="${BASENAME%.*}"
        EXTENSION="${BASENAME##*.}"
        NEWNAME="${NAME}${filenames[$BASENAME]}.$EXTENSION"
        cp "$FILE" "$OUTPUT_DIR/$NEWNAME"
    else
        filenames[$BASENAME]=1
        cp "$FILE" "$OUTPUT_DIR/$BASENAME"
    fi
done
