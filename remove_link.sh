#!/bin/bash

# remove all existing link of photos, albums
# /tmp/myspace/PhotoLibrary -> /Users/yujhe.li/Workspace/snippets/sync-gphotos/dev/gphotos/PhotoLibrary
# /tmp/myspace/albums/me -> /Users/yujhe.li/Workspace/snippets/sync-gphotos/dev/gphotos/albums/me
#
# Note: synology Photos does not support symlink, need to use `mount --bind target_dir source_dir` command
# https://www.albertogonzalez.net/how-to-create-a-symbolic-link-to-a-folder-on-a-synology-nas/

work_dir=$(dirname "$(readlink -f "$0")")
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

# remove albums link
if [ -d "${work_dir}/gphotos/albums" ]; then
    if [ -n "$(find "${work_dir}/gphotos/albums" -mindepth 1 -maxdepth 1 -type d -print -quit)" ]; then
        for target_dir in "${work_dir}/gphotos/albums/"*; do
            album=$(basename "$target_dir")
            umount "${photos_space}/albums/${album}"
        done
    fi
fi

# remove photos link
umount "${photos_space}/PhotoLibrary"
