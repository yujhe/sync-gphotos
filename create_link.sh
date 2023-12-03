#!/bin/bash

# mount photos, albums link
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

    mkdir -p "$source_link"
    mount --bind "$target_link" "$source_link"
    echo "Mount directory successfully. $source_link -> $target_link"
}

# mount directory for albums
if [ -d "${work_dir}/gphotos/albums" ]; then
    if [ -n "$(find "${work_dir}/gphotos/albums" -mindepth 1 -maxdepth 1 -type d -print -quit)" ]; then
        for target_dir in "${work_dir}/gphotos/albums/"*; do
            album=$(basename "$target_dir")
            create_link "$target_dir" "${photos_space}/albums/${album}"
        done
    fi
fi

# create link for photos
create_link "${work_dir}/gphotos/PhotoLibrary" "${photos_space}/PhotoLibrary"
