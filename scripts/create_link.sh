#!/bin/bash

# mount photos link
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

function create_link() {
    if [ ! "$#" -eq 2 ]; then
        echo "Error: create_link() usage: create_link target link"
        exit 1
    fi

    target_link="$1" # the file or directory to which the symbolic link will point.
    source_link="$2" # the name of the symbolic link that you're creating.

    # check if the target directory exists
    if [ ! -d "$target_link" ]; then
        echo "Error: target directory ${target_link} does not exist"
        exit 1
    fi

    # remove the existing mount point
    mount_info=$(df -a --output=target | grep "^$source_link\$")
    if [ -n "$mount_info" ]; then
        umount "$source_link"

        if [ $? -eq 0 ]; then
            echo "Umount '$source_link' successfully."
        else
            echo "Error: Failed to umount '${source_link}'."
            exit 1
        fi
    fi

    # https://www.albertogonzalez.net/how-to-create-a-symbolic-link-to-a-folder-on-a-synology-nas/
    mkdir -p "$source_link"
    mount --bind "$target_link" "$source_link"
    if [ $? -eq 0 ]; then
        echo "Mount directory successfully. $source_link -> $target_link"
    else
        echo "Error: Failed to mount '${target_link}'"
        exit 1
    fi
}

# create link for photos
# note: synology Photos does not support symlink, we can not use symlink in the albums
create_link "${work_dir}/gphotos/PhotoLibrary" "${photos_space}/PhotoLibrary"
