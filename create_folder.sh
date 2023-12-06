#!/bin/bash

# create directory architecture
# dev
# ├── config
# ├── db
# ├── gphotos
# └── scripts

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
    cp -r "${work_dir}/scripts" "${folder_name}"
    echo "Folder '$folder_name' created successfully."
fi

echo "Note: put client_secret.json to ${folder_name}/config/"
