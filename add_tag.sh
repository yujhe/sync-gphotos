#!/bin/bash

work_dir=$(dirname "$(readlink -f "$0")")

# add album tags to photos since Synology Photos does not suppory symlink
# note: the symbloic link in albums is not working if File Station too
function add_tag() {
    if [ ! "$#" -eq 2 ]; then
        echo "Error: add_tag() usage: photo_path tag"
        exit 1
    fi

    photo_path="$1"
    tag="$2"

    # add tag if it does not exists
    if ! exiftool -keywords -charset iptc=UTF8 "$photo_path" | grep -q "\b$tag\b"; then
        exiftool -keywords+="$tag" -charset iptc=UTF8 -overwrite_original "$photo_path"
        echo "Keyword '$tag' added to '$photo_path'."
    else
        echo "Keyword '$tag' already exist on '$photo_path', skip it."
    fi
}

if [ -d "${work_dir}/gphotos/albums" ]; then
    if [ -n "$(find "${work_dir}/gphotos/albums" -mindepth 1 -maxdepth 1 -type d -print -quit)" ]; then
        for target_dir in "${work_dir}/gphotos/albums/"*; do
            album=$(basename "$target_dir")
            for photo in "${target_dir}/"*; do
                photo=$(readlink -f "$photo")
                add_tag "$photo" "$album"
            done
        done
    fi
fi
