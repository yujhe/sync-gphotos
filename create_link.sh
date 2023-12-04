#!/bin/bash

# mount photos link
# /tmp/myspace/PhotoLibrary -> /Users/yujhe.li/Workspace/snippets/sync-gphotos/dev/gphotos/PhotoLibrary

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

function create_link() {
    if [ ! "$#" -eq 2 ]; then
        echo "Error: create_link() usage: create_link target link"
        exit 1
    fi

    # target_link: This is the file or directory to which the symbolic link will point.
    # source_link: This is the name of the symbolic link that you're creating.
    target_link="$1"
    source_link="$2"

    # check if the target directory exists
    if [ ! -d "$target_link" ]; then
        echo "Error: target directory ${target_link} does not exist"
        exit 1
    fi

    # remove the existing mount point
    if df "$source_link" >/dev/null 2>&1; then
        echo "Umount $source_link"
        umount "$source_link"
    fi

    # https://www.albertogonzalez.net/how-to-create-a-symbolic-link-to-a-folder-on-a-synology-nas/
    mkdir -p "$source_link"
    mount --bind "$target_link" "$source_link"
    echo "Mount directory successfully. $source_link -> $target_link"
}

# create link for photos
# note: synology Photos does not support symlink, we can not use symlink in the albums
create_link "${work_dir}/gphotos/PhotoLibrary" "${photos_space}/PhotoLibrary"
