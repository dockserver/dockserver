#!/bin/bash

# source stackoverflow.com

# Look at filenames in current directory and generate list with filename
# suffixes removed (a filename suffix is anything after the last dot in
# the file name). We assume filenames that does not contain newlines.
# Only unique prefixes will be generated.

# sample :
# bash rmdupe.sh Movies << MOVIES is $1 
# it's running without any separate yes/no action

for name in /mnt/unionfs/$1/*/*; do
        [ ! -f "$name" ] && continue # skip non-regular files
        printf '%s\n' "${name%.*}" 
done | sort -u | while IFS= read -r prefix; do

        # Set the positional parameters to the names matching a particular prefix.
        set -- "$prefix"*

        if [ "$#" -ne 2 ]; then
           printf 'Not exactly two files having prefix "%s"\n' "$prefix" >&2
           continue
        fi

        # Check file sizes and remove smallest.
        if [ "$( stat -c '%s' "$1" )" -lt "$( stat -c '%s' "$2" )" ]; then
           # First file is smaller
           printf 'Would remove "%s"\n' "$1"
           echo rm -rf "$1"
        else
           # Second file is smaller, or same size
           printf 'Would remove "%s"\n' "$2"
           echo rm -rf "$2"
        fi
done
