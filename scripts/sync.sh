#!/bin/bash

work_dir=$(dirname $(dirname "$(readlink -f "$0")"))
repo=$(basename "$work_dir")

# check if the secret exists
secret_file="${work_dir}/config/client_secret.json"
if [ ! -e "$secret_file" ]; then
    echo "Error: Client secret does not exist at $secret_file"
    exit 1
fi

# check token exists
token_file="${work_dir}/db/.gphotos.token"
if [ ! -e "$token_file" ]; then
    echo "Error: Token does not exist at $token_file"
    echo -e "Execute the following command before syncing: \ndocker run -it --rm -p 8080:8080 --name gphotos-sync-${repo} -v ${work_dir}/db:/storage -v ${work_dir}/config:/config gilesknap/gphotos-sync:latest --skip-files --skip-albums --skip-index /storage"
    exit 1
fi

echo "====== [START] DOWNLOAD PHOTOS ====="

sync_args=(
    "--photos-path /gphotos/PhotoLibrary"
    "--albums-path /gphotos/albums"
    "--omit-album-date"
    "--progress"
    # uncomment this, if you don't want to sync photos/albums
    # "--skip-files"
    # "--skip-albums"

    # uncomment this, if you only want to sync specified albums
    # "--album-regex ^(album1|album2)$"

    # uncomment this, if you want to resync photos/albums
    # "--flush-index"

    # uncomment this, if you want to rescan Google Photos
    # "--rescan"

    # uncomment this, if you want to sync photos before/after the date (inclusive)
    # note: not work, if you are syncing album which contains photos not between the date
    # "--start-date yyyy-mm-dd"
    # "--end-date yyyy-mm-dd"
)

docker run --rm \
    --name "gphotos-sync-${repo}" \
    -v "${work_dir}/db":/storage \
    -v "${work_dir}/config":/config \
    -v "${work_dir}/gphotos":/gphotos \
    -u $(id -u):$(id -g) \
    gilesknap/gphotos-sync:latest \
    ${sync_args[*]} /storage

echo "====== [END] DOWNLOAD PHOTOS ====="
