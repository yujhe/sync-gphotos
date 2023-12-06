#!/bin/bash

# remove all existing link of photos
# /tmp/myspace/PhotoLibrary -> /Users/yujhe.li/Workspace/snippets/sync-gphotos/dev/gphotos/PhotoLibrary

work_dir=$(dirname $(dirname "$(readlink -f "$0")"))
repo=$(basename "$work_dir")

photos_space="$1"
if [ -z "$photos_space" ]; then
    # ask the user for the path of photos folder
    read -p "Enter the absolute path of photos space (ex: /volume1/homes/user1/Photos): " photos_space
fi
photos_space="$(realpath $photos_space)"

# check if photos space directory exists
if [ ! -d "$photos_space" ]; then
    echo "Error: photo spaces does not exist"
    exit 1
fi

# remove photos link
# note: synology Photos does not support symlink, we can not use symlink in the albums
source_link="${photos_space}/PhotoLibrary"
umount "$source_link"
if [ $? -eq 0 ]; then
    echo "Umount '${source_link}' successfully."
else
    echo "Error: Failed to umount '${source_link}'."
    exit 1
fi
