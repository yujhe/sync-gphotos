#!/bin/bash

# create directory architecture
# dev
# ├── Dockerfile
# ├── add_tag.py
# ├── config/
# ├── create_link.sh
# ├── db/
# ├── gphotos/
# ├── remove_link.sh
# └── sync.sh

work_dir=$(dirname "$(readlink -f "$0")")

folder_name="$1"
if [ -z "$folder_name" ]; then
    # ask the user for a folder name
    read -p "Enter the folder name: " folder_name
fi

# check if the folder already exists
if [ -d "$folder_name" ]; then
    echo "Error: The folder '$folder_name' already exists."
else
    # Create the folder
    mkdir "$folder_name"
    mkdir "${folder_name}/db" "${folder_name}/config" "${folder_name}/gphotos"
    cp "${work_dir}/sync.sh" "${folder_name}"
    cp "${work_dir}/Dockerfile" "${work_dir}/add_tag.py" "${folder_name}"
    cp "${work_dir}/create_link.sh" "${folder_name}"
    cp "${work_dir}/remove_link.sh" "${folder_name}"
    echo "Folder '$folder_name' created successfully."
fi

echo "Note: put client_secret.json to ${folder_name}/config/"
